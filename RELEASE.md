# Release Process

This document describes the release process for the Product as Code (PaC) Specification.

## Overview

The PaC specification follows semantic versioning (MAJOR.MINOR.PATCH) and is published at https://spec.productascode.org/. Each release is automatically built and deployed when a new git tag is created.

## Release Types

- **Major Release (X.0.0)**: Breaking changes to the specification
- **Minor Release (0.X.0)**: New features or additions that are backward compatible
- **Patch Release (0.0.X)**: Bug fixes, clarifications, or documentation improvements

## Pre-Release Checklist

Before creating a release, ensure:

- [ ] All changes are documented in the specification
- [ ] Examples in the spec are valid and tested
- [ ] Version number in spec/ProductAsCode.md header is updated
- [ ] Any schema changes are backward compatible (for minor releases)
- [ ] Build passes locally with `npm run build`

## Release Steps

### 1. Update Version References

Update the version number in the specification document:
```bash
# Edit spec/ProductAsCode.md
# Update the version in the document header
```

### 2. Create Release Commit

```bash
git add spec/ProductAsCode.md
git commit -m "Release v0.X.Y"
```

### 3. Create Git Tag

```bash
# Create annotated tag with release notes
git tag -a v0.X.Y -m "Release v0.X.Y

## Changes
- Feature: Description of new feature
- Fix: Description of bug fix
- Docs: Documentation improvements

## Breaking Changes (if any)
- Description of breaking change"
```

### 4. Push to Repository

```bash
# Push the commit
git push origin main

# Push the tag
git push origin v0.X.Y
```

### 5. Verify Deployment

The Cloudflare Pages deployment will automatically:
1. Detect the new tag
2. Build the specification for the tagged version
3. Update the index page with the new release
4. Deploy to https://spec.productascode.org/

Check the deployment:
- Visit https://spec.productascode.org/
- Verify the new version appears in the releases list
- Check that the version-specific URL works: https://spec.productascode.org/v0.X.Y/

### 6. Create GitHub Release

1. Go to https://github.com/productascode/pac-specification/releases
2. Click "Draft a new release"
3. Select the tag you just created
4. Title: "v0.X.Y"
5. Copy the release notes from your tag annotation
6. Publish the release

## Emergency Rollback

If a release has critical issues:

1. **Do not delete the tag** - URLs are permanent once published
2. Create a patch release with the fix
3. If absolutely necessary, mark the release as deprecated in GitHub

## Version Archive

All previous versions remain accessible at their permanent URLs:
- Latest draft: https://spec.productascode.org/draft/
- Released versions: https://spec.productascode.org/vX.Y.Z/

## Continuous Deployment

The specification uses Cloudflare Pages for automatic deployment:
- **Draft**: Every push to `main` updates the draft version
- **Releases**: Every new tag creates a permanent versioned URL
- **Index**: The homepage automatically lists all available versions

## Local Testing

Before releasing, test the build locally:

```bash
# Install dependencies
npm install

# Build the specification
npm run build

# Serve locally
npm run serve
# Visit http://localhost:8080
```

## Release Communication

After a successful release:
1. Update the project README if needed
2. Announce in relevant channels (if applicable)
3. Update any dependent documentation or tools

## Troubleshooting

### Build Fails on Cloudflare
- Check the build logs in Cloudflare Pages dashboard
- Ensure Node version matches between local and CI (currently v22)
- Verify all dependencies are in package.json

### Tag Not Showing on Website
- Ensure the tag follows the `vX.Y.Z` format
- Check that the tag was pushed to the remote repository
- Wait a few minutes for Cloudflare Pages to rebuild

### Spec File Not Found
- The build script looks for spec files in this order:
  1. `spec/ProductAsCode.md` (current location)
  2. `versions/v0.0.1.md` (legacy location)
- Ensure your spec file is in one of these locations