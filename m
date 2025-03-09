Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8993B1FB3;
	Sun,  9 Mar 2025 09:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513687; cv=none; b=H59M97ub1FKgCF9xFVrBnFq+d9SXd7WRspI6Hly+tclUvIUWO0kNc/jeFVRm6a/BM0CvwvN1d4vOrA2e4bSXNSmAE0XUGFlayOQWhekV2ZTm8xAGeWBRDua5aUN4r6pYZKo+F/Bs5QXZEZtJdJe3Ei8gkBM7cnDIrsJRE2vXp1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513687; c=relaxed/simple;
	bh=SHALiv4yYAU3lmT24bDzJn3kcwrxcFCkMT2e2nCj/OM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=U/UxvUe6QFG5LCpzt1XGKZxlXB2On6sE1JIoQz5raarITjuCIUiNTgzVpGaT1gyU5oHMffu5cZ6mzJlrwkQHusJp73X0HMmaNHx2WZjeXrDw6IEFKuJAS78RjCLtDM033UG11BRLsfa6A1iU/8JjjhNuAju5zlE3H5KG37aNEvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0IlxCX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0IlxCX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF25C4CEE5;
	Sun,  9 Mar 2025 09:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513687;
	bh=SHALiv4yYAU3lmT24bDzJn3kcwrxcFCkMT2e2nCj/OM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=Z0IlxCX6Dfy9ZtB7kK0Rj0ALP4uTze+JevpTwb0dYZ0NBB0pZoSDDrLE6w924JYqD
	 Er7t/vJ0GKjUUl48mYECDE7419BZQUkNhHZ5rnTARctUhqQMutzqXUQDB84Y+GoSbG
	 KrN3wJTPOwSBFnVgSPfGcFyt94sJw0RrTCdUgycY=
Subject: Patch "Documentation: rust: discuss `#[expect(...)]` in the guidelines" has been added to the 6.12-stable tree
To: aliceryhl@google.com,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:47 +0100
In-Reply-To: <20250307225008.779961-18-ojeda@kernel.org>
Message-ID: <2025030947-overarch-isolated-b079@gregkh>
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

    Documentation: rust: discuss `#[expect(...)]` in the guidelines

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     documentation-rust-discuss-in-the-guidelines.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121472-greg=kroah.com@vger.kernel.org Fri Mar  7 23:51:27 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:24 +0100
Subject: Documentation: rust: discuss `#[expect(...)]` in the guidelines
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-18-ojeda@kernel.org>

From: Miguel Ojeda <ojeda@kernel.org>

commit 04866494e936d041fd196d3a36aecd979e4ef078 upstream.

Discuss `#[expect(...)]` in the Lints sections of the coding guidelines
document, which is an upcoming feature in Rust 1.81.0, and explain that
it is generally to be preferred over `allow` unless there is a reason
not to use it (e.g. conditional compilation being involved).

Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-19-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/rust/coding-guidelines.rst |  110 +++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -262,6 +262,116 @@ default (i.e. outside ``W=`` levels). In
 false positives but that are otherwise quite useful to keep enabled to catch
 potential mistakes.
 
+On top of that, Rust provides the ``expect`` attribute which takes this further.
+It makes the compiler warn if the warning was not produced. For instance, the
+following will ensure that, when ``f()`` is called somewhere, we will have to
+remove the attribute:
+
+.. code-block:: rust
+
+	#[expect(dead_code)]
+	fn f() {}
+
+If we do not, we get a warning from the compiler::
+
+	warning: this lint expectation is unfulfilled
+	 --> x.rs:3:10
+	  |
+	3 | #[expect(dead_code)]
+	  |          ^^^^^^^^^
+	  |
+	  = note: `#[warn(unfulfilled_lint_expectations)]` on by default
+
+This means that ``expect``\ s do not get forgotten when they are not needed, which
+may happen in several situations, e.g.:
+
+- Temporary attributes added while developing.
+
+- Improvements in lints in the compiler, Clippy or custom tools which may
+  remove a false positive.
+
+- When the lint is not needed anymore because it was expected that it would be
+  removed at some point, such as the ``dead_code`` example above.
+
+It also increases the visibility of the remaining ``allow``\ s and reduces the
+chance of misapplying one.
+
+Thus prefer ``except`` over ``allow`` unless:
+
+- The lint attribute is intended to be temporary, e.g. while developing.
+
+- Conditional compilation triggers the warning in some cases but not others.
+
+  If there are only a few cases where the warning triggers (or does not
+  trigger) compared to the total number of cases, then one may consider using
+  a conditional ``expect`` (i.e. ``cfg_attr(..., expect(...))``). Otherwise,
+  it is likely simpler to just use ``allow``.
+
+- Inside macros, when the different invocations may create expanded code that
+  triggers the warning in some cases but not in others.
+
+- When code may trigger a warning for some architectures but not others, such
+  as an ``as`` cast to a C FFI type.
+
+As a more developed example, consider for instance this program:
+
+.. code-block:: rust
+
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+Here, function ``g()`` is dead code if ``CONFIG_X`` is not set. Can we use
+``expect`` here?
+
+.. code-block:: rust
+
+	#[expect(dead_code)]
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+This would emit a lint if ``CONFIG_X`` is set, since it is not dead code in that
+configuration. Therefore, in cases like this, we cannot use ``expect`` as-is.
+
+A simple possibility is using ``allow``:
+
+.. code-block:: rust
+
+	#[allow(dead_code)]
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+An alternative would be using a conditional ``expect``:
+
+.. code-block:: rust
+
+	#[cfg_attr(not(CONFIG_X), expect(dead_code))]
+	fn g() {}
+
+	fn main() {
+	    #[cfg(CONFIG_X)]
+	    g();
+	}
+
+This would ensure that, if someone introduces another call to ``g()`` somewhere
+(e.g. unconditionally), then it would be spotted that it is not dead code
+anymore. However, the ``cfg_attr`` is more complex than a simple ``allow``.
+
+Therefore, it is likely that it is not worth using conditional ``expect``\ s when
+more than one or two configurations are involved or when the lint may be
+triggered due to non-local changes (such as ``dead_code``).
+
 For more information about diagnostics in Rust, please see:
 
 	https://doc.rust-lang.org/stable/reference/attributes/diagnostics.html


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
