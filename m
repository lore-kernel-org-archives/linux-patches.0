Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D2F159595;
	Mon, 29 Jan 2024 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548236; cv=none; b=roeEGdFRx5xuBK3L72w9CMsXUwCs+xCRJmxMNiuDQhpcbWu/2xgM3Cb29UYPhOYR88LWQr2YKR6ntqrRkcI5ZVlrI9hGvyUR9VDtND6AuUZt++W8KXZ3pszXDdr/lbtXsB5KNEsVfm2nGqBkFpuZsGRiXp1z33E/zRjKSSPV4DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548236; c=relaxed/simple;
	bh=vWuhYpD3zM7dlvmyYq8u6/0Ov0D2htEvfyKyQP9bwd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzB9N7pLtMm2HgjIcosbAGW/00O2oMl6ncEgh8tHPpIdYDca27iEveVSr3ZpkZgGpPiPvx6hdFAI/mr2DcplOeu14Ux6iUTnuhmKcanoSQ7frgboyIM57EbB4T7Vi1x/tXzywtPRsFS5XcD4/gCduwYG4TQ0JsgLYpV11mwse3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=048rWcV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="048rWcV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C812C43399;
	Mon, 29 Jan 2024 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548236;
	bh=vWuhYpD3zM7dlvmyYq8u6/0Ov0D2htEvfyKyQP9bwd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=048rWcV2qWlFH5wS6WlKhSyVXbsXFs6MrEOZznE2ooengI+zjEs6LHfss9VOP0hcg
	 lTqCZ27PkJYtt2AQkm520Nd0wPbKZehaVx5r8xLGJ5nMc43j2f6wm5BBVK6NqjSSQV
	 WhLg9F/ilx+LwJf0ZeS0P2Yx6Ve2C/fRZlQuMy5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 037/185] arm64: dts: qcom: sc7280: fix usb_1 wakeup interrupt types
Date: Mon, 29 Jan 2024 09:03:57 -0800
Message-ID: <20240129165959.779289042@linuxfoundation.org>
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

commit c34199d967a946e55381404fa949382691737521 upstream.

A recent cleanup reordering the usb_1 wakeup interrupts inadvertently
switched the DP and SuperSpeed interrupt trigger types.

Fixes: 4a7ffc10d195 ("arm64: dts: qcom: align DWC3 USB interrupts with DT schema")
Cc: stable@vger.kernel.org      # 5.19
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231120164331.8116-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3664,9 +3664,9 @@
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 14 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 14 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 15 IRQ_TYPE_EDGE_BOTH>,
-					      <&pdc 17 IRQ_TYPE_EDGE_BOTH>;
+					      <&pdc 17 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "hs_phy_irq",
 					  "dp_hs_phy_irq",
 					  "dm_hs_phy_irq",


