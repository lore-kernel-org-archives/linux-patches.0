Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41BF17C225;
	Mon, 10 Mar 2025 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627147; cv=none; b=jVbf2IGL1SuQRQeKWIhvyjxtZi1hIHFLKXrdtGCN7BqyIWsRwbDXJeWUJrKV3JxqSWlFGpieD4t1mBXEHaefW32VoacknMUTIctdJ01VGB1Fqgc1hvRgGyeUlQcMbuQEw39GqdgxCnBpCAt8o7P/t8fMqKjIVtib35eNMxadV2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627147; c=relaxed/simple;
	bh=TlWPLeCEdsQDDiR5E97+kyjT1rYFxp64uDl3cELXV28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZrR3CHJfgQ1F4x6CI/fwnxAW84i53QDPVZrXDv27bdotJWMeIDkmxS+gnyKAA4zXHml2q2k5zJ4SOpTcKbuwfdMDmWyEm+t8GqfujIm7dE0w6Exicn9yq3Z1U8Ava0xYEzpfZhUYRGqW6ShCKI1UQeq7tlKgp9NSmmoAGJT4t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqqtjAov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqqtjAov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE3CC4CEE5;
	Mon, 10 Mar 2025 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627147;
	bh=TlWPLeCEdsQDDiR5E97+kyjT1rYFxp64uDl3cELXV28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqqtjAovC7YhKhEBOsnMxJaYvWvETe+j5/SKwUfyQzarbwVtzjxG/CRLJDBuG7WmC
	 Z6JxlcCt9JO7JI+MNYw6hpto1uHdRUSGdHxv23rHNqQNU4SN6R2TsejVeO4g1JKw6r
	 mu7jQeyX92CcUm9Ks4Kib98TUr4JTMm5hUM7PpwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Filipe Xavier <felipe_life@live.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 029/269] rust: error: make conversion functions public
Date: Mon, 10 Mar 2025 18:03:02 +0100
Message-ID: <20250310170458.877085856@linuxfoundation.org>
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


