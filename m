Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C466929A1;
	Tue, 17 Feb 2026 20:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361493; cv=none; b=k7e8y/2CENif//8u1zJS0jl2fGAmvFjvFDgTy8atLJaaWwxdcYZjrdeboMkr0P6jBcMDa/DgZ5/RJ//rYA5dvBcsCR9dxt8LXEnua9eJOg5v6KKXUw/4uXdoxs7v8cEZdJvXOLuENvMOxTXinApnT88py2/rbKjnWBRV0DBBREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361493; c=relaxed/simple;
	bh=KUoF+ByEwtCSyEpOp5csEQUQlqY7znbosPuc5NUxajc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcooU3Xqiz/hygk3XlGNIwEJ3oylE9k0BnG6EUa2LWXheC6DeYm/Ec8dkVvJqnt82cwP6EMFON5FX6khJFoOMhfJpTf3tJZK6prxv8bxayFO2hgOdDPtJs78GfshXetbkBnFp0vOR2gUgLFDfPLuD3lnKQm79s+e0kM+rFjAezA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bllCpPTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bllCpPTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C8EC4CEF7;
	Tue, 17 Feb 2026 20:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361493;
	bh=KUoF+ByEwtCSyEpOp5csEQUQlqY7znbosPuc5NUxajc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bllCpPTA4ZWIDsdYF6dy5K87/GrTEV8PKlICbQJNWs/anMBROaM59bcBnvBCXwZWp
	 S+hFc9VADXo6Ou+0SEpXyMPl/Fb0OK2q8W1IyLiPbHAWTaLapA9vMy9Hcm89orFvju
	 30VQwVo+khmIODT8TCy7V/75/sJvZoRiM1ZFVQvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 04/43] rust: driver: fix broken intra-doc links to example driver types
Date: Tue, 17 Feb 2026 21:31:44 +0100
Message-ID: <20260217200006.639674811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 4c9f6a782f6078dc94450fcb22e65d520bfa0775 upstream.

The `auxiliary` and `pci` modules are conditional on
`CONFIG_AUXILIARY_BUS` and `CONFIG_PCI` respectively. When these are
disabled, the intra-doc links to `auxiliary::Driver` and `pci::Driver`
break, causing rustdoc warnings (or errors with `-D warnings`).

error: unresolved link to `kernel::auxiliary::Driver`
  --> rust/kernel/driver.rs:82:28
   |
82 | //! [`auxiliary::Driver`]: kernel::auxiliary::Driver
   |                            ^^^^^^^^^^^^^^^^^^^^^^^^^ no item named `auxiliary` in module `kernel`

Fix this by making the documentation for these examples conditional on
the corresponding configuration options.

Fixes: 970a7c68788e ("driver: rust: expand documentation for driver infrastructure")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reported-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Closes: https://lore.kernel.org/rust-for-linux/20251209.151817.744108529426448097.fujita.tomonori@gmail.com/
Link: https://patch.msgid.link/20251227-driver-types-v1-1-1916154fbe5e@google.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/driver.rs |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/rust/kernel/driver.rs
+++ b/rust/kernel/driver.rs
@@ -33,7 +33,14 @@
 //! }
 //! ```
 //!
-//! For specific examples see [`auxiliary::Driver`], [`pci::Driver`] and [`platform::Driver`].
+//! For specific examples see:
+//!
+//! * [`platform::Driver`](kernel::platform::Driver)
+#![cfg_attr(
+    CONFIG_AUXILIARY_BUS,
+    doc = "* [`auxiliary::Driver`](kernel::auxiliary::Driver)"
+)]
+#![cfg_attr(CONFIG_PCI, doc = "* [`pci::Driver`](kernel::pci::Driver)")]
 //!
 //! The `probe()` callback should return a `Result<Pin<KBox<Self>>>`, i.e. the driver's private
 //! data. The bus abstraction should store the pointer in the corresponding bus device. The generic
@@ -79,7 +86,6 @@
 //!
 //! For this purpose the generic infrastructure in [`device_id`] should be used.
 //!
-//! [`auxiliary::Driver`]: kernel::auxiliary::Driver
 //! [`Core`]: device::Core
 //! [`Device`]: device::Device
 //! [`Device<Core>`]: device::Device<device::Core>
@@ -87,8 +93,6 @@
 //! [`DeviceContext`]: device::DeviceContext
 //! [`device_id`]: kernel::device_id
 //! [`module_driver`]: kernel::module_driver
-//! [`pci::Driver`]: kernel::pci::Driver
-//! [`platform::Driver`]: kernel::platform::Driver
 
 use crate::error::{Error, Result};
 use crate::{acpi, device, of, str::CStr, try_pin_init, types::Opaque, ThisModule};


