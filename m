Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B570363C6C;
	Sat, 12 Sep 2026 07:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197866; cv=none; b=n54rvKvCLtdAFx64qtVz7kbCB4g2qO0TqzL2p70Oq2K9xPr6y0e5BoCwNbj8QsEiAIEN/91jISnE8Om9vDNXHRLRXGn5F760/lXEccJ7bAEfzSkIytpJ0ONwOotjDzyoQ4OeqkBdG0yuhn8yGCLd7m/e7syMTkxY3qvupwMkTEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197866; c=relaxed/simple;
	bh=yYep7Iwr7GilFo4ryl9lXn5aA1jcWhtnrlt0x56cNgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYh/JAQQNXpR2RfNCkDml/Wi2GT367JeyTyw5iFqHa1l8GcUYS30D3mdSLMs5571jcmZBwllDUJxpg7gfDgZ02AXAQZe5Bpja7/G1kSG0R5aH5+3pplTFpKuRsl+gdVkOx8aS9ErTTdhtY6An1Zzif3QkBkXXmKpBruJOsPv1I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYHat/bl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYHat/bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8133F1F000FF;
	Sat, 12 Sep 2026 07:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197865;
	bh=fLKqgVNfIyZipJJPP7JygIg9jkeEbrVszu0tQVulRH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYHat/blkynjv5H4+tP/uZV1H9PO+K0B9mCWbv9vz5LVlONq+zkjdx+c9g1wPxgWO
	 Mcg/QF4gMRubsCgxmXKsolSbGgOtsQN2sPcH+aOdctnkKJC9dLIy765CUotboOPL3M
	 mG95BObnIl5cpQcKOBBYMx0P1qQxMsgYRg74bUdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0262/1815] arm64: dts: qcom: sc8180x-lenovo-flex-5g: Rename regulator nodes
Date: Sat, 12 Sep 2026 08:33:32 +0200
Message-ID: <20260912065655.125436925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d86a31ddede29..0d2cfb830e839 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
@@ -157,14 +157,7 @@ cdsp_mem: cdsp-region@98900000 {
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
 
@@ -177,6 +170,13 @@ vreg_s4a_1p8: pm8150-s4-regulator {
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



