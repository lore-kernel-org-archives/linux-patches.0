Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39E52F28EE;
	Fri, 10 Oct 2025 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102376; cv=none; b=Mso/942H88UzENoXcyh/GXWeWqTiZTBkUKkmJm64P5NVJj5c2CydyzCnln1yE60gleAl6bzOlwl0NwuTbr2NDADLNv7NAiwnst0FVeqrXAKz8dsGKx289tfx065IQ7bBFtjP60+BEtv8D/698FRxlQpauxPlFc4Fgg1fdVn8u2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102376; c=relaxed/simple;
	bh=Ylb5LGEljE6OEEdSqUJDFlA8Brzy6EtvBRLi83kBbm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UO6F3bjjgpVUkBARXs8zG9kf00Uj4zc5Zb/FwkyvmXP9i3Gg3gCf2bAw5Y7ZID1cu//CN7OsNw3ENtxp8/SA+2dOGaC4rGIILTsbeGULsr8IL2G+tzrQeQQuGjKHh/QF/WdC+XbUC1Amlfbx72eHFRs+Kh2eGP7arPK/OneZVP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFVtsuvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFVtsuvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43877C4CEF1;
	Fri, 10 Oct 2025 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102376;
	bh=Ylb5LGEljE6OEEdSqUJDFlA8Brzy6EtvBRLi83kBbm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFVtsuvrdq0UEH9uYlECErJEhSJyXhoyV5XziCuBDLjA4fu5Iaf5f+TPq3wqetgcH
	 wTnyXGrwiJgp/gxS28QxBw5JhQQo6bpZW70LtEg6K92D4Iz79NNxLUpptjPAoifq4k
	 OuVqFAjSuJQsuzwMxeq3/wfg8EJQ4XWVIHpXRk8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.16 09/41] rust: drm: fix `srctree/` links
Date: Fri, 10 Oct 2025 15:15:57 +0200
Message-ID: <20251010131333.762115536@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit c2783c7cfefd55b1a5be781679cbee5191c0fd87 upstream.

These `srctree/` links pointed inside `linux/`, but they are directly
under `drm/`.

Thus fix them.

This cleans a future warning that will check our `srctree/` links.

Cc: stable@vger.kernel.org
Fixes: a98a73be9ee9 ("rust: drm: file: Add File abstraction")
Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
Fixes: 07c9016085f9 ("rust: drm: add driver abstractions")
Fixes: 1e4b8896c0f3 ("rust: drm: add device abstraction")
Fixes: 9a69570682b1 ("rust: drm: ioctl: Add DRM ioctl abstraction")
Acked-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/drm/device.rs  |    2 +-
 rust/kernel/drm/driver.rs  |    2 +-
 rust/kernel/drm/file.rs    |    2 +-
 rust/kernel/drm/gem/mod.rs |    2 +-
 rust/kernel/drm/ioctl.rs   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -2,7 +2,7 @@
 
 //! DRM device.
 //!
-//! C header: [`include/linux/drm/drm_device.h`](srctree/include/linux/drm/drm_device.h)
+//! C header: [`include/drm/drm_device.h`](srctree/include/drm/drm_device.h)
 
 use crate::{
     alloc::allocator::Kmalloc,
--- a/rust/kernel/drm/driver.rs
+++ b/rust/kernel/drm/driver.rs
@@ -2,7 +2,7 @@
 
 //! DRM driver core.
 //!
-//! C header: [`include/linux/drm/drm_drv.h`](srctree/include/linux/drm/drm_drv.h)
+//! C header: [`include/drm/drm_drv.h`](srctree/include/drm/drm_drv.h)
 
 use crate::{
     bindings, device,
--- a/rust/kernel/drm/file.rs
+++ b/rust/kernel/drm/file.rs
@@ -2,7 +2,7 @@
 
 //! DRM File objects.
 //!
-//! C header: [`include/linux/drm/drm_file.h`](srctree/include/linux/drm/drm_file.h)
+//! C header: [`include/drm/drm_file.h`](srctree/include/drm/drm_file.h)
 
 use crate::{bindings, drm, error::Result, prelude::*, types::Opaque};
 use core::marker::PhantomData;
--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -2,7 +2,7 @@
 
 //! DRM GEM API
 //!
-//! C header: [`include/linux/drm/drm_gem.h`](srctree/include/linux/drm/drm_gem.h)
+//! C header: [`include/drm/drm_gem.h`](srctree/include/drm/drm_gem.h)
 
 use crate::{
     alloc::flags::*,
--- a/rust/kernel/drm/ioctl.rs
+++ b/rust/kernel/drm/ioctl.rs
@@ -2,7 +2,7 @@
 
 //! DRM IOCTL definitions.
 //!
-//! C header: [`include/linux/drm/drm_ioctl.h`](srctree/include/linux/drm/drm_ioctl.h)
+//! C header: [`include/drm/drm_ioctl.h`](srctree/include/drm/drm_ioctl.h)
 
 use crate::ioctl;
 


