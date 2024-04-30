Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB312C54D;
	Tue, 30 Apr 2024 10:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473993; cv=none; b=P6kU3XZiN5+bBmF4AltP+6GtIxJTvDjDtY4qzlw9TqGMSrUS+EVtciEqpswt8l1nQ2YgbXs1UTx3OL2hfBeT3Ey+86Poe01IwhlFZCPn8uXL4OQj9ZuvB+zEZYWZoyKeX1bchE9nCmQkq5Fw52FAC3YQw6lC5i7AIuNKkH8qKfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473993; c=relaxed/simple;
	bh=pJ9avp/C7mBakq1DKvsnP1P57l/JVuC4Y2z73wwZ9fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oQLMIGF7lOR5ungZMgfN0YJcC9xk5mqPU1g1EEc95DPNEHthajW6WgAB3FAfWsVuLVGQcC5EcrktZER7Bhy4asPtT/L6CkOX9+TaH2FZczHiLlbG/o++Ujb6RfHunkbxVXck2iT11HBmnhKMO8EHC1SR9he07NONPnKzfwn4VN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zw6MVIvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zw6MVIvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29666C2BBFC;
	Tue, 30 Apr 2024 10:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473993;
	bh=pJ9avp/C7mBakq1DKvsnP1P57l/JVuC4Y2z73wwZ9fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zw6MVIvMjcMSZ41Q1kA7/NTjN+hNQBG+8mg6MTM9mphYq9DYO7srEermoLgtxqTLV
	 YIbtfuxNv8fkuDRMQwRUIzlCPiNuFYiKRXW+A7jzSb0u6uGQTLXE4U6GILvJYBSZ5D
	 qcwZqIrmuLCQiTez0AKAZUEcdTNkBh0cISM+0+jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 029/228] arm64: dts: mediatek: mt7986: drop invalid thermal block clock
Date: Tue, 30 Apr 2024 12:36:47 +0200
Message-ID: <20240430103104.654987146@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 970f8b01bd7719a22e577ba6c78e27f9ccf22783 ]

Thermal block uses only two clocks. Its binding doesn't document or
allow "adc_32k". Also Linux driver doesn't support it.

It has been additionally verified by Angelo by his detailed research on
MT7981 / MT7986 clocks (thanks!).

This fixes:
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: thermal@1100c800: clocks: [[4, 27], [4, 44], [4, 45]] is too long
        from schema $id: http://devicetree.org/schemas/thermal/mediatek,thermal.yaml#
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: thermal@1100c800: clock-names: ['therm', 'auxadc', 'adc_32k'] is too long
        from schema $id: http://devicetree.org/schemas/thermal/mediatek,thermal.yaml#

Fixes: 0a9615d58d04 ("arm64: dts: mt7986: add thermal and efuse")
Cc: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/linux-devicetree/17d143aa-576e-4d67-a0ea-b79f3518b81c@collabora.com/
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240213053739.14387-3-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index f3a2a89fada41..559990dcd1d17 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -332,9 +332,8 @@
 			reg = <0 0x1100c800 0 0x800>;
 			interrupts = <GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&infracfg CLK_INFRA_THERM_CK>,
-				 <&infracfg CLK_INFRA_ADC_26M_CK>,
-				 <&infracfg CLK_INFRA_ADC_FRC_CK>;
-			clock-names = "therm", "auxadc", "adc_32k";
+				 <&infracfg CLK_INFRA_ADC_26M_CK>;
+			clock-names = "therm", "auxadc";
 			nvmem-cells = <&thermal_calibration>;
 			nvmem-cell-names = "calibration-data";
 			#thermal-sensor-cells = <1>;
-- 
2.43.0



