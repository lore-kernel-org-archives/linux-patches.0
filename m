Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49A5163A90;
	Mon, 29 Jan 2024 17:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548385; cv=none; b=Ov3m/RWAGrMf6YXYKX1Iykk848dC0kvDbY2BRPcFdDRBZW8RP2k0aX2f9xrjpwhLmaGY37SeBlbFjH2Xzao8h5FTc1sTL75QNL4iZBJ4roz+eFPPJ2v/Szw5oVvETcp765OhQVEOdTsjC8aShksoWXNcnJtQD+5cbrIxBl9CfxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548385; c=relaxed/simple;
	bh=iROTM62lg/86u4CoRwX0WWcpXcnjQKESySEB3hueEFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBCiQrOYOxuzRamkVeBxp3SZ4CViijkyPPXGueyp+dpPit1WtAERuFOZ/iQ5PEseZndi5YFW3IOTO4gU1W9lMqh9RWl/nqwkYHcDc44ed2YFE6TRhsQ7El/JZxyzKxtje3q2NGQSA80v3mdFn1rr0qgH0/QE6RP74+N1QJOEZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=re3jbA+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="re3jbA+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF45C433F1;
	Mon, 29 Jan 2024 17:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548385;
	bh=iROTM62lg/86u4CoRwX0WWcpXcnjQKESySEB3hueEFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=re3jbA+GswbEjKmNCQbYAkGoelhaRTFJUZ+NU2eSjUk7MqhxFOuRUZhBKO4U2LT2W
	 PGO5c3XZhE62r3tKI22nMqS/Lm3BG2819SOHgzzm/pdptcqFSSS/ARIbhMl8tNwjvh
	 m8Gpbk5fPftMHvK7HxCKKtkTw+hT+2iUgm8MWFBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/185] ARM: dts: qcom: sdx55: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:05:57 -0800
Message-ID: <20240129170003.639056998@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 710dd03464e4ab5b3d329768388b165d61958577 ]

The USB SS PHY interrupt needs to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: fea4b41022f3 ("ARM: dts: qcom: sdx55: Add USB3 and PHY support")
Cc: stable@vger.kernel.org	# 5.12
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231213173131.29436-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index de747859fdc6..b85820448b9d 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -496,7 +496,7 @@ usb: usb@a6f8800 {
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 51 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 11 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 10 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
-- 
2.43.0



