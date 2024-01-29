Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4C2159560;
	Mon, 29 Jan 2024 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548071; cv=none; b=cfURnXx1O9cA+dIdhBmztz8EWXExK8h2AUwbFkesldIixxpsbphcPL+oa8be7ZX24k34hj8yON3UJJCXNPMTearqE873S1b+0neVwbAKasQxE9V+8ivZQXR1pHHmosX/0AQgvnDtQU4Dvrovp1x5wGxsAo0H5trnaVhiVUpsbXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548071; c=relaxed/simple;
	bh=/0gNNni+X2VA1cndng8HNRslr5L81TYn/XjGp1sSgZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBSyV50pjfKNHq/BZvK9uol8hTqssPSLot76J/QLlfaTRp1zjydN0LA3931/QLBleFsIOqHMTqWXZACBxXpIlMApEU5vK5NpwZrMQ7Y2lBUbdQKfhkPZyhUXefNcqZ/K/IiDcflZBIksMLg0DJra6690DnvqflPjhG0z1bdEWuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzLZ+3tA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzLZ+3tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C20C433C7;
	Mon, 29 Jan 2024 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548071;
	bh=/0gNNni+X2VA1cndng8HNRslr5L81TYn/XjGp1sSgZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzLZ+3tA3wIKrDVfIezeTtiJxnVn4ZDXaZxpSGKb8lBikbbK0DQrJU1pa7yGAi8ro
	 fmANAED0NqQ3J+fMabdyZto5H7vJcun3rNIsoYOMPvNMWOSuzcxGsh0h0S2C4lJ6Jf
	 V6aXOniSuNPB0eTh2dlY94WfHhC3AAhvT1rAZ2rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 079/346] arm64: dts: qcom: sc8180x: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:01:50 -0800
Message-ID: <20240129170018.710115944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

commit 0dc0f6da3d43da8d2297105663e51ecb01b6f790 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: b080f53a8f44 ("arm64: dts: qcom: sc8180x: Add remoteprocs, wifi and usb nodes")
Cc: stable@vger.kernel.org      # 6.5
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231120164331.8116-7-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -2554,8 +2554,8 @@
 			reg = <0 0x0a6f8800 0 0x400>;
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq",
 					  "ss_phy_irq",
 					  "dm_hs_phy_irq",
@@ -2628,8 +2628,8 @@
 			power-domains = <&gcc USB30_SEC_GDSC>;
 			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 491 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


