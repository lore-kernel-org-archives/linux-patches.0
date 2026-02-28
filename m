Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A15375AAD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301725; cv=none; b=B2pcBs188iQC/rK+63NoXAi7fscc6SGHnOkM9wwNJJJzTdxXJNPwICv6Wa3Cg6RwaNhGJHhZJEivhszP7NoY2j5mS+ryA6F7cMc/yk3nU6y1MAcShUiNBZJD87yNO87C59sQM+wZKbu8IsDyVA1L+uc22Uu7IfPi9lJKcwAm6xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301725; c=relaxed/simple;
	bh=pe4j21kb9nu6R0FBlr/Uf5be2DQou3ycPzDMeDw1Uqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqlnLr196vhIATMWkFfKUGRW32l3QvmvasUDD464jNYfy+9K2qzQm0WA7exuR4p3laoICPt0WgpJ0bSOsBC+soDnD/Yxh5iSnfAa5Pn/eckgDkm6nTzO4MzeZn/rrGMv/iCcOFXNP56Fo8qUIIYV2HWx96L/BpaJn4oBbSCxw9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s8RRTMpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s8RRTMpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94448C19423;
	Sat, 28 Feb 2026 18:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301725;
	bh=pe4j21kb9nu6R0FBlr/Uf5be2DQou3ycPzDMeDw1Uqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8RRTMpaQS69Hh+8r1B9yyV5E9Matj3juOr+zj3HTuwvzzqvV7XkAIBYQF0d7sEPb
	 icPMNMUphwJWSRA6gN2d+FoPXzTiPJ9qPji0PBLgLTZWq++GIGyJmSBRMHTP1bnSHs
	 NQLIjnUCrDr16ehllweTS7cpwfkZ27/IK088QwWk+RwkileI2yKzyEXZRhixV1d5Dt
	 Paqc3+znFLsCeDwbWyReYlurHgt2QyP6pO/6qEg/EeAv8r7RXa9IbaWL7ifJRDqAwa
	 AJ2Wr6zMbbLjPV0GokMEwJ+2LpN3WQtSVZ/sE4m/nv22U3BhNgR54UQmpZIV9lmWd5
	 D91TCP5ZiUHDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/385] arm64: dts: qcom: sdm845-db845c: drop CS from SPIO0
Date: Sat, 28 Feb 2026 12:55:45 -0500
Message-ID: <20260228180011.1568201-123-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 8bfb696ccdc5bcfad7a45b84c2c8a36757070e19 ]

On SDM845 SPI uses hardware-provided chip select, while specifying
cs-gpio makes the driver request GPIO pin, which on DB845c conflicts
with the normal host controllers pinctrl entry.

Drop the cs-gpios property to restore SPI functionality.

Fixes: cb29e7106d4e ("arm64: dts: qcom: db845c: Add support for MCP2517FD")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260106-wcn3990-pwrctl-v2-7-0386204328be@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 9a6d3d0c0ee43..276df1b078118 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -858,7 +858,6 @@ &spi0 {
 	status = "okay";
 	pinctrl-names = "default";
 	pinctrl-0 = <&qup_spi0_default>;
-	cs-gpios = <&tlmm 3 GPIO_ACTIVE_LOW>;
 
 	can@0 {
 		compatible = "microchip,mcp2517fd";
-- 
2.51.0

