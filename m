Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E641351FB2;
	Fri, 21 Nov 2025 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732576; cv=none; b=BKGWu9tU2QLv2oXBjSAyBQbsrOE/PqPhQrkH1HT0pFXNX0YLx2YjpM+82yDbLFVsK2ZoODoWxyTLDA1UvxVG/DHYKhhHkGxt8TN3zqyzKQxu6ZUo4yaQ4lzbzvrnptiqexhOY75pAdVhrd49RVlWaWDHKjMCeIzFZPiRLve/IPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732576; c=relaxed/simple;
	bh=Ysr85SZWLYB5CMuV9zogGS/tbUH6cyzGgVSOodhnoc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ey8S9RP3FVMEr9yjzA07wKKakXW+K+3l8WOzbDX+yyKiK6wllPdChbHuUIrEORgm+27TrSiA8kyUIqz8N2yrOryM275MbbmNUdmRQkjpDvQbkvcQh0uQPCCRbkyGQcaDOiHdZNC24vvz2aYHGZD7JVC+J6vc23JPTj6997Qce5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVDMQExe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVDMQExe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA84C4CEF1;
	Fri, 21 Nov 2025 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732575;
	bh=Ysr85SZWLYB5CMuV9zogGS/tbUH6cyzGgVSOodhnoc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVDMQExeh1iomV4hpJIMpq+oICV28m89+KQAGkRDfICXVjgVfmKfl/Q3UtX4RuBUG
	 j8n8UzcN6amD4/oUUdIXzccXby8Jl+9cBBxWttb5q/SPXeMQkMwhSTaNIlEjKBP5Fi
	 3vBsn/3tN1b/Ea/eiovt2BBk2I/evuo1k12rW2Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/529] net: stmmac: Check stmmac_hw_setup() in stmmac_resume()
Date: Fri, 21 Nov 2025 14:07:15 +0100
Message-ID: <20251121130235.857735484@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 6896c2449a1858acb643014894d01b3a1223d4e5 ]

stmmac_hw_setup() may return 0 on success and an appropriate negative
integer as defined in errno.h file on failure, just check it and then
return early if failed in stmmac_resume().

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Link: https://patch.msgid.link/20250811073506.27513-2-yangtiezhu@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f3155d69a013c..5096b70f82e1a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7901,7 +7901,14 @@ int stmmac_resume(struct device *dev)
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv, &priv->dma_conf);
 
-	stmmac_hw_setup(ndev, false);
+	ret = stmmac_hw_setup(ndev, false);
+	if (ret < 0) {
+		netdev_err(priv->dev, "%s: Hw setup failed\n", __func__);
+		mutex_unlock(&priv->lock);
+		rtnl_unlock();
+		return ret;
+	}
+
 	stmmac_init_coalesce(priv);
 	stmmac_set_rx_mode(ndev);
 
-- 
2.51.0



