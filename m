Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D176A39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302546; cv=none; b=i9J8Ooo4Jhz+R7Aap7pfK7Lspua/QPS3/zQyS1ZVI+dMa0uk3ulEmiMdYkhmLAtfm+ourDo61080Cg7QkdUWaw8ZFkDp8MX17/q+w0HGBHZDDqeLpYKQJBj+U7z4nJtMFHZ+X4HZ8W+ynNrxDIqGUqJ7ZH/e1nYqUEgOgawptEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302546; c=relaxed/simple;
	bh=roT4JKI/di2177Ln6aOO6fDKv/erMBtjPrVz217bKW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7PiERvg5NEzuHn9AR5wxYVitoemHwv0pXTTbI9G2kR8peISMyE+/erljTi6CZvi+fZJDLJk7yOQMXsF5PHsIIUtGyx7U4cQWlZSX29GpQfR00Ev7gx8Bc9ulzif1uGtSJasVOg04U8ETPouKBtv6OeQ02lsJaMOztne8guYBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V0xyDYyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V0xyDYyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA94C19423;
	Sat, 28 Feb 2026 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302546;
	bh=roT4JKI/di2177Ln6aOO6fDKv/erMBtjPrVz217bKW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0xyDYyd7LENBKUrc5amMbAg5U/qp+eihGbdP5VXKnG6DGmVd7e/rbpwn3mJAGX7s
	 xbIJRzCf+2rRPDunUNcblgJUGtI0eSr9EG/PkNRt9/JLS0AF/dHe6zxvd8kGYVO755
	 iiu+Hpy4C5C5bD0PSCTXpIrqlXpf2fvPd/VtOPjcU46MWNv7/51ozTR6Y0j78Jpbi2
	 oBoVSp8NfPxAVdSi2JHpN9wM3g6h+r2FogKGmneVmGn+DtMFR4yOvavyV7/DtCHBkr
	 fzY+BgKMscq8258IfEhGgm6WKl79m8a8p8hPM8wzoRyF6pz/9nxWKVIRyALVE8GzMD
	 2mkLYX4QSz2Fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/164] arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
Date: Sat, 28 Feb 2026 13:13:08 -0500
Message-ID: <20260228181505.1600663-49-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

[ Upstream commit c303e89f7f17c29981d09f8beaaf60937ae8b1f2 ]

Specify power supply for the second chain / antenna output of the
onboard WiFi chip.

Fixes: 3f72e2d3e682 ("arm64: dts: qcom: Add Dragonboard 845c")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260106-wcn3990-pwrctl-v2-8-0386204328be@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 62877311e5c24..cf2df9e2ccf30 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -342,6 +342,12 @@ vreg_l21a_2p95: ldo21 {
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 
+		vreg_l23a_3p3: ldo23 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3312000>;
+			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+		};
+
 		vreg_l24a_3p075: ldo24 {
 			regulator-min-microvolt = <3088000>;
 			regulator-max-microvolt = <3088000>;
@@ -1039,6 +1045,7 @@ &wifi {
 	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+	vdd-3.3-ch1-supply = <&vreg_l23a_3p3>;
 
 	qcom,snoc-host-cap-8bit-quirk;
 };
-- 
2.51.0

