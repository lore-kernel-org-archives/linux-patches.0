Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F23BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:02:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F29C433D2;
	Tue,  7 Mar 2023 18:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212163;
	bh=8V1+x6ybit2KX4REv7T+hER5xAc/AUbnp2PO5sA8t60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmKXdPW25iP8g1g4aNW3ttMRKSlkSu1dpHbBjqTTtxjorrMc1/Qr+NQ0nQ8sb6HJ7
	 nOfpzdNfyuqp4c+ABhTY/YxVKKmAxJZxdxlXhYZ4xhL3uNyw4iHBCW/nL3DsRk1GZN
	 jauQMb3cUyOQtERE+M7DurlVYh4Nd8lkB5gvp9jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Vorel <pvorel@suse.cz>,
	Jamie Douglass <jamiemdouglass@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/885] arm64: dts: qcom: msm8992-lg-bullhead: Enable regulators
Date: Tue,  7 Mar 2023 17:50:31 +0100
Message-Id: <20230307170006.059443994@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Petr Vorel <pvorel@suse.cz>

[ Upstream commit 2866527093ddbc6356bb31f560f0b4b4decf3e2e ]

Enable pm8994_s1, pm8994_l{26,29,30,32} regulators.
Use values from downstream kernel on bullhead rev 1.01.

NOTE: downstream kernel on angler rev 1.01 differences:
* pm8994_l29: regulator-min-microvolt = <2700000>
* pm8994_l{20,28,31}: use regulator-boot-on

Verification:
[    1.832460] s1: Bringing 0uV into 1025000-1025000uV
...
[    2.057667] l26: Bringing 0uV into 987500-987500uV
...
[    2.075722] l29: Bringing 0uV into 2800000-2800000uV
[    2.076604] l30: Bringing 0uV into 1800000-1800000uV
[    2.082431] l31: Bringing 0uV into 1262500-1262500uV
[    2.095767] l32: Bringing 0uV into 1800000-1800000uV

Fixes: f3b2c99e73be ("arm64: dts: Enable onboard SDHCI on msm8992")
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Jamie Douglass <jamiemdouglass@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230203100952.13857-1-pvorel@suse.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/msm8992-lg-bullhead.dtsi    | 32 ++++++-------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index db05dc3ba16df..465b2828acbd4 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -94,8 +94,8 @@ pm8994_regulators: pm8994-regulators {
 		/* S1, S2, S6 and S12 are managed by RPMPD */
 
 		pm8994_s1: s1 {
-			regulator-min-microvolt = <800000>;
-			regulator-max-microvolt = <800000>;
+			regulator-min-microvolt = <1025000>;
+			regulator-max-microvolt = <1025000>;
 		};
 
 		pm8994_s2: s2 {
@@ -251,11 +251,8 @@ pm8994_l25: l25 {
 		};
 
 		pm8994_l26: l26 {
-			/*
-			 * TODO: value from downstream
-			 * regulator-min-microvolt = <987500>;
-			 * fails to apply
-			 */
+			regulator-min-microvolt = <987500>;
+			regulator-max-microvolt = <987500>;
 		};
 
 		pm8994_l27: l27 {
@@ -269,19 +266,13 @@ pm8994_l28: l28 {
 		};
 
 		pm8994_l29: l29 {
-			/*
-			 * TODO: Unsupported voltage range.
-			 * regulator-min-microvolt = <2800000>;
-			 * regulator-max-microvolt = <2800000>;
-			 */
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <2800000>;
 		};
 
 		pm8994_l30: l30 {
-			/*
-			 * TODO: get this verified
-			 * regulator-min-microvolt = <1800000>;
-			 * regulator-max-microvolt = <1800000>;
-			 */
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
 
 		pm8994_l31: l31 {
@@ -290,11 +281,8 @@ pm8994_l31: l31 {
 		};
 
 		pm8994_l32: l32 {
-			/*
-			 * TODO: get this verified
-			 * regulator-min-microvolt = <1800000>;
-			 * regulator-max-microvolt = <1800000>;
-			 */
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
 		};
 	};
 
-- 
2.39.2



