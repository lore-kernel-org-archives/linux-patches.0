Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB426FDE1;
	Mon, 29 Jan 2024 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548490; cv=none; b=AdCZcxa/Uw+qVsXxGCkDVPm0LAoTja5Nx+WG6AWDDkyKRJL0m9o6atzyJBA39OmJxooRAmOVDj9o0RNehTETltQRx49fip7srurAleTruoIWyu5I6eIdubF9VCO5W/5Fw/Pu9yUmQS7ojFM6lL9+eOxjq+P8HmMJJVvz5jJzkAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548490; c=relaxed/simple;
	bh=Svt+8+AsqdGkaIpfWt5UQ8RaGFKDgLTPUQ+nbwR4hQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je6sxH7vTZp/X5+FhM9seIiApGTjlPlsGiiXfU1F2LccefAu8y790pd3tk/mgSH9vIMiJ2nYnab9p4bMXHRlzwwsavPhVZBbR1gbZ0nNEN5HVG2b3TlVZbtLfj7RDdKJL+sAWNnNO0ov1JFJ+5RbEwJfm1r7VDkInMiZrUUrUE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm+EObgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm+EObgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A7FC433F1;
	Mon, 29 Jan 2024 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548490;
	bh=Svt+8+AsqdGkaIpfWt5UQ8RaGFKDgLTPUQ+nbwR4hQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm+EObgBOqaylM87qJV7Eelx1LWbyGvx5bqXIXM3rfISnWwfrtOyFXlWMQLV8n5TB
	 XqEKNR1f1fwRqXDgAKPLMSGlrzYN7p26qUC3qC+xNVzt8tnhCO0maUgC1dp1EcuS7v
	 QioAkYUFnnsL3czOQ3q5OUjXjMbVhTmbRPe7aHGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 087/331] arm64: dts: qcom: sc7280: fix usb_1 wakeup interrupt types
Date: Mon, 29 Jan 2024 09:02:31 -0800
Message-ID: <20240129170017.479615565@linuxfoundation.org>
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
@@ -3668,9 +3668,9 @@
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


