Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2243F82871;
	Wed, 19 Jun 2024 13:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802267; cv=none; b=dr9c1DqzreCxpI0lAb5TMT9JTFd81DR/16Fciyz6ov1Z12dIwKFiy/AnmKWkIxCWVBfkWvoXBEmcRmoDoe63UN/iiPXeyID1T5QlErT7/gEU6xkdJniIYpE0LPQYF8fFWo23jpHA2Tu6qKBgg4k/ciTh+e2ypzwQlidUTdD3Ea4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802267; c=relaxed/simple;
	bh=xv/Z/4UUtwvdnhgG/8qGeiA2/bxiCfoqciQzm8gCrCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyda7SoEBS9MPV/BGNymBrdyrxwKftpuUxK2QFJlob+gCbFXQjB+Pb6HjYst7YZPJ0SPX8+tOUnW90HcB4VVzsXbJ0ly1w4uqcRYul9eoJHoVPtYWlUKt7bfimSQCJ9Gkdio+HDz3UvLtuzLJH4QbciRUsSjAbMDWzeWbD1UngY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKBF+XNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKBF+XNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0E5C2BBFC;
	Wed, 19 Jun 2024 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802267;
	bh=xv/Z/4UUtwvdnhgG/8qGeiA2/bxiCfoqciQzm8gCrCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKBF+XNRs97t977uoYadzhuaMeb5WsrpvQI+KxleL9k3N4srTX8BuzVi8flXe/jKK
	 PF6QlDeXk9J9xWBIOxTMd6VNly/0qkFL7sjOZO1x5qc4C+g0OQhm/aVk1/WOZ8fE/o
	 CzDLbozA8hYF8g5RsNj5kXJPA07WUcSYbHopXjsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/267] drm/vmwgfx: Remove STDU logic from generic mode_valid function
Date: Wed, 19 Jun 2024 14:54:49 +0200
Message-ID: <20240619125611.645628087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit dde1de06bd7248fd83c4ce5cf0dbe9e4e95bbb91 ]

STDU has its own mode_valid function now so this logic can be removed from
the generic version.

Fixes: 935f795045a6 ("drm/vmwgfx: Refactor drm connector probing for display modes")

Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240521184720.767-4-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h |  3 ---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c | 26 +++++++++-----------------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 6acc7ad0e9eb8..13423c7b0cbdb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1067,9 +1067,6 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 int vmw_kms_write_svga(struct vmw_private *vmw_priv,
 		       unsigned width, unsigned height, unsigned pitch,
 		       unsigned bpp, unsigned depth);
-bool vmw_kms_validate_mode_vram(struct vmw_private *dev_priv,
-				uint32_t pitch,
-				uint32_t height);
 int vmw_kms_present(struct vmw_private *dev_priv,
 		    struct drm_file *file_priv,
 		    struct vmw_framebuffer *vfb,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 59de170a31853..93e2a27daed0c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2151,13 +2151,12 @@ int vmw_kms_write_svga(struct vmw_private *vmw_priv,
 	return 0;
 }
 
+static
 bool vmw_kms_validate_mode_vram(struct vmw_private *dev_priv,
-				uint32_t pitch,
-				uint32_t height)
+				u64 pitch,
+				u64 height)
 {
-	return ((u64) pitch * (u64) height) < (u64)
-		((dev_priv->active_display_unit == vmw_du_screen_target) ?
-		 dev_priv->max_primary_mem : dev_priv->vram_size);
+	return (pitch * height) < (u64)dev_priv->vram_size;
 }
 
 /**
@@ -2853,25 +2852,18 @@ int vmw_du_helper_plane_update(struct vmw_du_update_plane *update)
 enum drm_mode_status vmw_connector_mode_valid(struct drm_connector *connector,
 					      struct drm_display_mode *mode)
 {
+	enum drm_mode_status ret;
 	struct drm_device *dev = connector->dev;
 	struct vmw_private *dev_priv = vmw_priv(dev);
-	u32 max_width = dev_priv->texture_max_width;
-	u32 max_height = dev_priv->texture_max_height;
 	u32 assumed_cpp = 4;
 
 	if (dev_priv->assume_16bpp)
 		assumed_cpp = 2;
 
-	if (dev_priv->active_display_unit == vmw_du_screen_target) {
-		max_width  = min(dev_priv->stdu_max_width,  max_width);
-		max_height = min(dev_priv->stdu_max_height, max_height);
-	}
-
-	if (max_width < mode->hdisplay)
-		return MODE_BAD_HVALUE;
-
-	if (max_height < mode->vdisplay)
-		return MODE_BAD_VVALUE;
+	ret = drm_mode_validate_size(mode, dev_priv->texture_max_width,
+				     dev_priv->texture_max_height);
+	if (ret != MODE_OK)
+		return ret;
 
 	if (!vmw_kms_validate_mode_vram(dev_priv,
 					mode->hdisplay * assumed_cpp,
-- 
2.43.0



