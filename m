Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15E42737E3;
	Tue, 11 Nov 2025 01:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825490; cv=none; b=H4E3HsfGsuWUVlBun8zccy5ZXJ66QKg1LJAEuhPdE9VKFm5gEwRR5wSF90Tr0J9q9ZrJWo06hj9klXofJQQhmZWEw6n8cK6gfp5kLqmbe0yl3UorpFEiVVN+xBn1V5EpVtyJXLVSvtHATD0kvNpIwtwxN/Azh3RtW+Cm3/e/Hzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825490; c=relaxed/simple;
	bh=BjPHPZelUx02PRPWEKqW5WEzEK6LEJc/6SjR+jdtyd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCvWaQfWwgXoSzYIboMf8Y1qcrVswZ1yyFm2hefaU83QpsW20bRyef6AxpmR2WRMegtbAUNNlKqXe/DKipO9EXDPkTW5HnOQGBlBm5odu64Rjdb6wXxWwppWqjyuRX2qrkTf3xwVugWu0rIABzzwpDlrk7IzbEB0F66PlWnHzQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hP10OlOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hP10OlOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAB9C4CEF5;
	Tue, 11 Nov 2025 01:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825489;
	bh=BjPHPZelUx02PRPWEKqW5WEzEK6LEJc/6SjR+jdtyd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hP10OlOgWuNDPV+dYwPa5fSh9JJgBqXmpOl/Y/kgsScsk2XwW8wCjlKpV+Vu5b+25
	 6bo9CgOt8LOlp0PQ+xy1mkbnZ/YAWXuxqCn+iRTW5ffvRUCeX8v5QORb9ymCcJhRdL
	 lbNQXy9sMjEOIPTcCuDmsvBKZQbkSiHOuCYBTaCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Jones <jajones@nvidia.com>,
	Faith Ekstrand <faith.ekstrand@collabora.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.17 824/849] drm/nouveau: Advertise correct modifiers on GB20x
Date: Tue, 11 Nov 2025 09:46:34 +0900
Message-ID: <20251111004556.350206693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Jones <jajones@nvidia.com>

commit 664ce10246ba00746af94a08b7fbda8ccaacd930 upstream.

8 and 16 bit formats use a different layout on
GB20x than they did on prior chips. Add the
corresponding DRM format modifiers to the list of
modifiers supported by the display engine on such
chips, and filter the supported modifiers for each
format based on its bytes per pixel in
nv50_plane_format_mod_supported().

Note this logic will need to be updated when GB10
support is added, since it is a GB20x chip that
uses the pre-GB20x sector layout for all formats.

Fixes: 6cc6e08d4542 ("drm/nouveau/kms: add support for GB20x")
Signed-off-by: James Jones <jajones@nvidia.com>
Reviewed-by: Faith Ekstrand <faith.ekstrand@collabora.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251030181153.1208-3-jajones@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c     |    4 ++-
 drivers/gpu/drm/nouveau/dispnv50/disp.h     |    1 
 drivers/gpu/drm/nouveau/dispnv50/wndw.c     |   24 ++++++++++++++++++--
 drivers/gpu/drm/nouveau/dispnv50/wndwca7e.c |   33 ++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2867,7 +2867,9 @@ nv50_display_create(struct drm_device *d
 	}
 
 	/* Assign the correct format modifiers */
-	if (disp->disp->object.oclass >= TU102_DISP)
+	if (disp->disp->object.oclass >= GB202_DISP)
+		nouveau_display(dev)->format_modifiers = wndwca7e_modifiers;
+	else if (disp->disp->object.oclass >= TU102_DISP)
 		nouveau_display(dev)->format_modifiers = wndwc57e_modifiers;
 	else
 	if (drm->client.device.info.family >= NV_DEVICE_INFO_V0_FERMI)
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.h
@@ -104,4 +104,5 @@ struct nouveau_encoder *nv50_real_outp(s
 extern const u64 disp50xx_modifiers[];
 extern const u64 disp90xx_modifiers[];
 extern const u64 wndwc57e_modifiers[];
+extern const u64 wndwca7e_modifiers[];
 #endif
--- a/drivers/gpu/drm/nouveau/dispnv50/wndw.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndw.c
@@ -786,13 +786,14 @@ nv50_wndw_destroy(struct drm_plane *plan
 }
 
 /* This function assumes the format has already been validated against the plane
- * and the modifier was validated against the device-wides modifier list at FB
+ * and the modifier was validated against the device-wide modifier list at FB
  * creation time.
  */
 static bool nv50_plane_format_mod_supported(struct drm_plane *plane,
 					    u32 format, u64 modifier)
 {
 	struct nouveau_drm *drm = nouveau_drm(plane->dev);
+	const struct drm_format_info *info = drm_format_info(format);
 	uint8_t i;
 
 	/* All chipsets can display all formats in linear layout */
@@ -800,13 +801,32 @@ static bool nv50_plane_format_mod_suppor
 		return true;
 
 	if (drm->client.device.info.chipset < 0xc0) {
-		const struct drm_format_info *info = drm_format_info(format);
 		const uint8_t kind = (modifier >> 12) & 0xff;
 
 		if (!format) return false;
 
 		for (i = 0; i < info->num_planes; i++)
 			if ((info->cpp[i] != 4) && kind != 0x70) return false;
+	} else if (drm->client.device.info.chipset >= 0x1b2) {
+		const uint8_t slayout = ((modifier >> 22) & 0x1) |
+			((modifier >> 25) & 0x6);
+
+		if (!format)
+			return false;
+
+		/*
+		 * Note in practice this implies only formats where cpp is equal
+		 * for each plane, or >= 4 for all planes, are supported.
+		 */
+		for (i = 0; i < info->num_planes; i++) {
+			if (((info->cpp[i] == 2) && slayout != 3) ||
+			    ((info->cpp[i] == 1) && slayout != 2) ||
+			    ((info->cpp[i] >= 4) && slayout != 1))
+				return false;
+
+			/* 24-bit not supported. It has yet another layout */
+			WARN_ON(info->cpp[i] == 3);
+		}
 	}
 
 	return true;
--- a/drivers/gpu/drm/nouveau/dispnv50/wndwca7e.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/wndwca7e.c
@@ -179,6 +179,39 @@ wndwca7e_ntfy_set(struct nv50_wndw *wndw
 	return 0;
 }
 
+/****************************************************************
+ *            Log2(block height) ----------------------------+  *
+ *            Page Kind ----------------------------------+  |  *
+ *            Gob Height/Page Kind Generation ------+     |  |  *
+ *                          Sector layout -------+  |     |  |  *
+ *                          Compression ------+  |  |     |  |  */
+const u64 wndwca7e_modifiers[] = { /*         |  |  |     |  |  */
+	/* 4cpp+ modifiers */
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 1, 2, 0x06, 0),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 1, 2, 0x06, 1),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 1, 2, 0x06, 2),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 1, 2, 0x06, 3),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 1, 2, 0x06, 4),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 1, 2, 0x06, 5),
+	/* 1cpp/8bpp modifiers */
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 2, 2, 0x06, 0),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 2, 2, 0x06, 1),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 2, 2, 0x06, 2),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 2, 2, 0x06, 3),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 2, 2, 0x06, 4),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 2, 2, 0x06, 5),
+	/* 2cpp/16bpp modifiers */
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 3, 2, 0x06, 0),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 3, 2, 0x06, 1),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 3, 2, 0x06, 2),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 3, 2, 0x06, 3),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 3, 2, 0x06, 4),
+	DRM_FORMAT_MOD_NVIDIA_BLOCK_LINEAR_2D(0, 3, 2, 0x06, 5),
+	/* All formats support linear */
+	DRM_FORMAT_MOD_LINEAR,
+	DRM_FORMAT_MOD_INVALID
+};
+
 static const struct nv50_wndw_func
 wndwca7e = {
 	.acquire = wndwc37e_acquire,


