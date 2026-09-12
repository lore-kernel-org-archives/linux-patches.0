Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7896C299920;
	Sat, 12 Sep 2026 12:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215022; cv=none; b=YKOOLAt40qt2ZD61iiyhse8qKfRINeUy3QSuUtd9BKHzpNJJgwakD+Dq638ENdiDjEkKgJeTlSEhYZgMYYZwsovZ9VsIj99DiP1lfVfx5uMPSO9TgG5wf+0KYOJMwH9Il5FAArWDWO4W/1V/hxmGYsj8UuusxzMRXV0bYid+5ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215022; c=relaxed/simple;
	bh=430LmtSpuDti9vmVHDDF390M//V6mnlSTO2GO1IwGV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMjXVpM09AUCltEwsPpkYL/Ke+Rta7DBUgpLoYJ5XIxSFp7TjdPLziOTeVNnOb5vNma59B39812NZQzN2cru0ENZJH1/XWwK/cnUeR9CXszFEWzpO+Hxj9We7/hmOA2KXgmdSrxiQNzC0mcHNQCpAFxu2/nUIRIaHilRXiaoESg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQB0xx6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQB0xx6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B042C1F000FF;
	Sat, 12 Sep 2026 12:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215021;
	bh=+BQkGUAeGpUA6C29ujxJD8kvKDt+l1brOEwPTkGksv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LQB0xx6uVH/jntUCwIIY7llCrIfZsx/3Rf7VKjnQ5xufs+98guQVvdupdVNTnG0NC
	 G2ZlIfdpVwsYgwTgERQyg/SwdVr3zrwfzcwSVtghtufYfP1Fp8FQOSUm+v7ljrME+T
	 viDCNk7DeS/IcycGyvpi182PQUb/PKsmfrGP4xIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0446/1376] arm64: dts: qcom: sc8180x-lenovo-flex-5g: Rename regulator nodes
Date: Sat, 12 Sep 2026 08:47:52 +0200
Message-ID: <20260912065617.474137367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 0b1c6d2a65fc41aa0d5f6617dd04043384678d61 ]

Align with the contemporary way of naming regulator nodes (regulator-
prefix) in preparation for adding more of them.

Reorder the renamed entries to match the expectations of the DT coding
style doc.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260616-topic-8180_disp_power-v2-3-167785993231@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: d5f5c089858f ("arm64: dts: qcom: sc8180x-lenovo-flex-5g: Describe the display power net")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8180x-lenovo-flex-5g.dts     | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
index 62de4774c556d..357b1214c1738 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
@@ -162,14 +162,7 @@ cdsp_mem: cdsp-region@98900000 {
 		};
 	};
 
-	vph_pwr: vph-pwr-regulator {
-		compatible = "regulator-fixed";
-		regulator-name = "vph_pwr";
-		regulator-min-microvolt = <3700000>;
-		regulator-max-microvolt = <3700000>;
-	};
-
-	vreg_s4a_1p8: pm8150-s4-regulator {
+	vreg_s4a_1p8: regulator-pm8150-s4 {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_s4a_1p8";
 
@@ -182,6 +175,13 @@ vreg_s4a_1p8: pm8150-s4-regulator {
 		vin-supply = <&vph_pwr>;
 	};
 
+	vph_pwr: regulator-vph-pwr {
+		compatible = "regulator-fixed";
+		regulator-name = "vph_pwr";
+		regulator-min-microvolt = <3700000>;
+		regulator-max-microvolt = <3700000>;
+	};
+
 	usbprim-sbu-mux {
 		compatible = "pericom,pi3usb102", "gpio-sbu-mux";
 
-- 
2.53.0



