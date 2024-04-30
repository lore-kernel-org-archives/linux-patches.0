Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E546912C462;
	Tue, 30 Apr 2024 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475200; cv=none; b=bWJRHW/a/Ton0wP3LZ86LQrZ40WesVc62A62KagdWFixJlNpFGNeitG8viMSA1jC6cWYy2mTmomJs2wTFyKDDoZ0z33RoRtb2Dsy/7JUMHb+y/E2gB7JRFTdQORSy5wN2kV5nqBS62WOrS0yl9Ys15l4KdIRvOGyIMzdMdY1WSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475200; c=relaxed/simple;
	bh=TkQHTWLX4Fh5NWZ3o/yUvyWD+xhfcY+T8xrUL3KHg3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sbocZi9H6A77gJKUU/eNPClG1s0DOWUIrwi9xSKcQcdwVYFie/0ci07I82HUAZo0qK+OUFI3zlvVAEhQ56dBgFVmPPR09AmykHdgop8zyebEzlklbj+kXIOh9foPVQAXDsj5uQ4W9UV3tkVJBEg/6vPn7o++OQX+hvVKywpXkMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2a3ymcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2a3ymcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD9AC2BBFC;
	Tue, 30 Apr 2024 11:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475199;
	bh=TkQHTWLX4Fh5NWZ3o/yUvyWD+xhfcY+T8xrUL3KHg3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2a3ymcgUFpsn3WtW0VHm0s4WTUIYyrV6TOqvJPfmxbYomof7qieLUv5pxn9Lr7s+
	 komHMq8o2pWzFEfRR8QvXapSZlqg2d+MzSif4aA/mc6D9NsSX1VZGC6DRB4aRb22GZ
	 DChUARVYVSaOIMSIfJgWg9RqlyL0Q1IhcuefsPFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/186] arm64: dts: mediatek: mt7622: drop "reset-names" from thermal block
Date: Tue, 30 Apr 2024 12:37:56 +0200
Message-ID: <20240430103058.729644487@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit ecb5b0034f5bcc35003b4b965cf50c6e98316e79 ]

Binding doesn't specify "reset-names" property and Linux driver also
doesn't use it.

Fix following validation error:
arch/arm64/boot/dts/mediatek/mt7622-rfb1.dtb: thermal@1100b000: Unevaluated properties are not allowed ('reset-names' was unexpected)
        from schema $id: http://devicetree.org/schemas/thermal/mediatek,thermal.yaml#

Fixes: ae457b7679c4 ("arm64: dts: mt7622: add SoC and peripheral related device nodes")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240317221050.18595-5-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 8e46480b5364b..917fa39a74f8d 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -513,7 +513,6 @@
 			 <&pericfg CLK_PERI_AUXADC_PD>;
 		clock-names = "therm", "auxadc";
 		resets = <&pericfg MT7622_PERI_THERM_SW_RST>;
-		reset-names = "therm";
 		mediatek,auxadc = <&auxadc>;
 		mediatek,apmixedsys = <&apmixedsys>;
 		nvmem-cells = <&thermal_calibration>;
-- 
2.43.0



