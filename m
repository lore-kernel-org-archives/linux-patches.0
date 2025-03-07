Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726AD18BC36;
	Fri,  7 Mar 2025 22:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387885; cv=none; b=VXDcG42/wqK7PKIFpu4Dmi1y3NnskBDpebEw93/qdHwqMX64okpHkotW4d/cmWlh710hvY4Juh3tko4e2UPWi16vMwSJrOiWqQWEWnN7+f5KYlmsR/50+L5t2tgo9B5Zk+pLumLMoqDdjKGeQCMx5I+IfMPpP0PIqetsCTqGLRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387885; c=relaxed/simple;
	bh=OkmbdLruYaOCvwt35n50oPj3akYdRHgMa1RwdQRHZ+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNLtVyVlIVZJl+BAJe+hTuUg6GdtGrFnLcHx72L6e5hodZ9SBiyDSIvXSJDyF9HYfsmrD9NnD8skXZqU8cTUEBauMEadlyU5A3tgXaKIaZsm+sc1OI3xNbdCypFvSg8cn2ObzUkFYAEkYX7Uzc6JqgokkNZTRn2VsxALQU2NvAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cg95FQoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cg95FQoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B00FC4CED1;
	Fri,  7 Mar 2025 22:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387885;
	bh=OkmbdLruYaOCvwt35n50oPj3akYdRHgMa1RwdQRHZ+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cg95FQoSCuhLymqotnStKLqAaIH45xjYatSSdgB7omjowuuKQjG8GZpibEd7Qwh0Q
	 fAWVDmx3SoGaurMh1nKI48phDWM5fcQKJ0qpZLS+tIMLD0FTCorU83I796lnWTFhTR
	 nhlSe4h3qN7F8TBegzXjjVLi4+BqxGFw/VBQQkgPOBnUPkafxfqKxpvnv3LFiSaoMA
	 ui6mUXJtm3KNR7JbF3Fb5oe5f/3cyiR0YI6bXopWpZZzPox7Ss3r6rr/Kt4a6Ylcj8
	 FJZcJBIbls749v87kCVGvxIDxhWwyBEspedJtFOPbyMo3lJJ+CP+ATDI47bisPocyX
	 2PQB04jtyJcLg==
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
Subject: [PATCH 6.12.y 18/60] rust: error: make conversion functions public
Date: Fri,  7 Mar 2025 23:49:25 +0100
Message-ID: <20250307225008.779961-19-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 rust/kernel/error.rs | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index a681acda87ce..2f1e4b783bfb 100644
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
@@ -133,8 +133,7 @@ pub(crate) fn to_blk_status(self) -> bindings::blk_status_t {
     }
 
     /// Returns the error encoded as a pointer.
-    #[expect(dead_code)]
-    pub(crate) fn to_ptr<T>(self) -> *mut T {
+    pub fn to_ptr<T>(self) -> *mut T {
         #[cfg_attr(target_pointer_width = "32", allow(clippy::useless_conversion))]
         // SAFETY: `self.0` is a valid error due to its invariant.
         unsafe {
@@ -270,9 +269,7 @@ pub fn to_result(err: core::ffi::c_int) -> Result {
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
@@ -318,9 +315,7 @@ pub(crate) fn from_err_ptr<T>(ptr: *mut T) -> Result<*mut T> {
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
-- 
2.48.1

