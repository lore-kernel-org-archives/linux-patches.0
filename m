Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498B714D424;
	Tue, 23 Jan 2024 00:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969284; cv=none; b=JunMPuBMaqCptQQ6u6WaxgYGhJhHVQE00kWkQ86AODECVystvjuRyZSCUNOkq/tj1z/gBZNgeCGQzeHyT2NEDhOLN4V0k3SwdLH+p+0OAu3zhJDStZP9uzuSuhQ8kZcaJmaZXG8zONG1lyi26QmfWoSVeJLqCA0zKd21/BLlZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969284; c=relaxed/simple;
	bh=fSeCrX8AA6WWcOeJGPkEzCUd9l2aQ2gNCPELNI1pINE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaKzy/pVP7Sqg7pTGYDgDHLU1Qq8dQaoTW+3EZ22xMoCHjTLJcdCvH75LRLe/TwXGUS6yQnMOuGjSGxk/YiweY+BQa/nJQhjzbjrPnoCtoVdwXQCNqQ0ytXkgJrOgAZPSuuJl913opitUmwI4bJLL8BG5w9S9kMqV9/ojLFxrZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUdIOlYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUdIOlYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9E9C43394;
	Tue, 23 Jan 2024 00:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969284;
	bh=fSeCrX8AA6WWcOeJGPkEzCUd9l2aQ2gNCPELNI1pINE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUdIOlYeOGIX09YBbHS5c0iJ4MX7T0MrMI9KYXJcRun4l7afwYQ0L/ZFc6yl5CnL2
	 2DJtPLmMfs06kU6koBhElkvAM5uOhEpzkBcpSamX1WuqbVstkBbT1izNMfdC7+u3dj
	 ZxEHh1wx9K50r2266UQbbc7AlwnJWFvMVS9uMmf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 145/641] arm64: dts: qcom: sm8550: fix USB wakeup interrupt types
Date: Mon, 22 Jan 2024 15:50:49 -0800
Message-ID: <20240122235822.583881229@linuxfoundation.org>
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

[ Upstream commit 29d91ecf530a4ef0b7f94cb8cde07ed69731e45d ]

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Note that only triggering on rising edges can be used to detect resume
events but not disconnect events.

Fixes: 7f7e5c1b037f ("arm64: dts: qcom: sm8550: Add USB PHYs and controller nodes")
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20231120164331.8116-12-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 09353b27bcad..6c2b4da8e90a 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2923,8 +2923,8 @@ usb_1: usb@a6f8800 {
 
 			interrupts-extended = <&intc GIC_SPI 130 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 17 IRQ_TYPE_LEVEL_HIGH>,
-					      <&pdc 15 IRQ_TYPE_EDGE_RISING>,
-					      <&pdc 14 IRQ_TYPE_EDGE_RISING>;
+					      <&pdc 15 IRQ_TYPE_EDGE_BOTH>,
+					      <&pdc 14 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq",
 					  "ss_phy_irq",
 					  "dm_hs_phy_irq",
-- 
2.43.0



