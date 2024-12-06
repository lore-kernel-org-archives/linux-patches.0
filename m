Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42821442E8;
	Fri,  6 Dec 2024 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496941; cv=none; b=UqRBxQP2CGkHMnJzDToU5DBQnKeYjbTIVgl32pN5uoZG2J56r2y/Oi+X0VmQ4thu7Vc6274/jVL/Oa9TEE/6M1BI7oIn+O1zrzY7dktnTFzLF1GgmEz0MLjal36occSkY27D1LdP8+BzI16lzVc8sLjoZzx2B69p9rSpxiui/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496941; c=relaxed/simple;
	bh=DicICngrkr3vPMZ7Yw37fJO/ajv7nzKO2Tq7uaM5lnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6fepj3BRF91lfDor8Afg4kxDBme8ZMBZhxDs9f1gKFjkKCbbqHvyey4K1rvRz6U5AHdaX26tr65KsIyei7d0lLt58vGvWW1Tjw5nXhj/Pv88B6Niam3OtB2nQ3Y19YMPbxDlgC5phOzGR0B0QaFbXGmlqfGL+dq8K+ChiyxHJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCP3M7O4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCP3M7O4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A80C4CED1;
	Fri,  6 Dec 2024 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496941;
	bh=DicICngrkr3vPMZ7Yw37fJO/ajv7nzKO2Tq7uaM5lnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCP3M7O4slckZ6srH2UrgyvYc1WHwq8l1RfwDXLm/l6DdJGak+QTI4o4Fgkdz1FEr
	 XIdOCCoiq2h0cOvspfJf+2teW6nSvbVRVm4sB0wtnWWroqITjI5oHc9fjPwu39lcZz
	 2GSDb8SxmaVcLiKE/ggxYykl63hUSH9gLPiuqrvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/676] arm64: dts: mediatek: Add ADC node on MT6357, MT6358, MT6359 PMICs
Date: Fri,  6 Dec 2024 15:29:30 +0100
Message-ID: <20241206143659.249581329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b0a4ce81f327eae06c1088f1a437edc48a94a3e8 ]

Add support for the ADC on MT6357/8/9 and keep it default enabled
as this IP is always present on those PMICs.
Users may use different IIO channels depending on board-specific
routing.

Link: https://lore.kernel.org/r/20240604123008.327424-6-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Stable-dep-of: 76ab2ae0ab9e ("arm64: dts: mediatek: mt6358: fix dtbs_check error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6357.dtsi | 5 +++++
 arch/arm64/boot/dts/mediatek/mt6358.dtsi | 5 +++++
 arch/arm64/boot/dts/mediatek/mt6359.dtsi | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt6357.dtsi b/arch/arm64/boot/dts/mediatek/mt6357.dtsi
index 3330a03c2f745..5fafa842d312f 100644
--- a/arch/arm64/boot/dts/mediatek/mt6357.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6357.dtsi
@@ -10,6 +10,11 @@ &pwrap {
 	mt6357_pmic: pmic {
 		compatible = "mediatek,mt6357";
 
+		pmic_adc: adc {
+			compatible = "mediatek,mt6357-auxadc";
+			#io-channel-cells = <1>;
+		};
+
 		regulators {
 			mt6357_vproc_reg: buck-vproc {
 				regulator-name = "vproc";
diff --git a/arch/arm64/boot/dts/mediatek/mt6358.dtsi b/arch/arm64/boot/dts/mediatek/mt6358.dtsi
index b605313bed99d..8c9b6f662e9bc 100644
--- a/arch/arm64/boot/dts/mediatek/mt6358.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6358.dtsi
@@ -12,6 +12,11 @@ pmic: pmic {
 		interrupts = <182 IRQ_TYPE_LEVEL_HIGH>;
 		#interrupt-cells = <2>;
 
+		pmic_adc: adc {
+			compatible = "mediatek,mt6358-auxadc";
+			#io-channel-cells = <1>;
+		};
+
 		mt6358codec: mt6358codec {
 			compatible = "mediatek,mt6358-sound";
 			mediatek,dmic-mode = <0>; /* two-wires */
diff --git a/arch/arm64/boot/dts/mediatek/mt6359.dtsi b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
index df3e822232d34..8e1b8c85c6ede 100644
--- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
@@ -9,6 +9,11 @@ pmic: pmic {
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
+		pmic_adc: adc {
+			compatible = "mediatek,mt6359-auxadc";
+			#io-channel-cells = <1>;
+		};
+
 		mt6359codec: mt6359codec {
 		};
 
-- 
2.43.0



