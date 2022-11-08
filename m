Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7715CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44420C433C1;
	Tue,  8 Nov 2022 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915727;
	bh=mfi0wsHe8iBtwirFDQ2mdHyHj3RoxXdX1ibAjTGwr+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQhOGu+SEXlNG2vy41zfufCAu/EWS4ehS7+NcEMMU855G87Lyh+xfXx5Z87/BTHqG
	 9MwN158IOMzbgN4RIMaP9KOAflPDox55KBgu40gszjTYAdTqqni5HS9INexpC5552S
	 cbvDZBOLY5aLMdaT5xmkI8zqO0Xspz21sK4+/tRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	devicetree@vger.kernel.org,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/118] arm64: dts: juno: Add thermal critical trip points
Date: Tue,  8 Nov 2022 14:39:12 +0100
Message-Id: <20221108133343.957974083@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit c4a7b9b587ca1bb4678d48d8be7132492b23a81c ]

When thermnal zones are defined, trip points definitions are mandatory.
Define a couple of critical trip points for monitoring of existing
PMIC and SOC thermal zones.

This was lost between txt to yaml conversion and was re-enforced recently
via the commit 8c596324232d ("dt-bindings: thermal: Fix missing required property")

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Fixes: f7b636a8d83c ("arm64: dts: juno: add thermal zones for scpi sensors")
Link: https://lore.kernel.org/r/20221028140833.280091-8-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/arm/juno-base.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index 2c0161125ece..cb45a2f0537a 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -595,12 +595,26 @@ pmic {
 			polling-delay = <1000>;
 			polling-delay-passive = <100>;
 			thermal-sensors = <&scpi_sensors0 0>;
+			trips {
+				pmic_crit0: trip0 {
+					temperature = <90000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 
 		soc {
 			polling-delay = <1000>;
 			polling-delay-passive = <100>;
 			thermal-sensors = <&scpi_sensors0 3>;
+			trips {
+				soc_crit0: trip0 {
+					temperature = <80000>;
+					hysteresis = <2000>;
+					type = "critical";
+				};
+			};
 		};
 
 		big_cluster_thermal_zone: big-cluster {
-- 
2.35.1



