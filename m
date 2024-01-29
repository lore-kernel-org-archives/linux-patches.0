Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0E215DBCF;
	Mon, 29 Jan 2024 17:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548474; cv=none; b=PV5U50rgpfp7OImz6tsg+VTnZeKTru+gx5kZ/zKyATppjWWLzJAvRphhirgTIIgw1MPMTHh6uCUIC9rVyvb+8TkgVLG02c+f2nbbmjOlf8vgAvpdF2v8Cf2WggubEmoy0OJaXXnLKHXdEMT+KiOL76ihpQZ+AKtzEg9JG9Ep6VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548474; c=relaxed/simple;
	bh=AA1ndQnJmKwG904GGhKvtLk1+H2R/AORGGtNW58Di6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5gxHJNUYt94yyEuR5uGJjd00qKt6JuEr3rA8xqTT62Ir7pW3cYaCv2BzssF5opqtWra8kvLKWmxvaK8ow55ek//W+DYaYuhivXg5fySSPdxPqLADu2LazkAkHJ708MltiNotoC9qnc3iE16pMXjrAbzAlHWqmuOn0oarCEiciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6MLz3xE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6MLz3xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3241AC43390;
	Mon, 29 Jan 2024 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548474;
	bh=AA1ndQnJmKwG904GGhKvtLk1+H2R/AORGGtNW58Di6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6MLz3xEofMwnieTv6fDbZ/6WGwrJHkj36gzfnGu5ga1XQSfeOEJroVAez9XcsSYR
	 c2rcdwGKhQ4jaUOyF10pUnTVeC1Kqhhb3HcjVS7OI4kWuTCZQrtJDwsulx2u0ijDJW
	 Sooydf/Dl+3TG1T0rQ/o4FH8yKVF3j9HQ8Q5m3ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Pham <quic_jackp@quicinc.com>,
	Jonathan Marek <jonathan@marek.ca>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 092/331] arm64: dts: qcom: sm8150: fix USB DP/DM HS PHY interrupts
Date: Mon, 29 Jan 2024 09:02:36 -0800
Message-ID: <20240129170017.624072516@linuxfoundation.org>
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

commit 134de5e831775e8b178db9b131c1d3769a766982 upstream.

The USB DP/DM HS PHY interrupts need to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states and to be able to detect disconnect events, which requires
triggering on falling edges.

A recent commit updated the trigger type but failed to change the
interrupt provider as required. This leads to the current Linux driver
failing to probe instead of printing an error during suspend and USB
wakeup not working as intended.

Fixes: 54524b6987d1 ("arm64: dts: qcom: sm8150: fix USB wakeup interrupt types")
Fixes: 0c9dde0d2015 ("arm64: dts: qcom: sm8150: Add secondary USB and PHY nodes")
Fixes: b33d2868e8d3 ("arm64: dts: qcom: sm8150: Add USB and PHY device nodes")
Cc: stable@vger.kernel.org      # 5.10
Cc: Jack Pham <quic_jackp@quicinc.com>
Cc: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231213173403.29544-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3592,10 +3592,10 @@
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <200000000>;
 
-			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
-				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
+			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
+					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
@@ -3645,10 +3645,10 @@
 					  <&gcc GCC_USB30_SEC_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <200000000>;
 
-			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
-				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
+			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
+					      <&intc GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 10 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


