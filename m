Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD33B1B3920;
	Sun,  9 Mar 2025 09:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513830; cv=none; b=rnyoLotcxu+ySTjXw4Sfc0Vu+DPNWA5keBSW7bQHosliFoF2PZ2jq8g9dSmjpw3cNM8NYS8+yVzJb1400PK6ctgyknSrqivEnX/3TWBKSxwQ+ZfVETRa/yg9/UnvMx1Uk0batdgUc+sQOGAn4Ss/vBzgDK1LjTYJSO4vMPhQvd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513830; c=relaxed/simple;
	bh=+qSsqViJaouve/7qR4gvBaV/DwFoH6YBENKSaV5tGZ8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=AV8kEtrQU94sA2giMDdKPUVrjGwUbCYwnCXhigNJq1WPelZYD+SGnJtBP8A4j6gX9nVDllN9i0P1BzStnt1il+ZLGuFh/0nQKSuYc/Lxx6F5ZFyVeVyWmx9hUeGTcBhSOS1Hjz6rxzq5A7tTf/WfZpqtCNHmX8bwlnsTJP44KP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1V4oqjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1V4oqjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E85C4CEEE;
	Sun,  9 Mar 2025 09:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513830;
	bh=+qSsqViJaouve/7qR4gvBaV/DwFoH6YBENKSaV5tGZ8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=l1V4oqjtPXTne/rgGlxvxknvcSsRlus1J/PrNucmPGrO6C4NQuuDeMEsH9Ruaozi9
	 20+jWjUd00zLqgmHYhAMUI0PTFi5l3Ty2cYt++Eeeb5Cy2824wnjvVy66mM1DmIZbQ
	 JFqvfHL46zmmm7XXvGAebyqfI3hKJyC6VCNQKhAc=
Subject: Patch "rust: introduce `.clippy.toml`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-12-ojeda@kernel.org>
Message-ID: <2025030951-paralyses-scallop-3bce@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    rust: introduce `.clippy.toml`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-introduce-.clippy.toml.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121466-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:09 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:18 +0100
Subject: rust: introduce `.clippy.toml`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-12-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 7d56786edcbdf58b6367fd7f01d5861214ad1c95 upstream.

Some Clippy lints can be configured/tweaked. We will use these knobs to
our advantage in later commits.

This is done via a configuration file, `.clippy.toml` [1]. The file is
currently unstable. This may be a problem in the future, but we can adapt
as needed. In addition, we proposed adding Clippy to the Rust CI's RFL
job [2], so we should be able to catch issues pre-merge.

Thus introduce the file.

Link: https://doc.rust-lang.org/clippy/configuration.html [1]
Link: https://github.com/rust-lang/rust/pull/128928 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-12-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .clippy.toml |    1 +
 .gitignore   |    1 +
 MAINTAINERS  |    1 +
 Makefile     |    3 +++
 4 files changed, 6 insertions(+)
 create mode 100644 .clippy.toml

--- /dev/null
+++ b/.clippy.toml
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0
--- a/.gitignore
+++ b/.gitignore
@@ -103,6 +103,7 @@ modules.order
 # We don't want to ignore the following even if they are dot-files
 #
 !.clang-format
+!.clippy.toml
 !.cocciconfig
 !.editorconfig
 !.get_maintainer.ignore
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20175,6 +20175,7 @@ B:	https://github.com/Rust-for-Linux/lin
 C:	zulip://rust-for-linux.zulipchat.com
 P:	https://rust-for-linux.com/contributing
 T:	git https://github.com/Rust-for-Linux/linux.git rust-next
+F:	.clippy.toml
 F:	Documentation/rust/
 F:	rust/
 F:	samples/rust/
--- a/Makefile
+++ b/Makefile
@@ -588,6 +588,9 @@ endif
 # Allows the usage of unstable features in stable compilers.
 export RUSTC_BOOTSTRAP := 1
 
+# Allows finding `.clippy.toml` in out-of-srctree builds.
+export CLIPPY_CONF_DIR := $(srctree)
+
 export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
 export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN
 export HOSTRUSTC KBUILD_HOSTRUSTFLAGS


Patches currently in stable-queue which might be from ojeda@kernel.org are

queue-6.12/drm-panic-avoid-reimplementing-iterator-find.patch
queue-6.12/documentation-rust-add-coding-guidelines-on-lints.patch
queue-6.12/rust-provide-proper-code-documentation-titles.patch
queue-6.12/rust-alloc-make-allocator-module-public.patch
queue-6.12/rust-alloc-remove-vecext-extension.patch
queue-6.12/rust-alloc-implement-reallocfunc.patch
queue-6.12/rust-alloc-separate-aligned_size-from-krealloc_aligned.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_comment-lint.patch
queue-6.12/rust-alloc-update-module-comment-of-alloc.rs.patch
queue-6.12/rust-kbuild-expand-rusttest-target-for-macros.patch
queue-6.12/rust-error-use-core-alloc-layouterror.patch
queue-6.12/rust-str-test-replace-alloc-format.patch
queue-6.12/loongarch-use-asm_reachable.patch
queue-6.12/rust-alloc-implement-allocator-for-kmalloc.patch
queue-6.12/rust-alloc-implement-collect-for-intoiter.patch
queue-6.12/rust-alloc-introduce-arraylayout.patch
queue-6.12/rust-alloc-implement-vmalloc-allocator.patch
queue-6.12/documentation-rust-discuss-in-the-guidelines.patch
queue-6.12/rust-error-check-for-config-test-in-error-name.patch
queue-6.12/rust-enable-clippy-ignored_unit_patterns-lint.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_doc-lint.patch
queue-6.12/rust-alloc-add-box-to-prelude.patch
queue-6.12/kbuild-rust-remove-the-alloc-crate-and-globalalloc.patch
queue-6.12/rust-alloc-add-allocator-trait.patch
queue-6.12/rust-treewide-switch-to-our-kernel-box-type.patch
queue-6.12/rust-introduce-.clippy.toml.patch
queue-6.12/rust-alloc-rename-kernelallocator-to-kmalloc.patch
queue-6.12/rust-alloc-implement-cmalloc-in-module-allocator_test.patch
queue-6.12/drm-panic-allow-verbose-version-check.patch
queue-6.12/rust-map-__kernel_size_t-and-friends-also-to-usize-isize.patch
queue-6.12/rust-alloc-add-module-allocator_test.patch
queue-6.12/rust-replace-clippy-dbg_macro-with-disallowed_macros.patch
queue-6.12/rust-alloc-add-__gfp_nowarn-to-flags.patch
queue-6.12/rust-enable-clippy-s-check-private-items.patch
queue-6.12/rust-error-make-conversion-functions-public.patch
queue-6.12/rust-sort-global-rust-flags.patch
queue-6.12/rust-alloc-implement-contains-for-flags.patch
queue-6.12/rust-init-remove-unneeded.patch
queue-6.12/rust-use-custom-ffi-integer-types.patch
queue-6.12/rust-sync-remove-unneeded.patch
queue-6.12/rust-treewide-switch-to-the-kernel-vec-type.patch
queue-6.12/rust-alloc-implement-kvmalloc-allocator.patch
queue-6.12/drm-panic-correctly-indent-continuation-of-line-in-list-item.patch
queue-6.12/rust-alloc-implement-kernel-vec-type.patch
queue-6.12/rust-workqueue-remove-unneeded.patch
queue-6.12/rust-error-optimize-error-type-to-use-nonzero.patch
queue-6.12/drm-panic-remove-unnecessary-borrow-in-alignment_pattern.patch
queue-6.12/rust-alloc-remove-extension-of-std-s-box.patch
queue-6.12/rust-block-fix-formatting-in-gendisk-doc.patch
queue-6.12/rust-enable-rustdoc-unescaped_backticks-lint.patch
queue-6.12/rust-fix-size_t-in-bindgen-prototypes-of-c-builtins.patch
queue-6.12/rust-enable-clippy-undocumented_unsafe_blocks-lint.patch
queue-6.12/rust-alloc-add-vec-to-prelude.patch
queue-6.12/rust-alloc-implement-intoiterator-for-vec.patch
queue-6.12/rust-alloc-implement-kernel-box.patch
queue-6.12/drm-panic-remove-redundant-field-when-assigning-value.patch
queue-6.12/rust-types-avoid-repetition-in-as-from-bytes-impls.patch
queue-6.12/rust-start-using-the-attribute.patch
queue-6.12/drm-panic-allow-verbose-boolean-for-clarity.patch
queue-6.12/maintainers-add-entry-for-the-rust-alloc-module.patch
queue-6.12/rust-alloc-fix-arraylayout-allocations.patch
queue-6.12/drm-panic-prefer-eliding-lifetimes.patch
