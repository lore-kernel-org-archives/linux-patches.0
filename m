Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0707522060;
	Tue, 23 Jan 2024 01:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974973; cv=none; b=Ui1GRfOYyXKxHB2AcJGui3ZyLycJzX4ChwzTVsXZhCp5VA60lPJ6Pjsi+tnwE3iCpQLkY2JE5mhDOu6GJYOVqy1uauh+VetClDzivfSIG4sUmnbt3PXz2XRt5xN+gXkz1cd57yYSVxU4zF8GHjzv1HZSsIcjq65Idp26frd022Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974973; c=relaxed/simple;
	bh=IHOWvM5SewBVf5gLUqxhUfyS5g8nqn/GtdCSMTiRT4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAeGubS0aOyqkq0zIT1zLFD67MuXUBqvGQERnX2Nzg2zSvlEvWKp/P5fqEmA1t8bLnf50OSxZS2LEF3Mz9SCWk7TjRlFNGlaHks5v5PtR07xtwEjdt+DN12CqiK8QC3JBNPws7ZgXdlKqSGrpWqBPZWnowXKjp3a7eqFbvPPx7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5ElJB2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5ElJB2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AE5C43390;
	Tue, 23 Jan 2024 01:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974972;
	bh=IHOWvM5SewBVf5gLUqxhUfyS5g8nqn/GtdCSMTiRT4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5ElJB2nzPzXrYFtO+YGnQRoUUhQ8E5HRmoKg3WKxfeo6cO5dyBDn++tiafHHLcu+
	 whipcTnDYsRv9rj8LcoP+sPfIlzKJLQ1xircZMyXuf1KIuqpk4jD3/46OMOkKmzHmZ
	 yRtwv0nWYPwuB+KJuniYuuI+2MpaIsecNrCOQ1jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/583] arm64: dts: qcom: sm6375: fix USB wakeup interrupt types
Date: Mon, 22 Jan 2024 15:53:46 -0800
Message-ID: <20240122235817.379658937@linuxfoundation.org>
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

[ Upstream commit 41952be6661b20f56c2c5b06c431880dd975b747 ]

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 59d34ca97f91 ("arm64: dts: qcom: Add initial device tree for SM6375")
Cc: stable@vger.kernel.org      # 6.2
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-10-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: d3246a0cf43f ("arm64: dts: qcom: sm6375: Hook up MPM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6375.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6375.dtsi b/arch/arm64/boot/dts/qcom/sm6375.dtsi
index e7ff55443da7..b479f3d9a3a8 100644
--- a/arch/arm64/boot/dts/qcom/sm6375.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6375.dtsi
@@ -1362,8 +1362,8 @@ usb_1: usb@4ef8800 {
 
 			interrupts = <GIC_SPI 302 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 93 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 94 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq",
 					  "ss_phy_irq",
 					  "dm_hs_phy_irq",
-- 
2.43.0



