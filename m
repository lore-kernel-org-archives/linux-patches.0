Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FD02F4300
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661759; cv=none; b=pK5DuKUiBPZ0vlTR6jJxIgAVqIPGX0h8ETHxuWh+AFgYOfanPX2jkcSwtb4lWTw5CSD9KTYvmG4WjrvyM8dFU7olijRmaiDZbRNbbBwpXa3WkFCUAwgv/I+WYcJAjQeXqUA5ArbPKSa51/kLiG4gq7Hna8R/QlSwBOotqH0Y/dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661759; c=relaxed/simple;
	bh=jqlBgg3sF64EbByHlPvZlWdlEBaMzgR77xa1AyROlpk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u7xmyMQHeJ6HBuEd5+hH7PmCA6PUbmqk8tep7CNezo1Jxw2+x8AzvQTc4O9rJz+mO26h5t4kP1JQLk7gtFaVsPst6GHstH95nsfqxLNhAL50b44DLmVzY7/1NlXZZ4HQw4oFbuD5i536CnBQmrFGru1KUoz42Oc2Z5xLzkqpNws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=sOUHRnes; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sOUHRnes"
X-UUID: b79144d0622f11f08b7dc59d57013e23-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=yK6pP8ct3hWE54sonE1HMGIx5/H1eGrNIjCFJab0FW4=;
	b=sOUHRnesE38FQeBqCLAxkjghxLR5zZQSqqaUwtrt46bdS4i4U4KIxaZHm9Wa1d+a4Peb+ayoguvFCXHM/vHrL2Fxa86zJFVL7KA9dIRMecXc5Jp5kmVussJlRJ7Il9zcWyQKjcXDevYlX7L2P4R6c3lr80LUg+aP/AfikvP/d3g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:693e8ec6-0534-4520-8212-dbb5637b2f14,IP:0,UR
	L:0,TC:0,Content:-5,EDM:-30,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-35
X-CID-META: VersionHash:9eb4ff7,CLOUDID:b68ad80e-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:2,
	IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b79144d0622f11f08b7dc59d57013e23-20250716
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1851545832; Wed, 16 Jul 2025 18:29:13 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 16 Jul 2025 18:29:11 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 16 Jul 2025 18:29:10 +0800
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
	<Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>, Peter Griffin
	<peter.griffin@linaro.org>, Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>, Conor Dooley <conor.dooley@microchip.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.12 2/2] arm64: defconfig: enable Maxim TCPCI driver
Date: Wed, 16 Jul 2025 18:28:54 +0800
Message-ID: <20250716102854.4012956-2-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250716102854.4012956-1-macpaul.lin@mediatek.com>
References: <20250716102854.4012956-1-macpaul.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MTK: N

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit d2ca319822e071423ab883bc8493053320b8e52c ]

Enable the Maxim max33359 as this is used by the gs101-oriole (Google
Pixel 6) board.

Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20241203-gs101-phy-lanes-orientation-dts-v2-1-1412783a6b01@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20241231131742.134329-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d2fdef159210..960fe7183539 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1123,6 +1123,7 @@ CONFIG_USB_MASS_STORAGE=m
 CONFIG_TYPEC=m
 CONFIG_TYPEC_TCPM=m
 CONFIG_TYPEC_TCPCI=m
+CONFIG_TYPEC_TCPCI_MAXIM=m
 CONFIG_TYPEC_FUSB302=m
 CONFIG_TYPEC_QCOM_PMIC=m
 CONFIG_TYPEC_UCSI=m
-- 
2.45.2

