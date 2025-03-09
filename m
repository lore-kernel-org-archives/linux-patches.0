Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1EF1AC43A;
	Sun,  9 Mar 2025 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513834; cv=none; b=Sa9Xh32xMi36U4LVNKmQJf2Syaeo6e5By2XJ1t3uzQ1Kwq3unp57a+WY5AHpAd1bdlfE97wktMvJCDLR4mdDpScckHBwUnne/ZzB2vE8+Vy5WFlNOaiJgGalCAemVrzDcDcy3Dey0CfDO7woNcA9R8pn9qLBdtwptWAPfHO4MBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513834; c=relaxed/simple;
	bh=woRoxPWCUkK4uDBuweL5k01aa6ZVwvsL29siQmzq9vM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Pj59kyUbO0ztLlf/8aKPu2L8EqT2DkgXq40sPak+9oANrrxQRk3ahagRUwjMMhj3jRzQmpFwORtq3e1iW+faJaCmfmWKwx6GGa/+wAKg0YEKNX4WNBJVHyJC7j7qdMaX+M8Mb7md4odCMjDJ6vK/OtKfL+P0Z9MvyVWp3AfCDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pk6BM3Nb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pk6BM3Nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9FAC4CEE5;
	Sun,  9 Mar 2025 09:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513834;
	bh=woRoxPWCUkK4uDBuweL5k01aa6ZVwvsL29siQmzq9vM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Pk6BM3Nb7rx4Avss5As8woRfIDqh1/iD3gpbSvqOZI3yoBF/90GayAK3f67g9KA/y
	 vQWoYtpR1kpEAUUpmk6aV9yochDYlzML0df78UIkSXTQ/B8x5LphP73z3MKxhwjxDU
	 iEGSJoI7PBs250th5JjL+vRv/a6AGmOkk3ABOgd0=
Subject: Patch "rust: kbuild: expand rusttest target for macros" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,ethan.twardy@gmail.com,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:51 +0100
In-Reply-To: <20250307225008.779961-57-ojeda@kernel.org>
Message-ID: <2025030951-bright-playlist-7860@gregkh>
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

    rust: kbuild: expand rusttest target for macros

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-kbuild-expand-rusttest-target-for-macros.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121511-greg=kroah.com@vger.kernel.org Fri Mar  7 23:53:11 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:50:03 +0100
Subject: rust: kbuild: expand rusttest target for macros
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-57-ojeda@kernel.org>

From: "Ethan D. Twardy" <ethan.twardy@gmail.com>

commit b2c261fa8629dff2bd1143fa790797a773ace102 upstream.

Previously, the rusttest target for the macros crate did not specify
the dependencies necessary to run the rustdoc tests. These tests rely on
the kernel crate, so add the dependencies.

Signed-off-by: Ethan D. Twardy <ethan.twardy@gmail.com>
Link: https://github.com/Rust-for-Linux/linux/issues/1076
Link: https://lore.kernel.org/r/20240704145607.17732-2-ethan.twardy@gmail.com
[ Rebased (`alloc` is gone nowadays, sysroot handling is simpler) and
  simplified (reused `rustdoc_test` rule instead of adding a new one,
  no need for `rustdoc-compiler_builtins`, removed unneeded `macros`
  explicit path). Made `vtable` example fail (avoiding to increase
  the complexity in the `rusttest` target). Removed unstable
  `-Zproc-macro-backtrace` option. Reworded accordingly. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile      |   17 +++++++++++++----
 rust/macros/lib.rs |    2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -129,6 +129,14 @@ rusttestlib-macros: private rustc_test_l
 rusttestlib-macros: $(src)/macros/lib.rs FORCE
 	+$(call if_changed,rustc_test_library)
 
+rusttestlib-kernel: private rustc_target_flags = \
+    --extern build_error --extern macros \
+    --extern bindings --extern uapi
+rusttestlib-kernel: $(src)/kernel/lib.rs \
+    rusttestlib-bindings rusttestlib-uapi rusttestlib-build_error \
+    $(obj)/libmacros.so $(obj)/bindings.o FORCE
+	+$(call if_changed,rustc_test_library)
+
 rusttestlib-bindings: $(src)/bindings/lib.rs FORCE
 	+$(call if_changed,rustc_test_library)
 
@@ -181,19 +189,20 @@ quiet_cmd_rustc_test = RUSTC T  $<
 
 rusttest: rusttest-macros rusttest-kernel
 
-rusttest-macros: private rustc_target_flags = --extern proc_macro
+rusttest-macros: private rustc_target_flags = --extern proc_macro \
+	--extern macros --extern kernel
 rusttest-macros: private rustdoc_test_target_flags = --crate-type proc-macro
-rusttest-macros: $(src)/macros/lib.rs FORCE
+rusttest-macros: $(src)/macros/lib.rs \
+    rusttestlib-macros rusttestlib-kernel FORCE
 	+$(call if_changed,rustc_test)
 	+$(call if_changed,rustdoc_test)
 
 rusttest-kernel: private rustc_target_flags = \
     --extern build_error --extern macros --extern bindings --extern uapi
-rusttest-kernel: $(src)/kernel/lib.rs \
+rusttest-kernel: $(src)/kernel/lib.rs rusttestlib-kernel \
     rusttestlib-build_error rusttestlib-macros rusttestlib-bindings \
     rusttestlib-uapi FORCE
 	+$(call if_changed,rustc_test)
-	+$(call if_changed,rustc_test_library)
 
 ifdef CONFIG_CC_IS_CLANG
 bindgen_c_flags = $(c_flags)
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -132,7 +132,7 @@ pub fn module(ts: TokenStream) -> TokenS
 /// calls to this function at compile time:
 ///
 /// ```compile_fail
-/// # use kernel::error::VTABLE_DEFAULT_ERROR;
+/// # // Intentionally missing `use`s to simplify `rusttest`.
 /// kernel::build_error(VTABLE_DEFAULT_ERROR)
 /// ```
 ///


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
