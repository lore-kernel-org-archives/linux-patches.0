Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C02A23C6;
	Tue, 23 Jan 2024 00:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969561; cv=none; b=qfqyNyCXRkuTIU2sxcCBXy9efZ8loIvRoPIwrlzWqTE9SrhRSXBkbxap5tb+RHYchDujlPLA7wGoOaZVvbSuZNC41G+mJgjY9K+GRRdvGxFC1c+lFnJhPF9novHefkmoE6p7+KbMWxuzGwSNJM7cRfNKZidIxsYLe/ao8kdXRXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969561; c=relaxed/simple;
	bh=XFv+t7vurEQ5Iv9FmWwinapf42Sf4alI3Tw1ma4hYxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9hbkYNU2ooTuJNfcoobY1iTg8BgbttxEkereD1mSxiNLfjkiwJbcC0hyHphDfnJEhTG/QBede0+vc2TwjqZI3KzZLVHIMxYlGcKFqBPA9hdcj8aGuA6yeLUbFZYzQ3jeMmaSA3IfSZ2wlbINEJNnRO95Jkz8cK+eUb4818sIB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8nN4PTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8nN4PTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEFFC43390;
	Tue, 23 Jan 2024 00:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969561;
	bh=XFv+t7vurEQ5Iv9FmWwinapf42Sf4alI3Tw1ma4hYxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8nN4PTRLK6x0lgrLYhvmYAsYZzzt8Uha28p0h4Tka/IXB776LBzQH/QoKfq7GFki
	 jpzHNEBrQSkoBsIdFosuQnQXe24FH6BzHAbVj4F+8SmDZ7E2yzz1z7vdppW4yi2bv4
	 c3Bdffv0jOmWjEOWUcS+wevrMn6zoma3/253K3Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 324/641] drm/mediatek: Return error if MDP RDMA failed to enable the clock
Date: Mon, 22 Jan 2024 15:53:48 -0800
Message-ID: <20240122235828.029705499@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index c3adaeefd551..c7233d0ac210 100644
--- a/drivers/gpu/drm/mediatek/mtk_mdp_rdma.c
+++ b/drivers/gpu/drm/mediatek/mtk_mdp_rdma.c
@@ -246,8 +246,7 @@ int mtk_mdp_rdma_clk_enable(struct device *dev)
 {
 	struct mtk_mdp_rdma *rdma = dev_get_drvdata(dev);
 
-	clk_prepare_enable(rdma->clk);
-	return 0;
+	return clk_prepare_enable(rdma->clk);
 }
 
 void mtk_mdp_rdma_clk_disable(struct device *dev)
-- 
2.43.0



