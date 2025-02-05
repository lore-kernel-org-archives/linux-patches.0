Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062AB146A7A;
	Wed,  5 Feb 2025 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767505; cv=none; b=Kxs0ug4voyhatqgNAQT5FV1ztEBTs+ufPyqbuJlFwdzcYc+gGd9iOhD98OQtDQ94Mm+mSQXf3XdI7EwvxbzWYe1ucGpO4gSk5JqtvPIjvQDm+8K1I/aXqaCyfNVa5AKrY2a24ZVre4PbVvDwUpgiGBLUrEInz9nqnVwseMjuiaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767505; c=relaxed/simple;
	bh=YFUP9kx4sK0xMdhOBHXJAvsdCjt4UXslkt15DStms18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLH3Cp73n4gfkZfx4oCnN7kgGMZjq2cCW5PGV7ELA126+l6jlsqnuBomiaHIluj3IpoaGOy/DFoMwoc0Th6Q+6K1FkBDN+nmuJwSGMxFNh9PT5hwYqcFu/bB4iBjBvANjrZzUklK5GWU/FObF0HWGdBhHc9XhLKEGj1j4iwV+ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqVP++LE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqVP++LE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650AEC4CED1;
	Wed,  5 Feb 2025 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767504;
	bh=YFUP9kx4sK0xMdhOBHXJAvsdCjt4UXslkt15DStms18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqVP++LErJ5nVqmcyA1WfCLDHpMNGn1nmCf82jeaWezY1/pquGsQJ4M2nSuVVJUjH
	 /ZF7gpoOljyvUApNe4SDsWvX2lOufL9xlpG4Ow0cpFbHNym594NumkfBqPCAVevgjf
	 tiKfJkP6DKyxIsnR4jCYWP08r7oaKBPzOwP7dpBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 413/623] dts: arm64: mediatek: mt8188: Update OVL compatible from MT8183 to MT8195
Date: Wed,  5 Feb 2025 14:42:35 +0100
Message-ID: <20250205134512.024632738@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 2a1a08590d371fc6327efc8b60d8bc1831f23fb4 ]

The OVL hardware capabilities have changed starting from MT8195,
making the MT8183 compatible no longer applicable.
Therefore, it is necessary to update the OVL compatible from MT8183 to
MT8195.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Fixes: 7075b21d1a8e ("arm64: dts: mediatek: mt8188: Add display nodes for vdosys0")
Link: https://lore.kernel.org/r/20241219181531.4282-4-jason-jh.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8188.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8188.dtsi b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
index faccc7f16259a..23ec3ff6cad9b 100644
--- a/arch/arm64/boot/dts/mediatek/mt8188.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
@@ -2488,7 +2488,7 @@
 		};
 
 		ovl0: ovl@1c000000 {
-			compatible = "mediatek,mt8188-disp-ovl", "mediatek,mt8183-disp-ovl";
+			compatible = "mediatek,mt8188-disp-ovl", "mediatek,mt8195-disp-ovl";
 			reg = <0 0x1c000000 0 0x1000>;
 			clocks = <&vdosys0 CLK_VDO0_DISP_OVL0>;
 			interrupts = <GIC_SPI 636 IRQ_TYPE_LEVEL_HIGH 0>;
-- 
2.39.5



