Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CD42BDC2E
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 11:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750849931; cv=none; b=qo9xIIlQUjFlBNN6cBqiTJn8adCWm1nrhDVIPX30KP2POrkmMLT7f8gclZqP+KC7SB/bNUJ7WNPKxCYFuvk3s4Zlh7HzsHktKaJw3uv/NuL5RqZkb31uQpT1JA6tCLXIDnUr/dCYhC0BUR9aigGxWvH3m/mWWUNBGbmdEE9eM5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750849931; c=relaxed/simple;
	bh=MTlM6vMRwqv+uHu3nWGtqbZ3uMZfL48tTQ905Pa8zM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DDrU/EdCGC7pgaL0OUH/Klkoo/g0RVV8FjgDeuq1Zpkn2c9dutR9bPYAVOfvkyjGuHEjLYP/ibKsFOQ+3QXCqHLMDCyGFAwEdggYj03r5JwvMvNI4QXc5f4CHyou/9hJnxf0vm74XM7Z9m0pFA6Q5UansgpQbgcSyIEs6RNH6Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g61K9Bw5; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g61K9Bw5"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7490cb9a892so695600b3a.0
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 04:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750849929; x=1751454729; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSEckj8RWfEPJ9gxxRoiQK/w0X9kSfI3L2wiTsQ12M0=;
        b=g61K9Bw5qrmRO6y2eozNXbkVxGR9KV8IiGzOFgPjrt220I+0rqcZ41wDx1yvdBVYLK
         69U4KVYbtnlrr1viwp7/Cu3iJofRxojdI/no/55AbvdYzAJSeIJULuwHWDkTcCaflhcR
         /Vc5P1tVMYrLvuE7NxtOCu83281qFRmsiObx7AyhMqi+yrERG2LVNnlNveskq2pCAPRB
         ZrFUjFLtxlDMu8I1pL4nV2V69Ea/ecpzJtSwWjfQ+letyisALfhuGY7EXQmOql6nYVS9
         nYRJwwfmpKaOB3VY2gulnn51khr4iyrdvR/TDYrxg1iQOyOs9CHBTheu2KWANmCmrhV4
         uRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750849929; x=1751454729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSEckj8RWfEPJ9gxxRoiQK/w0X9kSfI3L2wiTsQ12M0=;
        b=Q+hvwDNoQPETe+zgdfOFvVKMa/pChvKQc0k3Blt8uS3jT2wHIkxZo/RUCgNduFdKr1
         uMni2CQPowF6ORt3AaNIdUvZ3+VGyYd+nRaEV264acZfcsx8XiNUsyPvNVmyTlI0ZXh3
         qpYtYJO6+TRiN3DfoTEQSScpjRqWpDG1XOx9CTzwN0sr20fdX1eqBDzLrUULFEd0YhvL
         8SUA3+8pUbuvLhYi9S5QPnGD8+QLnUJGvZHGvTiA038XRvc25igJaUKK3J6XsDDqHhS2
         cci9V2ryxPzz5iNbeish7g1X0gAGRFMBGTr82cPum/J9KFDmt+LlQHbsBVqLvpYeUolb
         UugQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgpJu1upKvKUHy3DqLUU06UIbcZ6csfKcPAFI6z+JcJ9Pk8S6T2BFkTcrspZ604D5r7mv+8nGy@lists.linux.dev
X-Gm-Message-State: AOJu0YznfUUn4u0NqLTLJjzRI9Nylar12zhEK2JHrFqUIBa2cPeYELkT
	iA/dr/V1oKPJTW5nWsB2mzTVlsFTGh6KMyME3SMl/VLCohN9F4AaFVtKh0RdMeDm
X-Gm-Gg: ASbGncu/SNpSNtKN6sB6XBLMg9qPpaTRIQzZRGLsXStf9xdXQt1rivpfA93M8GJ8pB1
	f1IXQIGwbDii/4SZ4QN3brrJO0qWGRtOGy1eehfOGD/m2WfYdxe36Vq4ScU/BqB38dNdplLNMXY
	kwHrBl6wU4Jm6BiQhKJV0bG7IfsjwY6n+Jv2ienxS3QLmuqrkG3JDwpYjhHyHGcSlk1B9pyzNXR
	lsw7MlTBkNHZn7nY4DFc+stoHB/lsPd/d2iEGFDWzSv6LM4C2BQfU1E5iYTo3bgvaJ8YOrYeVCe
	/Iz9MtFSSSgjD+Sg+fwGjz8OBf3DvXyrwhD3VOHU6UpyGEk6/2eanLG3bju+uajj6P2x7Bx0OnK
	Yk94+
X-Google-Smtp-Source: AGHT+IEuJpzcoZ26pcXha9u5QvfHSftxtVoQ3ay6tMjWt/cJfs+b3/Al20QIkANTOR9bB6ds5sBW/Q==
X-Received: by 2002:a05:6a20:448f:b0:215:eac9:1ab3 with SMTP id adf61e73a8af0-2207f2a225fmr5499491637.29.1750849928596;
        Wed, 25 Jun 2025 04:12:08 -0700 (PDT)
Received: from shankari-IdeaPad.. ([2409:4080:10:4ef8:7bae:5763:c10a:8810])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34aabc3842sm2561417a12.50.2025.06.25.04.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 04:12:08 -0700 (PDT)
From: Shankari Anand <shankari.ak0208@gmail.com>
To: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	patches@lists.linux.dev
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Shankari Anand <shankari.ak0208@gmail.com>
Subject: [PATCH v2 2/2] rust: update ARef and AlwaysRefCounted call sites to import from sync::aref
Date: Wed, 25 Jun 2025 16:41:33 +0530
Message-Id: <20250625111133.698481-2-shankari.ak0208@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250625111133.698481-1-shankari.ak0208@gmail.com>
References: <20250625111133.698481-1-shankari.ak0208@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update call sites to import ARef and AlwaysRefCounted from sync::aref
instead of indirectly via types.
Remove the re-export of their definitions in types.rs.

Suggested-by: Benno Lossin <lossin@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1173
Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
---
 drivers/block/rnull.rs               |  3 +--
 drivers/gpu/drm/nova/driver.rs       |  2 +-
 drivers/gpu/drm/nova/gem.rs          |  2 +-
 rust/kernel/auxiliary.rs             |  2 +-
 rust/kernel/block/mq.rs              |  6 +++---
 rust/kernel/block/mq/operations.rs   |  2 +-
 rust/kernel/block/mq/request.rs      |  3 ++-
 rust/kernel/cred.rs                  |  3 ++-
 rust/kernel/device.rs                |  7 ++++---
 rust/kernel/devres.rs                |  3 +--
 rust/kernel/dma.rs                   |  2 +-
 rust/kernel/drm/device.rs            |  3 ++-
 rust/kernel/drm/driver.rs            |  2 +-
 rust/kernel/drm/gem/mod.rs           |  3 ++-
 rust/kernel/fs/file.rs               |  3 ++-
 rust/kernel/mm.rs                    |  3 ++-
 rust/kernel/mm/mmput_async.rs        |  2 +-
 rust/kernel/opp.rs                   | 13 +++++++------
 rust/kernel/pci.rs                   |  5 +++--
 rust/kernel/pid_namespace.rs         |  3 ++-
 rust/kernel/platform.rs              |  2 +-
 rust/kernel/task.rs                  |  7 ++++---
 rust/kernel/types.rs                 |  2 --
 samples/rust/rust_dma.rs             |  2 +-
 samples/rust/rust_driver_pci.rs      |  2 +-
 samples/rust/rust_driver_platform.rs |  2 +-
 samples/rust/rust_misc_device.rs     |  3 +--
 27 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/block/rnull.rs b/drivers/block/rnull.rs
index d07e76ae2c13..80a0f7aa949e 100644
--- a/drivers/block/rnull.rs
+++ b/drivers/block/rnull.rs
@@ -20,8 +20,7 @@
     error::Result,
     new_mutex, pr_info,
     prelude::*,
-    sync::{Arc, Mutex},
-    types::ARef,
+    sync::{aref::ARef, Arc, Mutex},
 };
 
 module! {
diff --git a/drivers/gpu/drm/nova/driver.rs b/drivers/gpu/drm/nova/driver.rs
index b28b2e05cc15..af2cbee80ec1 100644
--- a/drivers/gpu/drm/nova/driver.rs
+++ b/drivers/gpu/drm/nova/driver.rs
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-use kernel::{auxiliary, c_str, device::Core, drm, drm::gem, drm::ioctl, prelude::*, types::ARef};
+use kernel::{auxiliary, c_str, device::Core, drm, drm::gem, drm::ioctl, prelude::*, sync::aref::ARef};
 
 use crate::file::File;
 use crate::gem::NovaObject;
diff --git a/drivers/gpu/drm/nova/gem.rs b/drivers/gpu/drm/nova/gem.rs
index 33b62d21400c..cd82773dab92 100644
--- a/drivers/gpu/drm/nova/gem.rs
+++ b/drivers/gpu/drm/nova/gem.rs
@@ -4,7 +4,7 @@
     drm,
     drm::{gem, gem::BaseObject},
     prelude::*,
-    types::ARef,
+    sync::aref::ARef,
 };
 
 use crate::{
diff --git a/rust/kernel/auxiliary.rs b/rust/kernel/auxiliary.rs
index d2cfe1eeefb6..776c63387832 100644
--- a/rust/kernel/auxiliary.rs
+++ b/rust/kernel/auxiliary.rs
@@ -250,7 +250,7 @@ extern "C" fn release(dev: *mut bindings::device) {
 kernel::impl_device_context_into_aref!(Device);
 
 // SAFETY: Instances of `Device` are always reference-counted.
-unsafe impl crate::types::AlwaysRefCounted for Device {
+unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
     fn inc_ref(&self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
         unsafe { bindings::get_device(self.as_ref().as_raw()) };
diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
index 831445d37181..3e7e0de92604 100644
--- a/rust/kernel/block/mq.rs
+++ b/rust/kernel/block/mq.rs
@@ -20,7 +20,7 @@
 //! The kernel will interface with the block device driver by calling the method
 //! implementations of the `Operations` trait.
 //!
-//! IO requests are passed to the driver as [`kernel::types::ARef<Request>`]
+//! IO requests are passed to the driver as [`kernel::sync::aref::ARef<Request>`]
 //! instances. The `Request` type is a wrapper around the C `struct request`.
 //! The driver must mark end of processing by calling one of the
 //! `Request::end`, methods. Failure to do so can lead to deadlock or timeout
@@ -57,12 +57,12 @@
 //!
 //! ```rust
 //! use kernel::{
 //!     alloc::flags,
 //!     block::mq::*,
 //!     new_mutex,
 //!     prelude::*,
-//!     sync::{Arc, Mutex},
-//!     types::{ARef, ForeignOwnable},
+//!     sync::{aref::ARef, Arc, Mutex},
+//!     types::ForeignOwnable,
 //! };
 //!
 //! struct MyBlkDevice;
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index c2b98f507bcb..18d858763e08 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -10,7 +10,7 @@
     block::mq::Request,
     error::{from_result, Result},
     prelude::*,
-    types::ARef,
+    sync::aref::ARef,
 };
 use core::{marker::PhantomData, sync::atomic::AtomicU64, sync::atomic::Ordering};
 
diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index fefd394f064a..9cca7852b309 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -8,7 +8,8 @@
     bindings,
     block::mq::Operations,
     error::Result,
-    types::{ARef, AlwaysRefCounted, Opaque},
+    sync::aref::{ARef, AlwaysRefCounted},
+    types::Opaque,
 };
 use core::{
     marker::PhantomData,
diff --git a/rust/kernel/cred.rs b/rust/kernel/cred.rs
index 2599f01e8b28..2b6ac62f595f 100644
--- a/rust/kernel/cred.rs
+++ b/rust/kernel/cred.rs
@@ -11,7 +11,8 @@
 use crate::{
     bindings,
     task::Kuid,
-    types::{AlwaysRefCounted, Opaque},
+    sync::aref::AlwaysRefCounted,
+    types::Opaque,
 };
 
 /// Wraps the kernel's `struct cred`.
diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 5c946af3a4d5..3631fa67b330 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -7,7 +7,8 @@
 use crate::{
     bindings,
     str::CStr,
-    types::{ARef, Opaque},
+    sync::aref::ARef,
+    types::Opaque,
 };
 use core::{fmt, marker::PhantomData, ptr};
 
@@ -216,7 +217,7 @@ pub fn property_present(&self, name: &CStr) -> bool {
 kernel::impl_device_context_into_aref!(Device);
 
 // SAFETY: Instances of `Device` are always reference-counted.
-unsafe impl crate::types::AlwaysRefCounted for Device {
+unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
     fn inc_ref(&self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
         unsafe { bindings::get_device(self.as_raw()) };
@@ -322,7 +323,7 @@ macro_rules! impl_device_context_deref {
 #[macro_export]
 macro_rules! __impl_device_context_into_aref {
     ($src:ty, $device:tt) => {
-        impl ::core::convert::From<&$device<$src>> for $crate::types::ARef<$device> {
+        impl ::core::convert::From<&$device<$src>> for $crate::sync::aref::ARef<$device> {
             fn from(dev: &$device<$src>) -> Self {
                 (&**dev).into()
             }
diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index d0e6c6e162c2..7a1e2f2721b8 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -13,8 +13,7 @@
     ffi::c_void,
     prelude::*,
     revocable::{Revocable, RevocableGuard},
-    sync::{rcu, Arc, Completion},
-    types::ARef,
+    sync::{aref::ARef, rcu, Arc, Completion},
 };
 
 #[pin_data]
diff --git a/rust/kernel/dma.rs b/rust/kernel/dma.rs
index 8e317005decd..7e6407655969 100644
--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -9,8 +9,8 @@
     device::{Bound, Device},
     error::code::*,
     error::Result,
+    sync::aref::ARef,
     transmute::{AsBytes, FromBytes},
-    types::ARef,
 };
 
 /// Possible attributes associated with a DMA mapping.
diff --git a/rust/kernel/drm/device.rs b/rust/kernel/drm/device.rs
index b7ee3c464a12..d8f0be5fdce7 100644
--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -10,7 +10,8 @@
     error::from_err_ptr,
     error::Result,
     prelude::*,
-    types::{ARef, AlwaysRefCounted, Opaque},
+    sync::aref::{ARef, AlwaysRefCounted},
+    types::Opaque,
 };
 use core::{mem, ops::Deref, ptr, ptr::NonNull};
 
diff --git a/rust/kernel/drm/driver.rs b/rust/kernel/drm/driver.rs
index acb638086131..9f3450f77ca0 100644
--- a/rust/kernel/drm/driver.rs
+++ b/rust/kernel/drm/driver.rs
@@ -11,7 +11,7 @@
     error::{to_result, Result},
     prelude::*,
     str::CStr,
-    types::ARef,
+    sync::aref::ARef,
 };
 use macros::vtable;
 
diff --git a/rust/kernel/drm/gem/mod.rs b/rust/kernel/drm/gem/mod.rs
index 4cd69fa84318..d2c28397f810 100644
--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -10,7 +10,8 @@
     drm::driver::{AllocImpl, AllocOps},
     error::{to_result, Result},
     prelude::*,
-    types::{ARef, AlwaysRefCounted, Opaque},
+    sync::aref::{ARef, AlwaysRefCounted},
+    types::Opaque,
 };
 use core::{mem, ops::Deref, ptr::NonNull};
 
diff --git a/rust/kernel/fs/file.rs b/rust/kernel/fs/file.rs
index 35fd5db35c46..18cf579d3312 100644
--- a/rust/kernel/fs/file.rs
+++ b/rust/kernel/fs/file.rs
@@ -11,7 +11,8 @@
     bindings,
     cred::Credential,
     error::{code::*, Error, Result},
-    types::{ARef, AlwaysRefCounted, NotThreadSafe, Opaque},
+    sync::aref::{ARef, AlwaysRefCounted},
+    types::{NotThreadSafe, Opaque},
 };
 use core::ptr;
 
diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index 43f525c0d16c..4764d7b68f2a 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -13,7 +13,8 @@
 
 use crate::{
     bindings,
-    types::{ARef, AlwaysRefCounted, NotThreadSafe, Opaque},
+    sync::aref::{ARef, AlwaysRefCounted},
+    types::{NotThreadSafe, Opaque},
 };
 use core::{ops::Deref, ptr::NonNull};
 
diff --git a/rust/kernel/mm/mmput_async.rs b/rust/kernel/mm/mmput_async.rs
index 9289e05f7a67..b8d2f051225c 100644
--- a/rust/kernel/mm/mmput_async.rs
+++ b/rust/kernel/mm/mmput_async.rs
@@ -10,7 +10,7 @@
 use crate::{
     bindings,
     mm::MmWithUser,
-    types::{ARef, AlwaysRefCounted},
+    sync::aref::{ARef, AlwaysRefCounted},
 };
 use core::{ops::Deref, ptr::NonNull};
 
diff --git a/rust/kernel/opp.rs b/rust/kernel/opp.rs
index 0e94cb2703ec..16ec8dd7d1a3 100644
--- a/rust/kernel/opp.rs
+++ b/rust/kernel/opp.rs
@@ -16,7 +16,8 @@
     ffi::c_ulong,
     prelude::*,
     str::CString,
-    types::{ARef, AlwaysRefCounted, Opaque},
+    sync::aref::{ARef, AlwaysRefCounted},
+    types::Opaque,
 };
 
 #[cfg(CONFIG_CPU_FREQ)]
@@ -162,7 +163,7 @@ fn from(power: MicroWatt) -> Self {
 /// use kernel::device::Device;
 /// use kernel::error::Result;
 /// use kernel::opp::{Data, MicroVolt, Token};
-/// use kernel::types::ARef;
+/// use kernel::sync::aref::ARef;
 ///
 /// fn create_opp(dev: &ARef<Device>, freq: Hertz, volt: MicroVolt, level: u32) -> Result<Token> {
 ///     let data = Data::new(freq, volt, level, false);
@@ -211,7 +212,7 @@ fn drop(&mut self) {
 /// use kernel::device::Device;
 /// use kernel::error::Result;
 /// use kernel::opp::{Data, MicroVolt, Token};
-/// use kernel::types::ARef;
+/// use kernel::sync::aref::ARef;
 ///
 /// fn create_opp(dev: &ARef<Device>, freq: Hertz, volt: MicroVolt, level: u32) -> Result<Token> {
 ///     let data = Data::new(freq, volt, level, false);
@@ -262,7 +263,7 @@ fn freq(&self) -> Hertz {
 /// use kernel::clk::Hertz;
 /// use kernel::error::Result;
 /// use kernel::opp::{OPP, SearchType, Table};
-/// use kernel::types::ARef;
+/// use kernel::sync::aref::ARef;
 ///
 /// fn find_opp(table: &Table, freq: Hertz) -> Result<ARef<OPP>> {
 ///     let opp = table.opp_from_freq(freq, Some(true), None, SearchType::Exact)?;
@@ -335,7 +336,7 @@ fn drop(&mut self) {
 /// use kernel::error::Result;
 /// use kernel::opp::{Config, ConfigOps, ConfigToken};
 /// use kernel::str::CString;
-/// use kernel::types::ARef;
+/// use kernel::sync::aref::ARef;
 /// use kernel::macros::vtable;
 ///
 /// #[derive(Default)]
@@ -581,7 +582,7 @@ extern "C" fn config_regulators(
 /// use kernel::device::Device;
 /// use kernel::error::Result;
 /// use kernel::opp::Table;
-/// use kernel::types::ARef;
+/// use kernel::sync::aref::ARef;
 ///
 /// fn get_table(dev: &ARef<Device>, mask: &mut Cpumask, freq: Hertz) -> Result<Table> {
 ///     let mut opp_table = Table::from_of_cpumask(dev, mask)?;
diff --git a/rust/kernel/pci.rs b/rust/kernel/pci.rs
index 6b94fd7a3ce9..c7d95459e745 100644
--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -14,7 +14,8 @@
     io::Io,
     io::IoRaw,
     str::CStr,
-    types::{ARef, ForeignOwnable, Opaque},
+    sync::aref::ARef,
+    types::{ForeignOwnable, Opaque},
     ThisModule,
 };
 use core::{
@@ -438,7 +439,7 @@ pub fn set_master(&self) {
 kernel::impl_device_context_into_aref!(Device);
 
 // SAFETY: Instances of `Device` are always reference-counted.
-unsafe impl crate::types::AlwaysRefCounted for Device {
+unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
     fn inc_ref(&self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
         unsafe { bindings::pci_dev_get(self.as_raw()) };
diff --git a/rust/kernel/pid_namespace.rs b/rust/kernel/pid_namespace.rs
index 0e93808e4639..4fbbf4430f90 100644
--- a/rust/kernel/pid_namespace.rs
+++ b/rust/kernel/pid_namespace.rs
@@ -9,7 +9,8 @@
 
 use crate::{
     bindings,
-    types::{AlwaysRefCounted, Opaque},
+    sync::aref::AlwaysRefCounted,
+    types::Opaque,
 };
 use core::ptr;
 
diff --git a/rust/kernel/platform.rs b/rust/kernel/platform.rs
index 0a6a6be732b2..9c9807b7da54 100644
--- a/rust/kernel/platform.rs
+++ b/rust/kernel/platform.rs
@@ -198,7 +198,7 @@ fn as_raw(&self) -> *mut bindings::platform_device {
 kernel::impl_device_context_into_aref!(Device);
 
 // SAFETY: Instances of `Device` are always reference-counted.
-unsafe impl crate::types::AlwaysRefCounted for Device {
+unsafe impl crate::sync::aref::AlwaysRefCounted for Device {
     fn inc_ref(&self) {
         // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
         unsafe { bindings::get_device(self.as_ref().as_raw()) };
diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 927413d85484..b46488f6d1a8 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -9,7 +9,8 @@
     ffi::{c_int, c_long, c_uint},
     mm::MmWithUser,
     pid_namespace::PidNamespace,
-    types::{ARef, NotThreadSafe, Opaque},
+    sync::aref::ARef,
+    types::{NotThreadSafe, Opaque},
 };
 use core::{
     cmp::{Eq, PartialEq},
@@ -76,7 +77,7 @@ macro_rules! current {
 /// incremented when creating `State` and decremented when it is dropped:
 ///
 /// ```
-/// use kernel::{task::Task, types::ARef};
+/// use kernel::{task::Task, sync::aref::ARef};
 ///
 /// struct State {
 ///     creator: ARef<Task>,
@@ -340,7 +341,7 @@ pub fn active_pid_ns(&self) -> Option<&PidNamespace> {
 }
 
 // SAFETY: The type invariants guarantee that `Task` is always refcounted.
-unsafe impl crate::types::AlwaysRefCounted for Task {
+unsafe impl crate::sync::aref::AlwaysRefCounted for Task {
     fn inc_ref(&self) {
         // SAFETY: The existence of a shared reference means that the refcount is nonzero.
         unsafe { bindings::get_task_struct(self.as_ptr()) };
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 60cb48285630..fccb3ee71345 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -10,8 +10,6 @@
 };
 use pin_init::{PinInit, Zeroable};
 
-pub use crate::sync::aref::{ARef, AlwaysRefCounted};
-
 /// Used to transfer ownership to and from foreign (non-Rust) languages.
 ///
 /// Ownership is transferred from Rust to a foreign language by calling [`Self::into_foreign`] and
diff --git a/samples/rust/rust_dma.rs b/samples/rust/rust_dma.rs
index 874c2c964afa..4aa3ecb7e999 100644
--- a/samples/rust/rust_dma.rs
+++ b/samples/rust/rust_dma.rs
@@ -4,7 +4,7 @@
 //!
 //! To make this driver probe, QEMU must be run with `-device pci-testdev`.
 
-use kernel::{bindings, device::Core, dma::CoherentAllocation, pci, prelude::*, types::ARef};
+use kernel::{bindings, device::Core, dma::CoherentAllocation, pci, prelude::*, sync::aref::ARef};
 
 struct DmaSampleDriver {
     pdev: ARef<pci::Device>,
diff --git a/samples/rust/rust_driver_pci.rs b/samples/rust/rust_driver_pci.rs
index 15147e4401b2..adcdfbb57c6b 100644
--- a/samples/rust/rust_driver_pci.rs
+++ b/samples/rust/rust_driver_pci.rs
@@ -4,7 +4,7 @@
 //!
 //! To make this driver probe, QEMU must be run with `-device pci-testdev`.
 
-use kernel::{bindings, c_str, device::Core, devres::Devres, pci, prelude::*, types::ARef};
+use kernel::{bindings, c_str, device::Core, devres::Devres, pci, prelude::*, sync::aref::ARef};
 
 struct Regs;
 
diff --git a/samples/rust/rust_driver_platform.rs b/samples/rust/rust_driver_platform.rs
index 8b42b3cfb363..da7d0f3ae90d 100644
--- a/samples/rust/rust_driver_platform.rs
+++ b/samples/rust/rust_driver_platform.rs
@@ -2,7 +2,7 @@
 
 //! Rust Platform driver sample.
 
-use kernel::{c_str, device::Core, of, platform, prelude::*, types::ARef};
+use kernel::{c_str, device::Core, of, platform, prelude::*, sync::aref::ARef};
 
 struct SampleDriver {
     pdev: ARef<platform::Device>,
diff --git a/samples/rust/rust_misc_device.rs b/samples/rust/rust_misc_device.rs
index c881fd6dbd08..3f4954e3eb9c 100644
--- a/samples/rust/rust_misc_device.rs
+++ b/samples/rust/rust_misc_device.rs
@@ -105,8 +105,7 @@
     miscdevice::{MiscDevice, MiscDeviceOptions, MiscDeviceRegistration},
     new_mutex,
     prelude::*,
-    sync::Mutex,
-    types::ARef,
+    sync::{aref::ARef, Mutex},
     uaccess::{UserSlice, UserSliceReader, UserSliceWriter},
 };
 
-- 
2.34.1

