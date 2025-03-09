Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770DC1B3922;
	Sun,  9 Mar 2025 09:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513862; cv=none; b=FBbfskmZm24ih402fSYTdhpKQ/2cGMfPFJkowKJJrs0K1MLdruIRttNBnKOerBxHaZc06ETDlqGmNStWO1SV0X8oqciBMcAcMaDW2WA7+7VmD3/X+7g0n6FZ+wf+9DbH4XuOZk86vb9CWTTiq++h3R8MMvLFi3z9tlRJ9FyGN9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513862; c=relaxed/simple;
	bh=z1538r32xuuFSYkkgF8B/Fj2dIVvYXWyUibjutD8Ogw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=ShiGU1eBs18OcE4CX89yer03lJG5if3ILSsJwDJWGfGk1FSKnxAYcoeWBCPtbVnsioRoBxdOMMVfHShgT6zeQjeNEK0oCSFNE6XYsf2jyPe8GuNHu/o6uy/RQMESCIOgvb+TQ84MCLx08F0iUy0GBD40CuNscqeHAvrZMBM0OTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CW18yclS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CW18yclS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E889AC4CEE5;
	Sun,  9 Mar 2025 09:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513862;
	bh=z1538r32xuuFSYkkgF8B/Fj2dIVvYXWyUibjutD8Ogw=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=CW18yclSODwre15p2iZ1+84EAGI+X4fxXqi9aMrh4ItMKQ4Up+zAAAR0FnVOTUpj7
	 LZPgMIf2MDQveKGgjJsUAnx6Irwuc/ggRLWkBq9rawCvz3/3zmuGcVsar4VhAyWTln
	 337mZhyJb6Zjni2dT/JsjyOacsSUCKdAx3J895s8=
Subject: Patch "rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:52 +0100
In-Reply-To: <20250307225008.779961-2-ojeda@kernel.org>
Message-ID: <2025030952-overturn-smolder-3b97@gregkh>
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

    rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-workqueue-remove-unneeded.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121456-greg=kroah.com@vger.kernel.org Fri Mar  7 23:50:44 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:08 +0100
Subject: rust: workqueue: remove unneeded ``#[allow(clippy::new_ret_no_self)]`
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-2-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 024f9676a6d236132119832a90fb9a1a9115b41a upstream.

Perform the same clean commit b2516f7af9d2 ("rust: kernel: remove
`#[allow(clippy::new_ret_no_self)]`") did for a case that appeared in
workqueue in parallel in commit 7324b88975c5 ("rust: workqueue: add
helper for defining work_struct fields"):

    Clippy triggered a false positive on its `new_ret_no_self` lint
    when using the `pin_init!` macro. Since Rust 1.67.0, that does
    not happen anymore, since Clippy learnt to not warn about
    `-> impl Trait<Self>` [1][2].

    The kernel nowadays uses Rust 1.72.1, thus remove the `#[allow]`.

    Link: https://github.com/rust-lang/rust-clippy/issues/7344 [1]
    Link: https://github.com/rust-lang/rust-clippy/pull/9733 [2]

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-2-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/workqueue.rs |    1 -
 1 file changed, 1 deletion(-)

--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -366,7 +366,6 @@ unsafe impl<T: ?Sized, const ID: u64> Sy
 impl<T: ?Sized, const ID: u64> Work<T, ID> {
     /// Creates a new instance of [`Work`].
     #[inline]
-    #[allow(clippy::new_ret_no_self)]
     pub fn new(name: &'static CStr, key: &'static LockClassKey) -> impl PinInit<Self>
     where
         T: WorkItem<ID>,


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
