Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A2E15958A;
	Mon, 29 Jan 2024 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548489; cv=none; b=VTlMP46ECErzuqyodUWpUttYX64gtfkPDZP6yzmooYoowGe5Ytl0KqfOEbwbKvqitwVePqx27+QdxktY1vabzpp7ASB9pNbpTwySfjsBFxd/4fRcUoFhE6J7wuKcOdplAymuYJ+c9iJJfL38/3QF7LN2objI0szbjj20u7qKt4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548489; c=relaxed/simple;
	bh=Qrd27lQf1BzDkOI49EBgKoDzvbGERTsrEs76Q0D/UmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhxa8zEZA9DdisCklvzLNqf3QmhSqSqNqUi/si9OGhtnEcN5/BZFVj3gJBwbiu6xyPQyCDPjP+pLE1AzOIEPED5kycsLlNiMCICJkSthJGuAc5ydWm4eKnU3wpkNPTQkMDav5omri3aEIFY3x0J1HOzj8VlIlgpERXIMU+UL+TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHyRDMzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHyRDMzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2201C433F1;
	Mon, 29 Jan 2024 17:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548489;
	bh=Qrd27lQf1BzDkOI49EBgKoDzvbGERTsrEs76Q0D/UmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHyRDMzYS1BdziJYKm+WqXEXEM6xm9pyYt64KPmEPJPax7X8GLNoXzS4utIkN5FQK
	 bSAq2+bhmsYX7fSdBBdZyFW5ZWuDe1t5y/5YenNZj01EiEzYhRyZQElCIrTYTQr2Yh
	 5O/jnPbbdykluscmi1jRAcvkhFvcTL8fmS6jWvBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Jack Pham <quic_jackp@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 085/331] arm64: dts: qcom: sm8150: fix USB wakeup interrupt types
Date: Mon, 29 Jan 2024 09:02:29 -0800
Message-ID: <20240129170017.421837186@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

commit 54524b6987d1fffe64cbf3dded1b2fa6b903edf9 upstream.

The DP/DM wakeup interrupts are edge triggered and which edge to trigger
on depends on use-case and whether a Low speed or Full/High speed device
is connected.

Fixes: 0c9dde0d2015 ("arm64: dts: qcom: sm8150: Add secondary USB and PHY nodes")
Fixes: b33d2868e8d3 ("arm64: dts: qcom: sm8150: Add USB and PHY device nodes")
Cc: stable@vger.kernel.org      # 5.10
Cc: Jonathan Marek <jonathan@marek.ca>
Cc: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Link: https://lore.kernel.org/r/20231120164331.8116-11-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3594,8 +3594,8 @@
 
 			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 
@@ -3647,8 +3647,8 @@
 
 			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 490 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 491 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 490 IRQ_TYPE_EDGE_BOTH>,
+				     <GIC_SPI 491 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
 					  "dm_hs_phy_irq", "dp_hs_phy_irq";
 


