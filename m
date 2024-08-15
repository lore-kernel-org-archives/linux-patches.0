Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A13D18D630;
	Thu, 15 Aug 2024 13:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730203; cv=none; b=AORkvkbNvGH28h6WJ16SsJIIP/yJ7hsrKTnphmxzlWlPHCpFnJecHRslV92dYrMs25wajOftpXWD15EspcqgY0G5x5yRDPgR6YFgfZ5uyrSkkogISnJ1+0EH51TQjYbPEQ7oHfdliZAvsne3KxgS9s4CRic+XEn459KoGozatZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730203; c=relaxed/simple;
	bh=P43HW83HjFttXGwSFqkENGv7sJajTzOCVk4KCalrFOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfmsYJUFPMr6BdT2RGv0ceU3XJu6Tfc+Lpq92xCjQRCDANMSgeKAYnpH+naWPv8VavoQoUn6Pqgj25ImiQ/sprLgPKxOGyqbya4HjutNGZDkqPmZmjvZqfYJGYeJLp2EA1q6Uo63ZI9Bioc1Qq3nBrrwbzK61TGdMhLnTNXgCVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9seXVwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9seXVwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996F9C32786;
	Thu, 15 Aug 2024 13:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730203;
	bh=P43HW83HjFttXGwSFqkENGv7sJajTzOCVk4KCalrFOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9seXVwGAKsGiZ27k1DkjqaHkyhxLvP6Y2tm6Yikeqy0whsEn+A9CXL3jbnYfvIM3
	 ++qHLvqTddo+2Vzf9dyypUD5S7z21BtmN9I7YQ3bp+BWJqd/4EeBa7EnyezxxTFEKm
	 wy2QRKbKRnVPCAvCpxUQqgc09mK8WztUXXVyV138=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/484] arm64: dts: qcom: ipq8074: Disable SS instance in Parkmode for USB
Date: Thu, 15 Aug 2024 15:22:41 +0200
Message-ID: <20240815131953.109675103@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Krishna Kurapati <quic_kriskura@quicinc.com>

[ Upstream commit dc6ba95c6c4400a84cca5b419b34ae852a08cfb5 ]

For Gen-1 targets like IPQ8074, it is seen that stressing out the
controller in host mode results in HC died error:

 xhci-hcd.12.auto: xHCI host not responding to stop endpoint command
 xhci-hcd.12.auto: xHCI host controller not responding, assume dead
 xhci-hcd.12.auto: HC died; cleaning up

And at this instant only restarting the host mode fixes it. Disable
SuperSpeed instance in park mode for IPQ8074 to mitigate this issue.

Cc: stable@vger.kernel.org
Fixes: 5e09bc51d07b ("arm64: dts: ipq8074: enable USB support")
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240704152848.3380602-3-quic_kriskura@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 0a4c5b847ddd5..384904344baf0 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -514,6 +514,7 @@ dwc_0: dwc3@8a00000 {
 				interrupts = <GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&qusb_phy_0>, <&usb0_ssphy>;
 				phy-names = "usb2-phy", "usb3-phy";
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;
@@ -554,6 +555,7 @@ dwc_1: dwc3@8c00000 {
 				interrupts = <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&qusb_phy_1>, <&usb1_ssphy>;
 				phy-names = "usb2-phy", "usb3-phy";
+				snps,parkmode-disable-ss-quirk;
 				snps,is-utmi-l1-suspend;
 				snps,hird-threshold = /bits/ 8 <0x0>;
 				snps,dis_u2_susphy_quirk;
-- 
2.43.0



