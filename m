Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A7D1B0F26;
	Sun,  9 Mar 2025 09:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513809; cv=none; b=E4lVZ4+FpxBpQnxvaiz189OIwGYwwmKRgDyMgCs+Kox3f3nVcD3V6FXs0VrAHdfJZCSJoVP6I7mAph2vqKPHZAgFg+1zqRlh0X+7c5xnXJB9F3YCYV50TRYWlVbC0psIuwM5xFErvtyTylw0PytD1tmjjQEptiajPTinseupAv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513809; c=relaxed/simple;
	bh=8VUW61EHbVcoY2NhkVGuRTXKuwQK+bph0ikzmpGlYQU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=ScG6QPd2GSDTOGrKvi001OOOxJDjYiYNXeUg4MaRzD0uVKr6p62wkLKfqlzA1ptJhfUR3ITr7gYq5zfcfNc2EIj4uJRyztFcWYSm5LJjzSD/6yhASpxuV1K+eTC1fj69FxF/L39XrUqJE6bhZqVu2u7iCa4v2Vo5QNTx105EQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyezFBZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyezFBZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C696C4CEE5;
	Sun,  9 Mar 2025 09:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513809;
	bh=8VUW61EHbVcoY2NhkVGuRTXKuwQK+bph0ikzmpGlYQU=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=CyezFBZSyDL+b6uOX7ZM79WmWgtrjUxZn8KT0ULKMm+qX3MzlvRk5Imoxrvb/mMSh
	 Ik0aDaCCmdbEDnPzGEIFx1A+W6tzBg30T40mHuaH0q043Cq/6BelYhCHEmLF3jaA4E
	 j+Y1OFfd61fhZcAFcXz1nhr3zC2ACqqT/tDALLZ4=
Subject: Patch "rust: provide proper code documentation titles" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org,tmgross@umich.edu
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-14-ojeda@kernel.org>
Message-ID: <2025030951-startup-baking-bdbf@gregkh>
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

    rust: provide proper code documentation titles

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-provide-proper-code-documentation-titles.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121468-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:16 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:20 +0100
Subject: rust: provide proper code documentation titles
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-14-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 2f390cc589433dfcfedc307a141e103929a6fd4d upstream.

Rust 1.82.0's Clippy is introducing [1][2] a new warn-by-default lint,
`too_long_first_doc_paragraph` [3], which is intended to catch titles
of code documentation items that are too long (likely because no title
was provided and the item documentation starts with a paragraph).

This lint does not currently trigger anywhere, but it does detect a couple
cases if checking for private items gets enabled (which we will do in
the next commit):

    error: first doc comment paragraph is too long
      --> rust/kernel/init/__internal.rs:18:1
       |
    18 | / /// This is the module-internal type implementing `PinInit` and `Init`. It is unsafe to create this
    19 | | /// type, since the closure needs to fulfill the same safety requirement as the
    20 | | /// `__pinned_init`/`__init` functions.
       | |_
       |
       = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#too_long_first_doc_paragraph
       = note: `-D clippy::too-long-first-doc-paragraph` implied by `-D warnings`
       = help: to override `-D warnings` add `#[allow(clippy::too_long_first_doc_paragraph)]`

    error: first doc comment paragraph is too long
     --> rust/kernel/sync/arc/std_vendor.rs:3:1
      |
    3 | / //! The contents of this file come from the Rust standard library, hosted in
    4 | | //! the <https://github.com/rust-lang/rust> repository, licensed under
    5 | | //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,
    6 | | //! see <https://github.com/rust-lang/rust/blob/master/COPYRIGHT>.
      | |_
      |
      = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#too_long_first_doc_paragraph

Thus clean those two instances.

In addition, since we have a second `std_vendor.rs` file with a similar
header, do the same there too (even if that one does not trigger the lint,
because it is `doc(hidden)`).

Link: https://github.com/rust-lang/rust/pull/129531 [1]
Link: https://github.com/rust-lang/rust-clippy/pull/12993 [2]
Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long_first_doc_paragraph [3]
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-15-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init/__internal.rs     |    7 ++++---
 rust/kernel/std_vendor.rs          |    2 ++
 rust/kernel/sync/arc/std_vendor.rs |    2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -15,9 +15,10 @@ use super::*;
 /// [this table]: https://doc.rust-lang.org/nomicon/phantom-data.html#table-of-phantomdata-patterns
 pub(super) type Invariant<T> = PhantomData<fn(*mut T) -> *mut T>;
 
-/// This is the module-internal type implementing `PinInit` and `Init`. It is unsafe to create this
-/// type, since the closure needs to fulfill the same safety requirement as the
-/// `__pinned_init`/`__init` functions.
+/// Module-internal type implementing `PinInit` and `Init`.
+///
+/// It is unsafe to create this type, since the closure needs to fulfill the same safety
+/// requirement as the `__pinned_init`/`__init` functions.
 pub(crate) struct InitClosure<F, T: ?Sized, E>(pub(crate) F, pub(crate) Invariant<(E, T)>);
 
 // SAFETY: While constructing the `InitClosure`, the user promised that it upholds the
--- a/rust/kernel/std_vendor.rs
+++ b/rust/kernel/std_vendor.rs
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
+//! Rust standard library vendored code.
+//!
 //! The contents of this file come from the Rust standard library, hosted in
 //! the <https://github.com/rust-lang/rust> repository, licensed under
 //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,
--- a/rust/kernel/sync/arc/std_vendor.rs
+++ b/rust/kernel/sync/arc/std_vendor.rs
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: Apache-2.0 OR MIT
 
+//! Rust standard library vendored code.
+//!
 //! The contents of this file come from the Rust standard library, hosted in
 //! the <https://github.com/rust-lang/rust> repository, licensed under
 //! "Apache-2.0 OR MIT" and adapted for kernel use. For copyright details,


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
