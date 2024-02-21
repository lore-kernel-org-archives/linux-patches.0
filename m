Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CC369318;
	Wed, 21 Feb 2024 13:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522028; cv=none; b=NYNs3ZPzoCAQH1DhorgyXNE2fIeEFek5Z4JqowalK5h0NaHEnvLGbIYZSxwTlhTg0hhYfXGKZIrPiC5e5Q0/b3tqIUgYJyFwD1RpC4GrcQ+yXr7n/6GMRzEaWhR9WLJWZghvB0O237NV70jNzF36xAbn9jRfIAWjiiqkQka0n30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522028; c=relaxed/simple;
	bh=zCnqGueFwhGeixdVOC9HwRwuSemFsPWpJ+7eN2XRtv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Acv3V4XEhkiUpSklXuHEcFisJMZtejTWNlxmVq5ZL1P6WpLcIq8bsDsDvA6YptGeQl5m8aJbOmHzPE7Vk4lWYzu1cDZEmpQmwf50qNaMx0jP2cruhlyzZAyKgjitXpeEmNy0jJWRgSky+K4jvoRMLmsk/PJDHFdwkgfTeZEzoNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVTW3Vb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVTW3Vb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FEFC433C7;
	Wed, 21 Feb 2024 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522028;
	bh=zCnqGueFwhGeixdVOC9HwRwuSemFsPWpJ+7eN2XRtv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVTW3Vb20t9ip1k7qVOeiWP1aWyvgSpsM4wMb9twEbBfXxOlPk8yvOtP1/kneGo+G
	 nGJaaLZ2uXh8gIOgtD9qEB913h5o2IoVzdn419b5VL6dkXmR3BpD1m/mE0yJMFh+XI
	 tQqL+oHD026ko8DSRlAq/OxZ9jEtTXpAUFGxiTFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 031/476] arm64: dts: qcom: sdm845: fix USB DP/DM HS PHY interrupts
Date: Wed, 21 Feb 2024 14:01:22 +0100
Message-ID: <20240221130009.086468550@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3767,10 +3767,10 @@
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
 
@@ -3815,10 +3815,10 @@
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
 


