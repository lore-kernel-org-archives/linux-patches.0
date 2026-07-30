Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA8E383983;
	Thu, 30 Jul 2026 15:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426657; cv=none; b=M4oxZ+StdfSVGhHxVDDemcOnXgXIQ2zeuOXH+KVUZk4SXKM0Nwdcn9T7Bcn9Dk2nIPyUxUlOvflpqThGmTNkAWUR/GdAl5Tp6DxZjZ7vxT9rUwA1mGNYz6oLk1TEyTY8MbSYER39WPZIc6j4B795E7WKWleGqYHfz7rsvNv2IdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426657; c=relaxed/simple;
	bh=1+IzlN5s2JRYnvkxoNPtr1TfgtWo0GErjTgOv5iMmHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmTNoanYWIGxCTwiWjvS6LZKdwcoPb+x/kj9tAcHI/6wLho2hBqK5XzurS1NE8V1dcah19kN1NuB+suR7gu4weLVs01cUzfEHWD6qFdJTzVySJvEfq/yUCUFSAk8UuQemXuY7tbO88+DiLIsuRBQzBeN0bYnyvQotskQGor1pog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXjM2GJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXjM2GJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A3A1F000E9;
	Thu, 30 Jul 2026 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426655;
	bh=w2X6kCEC34snFIxQEDfYNBmkdxzXVnmzc62qW6SEaQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXjM2GJDv/JD765Tgu+A/bGDw9x6BKissRJvgX9Ci6EUujrSrc6FY7WAxb0bkwuXC
	 ZfARIdSJs4I2tEA1PBIOAGB4rmMg3r5ezXusU8ulFdGOUpDLdF+yKabKMFVZKD6uwO
	 XmToh2e0dmrE1SsqlGhbRkuzIDAupm+4BTt+CXY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/602] arm64: dts: qcom: correct RBR opp entry
Date: Thu, 30 Jul 2026 16:14:48 +0200
Message-ID: <20260730141446.396944992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 10 files changed, 46 insertions(+), 46 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3410,8 +3410,8 @@
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
@@ -4723,8 +4723,8 @@
 				edp_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4820,8 +4820,8 @@
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
@@ -3269,8 +3269,8 @@
 				dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -3347,8 +3347,8 @@
 				dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -3415,8 +3415,8 @@
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
@@ -4259,8 +4259,8 @@
 				mdss0_dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4337,8 +4337,8 @@
 				mdss0_dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4409,8 +4409,8 @@
 				mdss0_dp2_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4481,8 +4481,8 @@
 				mdss0_dp3_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5547,8 +5547,8 @@
 				mdss1_dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5619,8 +5619,8 @@
 				mdss1_dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5691,8 +5691,8 @@
 				mdss1_dp2_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5763,8 +5763,8 @@
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
@@ -2222,8 +2222,8 @@
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
@@ -3932,8 +3932,8 @@
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
@@ -4818,8 +4818,8 @@
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
@@ -2909,8 +2909,8 @@
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
@@ -3223,8 +3223,8 @@
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
@@ -4758,8 +4758,8 @@
 				mdss_dp0_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4841,8 +4841,8 @@
 				mdss_dp1_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -4923,8 +4923,8 @@
 				mdss_dp2_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 
@@ -5002,8 +5002,8 @@
 				mdss_dp3_opp_table: opp-table {
 					compatible = "operating-points-v2";
 
-					opp-160000000 {
-						opp-hz = /bits/ 64 <160000000>;
+					opp-162000000 {
+						opp-hz = /bits/ 64 <162000000>;
 						required-opps = <&rpmhpd_opp_low_svs>;
 					};
 


