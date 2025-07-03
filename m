Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557F15442C;
	Thu,  3 Jul 2025 15:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555315; cv=none; b=KLB2pq3WM8IILl7gJk+80ZSX+4dby+0kckYZw4T6vXqXIuJ7X9/J23KcFYkUX6gbY1Px7I5WLOAh5jdea37zhqBO54n99tHzOsuAPgW5GC+UqHxoZCkbVNIyDHjswe51qBlUbCXDRnrW4vW80qq+vC6PKLMKrFV8NJAoN9yfBG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555315; c=relaxed/simple;
	bh=Zpfa0c5LOaSVWtY0AOAPJOgs5mAke1u9EOpc57alUaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUg/SE+ZY9wSVocHsCnyYAKIQ94xmyqiY04ober2xnB2xzdWBmWHGtdkpIROeznt2lYkvl6nhLqVccxKdxgWRdZX1STYIKHIeGkSZc7co7HgpKlHRaCz4qqKUE2a/m9tYNbvt+H9k6lkyROFTXvrGcvtZZJcWPl/OaeuGDQVFtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wo3hQRYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wo3hQRYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37D0C4CEE3;
	Thu,  3 Jul 2025 15:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555315;
	bh=Zpfa0c5LOaSVWtY0AOAPJOgs5mAke1u9EOpc57alUaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wo3hQRYpnwxVzSduPJ+PGbowFWaoroR8PH9b5sOIcvC0jgeZ/UUSXDq1nDA2oKxfL
	 YjEhsDSDJc93cs4uJ1J2VDVAZMDSzo40djTciQJjQDLEthaFDSR2SeieGQr5Ia9epq
	 Sd1PY3f8ETvj4QKguNV0pgD44u/KEiyiB2bbsWZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 241/263] arm64: dts: qcom: x1e80100-crd: mark l12b and l15b always-on
Date: Thu,  3 Jul 2025 16:42:41 +0200
Message-ID: <20250703144014.071604398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit abf89bc4bb09c16a53d693b09ea85225cf57ff39 ]

The l12b and l15b supplies are used by components that are not (fully)
described (and some never will be) and must never be disabled.

Mark the regulators as always-on to prevent them from being disabled,
for example, when consumers probe defer or suspend.

Fixes: bd50b1f5b6f3 ("arm64: dts: qcom: x1e80100: Add Compute Reference Device")
Cc: stable@vger.kernel.org	# 6.8
Cc: Abel Vesa <abel.vesa@linaro.org>
Cc: Rajendra Nayak <quic_rjendra@quicinc.com>
Cc: Sibi Sankar <quic_sibis@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250314145440.11371-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-crd.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-crd.dtsi b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
index 296b41409ad17..780852fb87360 100644
--- a/arch/arm64/boot/dts/qcom/x1-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-crd.dtsi
@@ -434,6 +434,7 @@ vreg_l12b_1p2: ldo12 {
 			regulator-min-microvolt = <1200000>;
 			regulator-max-microvolt = <1200000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l13b_3p0: ldo13 {
@@ -455,6 +456,7 @@ vreg_l15b_1p8: ldo15 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_l16b_2p9: ldo16 {
-- 
2.39.5



