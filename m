Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5BF14D42C;
	Tue, 23 Jan 2024 00:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969283; cv=none; b=MU9Q4+gNVta45CQ/XFWKfg5L/dnaghYk/2r0w232UpwO23LCxHMfvx0ttOD1GZyZ989AKUUfal9wLbbItDzOQUYwp0vzP0JNcDIzCMu9KaWLXwl3+gwb9Aq8v1XYYaPP29BMQQjYloK0mLQDj8zpZxpIHfakfKRHq5Bna23LMs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969283; c=relaxed/simple;
	bh=+8MXDp+M/3YRK9ywn9Sf7BJVlBawAoEUwwct9zcFsqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/iA9Ll8Nww5oaeAzbn0Wrfm4YilISh/Xlw5a2ivUi796s3Sc8Hnccf/bvW6k1T2s7JEppGARaUVXDuRRmlc5b/+GLSROdefiuGZ3an+EWyspcEa5PwYupuzhLBx7mtmj7v1gNvG4lcOm4sMvOxqtxlhPTe1Q8GMY7IVedlvtsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaVAoHHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaVAoHHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3F6C433C7;
	Tue, 23 Jan 2024 00:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969283;
	bh=+8MXDp+M/3YRK9ywn9Sf7BJVlBawAoEUwwct9zcFsqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaVAoHHir7JSUF70+ONyc25tzjxutedzwNhVoJj0V3Q4s3Jyt8ASuTwyhA3No03O1
	 9qrxTH49gNm41hCCJb5tULG8lehcAi+ytSxK9covHsq9RPfSPsqx+X4dkR1GEqZGpk
	 OjnlV85NkrqThCgVNNVjmotWGfbXaWyBNBzksUVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 144/641] arm64: dts: qcom: sc7280: fix usb_2 wakeup interrupt types
Date: Mon, 22 Jan 2024 15:50:48 -0800
Message-ID: <20240122235822.556133963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

[ Upstream commit 24f8aba9a7c77c7e9d814a5754798e8346c7dd28 ]

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Note that only triggering on rising edges can be used to detect resume
events but not disconnect events.

Fixes: bb9efa59c665 ("arm64: dts: qcom: sc7280: Add USB related nodes")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-6-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 1a3db2579806..1dac0b10582e 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3428,8 +3428,8 @@ usb_2: usb@8cf8800 {
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 240 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 12 IRQ_TYPE_EDGE_RISING>,
-					      <&pdc 13 IRQ_TYPE_EDGE_RISING>;
+					      <&pdc 12 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 13 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq",
 					  "dp_hs_phy_irq",
 					  "dm_hs_phy_irq";
-- 
2.43.0



