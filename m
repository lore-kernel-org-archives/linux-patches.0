Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFD215B117;
	Mon, 29 Jan 2024 17:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548473; cv=none; b=H9fYXsNnBlSreJxbQY6y97gQE2Sw2hBXmjXRBOwRffrPD6xvFuyAfG6NJ9xjLnj997UykdH+whtISzOXPWuPjpidq5se/mjWWzzLPKv7iBu3WCJJ+96Lh+OBSJjDeKY3audvkSBJtx8RzmyFc8yG/938YgGp0P0zXRsQBbJNilM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548473; c=relaxed/simple;
	bh=0AUViJD7EIpU4mdqxwnFiBxwoqnsiMU5GhIP29uasR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO3hr7FSwO2rXtQcprQKHA7reMQz1sXQoqwkW44OoQccOyYUI1Xyv8vLXQ6tQXrF8JrJMabtsZaSQUWc3QRp0AfsEvy+GFMQaKRrMA0YN3M64jA3NHsdomFN4thffnN7IrN0Xjri6DgwMV2mbxHuvno6IB8j/h4VQp6nHX4pHTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCGdr3Nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCGdr3Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B9CC433F1;
	Mon, 29 Jan 2024 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548472;
	bh=0AUViJD7EIpU4mdqxwnFiBxwoqnsiMU5GhIP29uasR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCGdr3Nu6cROkPcKEWfoOYS5lvbwouY0Nm2chXZhKkmwowLynzJ8ghFgJDnli9e4f
	 FVdPd8vUN0vzHZYPubP/ELHujVuaYPuBOPz17IDirCeHmp8FKoJhzD7sBsklkNMihc
	 +aeu0nRm+hjX0h9Jx0h0K9wx9HNQY+al9Q7h1R14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 090/331] arm64: dts: qcom: sdm845: fix USB DP/DM HS PHY interrupts
Date: Mon, 29 Jan 2024 09:02:34 -0800
Message-ID: <20240129170017.561358198@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 204f9ed4bad6293933179517624143b8f412347c upstream.

The USB DP/DM HS PHY interrupts need to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states and to be able to detect disconnect events, which requires
triggering on falling edges.

A recent commit updated the trigger type but failed to change the
interrupt provider as required. This leads to the current Linux driver
failing to probe instead of printing an error during suspend and USB
wakeup not working as intended.

Fixes: 84ad9ac8d9ca ("arm64: dts: qcom: sdm845: fix USB wakeup interrupt types")
Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
Cc: stable@vger.kernel.org      # 4.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231213173403.29544-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4084,10 +4084,10 @@
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <150000000>;
 
-			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
-				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
+			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
+					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc_intc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
@@ -4135,10 +4135,10 @@
 					  <&gcc GCC_USB30_SEC_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <150000000>;
 
-			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
-				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
+			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
+					      <&intc GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 10 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc_intc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


