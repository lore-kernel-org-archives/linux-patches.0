Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFDB1DED58;
	Wed,  6 Nov 2024 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896045; cv=none; b=bDeZEJaaqrC+FnxqTrGr/3aIp4YxItgSDQkSeFo9hajsp7QCq/afElUQRNO3O1rrbtYhvs6g7ILXo9y4xE63BMcyAzj4tO3WG4B7UuXBbYfF/dyp4mObrc9ruGJUvIrm30REVmHD82QAT0qWdGnDsyeg7chp16ZK5h1bxXEucQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896045; c=relaxed/simple;
	bh=mfqrF43Pllih8y9OxZmjZJdPtltXQEyg2TDG470a59c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKUYyV8kPB+nuexXmvUn8sC4ZuoxM0xC1EIN8gA4I2vAF70NbYaVvB2EEcZe/PQsw5HLzjWUsgdXLjaaI1D7Jc+HKBYwPSYm2ApEaGkgFXUzxs+UrFjKSJ3wG1iojZ3ZIRjF3b+1vYaiL5yPuIThQaCy+kmV8tPjWfRTJKvkbRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHAwG+zL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHAwG+zL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874CCC4CECD;
	Wed,  6 Nov 2024 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896044;
	bh=mfqrF43Pllih8y9OxZmjZJdPtltXQEyg2TDG470a59c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHAwG+zLTT6ivHEgA0NmmirllmzzHgeIQyliFZcxrzJMe2cen/O2dUJ9UzgzgUo5J
	 n7iM6tvOUyszl+XbrDDa84TFQx+J76fU7Zbno+e2r7muRWhublwvepv0aAzQkCpST4
	 4tqVRX+98DAKUORHVJ6m3PHgfCY3jj3JjwtRUHw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 070/245] drm/mediatek: ovl: Remove the color format comment for ovl_fmt_convert()
Date: Wed,  6 Nov 2024 13:02:03 +0100
Message-ID: <20241106120320.929119023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 41607c3ceb0e527e0985387bc41bbf291dc9a3d8 ]

Since we changed MACROs to be consistent with DRM input color format
naming, the comment for ovl_fmt_conver() is no longer needed.

Fixes: 9f428b95ac89 ("drm/mediatek: Add new color format MACROs in OVL")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20241009034646.13143-4-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_disp_ovl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
index 9d6d9fd8342e4..4221206b994f1 100644
--- a/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
+++ b/drivers/gpu/drm/mediatek/mtk_disp_ovl.c
@@ -379,11 +379,6 @@ void mtk_ovl_layer_off(struct device *dev, unsigned int idx,
 
 static unsigned int ovl_fmt_convert(struct mtk_disp_ovl *ovl, unsigned int fmt)
 {
-	/* The return value in switch "MEM_MODE_INPUT_FORMAT_XXX"
-	 * is defined in mediatek HW data sheet.
-	 * The alphabet order in XXX is no relation to data
-	 * arrangement in memory.
-	 */
 	switch (fmt) {
 	default:
 	case DRM_FORMAT_RGB565:
-- 
2.43.0



