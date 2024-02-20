Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2658C612D7;
	Tue, 20 Feb 2024 21:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463236; cv=none; b=WStAaL70Dm5t8Ol1VsaXW/SbjB3ea46CDBXkkAGwsgyfp9EgjrvTXvECAojfzZBiyVEBHxjvkhSQwRO6A2tYNZ/0tooako6EVTdpRFU6clVOUlHLyvQMwrau2D9KXTNb2FTTGRiX5H4dKGQ2xCdFD8VJ0hzAl7TuGeqZ3k3swIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463236; c=relaxed/simple;
	bh=nCjPtsvs/bxHU/SnUL/4eKyWb5dkyRcTrktgsuiUU7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gpa0rUCDRa/S3zoK1iMQq5cc0tn1gi0fDzV2MZSgbJJRy81iZl+htTRThYKG4qnKI92wN9kRJrb8o/khmICJq6EsFtNUpI56PWhnZWRdgvfkIkseyCHyIEnowQVU3lVDQUnASdu71XFHY1s4BNSvBRwWS2Dd3mpeKPK8aOY+Yv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n50i/0fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n50i/0fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58A8C433F1;
	Tue, 20 Feb 2024 21:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463236;
	bh=nCjPtsvs/bxHU/SnUL/4eKyWb5dkyRcTrktgsuiUU7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n50i/0frmxSbBEv1aL/FPDfeIlG433725K6FTSGpT/edE0ZgVSlgXsqC5OQ2JXP4+
	 p91w3z5RXz2Xv0SiOg1IvMzeLuSp75dQ8rh8W1wGIxI8P2faaMgfP/440Jy5APNYEM
	 h5940c3iSLY7zQq/O/8sQlRgv5Mn+4zI/Q61FlRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/197] arm64: dts: qcom: sdm845: fix USB SS wakeup
Date: Tue, 20 Feb 2024 21:52:18 +0100
Message-ID: <20240220204846.424748270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

[ Upstream commit 971f5d8b0618d09db75184ddd8cca0767514db5d ]

The USB SS PHY interrupts need to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
Cc: stable@vger.kernel.org	# 4.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231213173403.29544-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 4d5905ef0b41..95c515da9f2e 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4049,7 +4049,7 @@ usb_1: usb@a6f8800 {
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc_intc 8 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc_intc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
@@ -4100,7 +4100,7 @@ usb_2: usb@a8f8800 {
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 7 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc_intc 10 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc_intc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
-- 
2.43.0



