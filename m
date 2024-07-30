Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A655A8BE8;
	Tue, 30 Jul 2024 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357216; cv=none; b=vBTikzxgZeAbggJxZN/plkYUaNLLB2WO28yIId5QJlfbzhV6NSN9byt7Z+lWOwNkTzk36ZBCd32up3zY5/oxd/rvTJZlzDUr+nFLgpe1WQKJd+ImDfeWJZELK68iH+N7uIgC1u9soRwdtKogaqF+F9aIlu3we7lQc8JxoxFFWX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357216; c=relaxed/simple;
	bh=fhXWT3mg0ZnOtbPXkc71plWOykCLNL8/bS2iKlvjCM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9hvC/fyKherijZuVPq/EJD02UDDpvpxVd9beoZ6QfVpFRAsoG47fD0PwdGt1q7frOjR1q6jOYVGSDF2AnfQ1jjsXulaKl/J8YBsN5LKnb+6A0B8Qub8gEK8KzhjohGzf+JJsTmpsRR0zjjPtdb17MWlrISDStQFWJBegvx3bXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSqfBdPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSqfBdPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD7DC4AF0C;
	Tue, 30 Jul 2024 16:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357216;
	bh=fhXWT3mg0ZnOtbPXkc71plWOykCLNL8/bS2iKlvjCM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSqfBdPbYj+PH384zNQkAUmkFsWPczM7NkZGTg44fSKpOiu+2lkeXIAOFrUyVe4V4
	 mvx5K5hV1YTUAfN2qCP6TRXHPvlbk7bbYcxyBKA8tAQYF+YcDZXwg10Y252WOh5Jf5
	 ydLFStQkyvo8Ty1XtYX7Yqe6xuSg5kf6RyBr677c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/568] drm/mediatek: Remove less-than-zero comparison of an unsigned value
Date: Tue, 30 Jul 2024 17:45:37 +0200
Message-ID: <20240730151648.872061455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
 drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
index 771f4e1733539..66ccde966e3c1 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_ddp_comp.c
@@ -553,7 +553,7 @@ int mtk_ddp_comp_init(struct device_node *node, struct mtk_ddp_comp *comp,
 	int ret;
 #endif
 
-	if (comp_id < 0 || comp_id >= DDP_COMPONENT_DRM_ID_MAX)
+	if (comp_id >= DDP_COMPONENT_DRM_ID_MAX)
 		return -EINVAL;
 
 	type = mtk_ddp_matches[comp_id].type;
-- 
2.43.0



