Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352526FDF2;
	Mon, 29 Jan 2024 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548478; cv=none; b=APZW+zDq7PWhohOq7L5GEIna4LHW7JYvnGkGy0r/W2dDgq9k6WBGoabv+oNVl/CORLb4F1jguMMonGXKPIxWUWHReowylHzclNOlVjtWPMHMeQaU6PSAjJatN3fS4nsERNuJGQ7uhp9koNRoJnCtLwbQ8cvAePM8/62WFfpn+BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548478; c=relaxed/simple;
	bh=VPEOXmJtEybjdC9QuGR2KZIEqe1oBxIZGC86Snvy8PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=audJ6d3Z7LMwu6hxTgEAo0ay/mQIWKPCUDkCHeWfMiT3/tviHuy+hCqg998vB8MOKIssJw0NRbix6Ic3depV9YQ0i7dEMJMx0preGdSLWGCKgHcd4Xau8UXylScpCn4FbV2MYwB7/pSQU/eq9CXzyJAdVL46xg4h4L11kEYqyxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDcqN7KP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDcqN7KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F060FC43390;
	Mon, 29 Jan 2024 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548478;
	bh=VPEOXmJtEybjdC9QuGR2KZIEqe1oBxIZGC86Snvy8PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDcqN7KPcikUAk6ocyG/X3wblJfR68vi+uwA+4Av9jRJIdA8LkhmDnqnp2Nfdo8Fi
	 Sr5UB1vFqrVFgMcWCi0xoTG+jcLnYuo36jdgg9pZYdJiZaRxocreGXRyPLqWVuBNVG
	 aSv+OtNVFC9jnFaC3VVkZDevYg1ZyzqWIMNVOPqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 097/331] arm64: dts: qcom: sdm670: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:02:41 -0800
Message-ID: <20240129170017.766181146@linuxfoundation.org>
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

commit 047b2edc35b8db22354b4fba37818b548fc18896 upstream.

The USB SS PHY interrupt needs to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: 07c8ded6e373 ("arm64: dts: qcom: add sdm670 and pixel 3a device trees")
Cc: stable@vger.kernel.org      # 6.2
Cc: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Richard Acayan <mailingradian@gmail.com>
Link: https://lore.kernel.org/r/20231214074319.11023-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm670.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sdm670.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm670.dtsi
@@ -1296,7 +1296,7 @@
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",


