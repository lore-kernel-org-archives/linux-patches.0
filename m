Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBC18BE8;
	Tue, 30 Jul 2024 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355621; cv=none; b=Bd+h6sZzOzO6ERo7PLGfY2Kvvojami4zzYr1prjP5ZNc/3OM4l0l+ZoO0bbvbE7Qh3eekrxryB/DdZdS56G5uG3ygkzVJ1f0+rVYGIU+TzKENlcwSSjjckBzAQLptz0EvTe5WFGNwaAfLt8bNlpNFiuw+LWphFKqg4Tid7vezXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355621; c=relaxed/simple;
	bh=c6vOTZKWcEI3+Yrp4tQ85/VbUTqMXyjIcGqqXYIHz0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIlDjTsjppaq44Hlh+TpVp42E2kgFHEL5bcArIh4q55uv6abZNAp+gqIm700x2qZ+Px5hGbbvgzbCcSZ91J3Uhbk6WPo9cD4UbFPfHqSM7epsB/d4bvbWFrMLbRRZ3qtm2Z/G50yZ2fZXD0B+fp9ZbtY9SUjHMxR3pMy2nx8+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3Y/AhfA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3Y/AhfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA6AC32782;
	Tue, 30 Jul 2024 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355621;
	bh=c6vOTZKWcEI3+Yrp4tQ85/VbUTqMXyjIcGqqXYIHz0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3Y/AhfAmxQBARvFHKlKHE/gjr97fPJ5UT+dc/095EGNBiLCxxKF1oSK8O50VsqLu
	 i3769+6e0SJMNDEw5itcnVSu+dB2M5vDvrmPcWbkujFjb/67hTvBodSM/hQvw5ujf9
	 CIHfeytWmM4bBAirWmMmFYEJOWfADgxQTTZG4K+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 072/809] arm64: dts: qcom: sc8280xp: Throttle the GPU when overheating
Date: Tue, 30 Jul 2024 17:39:08 +0200
Message-ID: <20240730151727.485185899@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit f7fd6d04c1046107a87a0fc883ed044cf8b877a1 ]

Add an 85C passive trip point with 1C of hysteresis to ensure the
thermal framework takes sufficient action to prevent reaching junction
temperature. Also, add passive polling to ensure more than one
temperature change event is recorded.

Fixes: 014bbc990e27 ("arm64: dts: qcom: sc8280xp: Introduce additional tsens instances")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240510-topic-gpus_are_cool_now-v1-2-ababc269a438@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index de554d5d02010..b0b0ab7794466 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -5958,10 +5958,25 @@ cpu-crit {
 		};
 
 		gpu-thermal {
+			polling-delay-passive = <250>;
+
 			thermal-sensors = <&tsens2 2>;
 
+			cooling-maps {
+				map0 {
+					trip = <&gpu_alert0>;
+					cooling-device = <&gpu THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+				};
+			};
+
 			trips {
-				gpu-crit {
+				gpu_alert0: trip-point0 {
+					temperature = <85000>;
+					hysteresis = <1000>;
+					type = "passive";
+				};
+
+				trip-point1 {
 					temperature = <110000>;
 					hysteresis = <1000>;
 					type = "critical";
-- 
2.43.0



