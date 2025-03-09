Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EE11FB3;
	Sun,  9 Mar 2025 09:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513730; cv=none; b=UXdG0OixgE/RdIOhsPWXfFXQqD+Yd2e5DeITVgvLopM8LiG0eOcHd8Y9Q2t7Jjc3dAyUq5mIsnlEfKbJCPuQYC9CDSiE8eNRjKTIGo7cYoXQ11k5SK2py1W7o6fEU9vPzvq9wsaBw09hhGb0rv4o80/W13P4yzY08E7IF4IqZOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513730; c=relaxed/simple;
	bh=CcWjIFW0npP6clrbNBABrOecclZcAI3SOBP37MlmwL8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=VX6uBodLJ8WW2DamQJ0jtLMfIi1EIiIkojZxPcdrFRmFagjHI9BnVIovaB7KA+4+cX5k6zsY8V0R21sAuzILU9OAY1JrPR9wWQoUqHNiEU2dOSIu8lzxLIE6Er6JHNThw7lxmyfVu+ygoSRxTeUXjnWDMOt+XUVP1oEq53t2aNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7l6jF4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7l6jF4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDE5C4CEEC;
	Sun,  9 Mar 2025 09:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513730;
	bh=CcWjIFW0npP6clrbNBABrOecclZcAI3SOBP37MlmwL8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=J7l6jF4K04H4jjR7DMEVPM5HywhlVKPPCcvNtPbU6Ry3rqVncv7OVtnYouVZoUp+2
	 m0/MguvLxZT/cAlyxGL+qi5PlFknB/y5rB5cH8OVq8DsgmQUYDTz6yxqgUJRBbkTpW
	 hWQDaniGkwddk+1uUFSfGDlEjK+FZXKhkJcnOtYg=
Subject: Patch "drm/panic: correctly indent continuation of line in list item" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gregkh@linuxfoundation.org,hi@alyssa.is,jfalempe@redhat.com,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,witcher@wiredspace.de
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:48 +0100
In-Reply-To: <20250307225008.779961-54-ojeda@kernel.org>
Message-ID: <2025030948-selection-contort-80ec@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    drm/panic: correctly indent continuation of line in list item

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     drm-panic-correctly-indent-continuation-of-line-in-list-item.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121508-greg=kroah.com@vger.kernel.org Fri Mar  7 23:53:09 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:50:00 +0100
Subject: drm/panic: correctly indent continuation of line in list item
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-54-ojeda@kernel.org>

From: Thomas Böhler <witcher@wiredspace.de>

commit 5bb698e6fc514ddd9e23b6649b29a0934d8d8586 upstream.

It is common practice in Rust to indent the next line the same amount of
space as the previous one if both belong to the same list item. Clippy
checks for this with the lint `doc_lazy_continuation`.

    error: doc list item without indentation
    --> drivers/gpu/drm/drm_panic_qr.rs:979:5
        |
    979 | /// conversion to numeric segments.
        |     ^
        |
        = help: if this is supposed to be its own paragraph, add a blank line
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_lazy_continuation
        = note: `-D clippy::doc-lazy-continuation` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::doc_lazy_continuation)]`
    help: indent this line
        |
    979 | ///   conversion to numeric segments.
        |     ++

Indent the offending line by 2 more spaces to remove this Clippy error.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-6-witcher@wiredspace.de
[ Reworded to indent Clippy's message. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -975,7 +975,7 @@ pub unsafe extern "C" fn drm_panic_qr_ge
 /// * `url_len`: Length of the URL.
 ///
 /// * If `url_len` > 0, remove the 2 segments header/length and also count the
-/// conversion to numeric segments.
+///   conversion to numeric segments.
 /// * If `url_len` = 0, only removes 3 bytes for 1 binary segment.
 #[no_mangle]
 pub extern "C" fn drm_panic_qr_max_data_size(version: u8, url_len: usize) -> usize {


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
