import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart version_manager.dart <command> [env]');
    print('Commands:');
    print('  get-args <env>  - Get build arguments for environment');
    print('  bump <env>      - Increment build number');
    print('  release <env>   - Interactive release flow (check tag, collect notes, create tag)');
    exit(1);
  }

  final command = args[0];

  if (command == 'release') {
    if (args.length < 2) {
      print('Error: Environment required for release command');
      exit(1);
    }
    final env = args[1];
    if (env != 'prod' && env != 'stg') {
      print('Error: Environment must be "prod" or "stg"');
      exit(1);
    }
    runReleaseFlow(env);
    return;
  }

  final env = args.length > 1 ? args[1] : null;

  if (env == null || (env != 'prod' && env != 'stg')) {
    print('Error: Environment must be "prod" or "stg"');
    exit(1);
  }

  final versionInfo = readVersion(env);

  if (command == 'get-args') {
    stdout.write('--build-name=${versionInfo['version']} --build-number=${versionInfo['build_number']}');
  } else if (command == 'bump') {
    bumpBuildNumber(env, versionInfo);
  } else {
    print('Unknown command: $command');
    exit(1);
  }
}

Map<String, String> readVersion(String env) {
  final file = File('version.yaml');
  if (!file.existsSync()) {
    print('Error: version.yaml not found');
    exit(1);
  }

  final lines = file.readAsLinesSync();
  String? version;
  String? buildNumber;

  bool inEnvSection = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().startsWith('$env:')) {
      inEnvSection = true;
      continue;
    }

    if (inEnvSection && line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('#')) {
      inEnvSection = false;
    }

    if (inEnvSection) {
      if (line.trim().startsWith('version:')) {
        version = line.split(':')[1].trim();
      } else if (line.trim().startsWith('build_number:')) {
        buildNumber = line.split(':')[1].trim();
      }
    }
  }

  if (version == null || buildNumber == null) {
    print('Error: Could not find version or build_number for $env');
    exit(1);
  }

  return {'version': version, 'build_number': buildNumber};
}

void bumpBuildNumber(String env, Map<String, String> versionInfo) {
  final file = File('version.yaml');
  final lines = file.readAsLinesSync();

  bool inEnvSection = false;
  int? buildNumberLineIndex;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.trim().startsWith('$env:')) {
      inEnvSection = true;
      continue;
    }

    if (inEnvSection && line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('#')) {
      inEnvSection = false;
    }

    if (inEnvSection && line.trim().startsWith('build_number:')) {
      buildNumberLineIndex = i;
      break;
    }
  }

  if (buildNumberLineIndex == null) {
    print('Error: Could not find build_number line for $env');
    exit(1);
  }

  final currentBuildNumber = int.parse(versionInfo['build_number']!);
  final newBuildNumber = currentBuildNumber + 1;
  lines[buildNumberLineIndex] = '  build_number: $newBuildNumber';
  file.writeAsStringSync(lines.join('\n'));
  print('Bumped $env build_number to $newBuildNumber');
}

void runReleaseFlow(String env) {
  print('🚀 Starting release flow for: $env');
  print('');

  // 1. Read current version
  final versionInfo = readVersion(env);
  final version = versionInfo['version']!;
  final buildNumber = versionInfo['build_number']!;
  final tagName = '$env-v$version+$buildNumber';

  print('📦 Current version: $version');
  print('🔢 Build number: $buildNumber');
  print('🏷️  Tag to create: $tagName');
  print('');

  // 2. Check if tag already exists
  final tagCheckResult = Process.runSync('git', ['tag', '-l', tagName]);
  if (tagCheckResult.stdout.toString().trim().isNotEmpty) {
    print('❌ Error: Tag "$tagName" already exists!');
    print('');
    print('Options:');
    print('  1. Bump build number: dart scripts/version_manager.dart bump $env');
    print('  2. Update version in version.yaml');
    exit(1);
  }

  print('✅ Tag "$tagName" is available');
  print('');

  // 3. Ask for release notes
  print('📝 Enter release notes (press Enter twice when done):');
  final notes = <String>[];
  while (true) {
    final line = stdin.readLineSync();
    if (line == null || line.isEmpty) {
      if (notes.isEmpty) {
        continue; // First empty line, keep waiting
      }
      break; // Second empty line, done
    }
    notes.add(line);
  }

  if (notes.isEmpty) {
    print('⚠️  No release notes provided. Using default message.');
    notes.add('Release $version build $buildNumber');
  }

  final releaseNotes = notes.join('\n');
  print('');
  print('📋 Release notes:');
  print('---');
  print(releaseNotes);
  print('---');
  print('');

  // 4. Confirm
  stdout.write('Create tag "$tagName"? (y/n): ');
  final confirmation = stdin.readLineSync();
  if (confirmation?.toLowerCase() != 'y') {
    print('❌ Release cancelled');
    exit(0);
  }

  // 5. Create tag
  final tagResult = Process.runSync('git', ['tag', '-a', tagName, '-m', releaseNotes]);
  if (tagResult.exitCode != 0) {
    print('❌ Error creating tag:');
    print(tagResult.stderr);
    exit(1);
  }

  print('');
  print('✅ Tag "$tagName" created successfully!');
  print('');
  print('📤 Next steps:');
  print('  1. Push the tag: git push origin $tagName');
  print('  2. Codemagic will automatically build and deploy');
  print('');
  print('💡 To cancel: git tag -d $tagName');
}
