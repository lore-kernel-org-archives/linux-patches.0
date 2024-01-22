Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404B5134723;
	Tue, 23 Jan 2024 00:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969307; cv=none; b=M1Gy3oMxguvBV/s7K3GEmUsu7iv7Dum2+RRZ1F839qc5ROcqTq9LJgRXMlnVCdTDYkang3sWmRh9/a5u60F6lTLOHCVCwlwxCgwlyr7VKnZT1NQZ8xaDOesQciR7tn1dilOpQmeUHOZxx3jYFZUOFGCS734lk7k7qzyeg4OT40o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969307; c=relaxed/simple;
	bh=mHxFZ27n8iKel0M9f0UgxonulI+nlHs8wQN5zyhNTGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2kDGRz6MlIlsiR0NyEKO5ccdZpdwbYyiO1nTdxVxKsAbVItBTozTdQ9Asw13yAtJ438MQD36M1XFGKoGAHqUKJNgc0VsOUyNTpVRxRroSBeVaeA5ddK8x5RqTjqyuoCoPTV1DRw97n2m/SyFXTzF2oHBPUBKoR1lE3rMzp5bBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTEx72fg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTEx72fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F97C43394;
	Tue, 23 Jan 2024 00:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969307;
	bh=mHxFZ27n8iKel0M9f0UgxonulI+nlHs8wQN5zyhNTGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTEx72fg/tjlaU/8ph2Lpdf2BU3qeqL5wC9j+bU0tpWVuTx35I9TiL27/sfr1pVXe
	 llO4q+T1TRWMxy3rp5Qx6Dsl1dsSnIYmJ1Sr8GaQyKzmm4ICRfXkAjWToX2PshRLz8
	 VTD8JXfjcj0gEKSRPhSWPEaoTopBjn2L+rEm49wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 139/641] arm64: dts: qcom: sm6125: add interrupts to DWC3 USB controller
Date: Mon, 22 Jan 2024 15:50:43 -0800
Message-ID: <20240122235822.403430168@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 67e4656f4487b95a39e45884c99235f62ebfaa47 ]

Add interrupts to SM6125 DWC3 USB controller, based on downstream/vendor
code of Trinket DTSI from Xiaomi Laurel device, to fix dtbs_check
warnings:

  sm6125-xiaomi-laurel-sprout.dtb: usb@4ef8800: 'interrupt-names' is a required property
  sm6125-xiaomi-laurel-sprout.dtb: usb@4ef8800: 'oneOf' conditional failed, one must be fixed:
    'interrupts' is a required property
    'interrupts-extended' is a required property

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20231111164229.63803-5-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index eb07eca3a48d..1dd3a4056e26 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -1185,6 +1185,10 @@ usb3: usb@4ef8800 {
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <66666667>;
 
+			interrupts = <GIC_SPI 260 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "hs_phy_irq", "ss_phy_irq";
+
 			power-domains = <&gcc USB30_PRIM_GDSC>;
 			qcom,select-utmi-as-pipe-clk;
 			status = "disabled";
-- 
2.43.0



