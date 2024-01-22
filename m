Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA9A14D446;
	Tue, 23 Jan 2024 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969357; cv=none; b=T02CvFn75QZ1hqYOrISQg3XWVpO3s8v+PBUA6ViyEP07st52pJDPSC2PhYsXNm6Wf1JPxIp+OFyYN+5ykR60OO5Zk0t2jbjBCWNIuim5boLvrwMlQn5JSZ/X5oPEhbld7mlqZqG6mhMVzCCJlFFetXGf03qwuX9zlXdVg/vL/s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969357; c=relaxed/simple;
	bh=AoWk6ZfQIk+rO0a5rTu2BYEV7FzM3VK1QHAC2vsX2uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0tqfy+1Uhu+bR4nU4w7G1BpA20BeETJYNQ+LjBn5mobFlNIv3BbChYapViWiE9C5X62gDjmxjUW9nq50LQ/InAaUNhJ7cfsXS9VoOa5dPtUNgZhiRU+EZRsvY02igPDHHdjtckWqVVWY2sqRQsc8bzbEgFFoyw/Dbr/nRj9tXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiUvU0Iu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiUvU0Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9898C433F1;
	Tue, 23 Jan 2024 00:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969357;
	bh=AoWk6ZfQIk+rO0a5rTu2BYEV7FzM3VK1QHAC2vsX2uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiUvU0IuKKAvBGusbSlfDN2b5IKMywNecWMJKhhSRo5eGG1Mi+uCLXb+M3oy5gvsa
	 vTdQi19jJaRcuSgeVBA7zL2zoLlns93VpgaiBl991VboSB7ZR0Knu+sh8wTyxpbSKE
	 2S7DsU5SwX3WI1SLjfRyq30gxbLFMg62DeM+0z2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 193/641] arm64: dts: qcom: sm6375: fix USB wakeup interrupt types
Date: Mon, 22 Jan 2024 15:51:37 -0800
Message-ID: <20240122235824.014481311@linuxfoundation.org>
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



