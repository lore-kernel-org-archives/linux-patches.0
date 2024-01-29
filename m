Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1001586DB;
	Mon, 29 Jan 2024 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548097; cv=none; b=ogn5HrzuDMn/VZ6DxwGlJwx6Z+foBxF0NENQXEFAn0+gUVPvuFrTdRmlKNMNEOBr15IFZadC30Y6Snnp9+CIh8Fw/3nzOclPO+DHPCrL3W9qkC7Iv6wTOVpZMZFR8Ud7etu5oc+EmrN1xTflqyuILj2G28z4Qu7Hu1AuAqV0Hdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548097; c=relaxed/simple;
	bh=6DIAf9zekYcrhAR1OIE2civ5LjONzHbIDK052iInW7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I400jaiRIOh+6Ev4OQ++kfUsOe00kqizKQw63obVFKqHeH6Bh1y6Qk51v8Je5rogtOaWfmTdqi3pwqVB3Fo0htBDy0+x0NJ8ToEDtA0CBhCniJ69eSH0qg2rkxPwXq1b9bf/MuCTpVc2Qapx/MdexjaH2woxxJCncQLAo3GtqEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bs4WdhFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bs4WdhFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B70C433C7;
	Mon, 29 Jan 2024 17:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548096;
	bh=6DIAf9zekYcrhAR1OIE2civ5LjONzHbIDK052iInW7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bs4WdhFBlJly+NMzRaMj/jik7ms/Bg9BjsKQ9sk6ifLvw6skbpVY2ltlA9A4giu2C
	 r50iB3XD0QUcyToDL+H5W8N6Xot0xSCz/iupggg/FAW89GvJwHqoeHGQItaOZ00t06
	 09UaxKyPfSUBZQ96LUKK3mFJmRKt5C9hzoLqsqgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 089/346] arm64: dts: qcom: sdm670: fix USB DP/DM HS PHY interrupts
Date: Mon, 29 Jan 2024 09:02:00 -0800
Message-ID: <20240129170019.018567121@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit c42d12ea105f67b0f137f1e52d5c59d13fe12b1f upstream.

The USB DP/DM HS PHY interrupts need to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states and to be able to detect disconnect events, which requires
triggering on falling edges.

A recent commit updated the trigger type but failed to change the
interrupt provider as required. This leads to the current Linux driver
failing to probe instead of printing an error during suspend and USB
wakeup not working as intended.

Fixes: de3b3de30999 ("arm64: dts: qcom: sdm670: fix USB wakeup interrupt types")
Fixes: 07c8ded6e373 ("arm64: dts: qcom: add sdm670 and pixel 3a device trees")
Cc: stable@vger.kernel.org      # 6.2
Cc: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Richard Acayan <mailingradian@gmail.com>
Link: https://lore.kernel.org/r/20231214074319.11023-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm670.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm670.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm670.dtsi
@@ -1295,10 +1295,10 @@
 					  <&gcc GCC_USB30_PRIM_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <150000000>;
 
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
 


