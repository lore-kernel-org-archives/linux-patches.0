Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22069221710;
	Thu, 13 Feb 2025 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457836; cv=none; b=c+UvBCpCNeB8EONQLbwFRfDDeb6DSfbTIRxMmeZQ4ebg1wjX5qNdXRJhEWs9BYqXlHsTonN2/k2lEhawNc4kDpXUYAnv1jlEH3Nqxi7DfcNtqhqPLTwIHpSmIUxU+Jw8Is/YnsGMQjhVdufY9wUexyvpxu0vNJF54CplndnKICk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457836; c=relaxed/simple;
	bh=HnUkuPb0W/nF1EotVOYKKbwlDz5lyuij42pXqErrOIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8hmF3WsKr9EOpmiVv+/Y9WkUggiqvYKW9HgeV0w3rvw4w5G5dG4pmsgYmqXhVOgH2MgwI5i7WVylDNgp+h8vfJhLzT4MeM31UNxmXU0v3ggGJ1fmpIlc8K3gEedK6VtRRjWiJGzIGMdqN/BcYH1h0Lt4PRWguZXloyduEi+37o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5PG1bau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5PG1bau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A63C4AF09;
	Thu, 13 Feb 2025 14:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457835;
	bh=HnUkuPb0W/nF1EotVOYKKbwlDz5lyuij42pXqErrOIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5PG1bauM+VI2rlhbCwvxZIfXpzhCTzyZva6oqRM25n6fcH82mDRaS/ZZLQ6cxKwF
	 yYb0RenwZZfdLnDYzDySu7amcjweS1A+p0tEM5+PtjLdflh0OjzoSEVBAaWCWkKc1b
	 g83dX1OJiOL/6BQdhWbGRasf2HmNai86gQsXKVYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 225/422] arm64: dts: qcom: x1e80100: Fix usb_2 controller interrupts
Date: Thu, 13 Feb 2025 15:26:14 +0100
Message-ID: <20250213142445.219514613@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit 680421056216efe727ff4ed48f481691d5873b9e upstream.

Back when the CRD support was brought up, the usb_2 controller didn't
have anything connected to it in order to test it properly, so it was
never enabled.

On the Lenovo ThinkPad T14s, the usb_2 controller has the fingerprint
controller connected to it. So enabling it, proved that the interrupts
lines were wrong from the start.

Fix both the pwr_event and the DWC ctrl_irq lines, according to
documentation.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Cc: stable@vger.kernel.org	# 6.9
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250107-x1e80100-fix-usb2-controller-irqs-v1-1-4689aa9852a7@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -4115,7 +4115,7 @@
 					  <&gcc GCC_USB20_MASTER_CLK>;
 			assigned-clock-rates = <19200000>, <200000000>;
 
-			interrupts-extended = <&intc GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&intc GIC_SPI 245 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 50 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 49 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "pwr_event",
@@ -4141,7 +4141,7 @@
 			usb_2_dwc3: usb@a200000 {
 				compatible = "snps,dwc3";
 				reg = <0 0x0a200000 0 0xcd00>;
-				interrupts = <GIC_SPI 241 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>;
 				iommus = <&apps_smmu 0x14e0 0x0>;
 				phys = <&usb_2_hsphy>;
 				phy-names = "usb2-phy";


