Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2427260B99;
	Tue, 23 Jan 2024 01:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974740; cv=none; b=SlJtndfLTRAs+9yNIx6gYLZeoWFIfrVJQWMZn3HmVHRANSkhX6q5oOa+GRNxGD1OYEkzuLOQt8DZx7y9N9FX4s8kydVjzSsk1kiVbZ41IRjjdFExFjsuUZi69Q3HUvWV8KvYztj1GraGKMQ1wTyL2OmM4LzOUxLlghv7uSFOzyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974740; c=relaxed/simple;
	bh=ou3pOO4qFxBfxNdXuG1Wq5Y4IoRJ0EPTNe9SAeETZ/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq+45nca3C9VT25fWXHAP5vR8sZDCbmNMM6N2fi+QDxPoT4bRSsFB7lrp0Y0ABqavgWK3EIDQAQ7QwNzXN8zQJzt3IywiwmXQSE3fp7k37Ag1wstobr3lSYW5ZTKCktti635sak+N2MMT/mi1rHwWLAhB1gwXHQ+8wOebzcr2AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MorrnOXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MorrnOXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED55C43390;
	Tue, 23 Jan 2024 01:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974740;
	bh=ou3pOO4qFxBfxNdXuG1Wq5Y4IoRJ0EPTNe9SAeETZ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MorrnOXHHFRuhXyIfhhiI9a5hakNfEjnTwTienmW8LhmzmCp/FgNnpt9vCADQ9bvq
	 teX1/pwBKTkLq/XKXigF0dBfTpnbl3hNzbU2MpgRN8MDtvGKUxeVihzzoli3/t8c6k
	 NsgfJ+rwAKCxRLBFZVMSz02Bg74lOy7JJAkFcVi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/583] arm64: dts: qcom: sc7280: fix usb_2 wakeup interrupt types
Date: Mon, 22 Jan 2024 15:53:04 -0800
Message-ID: <20240122235816.193361260@linuxfoundation.org>
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
index 1fa1a615109a..e6798447b29a 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3411,8 +3411,8 @@ usb_2: usb@8cf8800 {
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



