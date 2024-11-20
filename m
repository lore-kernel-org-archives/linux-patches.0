Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B0F1A4F1B;
	Wed, 20 Nov 2024 12:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107502; cv=none; b=HJteTTw5dlWXy9es6umCOWbBl304pPgQQgDai8TuD7e+Jxt49vJpfcqcrMMGPjNaU2h43GxcFC7+OzI9tCqtK3dYM+6xSArfvZqUgStxM6PCaF5EKlCKKaOSNuurRSm7bsw4l/N2BZqebFaGTqYavuhSRY7Wcdedxf7PVbqrOjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107502; c=relaxed/simple;
	bh=59DxKv/RjOYARZ9L+pKUWJDeMCWoBGOJGbM0vi8fjps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VtgN8CcHnjIH7A9kWAOQlhOhunEvp2rjb3SYYxl+RVKjNdKeXVQ4aLrLR6Eo5WNtoZ01KXIB+fc+T4E54jmm0SeVxU5NjTD0WQElcKl521VVvOa+C721cqnLsjNOl+mHqWfFU131mfihbpXan3L4FbBYu+pjeZSGRsaeHnc10ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbNklKil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbNklKil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43D8C4CECD;
	Wed, 20 Nov 2024 12:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107501;
	bh=59DxKv/RjOYARZ9L+pKUWJDeMCWoBGOJGbM0vi8fjps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbNklKilBKWgZhwr7BS9g+UMqpR+cJuVdpmvdZK3/KcBdvDxbo7S6k2/xnjfAFwNY
	 AkpI1zEVIOQX2kuNvRbwPF3lYV2PbBZdbSvvBYRPnzrKCZfHeN744O8yoii21IVitS
	 Xsbetam3LBUOpDEjamUpgTx2XoPuYmjls+WAAdwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 026/107] net: stmmac: dwmac-mediatek: Fix inverted handling of mediatek,mac-wol
Date: Wed, 20 Nov 2024 13:56:01 +0100
Message-ID: <20241120125630.267086172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit a03b18a71c128846360cc81ac6fdb0e7d41597b4 ]

The mediatek,mac-wol property is being handled backwards to what is
described in the binding: it currently enables PHY WOL when the property
is present and vice versa. Invert the driver logic so it matches the
binding description.

Fixes: fd1d62d80ebc ("net: stmmac: replace the use_phy_wol field with a flag")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://patch.msgid.link/20241109-mediatek-mac-wol-noninverted-v2-1-0e264e213878@collabora.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 2a9132d6d743c..001857c294fba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -589,9 +589,9 @@ static int mediatek_dwmac_common_data(struct platform_device *pdev,
 
 	plat->mac_interface = priv_plat->phy_mode;
 	if (priv_plat->mac_wol)
-		plat->flags |= STMMAC_FLAG_USE_PHY_WOL;
-	else
 		plat->flags &= ~STMMAC_FLAG_USE_PHY_WOL;
+	else
+		plat->flags |= STMMAC_FLAG_USE_PHY_WOL;
 	plat->riwt_off = 1;
 	plat->maxmtu = ETH_DATA_LEN;
 	plat->host_dma_width = priv_plat->variant->dma_bit_mask;
-- 
2.43.0



