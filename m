Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863F24499B8;
	Thu, 30 Jul 2026 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425073; cv=none; b=SVWizOAqeGyDhug4uOKIFRjB4HxogqLEB0D5dVEoHGYSpQnikCfD6FuXhbHfxKelhLHSoZc1HGxPtqf6T5xrQ06g+ZLPxYdU5KbzrQz7XtBPcI6GOyilZDSsVeXxUePJhwOwciIL2E1uH7pUkSu43sylX7Puj7Gnh87oKELVDX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425073; c=relaxed/simple;
	bh=hqRER3MzHNcXrbPRD5h328HudDkPX6cLJNkpS0rT1cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWnlf8jUiHYZWdH7NhdmM9Y7kxk9eeOb0qmzR7xtg4vK9rcbLxxdP841F4KLgJiYmvyE+M6g75UNZ4u4L9u/3llkgTeV4Dga62JG5Jbsg8LLfbDEKVz/l/gYyBUVE65bubU7QZ5cyzSzEl5cROdhgUz4OaCuKTtICih5FftNKlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YryCduBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YryCduBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FFC1F000E9;
	Thu, 30 Jul 2026 15:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425072;
	bh=yXA3hvAfOa+8ZpxDFGWiG9JtX7KdfSlZ3hA0Ts56ZfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YryCduBJGAWXWPB47YrzV66atLD7L/YC2tonwXXWJ1DBOOptkYD+KXO2dWS9iyPoI
	 8W4YVJcofNHFgHPaN/88iPvY4KjS2EhxyoZnGQ+6IFNqYxK6DSaMRnmsXUOBdI5/gB
	 Ke1U8AWieKAlxmSo8eBoec8STMIcuHggNqf5PPkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 616/675] arm64: dts: qcom: correct RBR opp entry
Date: Thu, 30 Jul 2026 16:15:46 +0200
Message-ID: <20260730141458.209004069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit a5c21b9bd5f531e50141b0484faabb707b92f1e2 ]

DisplayPort Reduced Bit Rate uses link rate of 1.62 Gbps, the main link
clock should be 162 MHz. Having the incorrect frequency (160 MHz) in the
OPP table will result in selecting wrong link frequency. Correct the
entry in the OPP table.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260304-msm-fix-rbr-v1-1-b9eba986eaef@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: c17e22094667 ("arm64: dts: qcom: hamoa: Fix OPP tables for all DisplayPort controllers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi   |    8 ++++----
 arch/arm64/boot/dts/qcom/sc7180.dtsi   |    4 ++--
 arch/arm64/boot/dts/qcom/sc7280.dtsi   |    8 ++++----
 arch/arm64/boot/dts/qcom/sc8180x.dtsi  |   12 ++++++------
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |   32 ++++++++++++++++----------------
 arch/arm64/boot/dts/qcom/sm6350.dtsi   |    4 ++--
 arch/arm64/boot/dts/qcom/sm8150.dtsi   |    4 ++--
 arch/arm64/boot/dts/qcom/sm8250.dtsi   |    4 ++--
 arch/arm64/boot/dts/qcom/sm8350.dtsi   |    4 ++--
 arch/arm64/boot/dts/qcom/sm8450.dtsi   |    4 ++--
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |   16 ++++++++--------
 11 files changed, 50 insertions(+), 50 deletions(-)

--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -5146,8 +5146,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5234,8 +5234,8 @@
 				dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3452,8 +3452,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -5196,8 +5196,8 @@
 				edp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5295,8 +5295,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -3303,8 +3303,8 @@
 				dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -3385,8 +3385,8 @@
 				dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -3461,8 +3461,8 @@
 				edp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -4754,8 +4754,8 @@
 				mdss0_dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4836,8 +4836,8 @@
 				mdss0_dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4916,8 +4916,8 @@
 				mdss0_dp2_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4991,8 +4991,8 @@
 				mdss0_dp3_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -6110,8 +6110,8 @@
 				mdss1_dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -6190,8 +6190,8 @@
 				mdss1_dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -6270,8 +6270,8 @@
 				mdss1_dp2_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -6345,8 +6345,8 @@
 				mdss1_dp3_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -2306,8 +2306,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3939,8 +3939,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -4824,8 +4824,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2925,8 +2925,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3483,8 +3483,8 @@
 				dp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -5522,8 +5522,8 @@
 				mdss_dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5610,8 +5610,8 @@
 				mdss_dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5697,8 +5697,8 @@
 				mdss_dp2_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5779,8 +5779,8 @@
 				mdss_dp3_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 


