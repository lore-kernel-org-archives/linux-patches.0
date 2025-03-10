Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95A022D7A6;
	Mon, 10 Mar 2025 17:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628951; cv=none; b=jD43ADWfD/B3y4/XUhjzvjOyjohVRpDGSVIVWfM73ocyAD6/+xtbpog4ku9ajc2zJ3ep1H4n6dTcyLgHhp8CEq2FaGDiAm1e1yuYxQQonulWOg6jTxACDlTmVygR0Wy3wxldsdbeksfpYOaXJJkc9qx/gSAavW4heDBduI+ftOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628951; c=relaxed/simple;
	bh=zQh39Xq+VzAa+HHdbDn52Udy8dU0s4Hg4snzD6uH1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce5IXgiEYApBfMmjswRoLo15A6F27qT4oANqT22GyUcPNWBeYAgnIOz8y5qSQi/FxoWdzCIN2Zf3ImbTZFL2q+lvYdkh1lsxMBKSReSuISfBtUcMsigM0krr+dPMq3ore0Yv44ujBThrhKcIYKus3Sc0VDnER5d24+mtYoaITGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWA6pWJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWA6pWJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A85C4CEE5;
	Mon, 10 Mar 2025 17:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628950;
	bh=zQh39Xq+VzAa+HHdbDn52Udy8dU0s4Hg4snzD6uH1xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWA6pWJcTI/anHp/SGx1dZIJJShTF7T0cR2Lh9N/WrNuCQpSt+iv/OFMGtIr3mY+Y
	 gDuePi//Js7ZIUzq4mf54Ha0DqpwWlIVX1MPs5h4GPWZRLtyt4eC9G5ar+Oh83dfb8
	 OowuP1zKYSy/qiGjaU0Cr7nSTmSLrlq89kvYXHYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/620] arm64: dts: qcom: sdm845: Fix interrupt types of camss interrupts
Date: Mon, 10 Mar 2025 17:59:32 +0100
Message-ID: <20250310170550.572300311@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit cb96722b728e81ad97f5b5b20dea64cd294a5452 ]

Qualcomm IP catalog says that all CAMSS interrupts is edge rising,
fix it in the CAMSS device tree node for sdm845 SoC.

Fixes: d48a6698a6b7 ("arm64: dts: qcom: sdm845: Add CAMSS ISP node")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20241127122950.885982-6-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index cff5423e9c88d..69212445d22c9 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -3948,16 +3948,16 @@
 				"vfe1",
 				"vfe_lite";
 
-			interrupts = <GIC_SPI 464 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 466 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 468 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 477 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 478 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 479 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 448 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 465 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 467 IRQ_TYPE_LEVEL_HIGH>,
-				<GIC_SPI 469 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 464 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 466 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 468 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 477 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 478 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 479 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 448 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 465 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 467 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 469 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "csid0",
 				"csid1",
 				"csid2",
-- 
2.39.5



