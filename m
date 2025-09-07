Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1C5D528;
	Sun,  7 Sep 2025 20:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276741; cv=none; b=dR0zca3r6yJmeWL/J561Li8zbMxprLinfwk8rnRKaIdEvDhnmSm3ZO886I1Wh/p86NZ9NDGBvz0OT+ojZT1s0aZnsiy5DtXwIrBd/AAJCa3ZHxNw2OF/G4aKuTthHjYZwl0YoUXuHtfNDA2B7UU4VUSjRmoMvxsh9oYfPe9c3kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276741; c=relaxed/simple;
	bh=hQkRAtUTbYMHcTSCV1PP06w4LHHfMT+mndPrl2p7HG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCVaDdx6lhhLtMOd9TkR7DvLa1AMAc/GuOKJ/xF3fNLMPzzsA4aHgcKXS0jdI9lef4aQeLghmJwm8UYA9q8/2GVzR0tbhVo0IqFZxuE0ZZK6lZR5hKvdeuSjhA9XP7THJzI/A0Et3zGYT4oW4fpxmbeXVDpu1IYi1MWnlbB6Qw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSfxZ6oE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSfxZ6oE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607FBC4CEF0;
	Sun,  7 Sep 2025 20:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276740;
	bh=hQkRAtUTbYMHcTSCV1PP06w4LHHfMT+mndPrl2p7HG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSfxZ6oEAxQwzLdPfkTiAHqytZRZmitGIqzMjGDwuKAIOXudwUWue56M69UJFjws5
	 OEiNKcyK/VlEBW8yiCryLK9SqoRmSAPKPP9ssPOlJz5a4n5tVlMcAjp1HbH6Iu2O5v
	 WrlrhhjghFUmZ8Hn7+yotc8HHV1miZGOT/Ba/LxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	Fei Shao <fshao@chromium.org>,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/121] drm/mediatek: Add crtc path enum for all_drm_priv array
Date: Sun,  7 Sep 2025 21:58:49 +0200
Message-ID: <20250907195612.237042050@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Jason-JH.Lin" <jason-jh.lin@mediatek.com>

[ Upstream commit 26c35d1d1646e593e3a82748b19d33b164871ae8 ]

Add mtk_drm_crtc_path enum for each display path.

Instead of using array index of all_drm_priv in mtk_drm_kms_init(),
mtk_drm_crtc_path enum can make code more readable.

Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Fei Shao <fshao@chromium.org>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231004024013.18956-3-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Stable-dep-of: 1f403699c40f ("drm/mediatek: Fix device/node reference count leaks in mtk_drm_get_all_drm_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |    6 +++---
 drivers/gpu/drm/mediatek/mtk_drm_drv.h |    8 +++++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -475,21 +475,21 @@ static int mtk_drm_kms_init(struct drm_d
 		for (j = 0; j < private->data->mmsys_dev_num; j++) {
 			priv_n = private->all_drm_private[j];
 
-			if (i == 0 && priv_n->data->main_len) {
+			if (i == CRTC_MAIN && priv_n->data->main_len) {
 				ret = mtk_drm_crtc_create(drm, priv_n->data->main_path,
 							  priv_n->data->main_len, j);
 				if (ret)
 					goto err_component_unbind;
 
 				continue;
-			} else if (i == 1 && priv_n->data->ext_len) {
+			} else if (i == CRTC_EXT && priv_n->data->ext_len) {
 				ret = mtk_drm_crtc_create(drm, priv_n->data->ext_path,
 							  priv_n->data->ext_len, j);
 				if (ret)
 					goto err_component_unbind;
 
 				continue;
-			} else if (i == 2 && priv_n->data->third_len) {
+			} else if (i == CRTC_THIRD && priv_n->data->third_len) {
 				ret = mtk_drm_crtc_create(drm, priv_n->data->third_path,
 							  priv_n->data->third_len, j);
 				if (ret)
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.h
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.h
@@ -9,11 +9,17 @@
 #include <linux/io.h>
 #include "mtk_drm_ddp_comp.h"
 
-#define MAX_CRTC	3
 #define MAX_CONNECTOR	2
 #define DDP_COMPONENT_DRM_OVL_ADAPTOR (DDP_COMPONENT_ID_MAX + 1)
 #define DDP_COMPONENT_DRM_ID_MAX (DDP_COMPONENT_DRM_OVL_ADAPTOR + 1)
 
+enum mtk_drm_crtc_path {
+	CRTC_MAIN,
+	CRTC_EXT,
+	CRTC_THIRD,
+	MAX_CRTC,
+};
+
 struct device;
 struct device_node;
 struct drm_crtc;


