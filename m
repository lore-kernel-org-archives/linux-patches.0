Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0874E1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685D3C433C1;
	Wed, 23 Nov 2022 09:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196708;
	bh=/Ue59DQoHvJQB/7bWavCBGlTSqIr5TIoKTJnlshEYVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvNPKf+T5gmOQ1foxelmWCCe4d/rMj8Bd6pRPrm48jI7Y1qt71IXsY/PHyF8BHGnD
	 S69rzvP/hj4sVEYj712LxH52qhx+eFUjcYbcIiMe6NbUk8NZVeGFT4cqawpdyZYzTU
	 ovkt9gQtv4S9IqevjyoWhXxlgDFTZrpXuRH13wKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 072/314] arm64: dts: qcom: sa8155p-adp: Specify which LDO modes are allowed
Date: Wed, 23 Nov 2022 09:48:37 +0100
Message-Id: <20221123084628.745041948@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit bd9f3dcf42d943b53190f99bcdbcfe98a56ac4cd ]

This board uses RPMH, specifies "regulator-allow-set-load" for LDOs,
but doesn't specify any modes with "regulator-allowed-modes".

Prior to commit efb0cb50c427 ("regulator: qcom-rpmh: Implement
get_optimum_mode(), not set_load()") the above meant that we were able
to set either LPM or HPM mode. After that commit (and fixes [1]) we'll
be stuck at the initial mode. Discussion of this has resulted in the
decision that the old dts files were wrong and should be fixed to
fully restore old functionality.

Let's re-enable the old functionality by fixing the dts.

NOTE: while here, let's also remove the nonsensical
"regulator-allow-set-load" on the fixed regulator "vreg_s4a_1p8".

[1] https://lore.kernel.org/r/20220824142229.RFT.v2.2.I6f77860e5cd98bf5c67208fa9edda4a08847c304@changeid

Fixes: 5b85e8f2225c ("arm64: dts: qcom: sa8155p-adp: Add base dts file")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220829094903.v2.1.Id59c32b560c4662d8b3697de2bd494d08d654806@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
index ba547ca9fc6b..ddb9cb182152 100644
--- a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
@@ -43,7 +43,6 @@ vreg_s4a_1p8: smps4 {
 
 		regulator-always-on;
 		regulator-boot-on;
-		regulator-allow-set-load;
 
 		vin-supply = <&vreg_3p3>;
 	};
@@ -137,6 +136,9 @@ vreg_l5a_0p88: ldo5 {
 			regulator-max-microvolt = <880000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7a_1p8: ldo7 {
@@ -152,6 +154,9 @@ vreg_l10a_2p96: ldo10 {
 			regulator-max-microvolt = <2960000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l11a_0p8: ldo11 {
@@ -258,6 +263,9 @@ vreg_l5c_1p2: ldo5 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l7c_1p8: ldo7 {
@@ -273,6 +281,9 @@ vreg_l8c_1p2: ldo8 {
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 			regulator-allow-set-load;
+			regulator-allowed-modes =
+			    <RPMH_REGULATOR_MODE_LPM
+			     RPMH_REGULATOR_MODE_HPM>;
 		};
 
 		vreg_l10c_3p3: ldo10 {
-- 
2.35.1



