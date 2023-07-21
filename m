Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40553200A7
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33F3C433C8;
	Fri, 21 Jul 2023 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965933;
	bh=Lmbqmx8pf/YjklMoJdpY4eIxAQxxcNHqHlveIVu6BRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zm8G2KqVRtteMyiLIfSI95SJARjYV1TCEh0p2BMyKCwFbjzC+u3tPqS4pTocX+aUD
	 0Ho3hp30bqm+R+M5vzgrvdN7NYhKKHieeV5UvQ2yd5v/OWFhCtOObGBLuQruxaq4IM
	 MBhEyAqfZc14/aK9f2/m4AfKZpW6r91FMxObC8uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/532] arm64: dts: qcom: apq8016-sbc: Fix regulator constraints
Date: Fri, 21 Jul 2023 18:00:41 +0200
Message-ID: <20230721160621.891892759@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit e27654df20d77ad7549a3cf6739ebaa3aa59a088 ]

For some reason DB410c has completely bogus regulator constraints that
actually just correspond to the programmable voltages which are already
provided by the regulator driver. Some of them are not just outside the
recommended operating conditions of the APQ8016E SoC but even exceed
the absolute maximum ratings, potentially risking permanent device
damage.

In practice it's not quite as dangerous thanks to the RPM firmware:
It turns out that it has its own voltage constraints and silently
clamps all regulator requests. For example, requesting 3.3V for L5
(allowed by the current regulator constraints!) still results in 1.8V
being programmed in the actual regulator hardware.

Experimentation with various voltages shows that the internal RPM
voltage constraints roughly correspond to the safe "specified range"
in the PM8916 Device Specification (rather than the "programmable
range" used inside apq8016-sbc.dtsi right now).

Combine those together with some fixed voltages used in the old
msm-3.10 device tree from Qualcomm to give DB410c some actually valid
voltage constraints.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 4c7d53d16d77 ("arm64: dts: apq8016-sbc: add regulators support")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230510-msm8916-regulators-v1-1-54d4960a05fc@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dts | 64 ++++++++++++------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
index a5320d6d30e7b..528138af24f09 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dts
@@ -440,21 +440,21 @@ &smd_rpm_regulators {
 	vdd_l7-supply = <&pm8916_s4>;
 
 	s3 {
-		regulator-min-microvolt = <375000>;
-		regulator-max-microvolt = <1562000>;
+		regulator-min-microvolt = <1250000>;
+		regulator-max-microvolt = <1350000>;
 	};
 
 	s4 {
-		regulator-min-microvolt = <1800000>;
-		regulator-max-microvolt = <1800000>;
+		regulator-min-microvolt = <1850000>;
+		regulator-max-microvolt = <2150000>;
 
 		regulator-always-on;
 		regulator-boot-on;
 	};
 
 	l1 {
-		regulator-min-microvolt = <375000>;
-		regulator-max-microvolt = <1525000>;
+		regulator-min-microvolt = <1225000>;
+		regulator-max-microvolt = <1225000>;
 	};
 
 	l2 {
@@ -463,13 +463,13 @@ l2 {
 	};
 
 	l4 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <2050000>;
+		regulator-max-microvolt = <2050000>;
 	};
 
 	l5 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
 	};
 
 	l6 {
@@ -478,45 +478,45 @@ l6 {
 	};
 
 	l7 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
 	};
 
 	l8 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <2900000>;
+		regulator-max-microvolt = <2900000>;
 	};
 
 	l9 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
 	};
 
 	l10 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
 	};
 
 	l11 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <2950000>;
+		regulator-max-microvolt = <2950000>;
 		regulator-allow-set-load;
 		regulator-system-load = <200000>;
 	};
 
 	l12 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <2950000>;
 	};
 
 	l13 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <3075000>;
+		regulator-max-microvolt = <3075000>;
 	};
 
 	l14 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <3300000>;
 	};
 
 	/**
@@ -524,14 +524,14 @@ l14 {
 	 * for mezzanine boards
 	 */
 	l15 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
 		regulator-always-on;
 	};
 
 	l16 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <3300000>;
 	};
 
 	l17 {
@@ -540,8 +540,8 @@ l17 {
 	};
 
 	l18 {
-		regulator-min-microvolt = <1750000>;
-		regulator-max-microvolt = <3337000>;
+		regulator-min-microvolt = <2700000>;
+		regulator-max-microvolt = <2700000>;
 	};
 };
 
-- 
2.39.2



