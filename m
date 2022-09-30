Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776E21E9F3
	for <patches@lists.linux.dev>; Tue,  1 Nov 2022 18:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8672C433D6
	for <patches@lists.linux.dev>; Tue,  1 Nov 2022 18:13:41 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cGfGN+hy"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 1 Nov 2022 18:13:38 +0000
Resent-Message-ID: <Y2Fh0mZqAhKkGmQn@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 30 Sep 2022 13:07:21 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=aCZm=2B=mediatek.com=zhichao.liu@kernel.org>)
	id 1oeEnV-001oBv-VK
	for broonie@sirena.co.uk; Fri, 30 Sep 2022 13:07:21 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 2AF126219B
	for <broonie@sirena.co.uk>; Fri, 30 Sep 2022 12:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id A7004C433D6; Fri, 30 Sep 2022 12:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C338AC433C1
	for <broonie@kernel.org>; Fri, 30 Sep 2022 12:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C338AC433C1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=mediatek.com
X-UUID: 63eadc7e2d034e288b984eb26141c8a3-20220930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=jQrHhkiF2Z7pOaZF0wtq4FYLXWF/7/+Hz5l7Tcarwbc=;
	b=cGfGN+hyCBGDgo0vtB3ZRJbMUzWOLy219zgXZ34kaxsASipSzF+IEgLhuaeL0YsQft+HiL5tE5Z/WD3NQRTl7x19zRau+PEDY08bSjplQz3fqaTx4XDFDz/om0/mUzJSRHCWRXIKEM0XBYs4Bz22NOVdOiQw+dM7L2TKuzFvKJY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:5d33eb21-a5c3-4171-99c9-566ed5d9c543,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:95
X-CID-INFO: VERSION:1.1.11,REQID:5d33eb21-a5c3-4171-99c9-566ed5d9c543,IP:0,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
	ON:quarantine,TS:95
X-CID-META: VersionHash:39a5ff1,CLOUDID:88d59507-1cee-4c38-b21b-a45f9682fdc0,B
	ulkID:220930200711JFLBY2VP,BulkQuantity:0,Recheck:0,SF:28|17|19|48|823|824
	,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0
X-UUID: 63eadc7e2d034e288b984eb26141c8a3-20220930
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
	(envelope-from <zhichao.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
	with ESMTP id 812084969; Fri, 30 Sep 2022 20:07:08 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 30 Sep 2022 20:07:07 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 30 Sep 2022 20:07:06 +0800
From: Zhichao Liu <zhichao.liu@mediatek.com>
To: Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>
CC: zhichao.liu <zhichao.liu@mediatek.com>
Date: Fri, 30 Sep 2022 19:58:28 +0800
Message-ID: <20220930115828.14442-1-zhichao.liu@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=aCZm=2B=mediatek.com=zhichao.liu@kernel.org
Subject: [PATCH] spi: mediatek: Fix packet division error
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: eAHmoC1HdPUS

From: "zhichao.liu" <zhichao.liu@mediatek.com>

Commit: 7e963fb2a33c ("spi: mediatek: add ipm design support for MT7986")
take a mistake on packet dividing operation, this patch is to fix it.

fixes: 7e963fb2a33c ("spi: mediatek: add ipm design support for MT7986")
Signed-off-by: zhichao.liu <zhichao.liu@mediatek.com>
---
 drivers/spi/spi-mt65xx.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 11aeae7fe7fc..a33c9a3de395 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -551,14 +551,17 @@ static void mtk_spi_enable_transfer(struct spi_master *master)
 	writel(cmd, mdata->base + SPI_CMD_REG);
 }
 
-static int mtk_spi_get_mult_delta(u32 xfer_len)
+static int mtk_spi_get_mult_delta(struct mtk_spi *mdata, u32 xfer_len)
 {
-	u32 mult_delta;
+	u32 mult_delta = 0;
 
-	if (xfer_len > MTK_SPI_PACKET_SIZE)
-		mult_delta = xfer_len % MTK_SPI_PACKET_SIZE;
-	else
-		mult_delta = 0;
+	if (mdata->dev_comp->ipm_design) {
+		if (xfer_len > MTK_SPI_IPM_PACKET_SIZE)
+			mult_delta = xfer_len % MTK_SPI_IPM_PACKET_SIZE;
+	} else {
+		if (xfer_len > MTK_SPI_PACKET_SIZE)
+			mult_delta = xfer_len % MTK_SPI_PACKET_SIZE;
+	}
 
 	return mult_delta;
 }
@@ -570,22 +573,22 @@ static void mtk_spi_update_mdata_len(struct spi_master *master)
 
 	if (mdata->tx_sgl_len && mdata->rx_sgl_len) {
 		if (mdata->tx_sgl_len > mdata->rx_sgl_len) {
-			mult_delta = mtk_spi_get_mult_delta(mdata->rx_sgl_len);
+			mult_delta = mtk_spi_get_mult_delta(mdata, mdata->rx_sgl_len);
 			mdata->xfer_len = mdata->rx_sgl_len - mult_delta;
 			mdata->rx_sgl_len = mult_delta;
 			mdata->tx_sgl_len -= mdata->xfer_len;
 		} else {
-			mult_delta = mtk_spi_get_mult_delta(mdata->tx_sgl_len);
+			mult_delta = mtk_spi_get_mult_delta(mdata, mdata->tx_sgl_len);
 			mdata->xfer_len = mdata->tx_sgl_len - mult_delta;
 			mdata->tx_sgl_len = mult_delta;
 			mdata->rx_sgl_len -= mdata->xfer_len;
 		}
 	} else if (mdata->tx_sgl_len) {
-		mult_delta = mtk_spi_get_mult_delta(mdata->tx_sgl_len);
+		mult_delta = mtk_spi_get_mult_delta(mdata, mdata->tx_sgl_len);
 		mdata->xfer_len = mdata->tx_sgl_len - mult_delta;
 		mdata->tx_sgl_len = mult_delta;
 	} else if (mdata->rx_sgl_len) {
-		mult_delta = mtk_spi_get_mult_delta(mdata->rx_sgl_len);
+		mult_delta = mtk_spi_get_mult_delta(mdata, mdata->rx_sgl_len);
 		mdata->xfer_len = mdata->rx_sgl_len - mult_delta;
 		mdata->rx_sgl_len = mult_delta;
 	}
-- 
2.18.0

