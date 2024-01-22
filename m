Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A8E67E91;
	Tue, 23 Jan 2024 02:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975322; cv=none; b=Ul0xaD10PHD+5wSKSsdjAT6U/mhxKe7FhsCjLb2dJ3sOaSRbC+zccx/SzdMctR17xoIUZ4qzlefYxUoHBQyFn6SFaF6A+1Ab7RV1sfToo02i6MuZIeWi3O7r7KnsOT+PlSl8EXuth5yTMJilHyGVYaX0PF8uoExVQ6aWGDU7nfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975322; c=relaxed/simple;
	bh=F3pTpZmbekM1vaKirx5KCCmMOaaPNn4u5YjXVDKUjps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLj2Fnn2tSdgsLfrzBabmK5fImTQ+2j9grocEWn9ZYjFulZDMVXcZ7sQDnixNM0UekpNoY32O8eg/+CHK4kloMvPSgSiznuzBxvQbrH8UIx1ARBJot+yf++zj+oK2NeceSkr+gCq4UsNKqP0P5oe+peyo/kLhLLYxNTboU/jqOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTbJaCYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTbJaCYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC757C43394;
	Tue, 23 Jan 2024 02:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975321;
	bh=F3pTpZmbekM1vaKirx5KCCmMOaaPNn4u5YjXVDKUjps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTbJaCYQsEiCLwpanFXv8CYFlJRbiXhX9vpj3fKVgOl7AOhQZmy35R/KVKO4HFwD1
	 PgSvzHPIjt4BjhpffZCxbxcydF/w759ceKObJv1qeIXmrxJGFTpC6zLqHIqHBwAEIh
	 34vLtsQE1hbr0wrTRPmlTgj4N4UORWTBe0I+6IiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hsiao Chien Sung <shawn.sung@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/583] drm/mediatek: Return error if MDP RDMA failed to enable the clock
Date: Mon, 22 Jan 2024 15:55:36 -0800
Message-ID: <20240122235820.722004867@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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



