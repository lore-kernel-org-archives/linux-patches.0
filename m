Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF68189915;
	Tue, 30 Jul 2024 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358384; cv=none; b=RiTFtuQz6iR0tYtubFAEjgZ3CR8nwZ3hHlXzsuHobBaPVr/OPyLlb/5VqlBl+KJ5a2tOIOSzkc1soaJqxhuJ4Vf2fq6/8VaPlP2QvWlLbkTN7fl7/Ayoi1Kqv/UCMuidOp+XxzmWyIvqwdA5zIPbJUq1mJHpqim2gQjK2/xp5YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358384; c=relaxed/simple;
	bh=K0k+Cyh2aJ2W9rayyaRxOXqLiKmSizJTQrRP6UTEZfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R34lPDZCJR9mMVFQSvdBVRi+Irlzt6B57HkQAICO8V6sijGbXafyWBZ2h+w7k0BG9iInJHOiur5pjAFXUd+voUM3MeiNApYT1a8oHIpxTVeSmE98pc46Orre/ThtcAiyX+8u1WisdH77MVlEj2uuZBy40M+JYVxrd1kUwZlo7pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhKdsvhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhKdsvhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAD4C4AF10;
	Tue, 30 Jul 2024 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358384;
	bh=K0k+Cyh2aJ2W9rayyaRxOXqLiKmSizJTQrRP6UTEZfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhKdsvheaUk8x54SH/DSNQwt94QxCUMRAXGZyHTOUd32p3pabr66RW4ejg16zPPxH
	 LiO+HX/OGzO33SHi5u334O5Cie+4Oura4KpD69RF1f9N4TSJRtP/VRSkTcNA4waNhG
	 ifISX09Fd9/nUHarKd6ICfPcD4etcF1izTITWxp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 354/809] drm/mediatek: Remove less-than-zero comparison of an unsigned value
Date: Tue, 30 Jul 2024 17:43:50 +0200
Message-ID: <20240730151738.619474029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 4ed9dd7fde22ed614384c03f8049723cbe7e6a58 ]

Fix a Coverity error that less-than-zero comparison of an unsigned value
is never true.

Fixes: 119f5173628a ("drm/mediatek: Add DRM Driver for Mediatek SoC MT8173.")
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240614034937.23978-1-shawn.sung@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_ddp_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
index 17b0364112922..a66e46d0b45eb 100644
--- a/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_ddp_comp.c
@@ -593,7 +593,7 @@ int mtk_ddp_comp_init(struct device_node *node, struct mtk_ddp_comp *comp,
 	int ret;
 #endif
 
-	if (comp_id < 0 || comp_id >= DDP_COMPONENT_DRM_ID_MAX)
+	if (comp_id >= DDP_COMPONENT_DRM_ID_MAX)
 		return -EINVAL;
 
 	type = mtk_ddp_matches[comp_id].type;
-- 
2.43.0



