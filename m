Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E281885A5;
	Wed, 28 Jan 2026 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614448; cv=none; b=qlU9zkO0yh0EtACLpHTgjsz1d0prt5qGOopv9EzPgr9932OZcIkscv4KibUt97WK9rFSCrHcLfwhwGTzUDQWpZXSeOhrzwUw5FlUV6trBzoKMjshj8BK4w6bZ99OstSGDKA1O661h9qMFDF7CcjBj6ymH5Y1BRw+69+TzKu946Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614448; c=relaxed/simple;
	bh=fGlFLP4NBKfGom1lqtURWyW9kAwvusBhnX2FYfUM6pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3KAgh8B+zT4vfA3xTqhWKowKStjRs6aO5+n0PQaSeZVx/mcAk32WoR5BWwC4AKxdE0O96cckIb3X/Rai5vzQBXLGWkXPsnwDcGFHJtEnZERe3I5anO8fs1GbdgdZPmtYZkqv+WoJIftxTrUwlv2MsejxntPnY4NR+e88u+RnvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8gywlmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8gywlmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD9CC4CEF1;
	Wed, 28 Jan 2026 15:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614448;
	bh=fGlFLP4NBKfGom1lqtURWyW9kAwvusBhnX2FYfUM6pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8gywlmTeyCZ97IQp0xw2K0mbnqsulQjY2v8OBX7yR/riqFD8njp65UOdgs3A0llR
	 0UEl5XjTKN1ZWSl5pXJcjjxKnI18Vo0d89ji+M9UJPwImr3tJddJWlR2l2tWz6hgGG
	 JFYR+qHfugYkjJYQb3RslIUr7y2Z4I+0sTiYrfiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/254] dt-bindings: power: qcom-rpmpd: split RPMh domains definitions
Date: Wed, 28 Jan 2026 16:21:24 +0100
Message-ID: <20260128145348.711616106@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit dcb8d01b65fb5a891ddbbedcbe6eff0b8ec37867 ]

Historically both RPM and RPMh domain definitions were a part of the
same, qcom-rpmpd.h header. Now as we have a separate header for RPMh
definitions, qcom,rpmhpd.h, move all RPMh power domain definitions to
that header.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20250718-rework-rpmhpd-rpmpd-v1-1-eedca108e540@oss.qualcomm.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 45e1be5ddec9 ("dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/power/qcom,rpmhpd.h | 233 ++++++++++++++++++++++++
 include/dt-bindings/power/qcom-rpmpd.h  | 228 +----------------------
 2 files changed, 234 insertions(+), 227 deletions(-)

diff --git a/include/dt-bindings/power/qcom,rpmhpd.h b/include/dt-bindings/power/qcom,rpmhpd.h
index 0f6a74e099701..758c3487bd662 100644
--- a/include/dt-bindings/power/qcom,rpmhpd.h
+++ b/include/dt-bindings/power/qcom,rpmhpd.h
@@ -28,4 +28,237 @@
 #define RPMHPD_XO               18
 #define RPMHPD_NSP2             19
 
+/* RPMh Power Domain performance levels */
+#define RPMH_REGULATOR_LEVEL_RETENTION		16
+#define RPMH_REGULATOR_LEVEL_MIN_SVS		48
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_D3		50
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_D2		52
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_D1		56
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_D0		60
+#define RPMH_REGULATOR_LEVEL_LOW_SVS		64
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_P1		72
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_L1		80
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_L2		96
+#define RPMH_REGULATOR_LEVEL_SVS		128
+#define RPMH_REGULATOR_LEVEL_SVS_L0		144
+#define RPMH_REGULATOR_LEVEL_SVS_L1		192
+#define RPMH_REGULATOR_LEVEL_SVS_L2		224
+#define RPMH_REGULATOR_LEVEL_NOM		256
+#define RPMH_REGULATOR_LEVEL_NOM_L0		288
+#define RPMH_REGULATOR_LEVEL_NOM_L1		320
+#define RPMH_REGULATOR_LEVEL_NOM_L2		336
+#define RPMH_REGULATOR_LEVEL_TURBO		384
+#define RPMH_REGULATOR_LEVEL_TURBO_L0		400
+#define RPMH_REGULATOR_LEVEL_TURBO_L1		416
+#define RPMH_REGULATOR_LEVEL_TURBO_L2		432
+#define RPMH_REGULATOR_LEVEL_TURBO_L3		448
+#define RPMH_REGULATOR_LEVEL_TURBO_L4		452
+#define RPMH_REGULATOR_LEVEL_TURBO_L5		456
+#define RPMH_REGULATOR_LEVEL_SUPER_TURBO	464
+#define RPMH_REGULATOR_LEVEL_SUPER_TURBO_NO_CPR	480
+
+/*
+ * Platform-specific power domain bindings. Don't add new entries here, use
+ * RPMHPD_* above.
+ */
+
+/* SA8775P Power Domain Indexes */
+#define SA8775P_CX	0
+#define SA8775P_CX_AO	1
+#define SA8775P_DDR	2
+#define SA8775P_EBI	3
+#define SA8775P_GFX	4
+#define SA8775P_LCX	5
+#define SA8775P_LMX	6
+#define SA8775P_MMCX	7
+#define SA8775P_MMCX_AO	8
+#define SA8775P_MSS	9
+#define SA8775P_MX	10
+#define SA8775P_MX_AO	11
+#define SA8775P_MXC	12
+#define SA8775P_MXC_AO	13
+#define SA8775P_NSP0	14
+#define SA8775P_NSP1	15
+#define SA8775P_XO	16
+
+/* SDM670 Power Domain Indexes */
+#define SDM670_MX	0
+#define SDM670_MX_AO	1
+#define SDM670_CX	2
+#define SDM670_CX_AO	3
+#define SDM670_LMX	4
+#define SDM670_LCX	5
+#define SDM670_GFX	6
+#define SDM670_MSS	7
+
+/* SDM845 Power Domain Indexes */
+#define SDM845_EBI	0
+#define SDM845_MX	1
+#define SDM845_MX_AO	2
+#define SDM845_CX	3
+#define SDM845_CX_AO	4
+#define SDM845_LMX	5
+#define SDM845_LCX	6
+#define SDM845_GFX	7
+#define SDM845_MSS	8
+
+/* SDX55 Power Domain Indexes */
+#define SDX55_MSS	0
+#define SDX55_MX	1
+#define SDX55_CX	2
+
+/* SDX65 Power Domain Indexes */
+#define SDX65_MSS	0
+#define SDX65_MX	1
+#define SDX65_MX_AO	2
+#define SDX65_CX	3
+#define SDX65_CX_AO	4
+#define SDX65_MXC	5
+
+/* SM6350 Power Domain Indexes */
+#define SM6350_CX	0
+#define SM6350_GFX	1
+#define SM6350_LCX	2
+#define SM6350_LMX	3
+#define SM6350_MSS	4
+#define SM6350_MX	5
+
+/* SM8150 Power Domain Indexes */
+#define SM8150_MSS	0
+#define SM8150_EBI	1
+#define SM8150_LMX	2
+#define SM8150_LCX	3
+#define SM8150_GFX	4
+#define SM8150_MX	5
+#define SM8150_MX_AO	6
+#define SM8150_CX	7
+#define SM8150_CX_AO	8
+#define SM8150_MMCX	9
+#define SM8150_MMCX_AO	10
+
+/* SA8155P is a special case, kept for backwards compatibility */
+#define SA8155P_CX	SM8150_CX
+#define SA8155P_CX_AO	SM8150_CX_AO
+#define SA8155P_EBI	SM8150_EBI
+#define SA8155P_GFX	SM8150_GFX
+#define SA8155P_MSS	SM8150_MSS
+#define SA8155P_MX	SM8150_MX
+#define SA8155P_MX_AO	SM8150_MX_AO
+
+/* SM8250 Power Domain Indexes */
+#define SM8250_CX	0
+#define SM8250_CX_AO	1
+#define SM8250_EBI	2
+#define SM8250_GFX	3
+#define SM8250_LCX	4
+#define SM8250_LMX	5
+#define SM8250_MMCX	6
+#define SM8250_MMCX_AO	7
+#define SM8250_MX	8
+#define SM8250_MX_AO	9
+
+/* SM8350 Power Domain Indexes */
+#define SM8350_CX	0
+#define SM8350_CX_AO	1
+#define SM8350_EBI	2
+#define SM8350_GFX	3
+#define SM8350_LCX	4
+#define SM8350_LMX	5
+#define SM8350_MMCX	6
+#define SM8350_MMCX_AO	7
+#define SM8350_MX	8
+#define SM8350_MX_AO	9
+#define SM8350_MXC	10
+#define SM8350_MXC_AO	11
+#define SM8350_MSS	12
+
+/* SM8450 Power Domain Indexes */
+#define SM8450_CX	0
+#define SM8450_CX_AO	1
+#define SM8450_EBI	2
+#define SM8450_GFX	3
+#define SM8450_LCX	4
+#define SM8450_LMX	5
+#define SM8450_MMCX	6
+#define SM8450_MMCX_AO	7
+#define SM8450_MX	8
+#define SM8450_MX_AO	9
+#define SM8450_MXC	10
+#define SM8450_MXC_AO	11
+#define SM8450_MSS	12
+
+/* SM8550 Power Domain Indexes */
+#define SM8550_CX	0
+#define SM8550_CX_AO	1
+#define SM8550_EBI	2
+#define SM8550_GFX	3
+#define SM8550_LCX	4
+#define SM8550_LMX	5
+#define SM8550_MMCX	6
+#define SM8550_MMCX_AO	7
+#define SM8550_MX	8
+#define SM8550_MX_AO	9
+#define SM8550_MXC	10
+#define SM8550_MXC_AO	11
+#define SM8550_MSS	12
+#define SM8550_NSP	13
+
+/* QDU1000/QRU1000 Power Domain Indexes */
+#define QDU1000_EBI	0
+#define QDU1000_MSS	1
+#define QDU1000_CX	2
+#define QDU1000_MX	3
+
+/* SC7180 Power Domain Indexes */
+#define SC7180_CX	0
+#define SC7180_CX_AO	1
+#define SC7180_GFX	2
+#define SC7180_MX	3
+#define SC7180_MX_AO	4
+#define SC7180_LMX	5
+#define SC7180_LCX	6
+#define SC7180_MSS	7
+
+/* SC7280 Power Domain Indexes */
+#define SC7280_CX	0
+#define SC7280_CX_AO	1
+#define SC7280_EBI	2
+#define SC7280_GFX	3
+#define SC7280_MX	4
+#define SC7280_MX_AO	5
+#define SC7280_LMX	6
+#define SC7280_LCX	7
+#define SC7280_MSS	8
+
+/* SC8180X Power Domain Indexes */
+#define SC8180X_CX	0
+#define SC8180X_CX_AO	1
+#define SC8180X_EBI	2
+#define SC8180X_GFX	3
+#define SC8180X_LCX	4
+#define SC8180X_LMX	5
+#define SC8180X_MMCX	6
+#define SC8180X_MMCX_AO	7
+#define SC8180X_MSS	8
+#define SC8180X_MX	9
+#define SC8180X_MX_AO	10
+
+/* SC8280XP Power Domain Indexes */
+#define SC8280XP_CX		0
+#define SC8280XP_CX_AO		1
+#define SC8280XP_DDR		2
+#define SC8280XP_EBI		3
+#define SC8280XP_GFX		4
+#define SC8280XP_LCX		5
+#define SC8280XP_LMX		6
+#define SC8280XP_MMCX		7
+#define SC8280XP_MMCX_AO	8
+#define SC8280XP_MSS		9
+#define SC8280XP_MX		10
+#define SC8280XP_MXC		12
+#define SC8280XP_MX_AO		11
+#define SC8280XP_NSP		13
+#define SC8280XP_QPHY		14
+#define SC8280XP_XO		15
+
 #endif
diff --git a/include/dt-bindings/power/qcom-rpmpd.h b/include/dt-bindings/power/qcom-rpmpd.h
index 73b3655155ec0..f160f373be2a3 100644
--- a/include/dt-bindings/power/qcom-rpmpd.h
+++ b/include/dt-bindings/power/qcom-rpmpd.h
@@ -4,66 +4,7 @@
 #ifndef _DT_BINDINGS_POWER_QCOM_RPMPD_H
 #define _DT_BINDINGS_POWER_QCOM_RPMPD_H
 
-/* SA8775P Power Domain Indexes */
-#define SA8775P_CX	0
-#define SA8775P_CX_AO	1
-#define SA8775P_DDR	2
-#define SA8775P_EBI	3
-#define SA8775P_GFX	4
-#define SA8775P_LCX	5
-#define SA8775P_LMX	6
-#define SA8775P_MMCX	7
-#define SA8775P_MMCX_AO	8
-#define SA8775P_MSS	9
-#define SA8775P_MX	10
-#define SA8775P_MX_AO	11
-#define SA8775P_MXC	12
-#define SA8775P_MXC_AO	13
-#define SA8775P_NSP0	14
-#define SA8775P_NSP1	15
-#define SA8775P_XO	16
-
-/* SDM670 Power Domain Indexes */
-#define SDM670_MX	0
-#define SDM670_MX_AO	1
-#define SDM670_CX	2
-#define SDM670_CX_AO	3
-#define SDM670_LMX	4
-#define SDM670_LCX	5
-#define SDM670_GFX	6
-#define SDM670_MSS	7
-
-/* SDM845 Power Domain Indexes */
-#define SDM845_EBI	0
-#define SDM845_MX	1
-#define SDM845_MX_AO	2
-#define SDM845_CX	3
-#define SDM845_CX_AO	4
-#define SDM845_LMX	5
-#define SDM845_LCX	6
-#define SDM845_GFX	7
-#define SDM845_MSS	8
-
-/* SDX55 Power Domain Indexes */
-#define SDX55_MSS	0
-#define SDX55_MX	1
-#define SDX55_CX	2
-
-/* SDX65 Power Domain Indexes */
-#define SDX65_MSS	0
-#define SDX65_MX	1
-#define SDX65_MX_AO	2
-#define SDX65_CX	3
-#define SDX65_CX_AO	4
-#define SDX65_MXC	5
-
-/* SM6350 Power Domain Indexes */
-#define SM6350_CX	0
-#define SM6350_GFX	1
-#define SM6350_LCX	2
-#define SM6350_LMX	3
-#define SM6350_MSS	4
-#define SM6350_MX	5
+#include <dt-bindings/power/qcom,rpmhpd.h>
 
 /* SM6350 Power Domain Indexes */
 #define SM6375_VDDCX		0
@@ -77,173 +18,6 @@
 #define SM6375_VDD_LPI_CX	8
 #define SM6375_VDD_LPI_MX	9
 
-/* SM8150 Power Domain Indexes */
-#define SM8150_MSS	0
-#define SM8150_EBI	1
-#define SM8150_LMX	2
-#define SM8150_LCX	3
-#define SM8150_GFX	4
-#define SM8150_MX	5
-#define SM8150_MX_AO	6
-#define SM8150_CX	7
-#define SM8150_CX_AO	8
-#define SM8150_MMCX	9
-#define SM8150_MMCX_AO	10
-
-/* SA8155P is a special case, kept for backwards compatibility */
-#define SA8155P_CX	SM8150_CX
-#define SA8155P_CX_AO	SM8150_CX_AO
-#define SA8155P_EBI	SM8150_EBI
-#define SA8155P_GFX	SM8150_GFX
-#define SA8155P_MSS	SM8150_MSS
-#define SA8155P_MX	SM8150_MX
-#define SA8155P_MX_AO	SM8150_MX_AO
-
-/* SM8250 Power Domain Indexes */
-#define SM8250_CX	0
-#define SM8250_CX_AO	1
-#define SM8250_EBI	2
-#define SM8250_GFX	3
-#define SM8250_LCX	4
-#define SM8250_LMX	5
-#define SM8250_MMCX	6
-#define SM8250_MMCX_AO	7
-#define SM8250_MX	8
-#define SM8250_MX_AO	9
-
-/* SM8350 Power Domain Indexes */
-#define SM8350_CX	0
-#define SM8350_CX_AO	1
-#define SM8350_EBI	2
-#define SM8350_GFX	3
-#define SM8350_LCX	4
-#define SM8350_LMX	5
-#define SM8350_MMCX	6
-#define SM8350_MMCX_AO	7
-#define SM8350_MX	8
-#define SM8350_MX_AO	9
-#define SM8350_MXC	10
-#define SM8350_MXC_AO	11
-#define SM8350_MSS	12
-
-/* SM8450 Power Domain Indexes */
-#define SM8450_CX	0
-#define SM8450_CX_AO	1
-#define SM8450_EBI	2
-#define SM8450_GFX	3
-#define SM8450_LCX	4
-#define SM8450_LMX	5
-#define SM8450_MMCX	6
-#define SM8450_MMCX_AO	7
-#define SM8450_MX	8
-#define SM8450_MX_AO	9
-#define SM8450_MXC	10
-#define SM8450_MXC_AO	11
-#define SM8450_MSS	12
-
-/* SM8550 Power Domain Indexes */
-#define SM8550_CX	0
-#define SM8550_CX_AO	1
-#define SM8550_EBI	2
-#define SM8550_GFX	3
-#define SM8550_LCX	4
-#define SM8550_LMX	5
-#define SM8550_MMCX	6
-#define SM8550_MMCX_AO	7
-#define SM8550_MX	8
-#define SM8550_MX_AO	9
-#define SM8550_MXC	10
-#define SM8550_MXC_AO	11
-#define SM8550_MSS	12
-#define SM8550_NSP	13
-
-/* QDU1000/QRU1000 Power Domain Indexes */
-#define QDU1000_EBI	0
-#define QDU1000_MSS	1
-#define QDU1000_CX	2
-#define QDU1000_MX	3
-
-/* SC7180 Power Domain Indexes */
-#define SC7180_CX	0
-#define SC7180_CX_AO	1
-#define SC7180_GFX	2
-#define SC7180_MX	3
-#define SC7180_MX_AO	4
-#define SC7180_LMX	5
-#define SC7180_LCX	6
-#define SC7180_MSS	7
-
-/* SC7280 Power Domain Indexes */
-#define SC7280_CX	0
-#define SC7280_CX_AO	1
-#define SC7280_EBI	2
-#define SC7280_GFX	3
-#define SC7280_MX	4
-#define SC7280_MX_AO	5
-#define SC7280_LMX	6
-#define SC7280_LCX	7
-#define SC7280_MSS	8
-
-/* SC8180X Power Domain Indexes */
-#define SC8180X_CX	0
-#define SC8180X_CX_AO	1
-#define SC8180X_EBI	2
-#define SC8180X_GFX	3
-#define SC8180X_LCX	4
-#define SC8180X_LMX	5
-#define SC8180X_MMCX	6
-#define SC8180X_MMCX_AO	7
-#define SC8180X_MSS	8
-#define SC8180X_MX	9
-#define SC8180X_MX_AO	10
-
-/* SC8280XP Power Domain Indexes */
-#define SC8280XP_CX		0
-#define SC8280XP_CX_AO		1
-#define SC8280XP_DDR		2
-#define SC8280XP_EBI		3
-#define SC8280XP_GFX		4
-#define SC8280XP_LCX		5
-#define SC8280XP_LMX		6
-#define SC8280XP_MMCX		7
-#define SC8280XP_MMCX_AO	8
-#define SC8280XP_MSS		9
-#define SC8280XP_MX		10
-#define SC8280XP_MXC		12
-#define SC8280XP_MX_AO		11
-#define SC8280XP_NSP		13
-#define SC8280XP_QPHY		14
-#define SC8280XP_XO		15
-
-/* SDM845 Power Domain performance levels */
-#define RPMH_REGULATOR_LEVEL_RETENTION		16
-#define RPMH_REGULATOR_LEVEL_MIN_SVS		48
-#define RPMH_REGULATOR_LEVEL_LOW_SVS_D3		50
-#define RPMH_REGULATOR_LEVEL_LOW_SVS_D2		52
-#define RPMH_REGULATOR_LEVEL_LOW_SVS_D1		56
-#define RPMH_REGULATOR_LEVEL_LOW_SVS_D0		60
-#define RPMH_REGULATOR_LEVEL_LOW_SVS		64
-#define RPMH_REGULATOR_LEVEL_LOW_SVS_P1		72
-#define RPMH_REGULATOR_LEVEL_LOW_SVS_L1		80
-#define RPMH_REGULATOR_LEVEL_LOW_SVS_L2		96
-#define RPMH_REGULATOR_LEVEL_SVS		128
-#define RPMH_REGULATOR_LEVEL_SVS_L0		144
-#define RPMH_REGULATOR_LEVEL_SVS_L1		192
-#define RPMH_REGULATOR_LEVEL_SVS_L2		224
-#define RPMH_REGULATOR_LEVEL_NOM		256
-#define RPMH_REGULATOR_LEVEL_NOM_L0		288
-#define RPMH_REGULATOR_LEVEL_NOM_L1		320
-#define RPMH_REGULATOR_LEVEL_NOM_L2		336
-#define RPMH_REGULATOR_LEVEL_TURBO		384
-#define RPMH_REGULATOR_LEVEL_TURBO_L0		400
-#define RPMH_REGULATOR_LEVEL_TURBO_L1		416
-#define RPMH_REGULATOR_LEVEL_TURBO_L2		432
-#define RPMH_REGULATOR_LEVEL_TURBO_L3		448
-#define RPMH_REGULATOR_LEVEL_TURBO_L4		452
-#define RPMH_REGULATOR_LEVEL_TURBO_L5		456
-#define RPMH_REGULATOR_LEVEL_SUPER_TURBO 	464
-#define RPMH_REGULATOR_LEVEL_SUPER_TURBO_NO_CPR	480
-
 /* MDM9607 Power Domains */
 #define MDM9607_VDDCX		0
 #define MDM9607_VDDCX_AO	1
-- 
2.51.0



