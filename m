Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0DF17BED0;
	Sat, 17 Oct 2026 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253295; cv=none; b=E4H1GlVzPJzsNqO6DP/keRvu/yIk75tXCsZ0pxzHAAVYGVC7LE4OzI6rWt5Xz0SbuC0HgaJUdJNHv6Rigk1hwxPF7vpAL9+2RAlpgvu4SEkcof/T1PfXKmXo2lRYuwSJU8jCNCDXwYFdTl37UJX8Cf6HoYQqzDhkx3cZdonfieU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253295; c=relaxed/simple;
	bh=j+DH6ABj+C4tfrSdIdNWaof/VX2k57b69NlcXcOgjGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snjzrHYkfjnbQYOE3cIXSj3IbERlspo9qs6qcuU8mu/vLDd7V9hn/iZ/3JxGnus/fBG+1KoZOEEsbashGRdO+7ehSZHBmgWFzDmS88qChyk5oTiwbVKzBYeqHEMPaLpqeGLpNHOU6GGrtfnV7r5Np7QuMUVmUThsVLVlS2+ZSnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wfa5uJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wfa5uJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B491F000C4;
	Sat, 17 Oct 2026 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253290;
	bh=XSa/fBlqAHk9vggjmmEMWtCxWCUOs26qxNan+fYVJYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wfa5uJUebecpnZ+56WJSs9GaACZ+wCyL66mYZRzDrsY4acMFhZ0CdW5RFwCfHREb
	 T7twT1oRcAvT91V3K5a2qaYEtZTNFE6nfXJPBxypHRXqwO1nZmhjztN9c/G/CjVlqS
	 Pqb7/ZELd5KP5VR/qKK5Pn4F+m5TF5jBaE8oWZMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/869] drm/vmwgfx: Stop using dev_private to store driver data.
Date: Sat, 17 Oct 2026 17:47:48 +0200
Message-ID: <20261017160037.708110592@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maaz Mombasawala <maaz.mombasawala@broadcom.com>

[ Upstream commit 1b1d5fe66ca591d34c5501aab8f5f09f347e8a3e ]

Currently vmwgfx uses the dev_private opaque pointer in drm_device to store
driver data in vmw_private struct. Using dev_private is deprecated, and the
recommendation is to embed struct drm_device in the larger per-device
structure.

The vmwgfx driver already embeds struct drm_device in its struct
vmw_private, so switch to using that exclusively and stop using
dev_private.

Signed-off-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240502004033.107533-1-maaz.mombasawala@broadcom.com
Stable-dep-of: 21bc51cb89ce ("drm/vmwgfx: validate pitch coming from userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 2 --
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 2e84e1029732d..1b0b9d2d4e720 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -856,8 +856,6 @@ static int vmw_driver_load(struct vmw_private *dev_priv, u32 pci_id)
 	bool refuse_dma = false;
 	struct pci_dev *pdev = to_pci_dev(dev_priv->drm.dev);
 
-	dev_priv->drm.dev_private = dev_priv;
-
 	vmw_sw_context_init(dev_priv);
 
 	mutex_init(&dev_priv->cmdbuf_mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 4e2807f5f94cf..b21831ef214a6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -639,7 +639,7 @@ static inline struct vmw_surface *vmw_res_to_srf(struct vmw_resource *res)
 
 static inline struct vmw_private *vmw_priv(struct drm_device *dev)
 {
-	return (struct vmw_private *)dev->dev_private;
+	return container_of(dev, struct vmw_private, drm);
 }
 
 static inline struct vmw_private *vmw_priv_from_ttm(struct ttm_device *bdev)
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 5f99f7437ae61..800a79e035ed6 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -280,7 +280,7 @@ static void vmw_du_put_cursor_mob(struct vmw_cursor_plane *vcp,
 static int vmw_du_get_cursor_mob(struct vmw_cursor_plane *vcp,
 				 struct vmw_plane_state *vps)
 {
-	struct vmw_private *dev_priv = vcp->base.dev->dev_private;
+	struct vmw_private *dev_priv = vmw_priv(vcp->base.dev);
 	u32 size = vmw_du_cursor_mob_size(vps->base.crtc_w, vps->base.crtc_h);
 	u32 i;
 	u32 cursor_max_dim, mob_max_size;
@@ -519,7 +519,7 @@ void vmw_du_cursor_plane_destroy(struct drm_plane *plane)
 	struct vmw_cursor_plane *vcp = vmw_plane_to_vcp(plane);
 	u32 i;
 
-	vmw_cursor_update_position(plane->dev->dev_private, false, 0, 0);
+	vmw_cursor_update_position(vmw_priv(plane->dev), false, 0, 0);
 
 	for (i = 0; i < ARRAY_SIZE(vcp->cursor_mobs); i++)
 		vmw_du_destroy_cursor_mob(&vcp->cursor_mobs[i]);
-- 
2.53.0



