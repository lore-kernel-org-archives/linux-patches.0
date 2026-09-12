Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A195447AF6D;
	Sat, 12 Sep 2026 12:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215012; cv=none; b=J2DWE9/ZposAv8qJlcmZ6EU94UmrEgJk/k0TL068ayPUkHPLFmFfXrZHrVKtcXzh0rchJ9sEh0WpMCOOiI7WyYESlKLwin0hhrFiFYZ/uAhPsR0yhdKy/HV6rANCEanGBkO7m2OSyd3oaEqD47r37509uwZfkwNZz+UIwqts4hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215012; c=relaxed/simple;
	bh=wStCEgWZucSBi3VJQOI7hrwSSNbUeCAMwvwzMjpwEYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfdFJntCLiarK5hHZlOlxp/xSGvRfOrsvEgdt1sLksgcThQLlF9WOC97HTN4Le13tlRyA1SF9KTbMA0h3qdGW5IrlK8sEw/wugrHsLCkXObOmuh1ONQIoFyh4B/4WBK5NSPsVN39d+/VQsjKipptOKKXsU3m4jDz1+wVmWm6BRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqtaB3xS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqtaB3xS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AAB1F000FF;
	Sat, 12 Sep 2026 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215011;
	bh=+ogvZtLpzVQTPXk45a3GrL4EGU2zt5RiiqwBPVliN2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqtaB3xS6SbkEdXAwhHfMmcZOWbdaN1V+l9uVQ5YTG+45QWuX6r+18YnspimctYCW
	 7uxzzRbmlDz1CtfHWgGwggOMyVpT92Ir4AvKxiEotHwCKmRlMyYkHSQPfyrTa+AF2A
	 oPOVkZvDhJtVgsl6n17cAKaFDaiC9KjvkSDttFZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0444/1376] arm64: dts: qcom: sc8180x-primus: Rename regulator nodes
Date: Sat, 12 Sep 2026 08:47:50 +0200
Message-ID: <20260912065617.429862280@linuxfoundation.org>
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

[ Upstream commit ae51d9396f9318189e91578878409d8ada152edb ]

The nodes would be sorted correctly, if their names started with
"regulator-" (which is the style used in the latest submissions).
Touch that up.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260616-topic-8180_disp_power-v2-1-167785993231@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 80bf2eb87bfb ("arm64: dts: qcom: sc8180x-primus: Describe the display power net")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
index 79b4d293ea1e7..09dc42f5f2f86 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
@@ -165,7 +165,7 @@ reserved-region@9a500000 {
 		};
 	};
 
-	vreg_nvme_0p9: nvme-0p9-regulator {
+	vreg_nvme_0p9: regulator-nvme-0p9 {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_nvme_0p9";
 
@@ -175,7 +175,7 @@ vreg_nvme_0p9: nvme-0p9-regulator {
 		regulator-always-on;
 	};
 
-	vreg_nvme_3p3: nvme-3p3-regulator {
+	vreg_nvme_3p3: regulator-nvme-3p3 {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_nvme_3p3";
 
@@ -188,7 +188,7 @@ vreg_nvme_3p3: nvme-3p3-regulator {
 		regulator-always-on;
 	};
 
-	vdd_kb_tp_3v3: vdd-kb-tp-3v3-regulator {
+	vdd_kb_tp_3v3: regulator-vdd-kb-tp-3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd_kb_tp_3v3";
 		regulator-min-microvolt = <3300000>;
@@ -203,7 +203,7 @@ vdd_kb_tp_3v3: vdd-kb-tp-3v3-regulator {
 		pinctrl-0 = <&kb_tp_3v3_en_active_state>;
 	};
 
-	vph_pwr: vph-pwr-regulator {
+	vph_pwr: regulator-vph-pwr {
 		compatible = "regulator-fixed";
 		regulator-name = "vph_pwr";
 		regulator-min-microvolt = <3700000>;
-- 
2.53.0



