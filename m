Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFE46341D;
	Tue, 23 Jan 2024 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971230; cv=none; b=Y6VAMCHRX8PBTkB8YZkT3KJ30xih3pC5aj1yHpGsEs9BRXaK0uxH4uQtuJ28AgMuPjfjB7QRHy1LLd3Gf/YUVBZX/keKSSisDCZo75if5PhK8HTQxnaevA4o5G1tWpTr1hDDl6Ged4tsVEzxzT2+7eFcNmO+tq3JD3gIsBmohZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971230; c=relaxed/simple;
	bh=46PCfKazoKS/hebfvF98sisly1NhB0UbckB0wxoL9YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yomm2IU8cBu1iJPnoYxO5ZaFuXLvi9rxXr3pEBlov7feuUXNQO0kdZw8O/4iljyXKISC25UcVqHpNvK6nEl4vpUECRpm+8whfO7LtpwaHbTFFaNreeh8Gpp2dO4OpXS7qwxUJ6ljlLZTe2QjTGeIShAZg3qByqR8djzykqhHBGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp5ar9bM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp5ar9bM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1480C43390;
	Tue, 23 Jan 2024 00:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971230;
	bh=46PCfKazoKS/hebfvF98sisly1NhB0UbckB0wxoL9YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp5ar9bM1HfcIe/sI78lzgaipVu43zkIjN5RvQ6ub6xO9woWsu+lDX86amTpkwnWb
	 UUFtiuqEve4OxM5CMZKmdn56fsKw/CeZdAdUeG+W/j5SjPQ47cBdXAySdb+s2O3d+D
	 Nz2rv8fu+iIeii4y15nF/buDAtB5L1t4TgWPEwuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/417] drm/mediatek: Return error if MDP RDMA failed to enable the clock
Date: Mon, 22 Jan 2024 15:56:15 -0800
Message-ID: <20240122235759.101045562@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsiao Chien Sung <shawn.sung@mediatek.com>

[ Upstream commit 21b287146adf39304193e4c49198021e06a28ded ]

Return the result of clk_prepare_enable() instead of
always returns 0.

Fixes: f8946e2b6bb2 ("drm/mediatek: Add display MDP RDMA support for MT8195")

Reviewed-by: CK Hu <ck.hu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hsiao Chien Sung <shawn.sung@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20231214055847.4936-21-shawn.sung@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_mdp_rdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_mdp_rdma.c b/drivers/gpu/drm/mediatek/mtk_mdp_rdma.c
index eecfa98ff52e..b288bb6eeecc 100644
--- a/drivers/gpu/drm/mediatek/mtk_mdp_rdma.c
+++ b/drivers/gpu/drm/mediatek/mtk_mdp_rdma.c
@@ -223,8 +223,7 @@ int mtk_mdp_rdma_clk_enable(struct device *dev)
 {
 	struct mtk_mdp_rdma *rdma = dev_get_drvdata(dev);
 
-	clk_prepare_enable(rdma->clk);
-	return 0;
+	return clk_prepare_enable(rdma->clk);
 }
 
 void mtk_mdp_rdma_clk_disable(struct device *dev)
-- 
2.43.0



