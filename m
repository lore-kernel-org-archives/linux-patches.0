Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062689;
	b=46Np5ReZtwRZLuVvUaf6N9vTnK9X6FIFL1acb/V+V9AkZLiUpC6aCucuYlvBuZ9aWVne
	 f/ybmKkN/CLKhmPoD1KKg1mmVDYsdebGaBFg8cmak9rvOGn4M3INSu5J18vtgJJG9LoTV
	 MPLEoKMTPOiLnAuLtJlneWcQCS1DcmUT6qylddQTd1f/KZ5mvyo/YTOt6auc0HgDW6sIK
	 mFnxQN7AEcRdHqxTLt/7FISQq9307aghWMpTleSKoYAyMPWzjW0u9ZqL59qVLicCSjajv
	 qrRyx4KlBfPofxZgUPFRPJ3eWb+h+eHh7u0pV5vQ8Vxj8Y/7bWag/mbl7p9A8E5KUCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=itDku/vLK6bpFS6b9ApL5qwqE+N4bZdz5AtYIk1m1ls=;
	b=xP03Kof4bzKX25XFFMr4wDQu+xrX4zQfYaDuFB8PGTHfgBY06Xx3ePE8mUx2ZpEvdpkm
	 wcgS58VCNlvhsOGZFp48k8t12mLWHbLPAV0loPkoe0wVA3vat7+ORsLJ7RmCiQhVUmh2d
	 UpFKJ0qH0UHCXO7ksrUXBzeYvm/+yrp0HJz3jJ51fNt9iZacaHJjW1jkiGB+fzKn74l0L
	 SNuCpdjc246/Dn8TEszwPf9TlxDofFkSh6dE1fwqKzwAYSadjRY04tOvnOgLD9xlC9drd
	 Dp0XOQhw181roM2ZhHvZs/c3A1bOOxfRTEKqmkZSq2tRwRhTiBe9RzTUzrOOVJxzFcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z2/Oo3Xb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA104606A32D;
	Sat,  7 Nov 2026 14:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2/Oo3Xb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897FF1F0089F;
	Sat,  7 Nov 2026 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062688;
	bh=itDku/vLK6bpFS6b9ApL5qwqE+N4bZdz5AtYIk1m1ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2/Oo3XbT7jsUVd1cct7niE03JbkliIfnV8eosnxJKlP9R2BMlQP49u/HeNXXGC2e
	 D+o9YOOvEb9DTKlqCiFvFhf2CSGAJ1faOB4kbwCcfC1suuZawqd4MSdTzzNgpqd9RG
	 xrYIy/Aa1DMTvAOcUYmPvQLh2NcVq45/2n8P4hxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/869] rust: irq: declare cfi_encoding for irqreturn
Date: Sat,  7 Nov 2026 08:44:58 -0500
Message-ID: <20261107134852.534647921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit 01f3e6b4b1c8c1748e59ba53631ab1f5d9ad0ea4 ]

The IRQ callbacks return c_uint. C calls them through irq_handler_t,
which returns enum irqreturn. kCFI encodes enum types by name even with
integer normalization, so the type ids never match and every call fails
the CFI check.

Generate irqreturn as a newtype with a cfi_encoding, as is done for
lru_status, and return bindings::irqreturn_t from the callbacks.

Fixes: 0851d34a8cc3 ("rust: irq: add support for non-threaded IRQs and handlers")
Fixes: 135d40523244 ("rust: irq: add support for threaded IRQs and handlers")
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261019-rust-cfi-fixes-v1-1-9503472ba738@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ sashal: replaced bindgen's custom enum attribute option with sed post-processing to support older bindgen ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile              |  3 ++-
 rust/bindgen_parameters    |  3 +++
 rust/bindings/lib.rs       |  1 +
 rust/kernel/irq/request.rs | 22 +++++++++++-----------
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index d4618f646b05b..3867ff14fbdec 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -367,7 +367,8 @@ quiet_cmd_bindgen = BINDGEN $@
 $(obj)/bindings/bindings_generated.rs: private bindgen_target_flags = \
     $(shell grep -Ev '^#|^$$' $(src)/bindgen_parameters)
 $(obj)/bindings/bindings_generated.rs: private bindgen_target_extra = ; \
-    sed -Ei 's/pub const RUST_CONST_HELPER_([a-zA-Z0-9_]*)/pub const \1/g' $@
+    sed -Ei 's/pub const RUST_CONST_HELPER_([a-zA-Z0-9_]*)/pub const \1/g' $@; \
+    sed -Ei 's/^pub struct irqreturn\(/#[cfi_encoding="9irqreturn"]\n&/' $@
 $(obj)/bindings/bindings_generated.rs: $(src)/bindings/bindings_helper.h \
     $(src)/bindgen_parameters FORCE
 	$(call if_changed_dep,bindgen)
diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index e13c6f9dd17b2..9e02500dc9792 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -23,6 +23,9 @@
 # warning. We don't need to peek into it anyway.
 --opaque-type spinlock
 
+# enums that appear in indirect function calls should specify a cfi type
+--newtype-enum irqreturn
+
 # `seccomp`'s comment gets understood as a doctest
 --no-doc-comments
 
diff --git a/rust/bindings/lib.rs b/rust/bindings/lib.rs
index 8305adbdf8cbf..37f584727eba1 100644
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -23,6 +23,7 @@
     unreachable_pub,
     unsafe_op_in_unsafe_fn
 )]
+#![feature(cfi_encoding)]
 
 #[allow(dead_code)]
 #[allow(clippy::as_underscore)]
diff --git a/rust/kernel/irq/request.rs b/rust/kernel/irq/request.rs
index 70700f43ddd37..4f2b315856b9b 100644
--- a/rust/kernel/irq/request.rs
+++ b/rust/kernel/irq/request.rs
@@ -20,10 +20,10 @@
 #[repr(u32)]
 pub enum IrqReturn {
     /// The interrupt was not from this device or was not handled.
-    None = bindings::irqreturn_IRQ_NONE,
+    None = bindings::irqreturn::IRQ_NONE.0,
 
     /// The interrupt was handled by this device.
-    Handled = bindings::irqreturn_IRQ_HANDLED,
+    Handled = bindings::irqreturn::IRQ_HANDLED.0,
 }
 
 /// Callbacks for an IRQ handler.
@@ -275,7 +275,7 @@ pub fn synchronize(&self, dev: &Device<Bound>) -> Result {
 unsafe extern "C" fn handle_irq_callback<T: Handler + 'static>(
     _irq: i32,
     ptr: *mut c_void,
-) -> c_uint {
+) -> bindings::irqreturn_t {
     // SAFETY: `ptr` is a pointer to `RegistrationInner` set in `Registration::new`
     let inner = unsafe { &*(ptr as *const RegistrationInner) };
     // SAFETY: `inner.handler` is a pointer to `T` set in `Registration::new`
@@ -284,20 +284,20 @@ pub fn synchronize(&self, dev: &Device<Bound>) -> Result {
     // callback is running implies that the device has not yet been unbound.
     let device = unsafe { inner.dev.as_bound() };
 
-    T::handle(handler, device) as c_uint
+    bindings::irqreturn_t(T::handle(handler, device) as c_uint)
 }
 
 /// The value that can be returned from [`ThreadedHandler::handle`].
 #[repr(u32)]
 pub enum ThreadedIrqReturn {
     /// The interrupt was not from this device or was not handled.
-    None = bindings::irqreturn_IRQ_NONE,
+    None = bindings::irqreturn::IRQ_NONE.0,
 
     /// The interrupt was handled by this device.
-    Handled = bindings::irqreturn_IRQ_HANDLED,
+    Handled = bindings::irqreturn::IRQ_HANDLED.0,
 
     /// The handler wants the handler thread to wake up.
-    WakeThread = bindings::irqreturn_IRQ_WAKE_THREAD,
+    WakeThread = bindings::irqreturn::IRQ_WAKE_THREAD.0,
 }
 
 /// Callbacks for a threaded IRQ handler.
@@ -501,7 +501,7 @@ pub fn synchronize(&self, dev: &Device<Bound>) -> Result {
 unsafe extern "C" fn handle_threaded_irq_callback<T: ThreadedHandler + 'static>(
     _irq: i32,
     ptr: *mut c_void,
-) -> c_uint {
+) -> bindings::irqreturn_t {
     // SAFETY: `ptr` is a pointer to `RegistrationInner` set in `ThreadedRegistration::new`
     let inner = unsafe { &*(ptr as *const RegistrationInner) };
     // SAFETY: `inner.handler` is a pointer to `T` set in `ThreadedRegistration::new`
@@ -510,7 +510,7 @@ pub fn synchronize(&self, dev: &Device<Bound>) -> Result {
     // callback is running implies that the device has not yet been unbound.
     let device = unsafe { inner.dev.as_bound() };
 
-    T::handle(handler, device) as c_uint
+    bindings::irqreturn_t(T::handle(handler, device) as c_uint)
 }
 
 /// # Safety
@@ -519,7 +519,7 @@ pub fn synchronize(&self, dev: &Device<Bound>) -> Result {
 unsafe extern "C" fn thread_fn_callback<T: ThreadedHandler + 'static>(
     _irq: i32,
     ptr: *mut c_void,
-) -> c_uint {
+) -> bindings::irqreturn_t {
     // SAFETY: `ptr` is a pointer to `RegistrationInner` set in `ThreadedRegistration::new`
     let inner = unsafe { &*(ptr as *const RegistrationInner) };
     // SAFETY: `inner.handler` is a pointer to `T` set in `ThreadedRegistration::new`
@@ -528,5 +528,5 @@ pub fn synchronize(&self, dev: &Device<Bound>) -> Result {
     // callback is running implies that the device has not yet been unbound.
     let device = unsafe { inner.dev.as_bound() };
 
-    T::handle_threaded(handler, device) as c_uint
+    bindings::irqreturn_t(T::handle_threaded(handler, device) as c_uint)
 }
-- 
2.53.0



