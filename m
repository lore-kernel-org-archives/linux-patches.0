Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D51350D6;
	Tue, 23 Jan 2024 00:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969345; cv=none; b=LAG8Frkumlrf/Uum980jw+oi1ZP+T9SOYHtJEyUdS5YLHKNdXar4uF5TpC1w53np/07XHGYVbmai0xt3RTPftPVEfh7WLGxZyZxhs/Y9uC1CzmlSlynYv9O/gx+1GqZmvCn0Zkf2n82S8XbV+N0P2cv4ZHYMesjVd5v47znxUmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969345; c=relaxed/simple;
	bh=p2+3T1Xl8t0MBTNSNfSrVR08gaqO2xW/Qq737NmgohI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJmzyIY1HgYBy/J1wt0YiHZyBGfAddiNIxHQr2LZyeT+LRSxAmIxMym9SK7R69P4USfeRmKMf7uqwW2ZK/CSGal9498GIhWkm3yxJMzSyTtYjoVYKbu8UFz1GrudM5t9Zflek4dMgiXBhUSqKCgZsnZfsr6Tp5ZTLjRpXFmzckk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aiyu84Yk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aiyu84Yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE775C43394;
	Tue, 23 Jan 2024 00:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969345;
	bh=p2+3T1Xl8t0MBTNSNfSrVR08gaqO2xW/Qq737NmgohI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aiyu84YkSUejH8VDUrFaHtxZ53nGOQVvL/OgJ+8piOeV96FQEFckNqAGO+1yeGd9o
	 fN7d30hjNbCDTgkMLyPT4Gs8kLR4u+oqzEdm3f0AzS3AsCBRGLQI74FIEAqqNaGEMs
	 taXd+j7m0TiRVpx75eEnqp7bBJ3/RfAIbHBkGCxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 162/641] arm64: dts: mediatek: mt8183: correct MDP3 DMA-related nodes
Date: Mon, 22 Jan 2024 15:51:06 -0800
Message-ID: <20240122235823.095521959@linuxfoundation.org>
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

From: Moudy Ho <moudy.ho@mediatek.com>

[ Upstream commit 188ffcd7fea79af3cac441268fc99f60e87f03b3 ]

In order to generalize the node names, the DMA-related nodes
corresponding to MT8183 MDP3 need to be corrected.

Fixes: 60a2fb8d202a ("arm64: dts: mt8183: add MediaTek MDP3 nodes")
Signed-off-by: Moudy Ho <moudy.ho@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 976dc968b3ca..df6e9990cd5f 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1660,7 +1660,7 @@ mmsys: syscon@14000000 {
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0 0x1000>;
 		};
 
-		mdp3-rdma0@14001000 {
+		dma-controller0@14001000 {
 			compatible = "mediatek,mt8183-mdp3-rdma";
 			reg = <0 0x14001000 0 0x1000>;
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x1000 0x1000>;
@@ -1672,6 +1672,7 @@ mdp3-rdma0@14001000 {
 			iommus = <&iommu M4U_PORT_MDP_RDMA0>;
 			mboxes = <&gce 20 CMDQ_THR_PRIO_LOWEST 0>,
 				 <&gce 21 CMDQ_THR_PRIO_LOWEST 0>;
+			#dma-cells = <1>;
 		};
 
 		mdp3-rsz0@14003000 {
@@ -1692,7 +1693,7 @@ mdp3-rsz1@14004000 {
 			clocks = <&mmsys CLK_MM_MDP_RSZ1>;
 		};
 
-		mdp3-wrot0@14005000 {
+		dma-controller@14005000 {
 			compatible = "mediatek,mt8183-mdp3-wrot";
 			reg = <0 0x14005000 0 0x1000>;
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x5000 0x1000>;
@@ -1701,6 +1702,7 @@ mdp3-wrot0@14005000 {
 			power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
 			clocks = <&mmsys CLK_MM_MDP_WROT0>;
 			iommus = <&iommu M4U_PORT_MDP_WROT0>;
+			#dma-cells = <1>;
 		};
 
 		mdp3-wdma@14006000 {
-- 
2.43.0



