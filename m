Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FAA50253;
	Tue, 23 Jan 2024 01:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974717; cv=none; b=SBaIk9CV5FqJCJdbF+vBJZVh1NXMVTCPIS7Uf9xctxdsQ4L+wm5O12gSXfEiR6BQ7rioA7yg4PUE63DzzeDjLDWGArj/4eGLqWxVoAj5R1x0wq0aIDnYD6QmhsyPea0CB+fWAbyxyQvjJ/2K4/UHi7yBgFZQFEsvEV+EYQanzHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974717; c=relaxed/simple;
	bh=N/2ttepHxksBeoTFm1FrCHSp8Ego7qsV6ChgefDQpfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLbT/jpDVMuoJGGzz4H39+kJ8NpvIoFvxI3DvXZraWi3V+Cux+f8c8KoteMjV6dl8oGWmuWT07tsYSaGX2muwqXoiQhjf4BU7a+nUIk+SF7DacNvNWpMZH1dI38fBGi+HMmKkq0ybkY6T4ZuqTs898AyW3Ae0I1D/WP8sLPaWFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecTVijXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecTVijXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFDAC43390;
	Tue, 23 Jan 2024 01:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974716;
	bh=N/2ttepHxksBeoTFm1FrCHSp8Ego7qsV6ChgefDQpfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecTVijXML1WyHycvQ8xK+TopW4WgHEw9Pce3GKUcxSWx1Y5+RR6vYLXWZUEwAtlqN
	 TPQ3ueo1kRDdPjd+CL9KI58Qwtzzb0/nzwhTreVVLoW5oXwNTIXuEPFqFhic9ffDSF
	 P8/P83Bdzi+Mx+wZ+Xkq+fBdeRU0aWmSOuFnASkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shazad Hussain <quic_shazhuss@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/583] arm64: dts: qcom: sa8775p: fix USB wakeup interrupt types
Date: Mon, 22 Jan 2024 15:53:03 -0800
Message-ID: <20240122235816.165849775@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

[ Upstream commit 0984bc0165f7c5203dfffe8cdb5186995f628a80 ]

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Note that only triggering on rising edges can be used to detect resume
events but not disconnect events.

Fixes: de1001525c1a ("arm64: dts: qcom: sa8775p: add USB nodes")
Cc: Shazad Hussain <quic_shazhuss@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20231120164331.8116-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index be31ef35dfe8..d4ca92b98c7d 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -1602,8 +1602,8 @@ usb_0: usb@a6f8800 {
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 287 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 14 IRQ_TYPE_EDGE_RISING>,
-					      <&pdc 15 IRQ_TYPE_EDGE_RISING>,
+					      <&pdc 14 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 15 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 12 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "pwr_event",
 					  "dp_hs_phy_irq",
@@ -1689,8 +1689,8 @@ usb_1: usb@a8f8800 {
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 352 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 8 IRQ_TYPE_EDGE_RISING>,
-					      <&pdc 7 IRQ_TYPE_EDGE_RISING>,
+					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 7 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 13 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "pwr_event",
 					  "dp_hs_phy_irq",
@@ -1752,8 +1752,8 @@ usb_2: usb@a4f8800 {
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 444 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 10 IRQ_TYPE_EDGE_RISING>,
-					      <&pdc 9 IRQ_TYPE_EDGE_RISING>;
+					      <&pdc 10 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "pwr_event",
 					  "dp_hs_phy_irq",
 					  "dm_hs_phy_irq";
-- 
2.43.0



