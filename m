Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B15882495;
	Wed, 19 Jun 2024 13:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803090; cv=none; b=VLB/eSZ1ahm6sOmAnUwSqpWH3NvSX3umOpxVmCoe4HtisQLJByDCAManB33sjObSAcXl4TVziQzkJSHY+M9dEp2oyWijxTgHJlopLxRQM44tXkZGK2+pzrCB9uxVgn7o1MUdqoJ0EXp8Z1qCHHYeV9vQ9ScLPJJbcEV3h7u+m/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803090; c=relaxed/simple;
	bh=DqUN0gTtLJNLoO7/w5dHV8+d6C0q9JNnN5bqV5FI05E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VH624hV6YGyauy1H3VtY3EKxzK9hDNah6TSvFA0Pc/0yablM4EgQQrgIB8VWDm6bMgSchOjm24J/KM/Iq76LxR3m2AlwzALYPq2Sq5Rnvq2/LUJQYf4nM1c04uP8uBOH7SwrjKe66zrrNMgaQNKQLwapvmK9IPqkFSyaRT88ShE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQy0+TIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQy0+TIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D694DC2BBFC;
	Wed, 19 Jun 2024 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803090;
	bh=DqUN0gTtLJNLoO7/w5dHV8+d6C0q9JNnN5bqV5FI05E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQy0+TIk7GxM1lFzujQlmXpLNBr6KdUq1g8N2LTt/t7iTuKslkXx8w9F7vsbL5SK2
	 HhIyRL2qSOavF2DyERGAGzSS5yKpETYqOMNbIFNzkABx9Y5mZKw5bjD2SiDeGx5IH5
	 4+ThCB0BCnVidN3Fsc0iHNo9g2OFdPFIGW4Svx5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 142/281] drm/vmwgfx: Remove STDU logic from generic mode_valid function
Date: Wed, 19 Jun 2024 14:55:01 +0200
Message-ID: <20240619125615.305948277@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index b019a1a1787af..c1430e55474cb 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1066,9 +1066,6 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
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
index 84ae4e10a2ebe..42fcf4698aba9 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -2157,13 +2157,12 @@ int vmw_kms_write_svga(struct vmw_private *vmw_priv,
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
@@ -2859,25 +2858,18 @@ int vmw_du_helper_plane_update(struct vmw_du_update_plane *update)
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



