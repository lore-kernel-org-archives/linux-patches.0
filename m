Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB1A78B5E;
	Wed, 21 Feb 2024 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525045; cv=none; b=nA3mZ5sgvx2OASIgCBGILXtU6AWp+C8Dw5b9Z9jiu3eM6S9FknFTrzf8ghmeELxsdYgScwp7Cn0nWyrwotXPtUw+AqPHd0+Zvopqwpp/plF4iUy4Jf8wXxd3iGtLsrpsM9BD/UuPFsGHzMbDZOFhqMFeN+3O8NzfhyLj6vTxMBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525045; c=relaxed/simple;
	bh=yOuJBEYrJzjpuwyx0YoGJMDghAKmeIiseOFIo/9KBfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/sykitEAX08Nfb9Om9WsRsK4A7Y6ZuH8opgC2hR1W+8tsaOSToBzhIJ5K8vqAg3ew7yT7Wia7gnW4RaHrJpuAqMFmZkSwa+tpTpbCJA4qmMTvRAPVtd8JkFjjJ0c+7jH9U6FOD/HZqny8trYCTMIdsubYO2eYgZ1NY91kwANEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STBmelHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STBmelHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572ABC433F1;
	Wed, 21 Feb 2024 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525043;
	bh=yOuJBEYrJzjpuwyx0YoGJMDghAKmeIiseOFIo/9KBfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STBmelHwM5M/BbcQTpydAB0jaXCPsg/F+LQbwbNRHti+yzaaBGye2+N1gjAZAdSSH
	 iROb1XiSkj8XORFKw++NSwUk2vJQearT5oVySQ5l3odeaPIzcSjYmgzejxRqQxVGII
	 EWgKXKIvmDU8tGq1XRZthb2a1QWIFAwvInlPACEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.4 015/267] arm64: dts: qcom: sdm845: fix USB wakeup interrupt types
Date: Wed, 21 Feb 2024 14:05:56 +0100
Message-ID: <20240221125940.531673812@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 84ad9ac8d9ca29033d589e79a991866b38e23b85 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
Cc: stable@vger.kernel.org      # 4.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-9-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2503,8 +2503,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
@@ -2547,8 +2547,8 @@
 
 			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 491 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


