Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B102980DB;
	Wed, 30 Jul 2025 13:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880857; cv=none; b=IdSLRhO7f/zbft5YmamZf7KvmOhcKAvErWtT1I/OnDkcPhbdjgMMG2ejVc0SufnDQ4+3jEwOqZ7+DwHlCBgudyBLfcjucK0c+8mPDGtDSICygSXi35TN+QgQve6rDzg1Rz923qq9Zamnradu6g7vZ203svl9bzljZUFjz12gcL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880857; c=relaxed/simple;
	bh=F2q0GQGqh2AaMTpYDgf9tG4s1JlhvxttxPNy3dOUclY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3lW1apbICc29zsgN0bDD0RoVVSlvlCSaACWSZjdSKPxjhsB1ICPHlO+nSrq4Rnu2g2a8nWTG8JcO4p0xp43UE0x5AI86zHAtgxCbViACMRNYRws+u5+HVFbrIl6xTTB0yESg8K9dNCi1NKTI6RDMebPbvpGcymJ/Kr7wfJ3bXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJI2hEZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJI2hEZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228B8C4CEEB;
	Wed, 30 Jul 2025 13:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753880857;
	bh=F2q0GQGqh2AaMTpYDgf9tG4s1JlhvxttxPNy3dOUclY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJI2hEZbRdIkWwyv5psUNw73Vl7DEIc0YUKNvEzN12SJAf6owCvlfTgUUOPq6Boza
	 jbE96pT/8TZLDpCi2O8yJXt8eblAqWWeXm+OS7Ks8YGuendzrNzPTr+kqVtRbRQ5wR
	 FxY7hjsQL9YOHiIBjSjWMf5wd0i9V0bhDduwpDpr/F8/I+0eD8+90yST/Q0EY/NHPz
	 /9GyDtSOhCupCC2F55a+pOGHp+R8kHeGYGsZE1O+oD+QQM4OFETa8zu0QOHjVIMA1n
	 VcWGnZM6ZJekzDArHTFjE8Zhxjc2aSS/DdMkKkUC6AVo1AlJYZ+49WXZfRy3ttRlxl
	 wEusv7wPSCEZQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/3] rust: drm: fix `srctree/` links
Date: Wed, 30 Jul 2025 15:07:15 +0200
Message-ID: <20250730130716.3278285-3-ojeda@kernel.org>
In-Reply-To: <20250730130716.3278285-1-ojeda@kernel.org>
References: <20250730130716.3278285-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These `srctree/` links pointed inside `linux/`, but they are directly
under `drm/`.

Thus fix them.

This cleans a future warning that will check our `srctree/` links.

Fixes: a98a73be9ee9 ("rust: drm: file: Add File abstraction")
Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
Fixes: 07c9016085f9 ("rust: drm: add driver abstractions")
Fixes: 1e4b8896c0f3 ("rust: drm: add device abstraction")
Fixes: 9a69570682b1 ("rust: drm: ioctl: Add DRM ioctl abstraction")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/drm/device.rs  | 2 +-
 rust/kernel/drm/driver.rs  | 2 +-
 rust/kernel/drm/file.rs    | 2 +-
 rust/kernel/drm/gem/mod.rs | 2 +-
 rust/kernel/drm/ioctl.rs   | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/drm/device.rs b/rust/kernel/drm/device.rs
index e598c4274f29..306aaa783bbc 100644
--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -2,7 +2,7 @@
 
 //! DRM device.
 //!
-//! C header: [`include/linux/drm/drm_device.h`](srctree/include/linux/drm/drm_device.h)
+//! C header: [`include/drm/drm_device.h`](srctree/include/drm/drm_device.h)
 
 use crate::{
     bindings, device, drm,
diff --git a/rust/kernel/drm/driver.rs b/rust/kernel/drm/driver.rs
index acb638086131..6381cf57fb42 100644
--- a/rust/kernel/drm/driver.rs
+++ b/rust/kernel/drm/driver.rs
@@ -2,7 +2,7 @@
 
 //! DRM driver core.
 //!
-//! C header: [`include/linux/drm/drm_drv.h`](srctree/include/linux/drm/drm_drv.h)
+//! C header: [`include/drm/drm_drv.h`](srctree/include/drm/drm_drv.h)
 
 use crate::{
     bindings, device,
diff --git a/rust/kernel/drm/file.rs b/rust/kernel/drm/file.rs
index b9527705e551..f736cade7eb4 100644
--- a/rust/kernel/drm/file.rs
+++ b/rust/kernel/drm/file.rs
@@ -2,7 +2,7 @@
 
 //! DRM File objects.
 //!
-//! C header: [`include/linux/drm/drm_file.h`](srctree/include/linux/drm/drm_file.h)
+//! C header: [`include/drm/drm_file.h`](srctree/include/drm/drm_file.h)
 
 use crate::{bindings, drm, error::Result, prelude::*, types::Opaque};
 use core::marker::PhantomData;
diff --git a/rust/kernel/drm/gem/mod.rs b/rust/kernel/drm/gem/mod.rs
index 6f914ae0a5aa..95fb562cc968 100644
--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -2,7 +2,7 @@
 
 //! DRM GEM API
 //!
-//! C header: [`include/linux/drm/drm_gem.h`](srctree/include/linux/drm/drm_gem.h)
+//! C header: [`include/drm/drm_gem.h`](srctree/include/drm/drm_gem.h)
 
 use crate::{
     alloc::flags::*,
diff --git a/rust/kernel/drm/ioctl.rs b/rust/kernel/drm/ioctl.rs
index 445639404fb7..a19bc8eca029 100644
--- a/rust/kernel/drm/ioctl.rs
+++ b/rust/kernel/drm/ioctl.rs
@@ -2,7 +2,7 @@
 
 //! DRM IOCTL definitions.
 //!
-//! C header: [`include/linux/drm/drm_ioctl.h`](srctree/include/linux/drm/drm_ioctl.h)
+//! C header: [`include/drm/drm_ioctl.h`](srctree/include/drm/drm_ioctl.h)
 
 use crate::ioctl;
 
-- 
2.50.1

