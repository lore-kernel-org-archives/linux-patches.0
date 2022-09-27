Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC37F4
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 11:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D4DC433D6
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 11:11:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="r1ui01H8"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 27 Sep 2022 12:10:59 +0100
Resent-Message-ID: <YzLaQ6xqpEJ/ly6u@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 27 Sep 2022 09:41:54 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=NYpL=Z6=mediatek.com=zhichao.liu@kernel.org>)
	id 1od6A4-001827-1P
	for broonie@sirena.co.uk; Tue, 27 Sep 2022 09:41:54 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 17A02B81A60
	for <broonie@sirena.co.uk>; Tue, 27 Sep 2022 08:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id EDC5AC433D6; Tue, 27 Sep 2022 08:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC196C433C1
	for <broonie@kernel.org>; Tue, 27 Sep 2022 08:41:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org DC196C433C1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=mediatek.com
X-UUID: d3efb28f65cc4f8095d83905bca6bf16-20220927
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=LllkYN2TYOa/CBtxBGcb3RxtSgrBPrKEbRibGJ8SoOQ=;
	b=r1ui01H8ea+rwHMpGhogor9qIOWWAa7ewgJa+7ZKEMOsterkdXgFsvE8BprMr+MM4ksU/AXLPe0KtzCB0o6fdCK6Ad5JI/yUEHY3KTl4HVHOb2Cm33XyKaRSVnk2vgZmr9R2FvExAHzD2tHenEHSOP8wNhJOwru+0nlxN85KnDA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:531587b9-31d0-4ccf-ae54-3c6bbfd42a22,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:95
X-CID-INFO: VERSION:1.1.11,REQID:531587b9-31d0-4ccf-ae54-3c6bbfd42a22,IP:0,URL
	:0,TC:0,Content:-5,EDM:0,RT:0,SF:100,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
	ON:quarantine,TS:95
X-CID-META: VersionHash:39a5ff1,CLOUDID:1db32907-1cee-4c38-b21b-a45f9682fdc0,B
	ulkID:2209271641449SEOQCA4,BulkQuantity:0,Recheck:0,SF:28|17|19|48|823|824
	,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0
X-UUID: d3efb28f65cc4f8095d83905bca6bf16-20220927
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
	(envelope-from <zhichao.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
	with ESMTP id 167942425; Tue, 27 Sep 2022 16:41:43 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 27 Sep 2022 16:41:41 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Sep 2022 16:41:41 +0800
From: Zhichao Liu <zhichao.liu@mediatek.com>
To: Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>
CC: zhichao.liu <zhichao.liu@mediatek.com>
Date: Tue, 27 Sep 2022 16:32:48 +0800
Message-ID: <20220927083248.25404-1-zhichao.liu@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=NYpL=Z6=mediatek.com=zhichao.liu@kernel.org
Subject: [PATCH] spi: mt65xx: Add dma max segment size declaration
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: H/NtT8bXEN0u

From: "zhichao.liu" <zhichao.liu@mediatek.com>

Add spi dma max segment size declaration according to spi
hardware capability, instead of 64KB by system default
setting, to improve bus bandwidth for mass data transmission.

Signed-off-by: zhichao.liu <zhichao.liu@mediatek.com>
---
 drivers/spi/spi-mt65xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-mt65xx.c b/drivers/spi/spi-mt65xx.c
index 0a3b9f7eed30..11aeae7fe7fc 100644
--- a/drivers/spi/spi-mt65xx.c
+++ b/drivers/spi/spi-mt65xx.c
@@ -1184,6 +1184,11 @@ static int mtk_spi_probe(struct platform_device *pdev)
 	if (!dev->dma_mask)
 		dev->dma_mask = &dev->coherent_dma_mask;
 
+	if (mdata->dev_comp->ipm_design)
+		dma_set_max_seg_size(dev, SZ_16M);
+	else
+		dma_set_max_seg_size(dev, SZ_256K);
+
 	ret = devm_request_irq(dev, irq, mtk_spi_interrupt,
 			       IRQF_TRIGGER_NONE, dev_name(dev), master);
 	if (ret)
-- 
2.18.0

