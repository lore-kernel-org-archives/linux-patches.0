Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DF33081D8;
	Wed,  3 Dec 2025 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779076; cv=none; b=g7PCN3nTUvakCvIjzW5NBwiXcsJjq4RH5VgagOtn+P0iOj/ULibeJA2u1uTeSPk3mTOrn9IpGYUWan6ZiOqP1W5LdjtEeN+y32WlbjTO2kdb277wEjWLV06MFIZwP/DgZzPBpcQv9y6Xkzg9WQ/pncdyrRFINaE/lzldAuhkyKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779076; c=relaxed/simple;
	bh=57pg+cVFmB3oybu/MC/P8UMppW2NklP6cUCgyi5t3SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCbiV+WTk+0mMV/QCj0v2fEWDqpiL8pfdr92ADezLxXVTdFCZ8qsIA2wA8W6lsQse/gMJancDd1cYZoirWtTILeBDPnPfT6lAX8G/5SEtVELJZJb6LZJPN69nX6Fyfry/EEVS3xGgylq31OD04YeDLq/G84EHu34xjQYke+zvE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Psauy/0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Psauy/0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9156C4CEF5;
	Wed,  3 Dec 2025 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779075;
	bh=57pg+cVFmB3oybu/MC/P8UMppW2NklP6cUCgyi5t3SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Psauy/0Lxz0fA6gt8owfbDGxK2lhuFm51MnZwpjZaeBGDoKLqU6wvQO3ziCX4rqei
	 O2kwh0WW4VvmhCUi4HIID2GNptnzwSZTDiTragOnMxaHapq/hxfzI/X+ga/JyBXuNc
	 EnPoR9sdb27vEzNmtbnCBNHVYUEOQj5cbtjkMs8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/568] net: stmmac: Check stmmac_hw_setup() in stmmac_resume()
Date: Wed,  3 Dec 2025 16:22:30 +0100
Message-ID: <20251203152446.149689214@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index be84aed471603..03fbb611b2a67 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7589,7 +7589,14 @@ int stmmac_resume(struct device *dev)
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



