Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6D05384;
	Tue, 23 Jan 2024 00:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970793; cv=none; b=CncQGH3YgCvq1eiXwiMT2P7Y/poE5Wxhc7yjLGjS2e7OaiAxwvStiRTJQuz1Aso7ns6/JmeNCadWtpefYg7d/VvMJkBrRI4uR1XHGTL9T63/LorDzpyF9bI/SqFR6H8RX/BHwNohp051wdfd89RHnuPfQHG8bD0LZ8r73ddi0CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970793; c=relaxed/simple;
	bh=0vF0A1SV6QjNK5pg8XLUtLG2+ZHPAlHZhKnFg4GfYX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr0UM5HQdsud8kT9Vnv0AGnoR0t/Jap4uE+QmwJoxojvrobm5ZJYQB6C2iwV9KCt7v1P4L6M6+C2BFrLYcWkBNKhDDOcj0fqZyY4tECReh4cTSsGyDq4S79ip2IkWub275TGLV8qsoYDeqCqo5OGDDXR2cS1bh3aEHAkJcoSHkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCCx/c3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCCx/c3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8F8C433F1;
	Tue, 23 Jan 2024 00:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970793;
	bh=0vF0A1SV6QjNK5pg8XLUtLG2+ZHPAlHZhKnFg4GfYX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCCx/c3bw+jvuLJ0W4FVy33YINPGDcX3UNeeSIIlVNYEwy/pPWGXeNqLOcUXaMi7d
	 uPVz+PosR32JxX3NZO9hxR3SPM2/TBc0VmU6UuGWBzZyvdEIi44tB9J2xR1VPU0jtr
	 70tyGR/LBF1bH/lA6IHDV2u8reaE3Ol6HzcW100A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moudy Ho <moudy.ho@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/417] arm64: dts: mediatek: mt8183: correct MDP3 DMA-related nodes
Date: Mon, 22 Jan 2024 15:54:38 -0800
Message-ID: <20240122235755.562860521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 10779a9947fe..d5d9b954c449 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1586,7 +1586,7 @@ mmsys: syscon@14000000 {
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0 0x1000>;
 		};
 
-		mdp3-rdma0@14001000 {
+		dma-controller0@14001000 {
 			compatible = "mediatek,mt8183-mdp3-rdma";
 			reg = <0 0x14001000 0 0x1000>;
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x1000 0x1000>;
@@ -1598,6 +1598,7 @@ mdp3-rdma0@14001000 {
 			iommus = <&iommu M4U_PORT_MDP_RDMA0>;
 			mboxes = <&gce 20 CMDQ_THR_PRIO_LOWEST 0>,
 				 <&gce 21 CMDQ_THR_PRIO_LOWEST 0>;
+			#dma-cells = <1>;
 		};
 
 		mdp3-rsz0@14003000 {
@@ -1618,7 +1619,7 @@ mdp3-rsz1@14004000 {
 			clocks = <&mmsys CLK_MM_MDP_RSZ1>;
 		};
 
-		mdp3-wrot0@14005000 {
+		dma-controller@14005000 {
 			compatible = "mediatek,mt8183-mdp3-wrot";
 			reg = <0 0x14005000 0 0x1000>;
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0x5000 0x1000>;
@@ -1627,6 +1628,7 @@ mdp3-wrot0@14005000 {
 			power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
 			clocks = <&mmsys CLK_MM_MDP_WROT0>;
 			iommus = <&iommu M4U_PORT_MDP_WROT0>;
+			#dma-cells = <1>;
 		};
 
 		mdp3-wdma@14006000 {
-- 
2.43.0



