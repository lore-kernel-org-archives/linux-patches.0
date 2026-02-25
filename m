Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B509C18B0A;
	Wed, 25 Feb 2026 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983285; cv=none; b=kRTH8g/BuszJ/CNouax4PcJt1wRtNcJ0ie3NZVpamQHn2gGlenahVP7VtQKVV4K6//zKXVSQDilfQoss+LlEDckLxr98XLYxyorOhU9QfW27fp/p9EIbLOkwP5bB8zg6Azw1P6xXxwVoxTH8n2kyM2Ti68NPQwuHs5DC7c3OIa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983285; c=relaxed/simple;
	bh=mxfB2HfyCdloaKzN6BXjsA7y8AWlzRUMX8Ii20US1oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqCtYMfJ2flOZ2nBbHfDj1cVHR2gDNrW36jhJv1GSszkSOSmFkRX+YyOxPkMjF0GIiahv2/x1QFsXQQHRqh4aI18dKrKIsqxUwptJ4tLLm7aSp+4I6voNri1ZEe1fsdjtzFHpur0i8eR6TX8cTgj2CpIRi3ZY/vpH8EQy7tSADE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/dmTDbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/dmTDbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694B6C116D0;
	Wed, 25 Feb 2026 01:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983285;
	bh=mxfB2HfyCdloaKzN6BXjsA7y8AWlzRUMX8Ii20US1oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/dmTDbzqDUbPZBk45FiGBtCau0hfB9npxScTaiZWzsiaacd36yIfU5kIJGxkvjHJ
	 q2EkMz2Zsvnv18os/slwfQmRc7O0Lfq2Fp7gFReNKhPk7Gk150iwdeMGhDaRLPrx4F
	 T46qDGLqpQ315956e7PmcD1BfPxXiut/f7NzPwU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 422/781] rust: driver-core: use "kernel vertical" style for imports
Date: Tue, 24 Feb 2026 17:18:51 -0800
Message-ID: <20260225012410.052655058@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 52563c665b0b0b39f319bee40ecc5e8f25b9050a ]

Convert all imports to use "kernel vertical" style.

With this, subsequent patches neither introduce unrelated changes nor
leave an inconsistent import pattern.

While at it, drop unnecessary imports covered by prelude::*.

Link: https://docs.kernel.org/rust/coding-guidelines.html#imports
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260105142123.95030-3-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Stable-dep-of: ba268514ea14 ("rust: devres: fix race condition due to nesting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/device.rs | 14 +++++++++++---
 rust/kernel/devres.rs | 25 +++++++++++++++++++------
 rust/kernel/driver.rs | 12 ++++++++----
 3 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 031720bf5d8ca..7b950b01f16d4 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -5,12 +5,20 @@
 //! C header: [`include/linux/device.h`](srctree/include/linux/device.h)
 
 use crate::{
-    bindings, fmt,
+    bindings,
+    fmt,
     prelude::*,
     sync::aref::ARef,
-    types::{ForeignOwnable, Opaque},
+    types::{
+        ForeignOwnable,
+        Opaque, //
+    }, //
+};
+use core::{
+    any::TypeId,
+    marker::PhantomData,
+    ptr, //
 };
-use core::{any::TypeId, marker::PhantomData, ptr};
 
 #[cfg(CONFIG_PRINTK)]
 use crate::c_str;
diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index 835d9c11948e7..db02f8b1788d4 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -8,13 +8,26 @@
 use crate::{
     alloc::Flags,
     bindings,
-    device::{Bound, Device},
-    error::{to_result, Error, Result},
-    ffi::c_void,
+    device::{
+        Bound,
+        Device, //
+    },
+    error::to_result,
     prelude::*,
-    revocable::{Revocable, RevocableGuard},
-    sync::{aref::ARef, rcu, Completion},
-    types::{ForeignOwnable, Opaque, ScopeGuard},
+    revocable::{
+        Revocable,
+        RevocableGuard, //
+    },
+    sync::{
+        aref::ARef,
+        rcu,
+        Completion, //
+    },
+    types::{
+        ForeignOwnable,
+        Opaque,
+        ScopeGuard, //
+    },
 };
 
 use pin_init::Wrapper;
diff --git a/rust/kernel/driver.rs b/rust/kernel/driver.rs
index bee3ae21a27b2..36de8098754d0 100644
--- a/rust/kernel/driver.rs
+++ b/rust/kernel/driver.rs
@@ -94,10 +94,14 @@
 //! [`device_id`]: kernel::device_id
 //! [`module_driver`]: kernel::module_driver
 
-use crate::error::{Error, Result};
-use crate::{acpi, device, of, str::CStr, try_pin_init, types::Opaque, ThisModule};
-use core::pin::Pin;
-use pin_init::{pin_data, pinned_drop, PinInit};
+use crate::{
+    acpi,
+    device,
+    of,
+    prelude::*,
+    types::Opaque,
+    ThisModule, //
+};
 
 /// Trait describing the layout of a specific device driver.
 ///
-- 
2.51.0



