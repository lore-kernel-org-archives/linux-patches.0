Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49C8242D86;
	Wed, 28 Jan 2026 15:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614429; cv=none; b=PxQ60orySH3VB7bw6Ep/Uydk1bsP/7Jwzct7K453RFHov6DHuvX3MCK4MmvafSlSEK17oPp8+OiPaA6bb5q3CtsvsgVMgLOvHhTFQm6TOzotM405qJLqQTqNj1ghz5hhy1I47vmkWlH+2Qz3pNMBgFTdhgohF5B0W1yGfEcrycQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614429; c=relaxed/simple;
	bh=Eed6dwRhcr1dn/XH2jAuprsVU7k+olDSWNTeM2A3W+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DknULZmdItrv4cLfbs0OvtZB3w4rJ+yhPZ6x/8zAz2NKpZLbgFoJTBVvKJc+hSN8XF4ifjm4Yl2bIeAIBShk5lSfUtuYcrSLSU03DYeYFBn+gb/jcIuXlwP1l0tX5432WzHuW7/GzxmdH9KeXo0XY0cfcDVseVV/boXIWnbtJBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBiGrAd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBiGrAd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9D1C4CEF1;
	Wed, 28 Jan 2026 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614429;
	bh=Eed6dwRhcr1dn/XH2jAuprsVU7k+olDSWNTeM2A3W+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBiGrAd1sdXEeUEtr67kJ+aCL3MjKOFo0gqkU9zfTvgaTvZlD5Kh7YH8tFv6YpHyw
	 E6o9Y+Rcj+aTIsObUgqriyo188LRBkxyQI9Yu0wxD7wa0rrIZQjD7flBYnvlcPxdkn
	 AfDj94TR6dtEGkJJq+JrBe2Z2u86TO97eacpY7V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Jishnu Prakash <quic_jprakash@quicinc.com>,
	Melody Olvera <quic_molvera@quicinc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/254] dt-bindings: power: qcom,rpmpd: document the SM8750 RPMh Power Domains
Date: Wed, 28 Jan 2026 16:21:22 +0100
Message-ID: <20260128145348.640209932@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 134e9d035d830aabd1121bcda89f7ee9a476d3a3 ]

Document the RPMh Power Domains on the SM8750 Platform.

Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Signed-off-by: Jishnu Prakash <quic_jprakash@quicinc.com>
Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
Message-ID: <20241112002444.2802092-2-quic_molvera@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 45e1be5ddec9 ("dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 1 +
 include/dt-bindings/power/qcom-rpmpd.h                  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 2ff246cf8b81d..bb01bf5663f37 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -56,6 +56,7 @@ properties:
           - qcom,sm8450-rpmhpd
           - qcom,sm8550-rpmhpd
           - qcom,sm8650-rpmhpd
+          - qcom,sm8750-rpmhpd
           - qcom,x1e80100-rpmhpd
       - items:
           - enum:
diff --git a/include/dt-bindings/power/qcom-rpmpd.h b/include/dt-bindings/power/qcom-rpmpd.h
index 7f4e2983a4c57..ced784a8afc12 100644
--- a/include/dt-bindings/power/qcom-rpmpd.h
+++ b/include/dt-bindings/power/qcom-rpmpd.h
@@ -218,6 +218,7 @@
 /* SDM845 Power Domain performance levels */
 #define RPMH_REGULATOR_LEVEL_RETENTION		16
 #define RPMH_REGULATOR_LEVEL_MIN_SVS		48
+#define RPMH_REGULATOR_LEVEL_LOW_SVS_D3		50
 #define RPMH_REGULATOR_LEVEL_LOW_SVS_D2		52
 #define RPMH_REGULATOR_LEVEL_LOW_SVS_D1		56
 #define RPMH_REGULATOR_LEVEL_LOW_SVS_D0		60
@@ -238,6 +239,7 @@
 #define RPMH_REGULATOR_LEVEL_TURBO_L1		416
 #define RPMH_REGULATOR_LEVEL_TURBO_L2		432
 #define RPMH_REGULATOR_LEVEL_TURBO_L3		448
+#define RPMH_REGULATOR_LEVEL_TURBO_L4		452
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO 	464
 #define RPMH_REGULATOR_LEVEL_SUPER_TURBO_NO_CPR	480
 
-- 
2.51.0



