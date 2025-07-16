Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BB22F3629
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661756; cv=none; b=igJuEy4928ac7vf92V7VT6oaMMJVATlKtccyXlc+qFUbtATfSi698cmyurX2RWOuIL4ESsYDHZsOhFYYWBN4y3o/kUrCAhLlsrMeLs9xY1bbw5Ab/ULt2no0RsQkbrBlIakYWBinUF7gixULCa36iPMy8l3DHO2xSNeHppUSUTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661756; c=relaxed/simple;
	bh=/y243RWb1/KmlUmxcOyXNlYvWJdD2w1jFInGjtJ0rJw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GO6nM2P8Hvf1zMj9vSXyD5OfXByqh4LEXhoDkV299+nwYdspk346QX+6cFkiWqhJekTbjrwmHz55jMCw4KC+V3zM9WDTHLG+jUieOCJg8w4skX8l8q3dmB+yN6wwhk5xKLGGnfbeF8l3hEfh7bfwGXzLO2ecQop/okU9urHhuYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dGjcCQwn; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dGjcCQwn"
X-UUID: b51081ee622f11f0b33aeb1e7f16c2b6-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=47DSmbpAEvdNnkdmmTBwsL5yTco8H3BTdt/jhcrSUBw=;
	b=dGjcCQwnTpQZA88uayD+pOiZt3iqocExF2ha0PcMsUzfvpHy/06TaPiTy6m+s1w+CPO3XrVD/94O+gqzW25D67TAz3UCHN4U5TkWNlGjNIN/j55TIBB9GKRPC6wBCuWKBv4H6ZMNePDHHpdB/EA7gs6ir162lunTAjya+Ej/ZTo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:952e2e1d-51c2-4e26-8f3f-ccb5d413a5b6,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:e51c1373-f565-4a89-86be-304708e7ad47,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b51081ee622f11f0b33aeb1e7f16c2b6-20250716
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1060070217; Wed, 16 Jul 2025 18:29:08 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 16 Jul 2025 18:29:07 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 16 Jul 2025 18:29:06 +0800
From: Macpaul Lin <macpaul.lin@mediatek.com>
To: <openembedded-core@lists.openembedded.org>, <patches@lists.linux.dev>,
	<stable@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon <will@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Sasha
 Levin <sashal@kernel.org>,
	=?UTF-8?q?N=C3=ADcolas=20F=20=2E=20R=20=2E=20A=20=2E=20Prado?=
	<nfraprado@collabora.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
CC: Bear Wang <bear.wang@mediatek.com>, Pablo Sun <pablo.sun@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>, Macpaul Lin <macpaul@gmail.com>,
	MediaTek Chromebook Upstream
	<Project_Global_Chrome_Upstream_Group@mediatek.com>, Dmitry Baryshkov
	<dmitry.baryshkov@linaro.org>, Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 1/2] arm64: defconfig: enable DRM_DISPLAY_CONNECTOR as a module
Date: Wed, 16 Jul 2025 18:28:53 +0800
Message-ID: <20250716102854.4012956-1-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 691b5b53dbcc30bb3572cbb255374990723af0d2 ]

The display connector family of bridges is used on a plenty of ARM64
platforms (including, but not being limited to several Qualcomm Robotics
and Dragonboard platforms). It doesn't make sense for the DRM drivers to
select the driver, so select it via the defconfig.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250214-arm64-display-connector-v1-1-306bca76316e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
[ Backport to 6.12.y ]
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 7e475f38f3e1..219ef05ee5a7 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -911,6 +911,7 @@ CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=m
 CONFIG_DRM_PANEL_SITRONIX_ST7703=m
 CONFIG_DRM_PANEL_TRULY_NT35597_WQXGA=m
 CONFIG_DRM_PANEL_VISIONOX_VTDR6130=m
+CONFIG_DRM_DISPLAY_CONNECTOR=m
 CONFIG_DRM_FSL_LDB=m
 CONFIG_DRM_LONTIUM_LT8912B=m
 CONFIG_DRM_LONTIUM_LT9611=m
-- 
2.45.2

