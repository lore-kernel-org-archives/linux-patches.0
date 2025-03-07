Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3A418BC36;
	Fri,  7 Mar 2025 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387875; cv=none; b=OmaKRXoiOYr/OTifAgGdASrrO8NZfVv/F9N8OT7hbXSRO1xOcjzEk0SjKX/N0wHHjdXgAm428N5qu1myfi2ZcdySVHquKvza7AYLIBiE4m8E/sAG+THWZtL2oZW66y9E1DycQNidcjG9MW3CfCc9U70rOSb7yXeMBIdX1hmRo1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387875; c=relaxed/simple;
	bh=yDdZLF3pEq2IY+o0JCHkjFgVUm5g7uaowljSOIRmIiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VE3bqF7Ombm2LAtfcbEqxBJ/gOQSuUfD9xk5U76h9JAtuuari7Nqfak59zWrnuiICCIO0ZI+2D/IaLHBRImlm9GJTdrIaJYXQ+DyImQQOVJ9J4akmCnQLJq9Dymmnot5ULEzXGGwj5UuyRf4UVvWmqXD6CX31MYrawUOlfBb4rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tp7y1YN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tp7y1YN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30832C4CED1;
	Fri,  7 Mar 2025 22:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387874;
	bh=yDdZLF3pEq2IY+o0JCHkjFgVUm5g7uaowljSOIRmIiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tp7y1YN51YPwVkyw9zhE1TX9ePrQTRii7yvCzanuFBft8SYEYJGC7qzPwmEk/JVeA
	 Q0lih8rPFqQ9nnrqseVow5ZuPEMeNuGCwwrqdCF7E9puOUZbrIgFtx7MMquo8t2D2o
	 a5vNg2O+6ST3Y0bh4fM57UcmPaZnPuJSUF4X+hIJS+dZ3d26dBx7iPIGiEwQytNiwL
	 ZmgZC9R1wU6oYgohm4CgJyefSm8tFFe3GFLovlHRSIqAME3iu5hRYNjgLgwFf0RLPD
	 SSsa3qmSCbhii3Q5dSH2IrLT42DjEF5JHE7sQrj/oJAkRyZ+s/E4dvs7s9hOmOJ0w1
	 Bapy5y1wsiMow==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 14/60] rust: enable Clippy's `check-private-items`
Date: Fri,  7 Mar 2025 23:49:21 +0100
Message-ID: <20250307225008.779961-15-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 624063b9ac97f40cadca32a896aafeb28b1220fd upstream.

In Rust 1.76.0, Clippy added the `check-private-items` lint configuration
option. When turned on (the default is off), it makes several lints
check private items as well.

In our case, it affects two lints we have enabled [1]:
`missing_safety_doc` and `unnecessary_safety_doc`.

It also seems to affect the new `too_long_first_doc_paragraph` lint [2],
even though the documentation does not mention it.

Thus allow the few instances remaining we currently hit and enable
the lint.

Link: https://doc.rust-lang.org/nightly/clippy/lint_configuration.html#check-private-items [1]
Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long_first_doc_paragraph [2]
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-16-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 .clippy.toml                   | 2 ++
 rust/kernel/init.rs            | 1 +
 rust/kernel/init/__internal.rs | 2 ++
 rust/kernel/init/macros.rs     | 1 +
 rust/kernel/print.rs           | 1 +
 5 files changed, 7 insertions(+)

diff --git a/.clippy.toml b/.clippy.toml
index ad9f804fb677..e4c4eef10b28 100644
--- a/.clippy.toml
+++ b/.clippy.toml
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+check-private-items = true
+
 disallowed-macros = [
     # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
     # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 0330a8756fa5..fdbf0857ba20 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -125,6 +125,7 @@
 //! use core::{ptr::addr_of_mut, marker::PhantomPinned, pin::Pin};
 //! # mod bindings {
 //! #     #![allow(non_camel_case_types)]
+//! #     #![allow(clippy::missing_safety_doc)]
 //! #     pub struct foo;
 //! #     pub unsafe fn init_foo(_ptr: *mut foo) {}
 //! #     pub unsafe fn destroy_foo(_ptr: *mut foo) {}
diff --git a/rust/kernel/init/__internal.rs b/rust/kernel/init/__internal.rs
index 163eb072f296..549ae227c2ea 100644
--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -54,6 +54,7 @@ unsafe fn __pinned_init(self, slot: *mut T) -> Result<(), E> {
 pub unsafe trait HasPinData {
     type PinData: PinData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __pin_data() -> Self::PinData;
 }
 
@@ -83,6 +84,7 @@ fn make_closure<F, O, E>(self, f: F) -> F
 pub unsafe trait HasInitData {
     type InitData: InitData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __init_data() -> Self::InitData;
 }
 
diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
index 736fe0ce0cd9..193d39886b1f 100644
--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -989,6 +989,7 @@ fn drop(&mut self) {
         //
         // The functions are `unsafe` to prevent accidentally calling them.
         #[allow(dead_code)]
+        #[allow(clippy::missing_safety_doc)]
         impl<$($impl_generics)*> $pin_data<$($ty_generics)*>
         where $($whr)*
         {
diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index fe53fc469c4f..45af17095a24 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -14,6 +14,7 @@
 use crate::str::RawFormatter;
 
 // Called from `vsprintf` with format specifier `%pA`.
+#[allow(clippy::missing_safety_doc)]
 #[no_mangle]
 unsafe extern "C" fn rust_fmt_argument(
     buf: *mut c_char,
-- 
2.48.1

