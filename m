Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A6315CD74;
	Wed,  5 Feb 2025 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766955; cv=none; b=bSLZCnUhcJWsfUIXuHvxGorZQ0gZ52RLpouzdptBh4KNLKh+cwfAfdcFY0XYajAT9TkZU895EI+wkwSOQwkYm+2DAVnwqWRf8HbkQf5qAdB8gE7MU0k9JG9DbfTXO3LfN+mWjeSrYc6FjBAjb1/rwYDQlVhSOSa3IXmMSXJUNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766955; c=relaxed/simple;
	bh=1arRzAYzMfOL29LO9Ex1gOE0XDyKIzX405PDb16GlwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTy3ti3xBNIrOutP+2e/WFqlbs3QSpHPeK93vUm7KlwvihRe0DKagkWxSfSlMuLzHhvVoKIvDIaKpuHxSqhbeh6O96oqCrxzpRmC/XAYaHLjD6TFw4JDjpjKuZRlSebMc1hEngKhxHD1ZLpncWqsHTt+XFAR4+96vO6YLKRwcps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPlq382V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPlq382V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E183AC4CEDD;
	Wed,  5 Feb 2025 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766955;
	bh=1arRzAYzMfOL29LO9Ex1gOE0XDyKIzX405PDb16GlwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPlq382Vv6iQtb75IT1n9mw/lj6EeFHUKmJszvAHl3q6aTORnMyQeFTUyazaEdtcN
	 UC0SKNbGHzWXLp1DusT1oFjNT6tLjH2ejbrF8Tq5kvnNceHa1vJsS05uSkNC/2I+ou
	 B4wUrAeUGeAWDg/JPYdr4iteUifFFutceFq1RwZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/590] arm64: dts: qcom: sdm845: Fix interrupt types of camss interrupts
Date: Wed,  5 Feb 2025 14:42:20 +0100
Message-ID: <20250205134509.998282157@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 54077549b9da7..0a0cef9dfcc41 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4326,16 +4326,16 @@
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



