Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E781AC43A;
	Sun,  9 Mar 2025 09:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513817; cv=none; b=eq23ycfL2PthgNOVD92ofS/sWsDYOyC0g1zJwK4N/b0Kj9D4vrFQ3zWB9MqK1tJUH6g3TIEp9wTOsHLk1cVG3HkHjWSKIy75mq8k86ckdgs2RDzvTkxOqbKc+zpm2iGocVY52gXSzOnsJfvo8m3mo7qlw4jAhdpFf4dFOf7Tj5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513817; c=relaxed/simple;
	bh=R6/ZBoCSwBAeDBhDzIHhE8ZcCqwzAKJ94kk6fy4zwkY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Lfc56RYuTAfLeUXq4J26Ko1Av1CHZ55kW968zawra8AJubQyiO7hlJrOxlPdJdIa2N0BEiHiZZZCYRcVxczNYUnNogqBTZQLb9J7GhYC5s7u+3VhvG28a+KtjA7PhUFEY9ChH2uKw73PuUdnTIIh3SFlaxpLzXyuORKWkn+4hNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XF8c10Lq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XF8c10Lq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B7C4CEE5;
	Sun,  9 Mar 2025 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513815;
	bh=R6/ZBoCSwBAeDBhDzIHhE8ZcCqwzAKJ94kk6fy4zwkY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=XF8c10LqfSYbFO34kUmBYNMlKReXLBHtWLyIpTiQNZRpW7SJWsZDUf6jtEca/DfFy
	 1J7bva3ZdSr6ninJz+QcnIPtz2gLDTUAW862yFzIGvJYgYS7Pc7LukcyvUzMJbrV4A
	 2X00VhBjzDTy7Ko/utKK6GwSwCH5M2OonbRSks2g=
Subject: Patch "rust: error: make conversion functions public" has been added to the 6.12-stable tree
To: aliceryhl@google.com,benno.lossin@proton.me,dakr@kernel.org,felipe_life@live.com,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-19-ojeda@kernel.org>
Message-ID: <2025030951-hunchback-hypnotist-5673@gregkh>
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

    rust: error: make conversion functions public

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-error-make-conversion-functions-public.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121473-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:29 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:25 +0100
Subject: rust: error: make conversion functions public
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-19-ojeda@kernel.org>

From: Filipe Xavier <felipe_life@live.com>

commit 5ed147473458f8c20f908a03227d8f5bb3cb8f7d upstream.

Change visibility to public of functions in error.rs:
from_err_ptr, from_errno, from_result and to_ptr.
Additionally, remove dead_code annotations.

Link: https://github.com/Rust-for-Linux/linux/issues/1105
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Filipe Xavier <felipe_life@live.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/DM4PR14MB7276E6948E67B3B23D8EA847E9652@DM4PR14MB7276.namprd14.prod.outlook.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/error.rs |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -95,7 +95,7 @@ impl Error {
     ///
     /// It is a bug to pass an out-of-range `errno`. `EINVAL` would
     /// be returned in such a case.
-    pub(crate) fn from_errno(errno: core::ffi::c_int) -> Error {
+    pub fn from_errno(errno: core::ffi::c_int) -> Error {
         if errno < -(bindings::MAX_ERRNO as i32) || errno >= 0 {
             // TODO: Make it a `WARN_ONCE` once available.
             crate::pr_warn!(
@@ -133,8 +133,7 @@ impl Error {
     }
 
     /// Returns the error encoded as a pointer.
-    #[expect(dead_code)]
-    pub(crate) fn to_ptr<T>(self) -> *mut T {
+    pub fn to_ptr<T>(self) -> *mut T {
         #[cfg_attr(target_pointer_width = "32", allow(clippy::useless_conversion))]
         // SAFETY: `self.0` is a valid error due to its invariant.
         unsafe {
@@ -270,9 +269,7 @@ pub fn to_result(err: core::ffi::c_int)
 ///     from_err_ptr(unsafe { bindings::devm_platform_ioremap_resource(pdev.to_ptr(), index) })
 /// }
 /// ```
-// TODO: Remove `dead_code` marker once an in-kernel client is available.
-#[allow(dead_code)]
-pub(crate) fn from_err_ptr<T>(ptr: *mut T) -> Result<*mut T> {
+pub fn from_err_ptr<T>(ptr: *mut T) -> Result<*mut T> {
     // CAST: Casting a pointer to `*const core::ffi::c_void` is always valid.
     let const_ptr: *const core::ffi::c_void = ptr.cast();
     // SAFETY: The FFI function does not deref the pointer.
@@ -318,9 +315,7 @@ pub(crate) fn from_err_ptr<T>(ptr: *mut
 ///     })
 /// }
 /// ```
-// TODO: Remove `dead_code` marker once an in-kernel client is available.
-#[allow(dead_code)]
-pub(crate) fn from_result<T, F>(f: F) -> T
+pub fn from_result<T, F>(f: F) -> T
 where
     T: From<i16>,
     F: FnOnce() -> Result<T>,


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
