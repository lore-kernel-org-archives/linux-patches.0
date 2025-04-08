Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17CB224239;
	Tue,  8 Apr 2025 11:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111812; cv=none; b=ep220B4U6g1c50vbBMXUw/Kad2SrRnPJovjDGBZz5Flp+H2hBwLvd5/44DBpjXze2VOJNl3uSF/vb7d/haehc1yKb4BVhGcNdt1fEwtSXqOqHUWxmsTBY1y7GlY8kXRarNl4YLQiEK3N/rw17Ly5uJfPu25HJFUANz+x1xNMrcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111812; c=relaxed/simple;
	bh=xyvui6/+LFIz9mRKw133xeHG8SCovq8Tu0JQ5RabA5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOJTp+a9tl5mnj1qK4QgsaBQDgb3neRS00ApWRHPwKF13a2htnJY0CyXdewIm4FYnVjougRb2ztZUYNYSaQkmpGDlygERRMPspLvcEAxjoEJ5wUAVepLzAo/2LgANR2QNeKii8j3sSUIR0qGCdW01uhYbftUnLtJ9wQtY9t5wl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZwWHkFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZwWHkFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4221EC4CEE5;
	Tue,  8 Apr 2025 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111812;
	bh=xyvui6/+LFIz9mRKw133xeHG8SCovq8Tu0JQ5RabA5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZwWHkFSl6xjNa2huz8/YSbNbD9CfmUrovUlISAANybc8310MnhVATGf/S3D6JZIm
	 Hjjr83AZQveb9CFbPxgdOpq9hb1MT6n/EyJDi3Rr4nOjLpOsp5VcKSUI9BxPoo25IY
	 vEBAoaV3fzFC9neS34yk/3K7c3gqdgJofidjz/0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 569/731] octeontx2-af: Free NIX_AF_INT_VEC_GEN irq
Date: Tue,  8 Apr 2025 12:47:46 +0200
Message-ID: <20250408104927.508506726@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 323d6db6dc7decb06f2545efb9496259ddacd4f4 ]

Due to the incorrect initial vector number in
rvu_nix_unregister_interrupts(), NIX_AF_INT_VEC_GEN is not
geeting free. Fix the vector number to include NIX_AF_INT_VEC_GEN
irq.

Fixes: 5ed66306eab6 ("octeontx2-af: Add devlink health reporters for NIX")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250327094054.2312-1-gakula@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index dab4deca893f5..27c3a2daaaa95 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -207,7 +207,7 @@ static void rvu_nix_unregister_interrupts(struct rvu *rvu)
 		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
 	}
 
-	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+	for (i = NIX_AF_INT_VEC_GEN; i < NIX_AF_INT_VEC_CNT; i++)
 		if (rvu->irq_allocated[offs + i]) {
 			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
 			rvu->irq_allocated[offs + i] = false;
-- 
2.39.5



