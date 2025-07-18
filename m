Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA7D1E1A3B
	for <patches@lists.linux.dev>; Fri, 18 Jul 2025 08:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752827539; cv=none; b=nUww8Bz7RCmDYpCsrCRSbPFLdfrVxhmfFYMk17uCSlMQViFFJJDxYOnZMZMhNA31dfhhuoVRmTbkQZxVvesejd2Rfw3IbqsEVv7a42C/1Q8zEgxNy+CevtHNilAqVwPzk4NwudbKqPOOX1sMcQI2Y518tbeCI8X3OsTYDj/cKJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752827539; c=relaxed/simple;
	bh=8mI/CryjuPW53XG2803NV0fHo7AQCd/bUli3ZC81q1c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/+4pd4M7QO/7B5hfIQiTxj2ouJ7BUL90PKtfScqkw4k0LmHdv0x5HLKr1Z6CeVoi9gKGuDOlPPxoOvUjEGbNn4GqRVCs4DZR8HcZHJHEw6gKE1FB3+csGREjj3QtTSPmqcmFrF3ckC6fwhrVTh00E56mGCuOiWfmvrFA2BdegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Pt57KYSV; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Pt57KYSV"
X-UUID: b4936da263b111f0b33aeb1e7f16c2b6-20250718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=bWPvaQQMd5CLHEhX9CTA9EMlFSg+oaAeIgUHdvoTJg8=;
	b=Pt57KYSVNWGSYHHbBtvprelHId5flsfP8Lr2NVamWPz5hft9yXCPn9EKdJJl2JZuDBrZse2gQ9eNA7VmpAeu6r9RoRzYr6MwXlzRGQo7sqWRnTcIqChjcTltkBDadJ1F+W0cE3W5OGHuas49mk8AyQlNzahDC+yONq95V+rmr0c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:f2473818-d145-4f75-b242-e301ffeb6fd9,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:a786049a-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b4936da263b111f0b33aeb1e7f16c2b6-20250718
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <macpaul.lin@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 677885912; Fri, 18 Jul 2025 16:32:13 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 18 Jul 2025 16:32:12 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 18 Jul 2025 16:32:12 +0800
From: Macpaul Lin <macpaul.lin@mediatek.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Matthias Brugger
	<matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Sean Wang
	<sean.wang@mediatek.com>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>,
	<openembedded-core@lists.openembedded.org>, <patches@lists.linux.dev>,
	<stable@vger.kernel.org>
CC: Bear Wang <bear.wang@mediatek.com>, Pablo Sun <pablo.sun@mediatek.com>,
	Ramax Lo <ramax.lo@mediatek.com>, Macpaul Lin <macpaul.lin@mediatek.com>,
	Macpaul Lin <macpaul@gmail.com>, MediaTek Chromebook Upstream
	<Project_Global_Chrome_Upstream_Group@mediatek.com>
Subject: [PATCH 4/4] arm64: defconfig: Enable UFS support for MediaTek Genio 1200 EVK UFS board
Date: Fri, 18 Jul 2025 16:32:02 +0800
Message-ID: <20250718083202.654568-4-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250718083202.654568-1-macpaul.lin@mediatek.com>
References: <20250718083202.654568-1-macpaul.lin@mediatek.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

Enable the UFS related settings to support Genio 1200 EVK UFS board.
This board uses UFS as the boot device and also the main storage.
This includes support for:
 - CONFIG_PHY_MTK_UFS
 - CONFIG_SCSI_UFS_MEDIATEK

Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
---
 arch/arm64/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 7e04a2905ce4..c7ca08ed1bf1 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -1208,6 +1208,7 @@ CONFIG_SCSI_UFS_BSG=y
 CONFIG_SCSI_UFSHCD_PLATFORM=y
 CONFIG_SCSI_UFS_CDNS_PLATFORM=m
 CONFIG_SCSI_UFS_QCOM=m
+CONFIG_SCSI_UFS_MEDIATEK=m
 CONFIG_SCSI_UFS_HISI=y
 CONFIG_SCSI_UFS_RENESAS=m
 CONFIG_SCSI_UFS_TI_J721E=m
@@ -1591,6 +1592,7 @@ CONFIG_PHY_HISI_INNO_USB2=y
 CONFIG_PHY_MVEBU_CP110_COMPHY=y
 CONFIG_PHY_MTK_PCIE=m
 CONFIG_PHY_MTK_TPHY=y
+CONFIG_PHY_MTK_UFS=m
 CONFIG_PHY_MTK_HDMI=m
 CONFIG_PHY_MTK_MIPI_DSI=m
 CONFIG_PHY_MTK_DP=m
-- 
2.45.2

