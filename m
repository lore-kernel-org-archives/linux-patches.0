Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A6A1E519;
	Mon, 10 Mar 2025 17:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627133; cv=none; b=Y0rZZC9jrEDqpxQJ4N3l2xrp9z4K8qLnaml6p1y1pfGKluzIgK2RiDGt/dRoOaCk3OtONBPfW2MnU2GspqMCQIYxU1LIz2beYZoj/k1j5MxfIcjzGSTUPGoVCZFQXH/6wOTXj32cwlyvuoTyGv0Zebbo5ozyoQhcuofLW5OASrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627133; c=relaxed/simple;
	bh=FxRYxGa16No0wW2MunObrg2rYuFR/QNbXr/e3uEzaQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GSDDny4Tdw7LKmwfrKM+/FRKZlGOL5AsSItjrRKmrYLU4zNoxC7HSXQTEKLsWtfgpa57Mi4qnFjLm+c5Cy9v61acD4hSnkfC8uNOOjL9yEyv7EjPaey571XW5AGtypor95rBxv3Eu68vcb/39tQRFu2DrCvwPwfiIX1o/psL/Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOl+Hw/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOl+Hw/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDB8C4CEE5;
	Mon, 10 Mar 2025 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627133;
	bh=FxRYxGa16No0wW2MunObrg2rYuFR/QNbXr/e3uEzaQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOl+Hw/8/xoYYawgnj8mweemCNzMq6mbA72CfKcsrZo3J3xh6YHwCcvVCZY66bfxv
	 ZhP4YApXewJJXx0LeZ357xwMuEHopZhZvfzhd4U1w5rjx9Wcg33mhsPGOVLik94tni
	 vYOXxZEZqya2ih/Mekr98sCKvy78pBcSTARys+cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gross <tmgross@umich.edu>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 025/269] rust: enable Clippys `check-private-items`
Date: Mon, 10 Mar 2025 18:02:58 +0100
Message-ID: <20250310170458.716244871@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .clippy.toml                   |    2 ++
 rust/kernel/init.rs            |    1 +
 rust/kernel/init/__internal.rs |    2 ++
 rust/kernel/init/macros.rs     |    1 +
 rust/kernel/print.rs           |    1 +
 5 files changed, 7 insertions(+)

--- a/.clippy.toml
+++ b/.clippy.toml
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+check-private-items = true
+
 disallowed-macros = [
     # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
     # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
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
--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -54,6 +54,7 @@ where
 pub unsafe trait HasPinData {
     type PinData: PinData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __pin_data() -> Self::PinData;
 }
 
@@ -83,6 +84,7 @@ pub unsafe trait PinData: Copy {
 pub unsafe trait HasInitData {
     type InitData: InitData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __init_data() -> Self::InitData;
 }
 
--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -989,6 +989,7 @@ macro_rules! __pin_data {
         //
         // The functions are `unsafe` to prevent accidentally calling them.
         #[allow(dead_code)]
+        #[allow(clippy::missing_safety_doc)]
         impl<$($impl_generics)*> $pin_data<$($ty_generics)*>
         where $($whr)*
         {
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -14,6 +14,7 @@ use core::{
 use crate::str::RawFormatter;
 
 // Called from `vsprintf` with format specifier `%pA`.
+#[allow(clippy::missing_safety_doc)]
 #[no_mangle]
 unsafe extern "C" fn rust_fmt_argument(
     buf: *mut c_char,


