Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C591FBCB2;
	Tue,  8 Apr 2025 11:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110509; cv=none; b=O79tYes9TM70EKdj80WwBGBXJgAK360n+wy5QKA6a9hwybOkuTQ4Zac8d3LM44g/UaTxktIXVSgLmSd74bDVgzCvKXKB5scl0ZVqL/afQOKPemGPm98dk5eFHFDWeFQIdaHyGgEnFqV8+8ur6GUH38NjAHgXD/3l/MesOsIyC0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110509; c=relaxed/simple;
	bh=neGZtTNVDTQ6rg7YTRhFusYgoYCHKAi6ILyJD2zmuVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx2A7xRxiVUCi2G5Aoiop7Ocu4AVhYvCW3kjQ/jG/tt00uk8RWBuWy6M/3HIUZYtshpfuucRc3VXiUT+MRmpIKM1CuG6RBRS2uyNthAQAuFX+ufgMeHPTsjMgZo3oczwUT4N6WXWSjmhiUvL7pdgAmz5tsRKt4qtNzRH7mlVyog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MopvyAlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MopvyAlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C8EC4CEE5;
	Tue,  8 Apr 2025 11:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110508;
	bh=neGZtTNVDTQ6rg7YTRhFusYgoYCHKAi6ILyJD2zmuVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MopvyAlVjeZbqTr8sgiQFQkSC10JYAY8Mvs8e4eH5K9+Heqx4p3N4a0acKG2e3zAQ
	 loWESxuy7HeIFm5HStqz7NAuy2+/IoFMbhTXqoGCdGMrTdNwIhrrJM3hN0/q3Ri88u
	 90KyO+eQGaMmPq5O8kHa8Ixkm4zuCeuk83a9C+40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie Huang <eddie.huang@mediatek.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 083/731] arm64: dts: mediatek: mt8173: Fix some node names
Date: Tue,  8 Apr 2025 12:39:40 +0200
Message-ID: <20250408104916.201108650@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit be035e4a26edf8fdcbc4fe95d16c28deade13bb0 ]

Some node names are incorrect, causing DT validations due to mismatches.

Fixes: b3a372484157 ("arm64: dts: Add mediatek MT8173 SoC and evaluation board dts and Makefile")
Fixes: f2ce70149568 ("arm64: dts: mt8173: Add clock controller device nodes")
Cc: Eddie Huang <eddie.huang@mediatek.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250108083424.2732375-3-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 3458be7f7f611..0ca63e8c4e16c 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -352,14 +352,14 @@
 			#clock-cells = <1>;
 		};
 
-		infracfg: power-controller@10001000 {
+		infracfg: clock-controller@10001000 {
 			compatible = "mediatek,mt8173-infracfg", "syscon";
 			reg = <0 0x10001000 0 0x1000>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 		};
 
-		pericfg: power-controller@10003000 {
+		pericfg: clock-controller@10003000 {
 			compatible = "mediatek,mt8173-pericfg", "syscon";
 			reg = <0 0x10003000 0 0x1000>;
 			#clock-cells = <1>;
@@ -564,7 +564,7 @@
 			memory-region = <&vpu_dma_reserved>;
 		};
 
-		sysirq: intpol-controller@10200620 {
+		sysirq: interrupt-controller@10200620 {
 			compatible = "mediatek,mt8173-sysirq",
 				     "mediatek,mt6577-sysirq";
 			interrupt-controller;
-- 
2.39.5



