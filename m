Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B6B1586DB;
	Mon, 29 Jan 2024 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548096; cv=none; b=GXygcfcZnNi9xfZewBODSdohFlmiV0cD22oHonxxX3shHD0LWcJt8upg1yFCYVEzyJNudxy/MPrxCk/juN1EbwSMRYDs6WnpeiomGS/lnWLn1vMbdGUdhqN9/JKDRRoJ5G4yVzpFtZh9wZTHUOTB5HRsfbz7+G4FpLdFca11hBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548096; c=relaxed/simple;
	bh=D3NYvpLNCsX+zofWyU203XabKw8/lDw5k/a9Zut6bbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFWgkcBdSDGCFi15BCLMS1WR5XphYz++awL0HynRT4tfdo02o3rkOuUwRByB9D61bHyr/EfCOyaPY/c3RoaUA5bBpkIaXXAM4D6VR9SMTMvCWR0t2fVRYEW/umg+vK8N/c5G80M3VMNUItpSZvuHvec0VdF1k6CvKIImSHj3/Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Gyi9riS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Gyi9riS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C8FC433B2;
	Mon, 29 Jan 2024 17:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548096;
	bh=D3NYvpLNCsX+zofWyU203XabKw8/lDw5k/a9Zut6bbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Gyi9riSatcfk+GS2Nq2Bsx2vSul24mijh3EjDlIihTR2+mxrLtnkcUVBs/H8tGdU
	 X1UheDFvdspGD0jksX8AtQvOy6Tys15/HMvsSSqMKBZSuDO6iQWROknbGXfTOnwwXe
	 gKwFuhq9C8qTSU2nQU2mPnwgdr+pqeoRfGWfT53Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 088/346] arm64: dts: qcom: sc8180x: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:01:59 -0800
Message-ID: <20240129170018.992990983@linuxfoundation.org>
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

commit 0afa885d42d05d30161ab8eab1ebacd993edb82b upstream.

The USB SS PHY interrupt needs to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: b080f53a8f44 ("arm64: dts: qcom: sc8180x: Add remoteprocs, wifi and usb nodes")
Cc: stable@vger.kernel.org      # 6.5
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231214074319.11023-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2553,7 +2553,7 @@
 			compatible = "qcom,sc8180x-dwc3", "qcom,dwc3";
 			reg = <0 0x0a6f8800 0 0x400>;
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq",
@@ -2627,7 +2627,7 @@
 			resets = <&gcc GCC_USB30_SEC_BCR>;
 			power-domains = <&gcc USB30_SEC_GDSC>;
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 7 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 10 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",


