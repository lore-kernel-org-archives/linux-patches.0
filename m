Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E170013D890;
	Sat, 23 Nov 2024 22:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732400940; cv=none; b=ndJDs6Vh8oCWVjeZkeA64/J12NMFz7hFHd6MqY5l/nqLkTNyf88dKc2Hz91jO3gm4LUvH7b65EmDfWJlGycnZXeulwj52+3ZXWFlV1ntk65e3/VvqWRtnq9/j7tGaZht5R5APtMKkxbGzGEakgCQYiLRwsaMO4LVkGzHQFWjJ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732400940; c=relaxed/simple;
	bh=SaKBv1q/DnVbD4aKC6INMyugPq2qWXVF+pz3DbeoW64=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DjBN0CNeWfhXwGyL5E+s/4yA+G0BuAH7VpZ6j6LI3BLJgSwENIVVggKpXqDkHGI/U3CCWe7vvVMIvm0zhgFIFPxcyVIsoRKBihQzIswgFtlpsCJQ/C7scDBY4AaN5JYAAE40+cabm+Nd6hH9btapCtYv7pTCSCK27KcjCNcfF20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t707zDpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t707zDpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D015FC4CECD;
	Sat, 23 Nov 2024 22:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732400939;
	bh=SaKBv1q/DnVbD4aKC6INMyugPq2qWXVF+pz3DbeoW64=;
	h=From:To:Cc:Subject:Date:From;
	b=t707zDpkIJTdTbjEtPbEaD91BOLfiafTOlArBciBjFf5GFxeqkXS8XTDnobgu7czu
	 sS+gWR9FfawRDDUgQoc3EcPWgv58rEBnKzFsLTWST+TpKfxRL9QH7+ttG7th2r3OZp
	 WftTQcEF9dsxpdtTNTIM4ZbLMD5k9Pgo6s7qM9frfAIugFd4/0jBP2JAvwaSz2AMBD
	 6j+8AgBAwuBXunR6vyLuuhkuT+AXbgsp+X0VMQ+3GKg5GlNsA018oAkKj61eWjAEa2
	 KH6Ns7/a2XlCLpOiG6YaiDvVdFcCsZOIspRIna/OIOIoz0cDHPai2KiyOg8CGJKzqt
	 eylSV7tU37mvw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/3] rust: use the `build_error!` macro, not the hidden function
Date: Sat, 23 Nov 2024 23:28:47 +0100
Message-ID: <20241123222849.350287-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Code and some examples were using the function, rather than the macro. The
macro is what is documented.

Thus move users to the macro.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/block/mq/operations.rs |  2 +-
 rust/kernel/net/phy.rs             | 18 +++++++++---------
 rust/macros/lib.rs                 |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index c8646d0d9866..962f16a5a530 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -35,7 +35,7 @@ pub trait Operations: Sized {
     /// Called by the kernel to poll the device for completed requests. Only
     /// used for poll queues.
     fn poll() -> bool {
-        crate::build_error(crate::error::VTABLE_DEFAULT_ERROR)
+        crate::build_error!(crate::error::VTABLE_DEFAULT_ERROR)
     }
 }
 
diff --git a/rust/kernel/net/phy.rs b/rust/kernel/net/phy.rs
index beb62ec712c3..f488f6c55e9a 100644
--- a/rust/kernel/net/phy.rs
+++ b/rust/kernel/net/phy.rs
@@ -587,17 +587,17 @@ pub trait Driver {
 
     /// Issues a PHY software reset.
     fn soft_reset(_dev: &mut Device) -> Result {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Sets up device-specific structures during discovery.
     fn probe(_dev: &mut Device) -> Result {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Probes the hardware to determine what abilities it has.
     fn get_features(_dev: &mut Device) -> Result {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Returns true if this is a suitable driver for the given phydev.
@@ -609,32 +609,32 @@ fn match_phy_device(_dev: &Device) -> bool {
     /// Configures the advertisement and resets auto-negotiation
     /// if auto-negotiation is enabled.
     fn config_aneg(_dev: &mut Device) -> Result {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Determines the negotiated speed and duplex.
     fn read_status(_dev: &mut Device) -> Result<u16> {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Suspends the hardware, saving state if needed.
     fn suspend(_dev: &mut Device) -> Result {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Resumes the hardware, restoring state if needed.
     fn resume(_dev: &mut Device) -> Result {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Overrides the default MMD read function for reading a MMD register.
     fn read_mmd(_dev: &mut Device, _devnum: u8, _regnum: u16) -> Result<u16> {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Overrides the default MMD write function for writing a MMD register.
     fn write_mmd(_dev: &mut Device, _devnum: u8, _regnum: u16, _val: u16) -> Result {
-        kernel::build_error(VTABLE_DEFAULT_ERROR)
+        kernel::build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Callback for notification of link change.
diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 4ab94e44adfe..1a30c8075ebd 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -123,12 +123,12 @@ pub fn module(ts: TokenStream) -> TokenStream {
 /// used on the Rust side, it should not be possible to call the default
 /// implementation. This is done to ensure that we call the vtable methods
 /// through the C vtable, and not through the Rust vtable. Therefore, the
-/// default implementation should call `kernel::build_error`, which prevents
+/// default implementation should call `kernel::build_error!`, which prevents
 /// calls to this function at compile time:
 ///
 /// ```compile_fail
 /// # // Intentionally missing `use`s to simplify `rusttest`.
-/// kernel::build_error(VTABLE_DEFAULT_ERROR)
+/// kernel::build_error!(VTABLE_DEFAULT_ERROR)
 /// ```
 ///
 /// Note that you might need to import [`kernel::error::VTABLE_DEFAULT_ERROR`].
@@ -145,11 +145,11 @@ pub fn module(ts: TokenStream) -> TokenStream {
 /// #[vtable]
 /// pub trait Operations: Send + Sync + Sized {
 ///     fn foo(&self) -> Result<()> {
-///         kernel::build_error(VTABLE_DEFAULT_ERROR)
+///         kernel::build_error!(VTABLE_DEFAULT_ERROR)
 ///     }
 ///
 ///     fn bar(&self) -> Result<()> {
-///         kernel::build_error(VTABLE_DEFAULT_ERROR)
+///         kernel::build_error!(VTABLE_DEFAULT_ERROR)
 ///     }
 /// }
 ///

base-commit: b2603f8ac8217bc59f5c7f248ac248423b9b99cb
-- 
2.47.0

