Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF06A1AC43A;
	Sun,  9 Mar 2025 09:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513821; cv=none; b=hQAtCf6gvFnwRFG/EIUOP/pc5t5LBhYAWiV2SMNh80ZDlLqhucOf/ub9kOxJdI2pJx6a01HF+SV88KhRWl2TQMFgAlSNvU86pgWX5LS8lSiDbmDIGtXbkKcUXXM8b+lNRpnPlo3WEDCC0MOgD+SG38DDubF4Ytlk00ooQQS0U6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513821; c=relaxed/simple;
	bh=5CAU62sPQFVhh4wF+fYoPvfknKiQuNpYSoY4hzEIvrs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Y+jQPOzMFHwUukk6nWXn7XFkTf8zFIlakap6qwEG5V87kyPzCBPYM9blj9WcPTxJvQDiFRb+prkHEaXe2DCcvp72QiKtonBUNt3sBHpOQmIHUtqT4EhAWuRaefW+C46gZGXfD88h1NHkrWWxV1+zB9q0o0TH+NMNCYN5NFqanRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSC2ZmPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSC2ZmPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E3DC4CEE5;
	Sun,  9 Mar 2025 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513821;
	bh=5CAU62sPQFVhh4wF+fYoPvfknKiQuNpYSoY4hzEIvrs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=tSC2ZmPYtlikv0rVD3s617WH78g3iXpGFYMghvnatKzW3Kf7P34om+qDdZRKD8Y9P
	 izTsmFuk6aV0qN6rdL/JSRn2TzGzSD43GJchHz3RkhAYI4Lk7/Z5OFUsJfRevUR+Un
	 juyeghO31LPkL3bHfsU/arfK1vWPjsGpQAZAcEz4=
Subject: Patch "rust: error: use `core::alloc::LayoutError`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,benno.lossin@proton.me,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-42-ojeda@kernel.org>
Message-ID: <2025030951-renderer-promenade-ae95@gregkh>
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

    rust: error: use `core::alloc::LayoutError`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-error-use-core-alloc-layouterror.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121496-greg=kroah.com@vger.kernel.org Fri Mar  7 23:52:38 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:48 +0100
Subject: rust: error: use `core::alloc::LayoutError`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-42-ojeda@kernel.org>

From: Danilo Krummrich <dakr@kernel.org>

commit 29a48d25ff53c183482dc88a99133a0fb5aa541a upstream.

Use `core::alloc::LayoutError` instead of `alloc::alloc::LayoutError` in
preparation to get rid of Rust's alloc crate.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-23-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/error.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -6,7 +6,7 @@
 
 use crate::{alloc::AllocError, str::CStr};
 
-use alloc::alloc::LayoutError;
+use core::alloc::LayoutError;
 
 use core::fmt;
 use core::num::NonZeroI32;


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
