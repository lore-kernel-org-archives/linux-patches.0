Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D71C10A1E;
	Wed, 28 Jan 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614464; cv=none; b=msKpfejESTMe9WFFhgfWNEDKW6tqame+7BOoXIxe+Xrcct8OGMa6XBDVrvGUYc61bZvgSRm71i44StP+4mkKjMRRATLwjw3Axqo0Fs4jXMjOf0xq3OXq8BqdSb/2W5s0PRermhdEjojt6hZAD9KWlafMwKd0EZNYzA481DFjp5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614464; c=relaxed/simple;
	bh=pCQJeh3dCgOVUoP9SO3fzJ1OvrxpOkl6h+fEtp4QCMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUjPCGPJpqrrKR/bmrijkRyFaXt7Egw0Mm2gXji8oYEb15XZ0gz9NYz9tcszPOIzQUi2LaYoK5XbCidwd43D3dz/KTuq0AJnOKaFoBMKxQfhVuSA+zDwxiAUyLZ+bpD4YjDapMU+Furxfv3SLGfYMsop4DQdelkZ7FvVmWrIlDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6s0hTxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6s0hTxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB88C4CEF1;
	Wed, 28 Jan 2026 15:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614464;
	bh=pCQJeh3dCgOVUoP9SO3fzJ1OvrxpOkl6h+fEtp4QCMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6s0hTxetykD3yYFJCT2nuAMUsgdLbLpXm/cxW2Y8F2yJQjJ3O97vjpm7gxC0C/CJ
	 tUrAI0DbAEdG4cVDyCO98gi4ueZMffU3x5siVmoG2ngGGyJcurTeh5kRSMthOshnJs
	 PwO+kaeUedH3eP0T5K/Fdmodo5uKG6eIH32xkL1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Otto=20Pfl=C3=BCger?= <otto.pflueger@abscue.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/254] dt-bindings: power: rpmpd: Add MSM8917, MSM8937 and QM215
Date: Wed, 28 Jan 2026 16:21:19 +0100
Message-ID: <20260128145348.531864982@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Otto Pflüger <otto.pflueger@abscue.de>

[ Upstream commit 61848698288d93a230cab9c0585e726df66f2402 ]

The MSM8917, MSM8937 and QM215 SoCs have VDDCX and VDDMX power domains
controlled in voltage level mode. Define the MSM8937 and QM215 power
domains as aliases because these SoCs are similar to MSM8917 and may
share some parts of the device tree.

Also add the compatibles for these SoCs to the documentation, with
qcom,msm8937-rpmpd using qcom,msm8917-rpmpd as a fallback compatible
because there are no known differences. QM215 is not compatible with
these because it uses different regulators.

Signed-off-by: Otto Pflüger <otto.pflueger@abscue.de>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231014133823.14088-2-otto.pflueger@abscue.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 45e1be5ddec9 ("dt-bindings: power: qcom,rpmpd: Add SC8280XP_MXC_AO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/power/qcom,rpmpd.yaml | 81 ++++++++++---------
 include/dt-bindings/power/qcom-rpmpd.h        | 21 +++++
 2 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
index 53886f02d98a9..d38c762e12804 100644
--- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
+++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
@@ -15,43 +15,50 @@ description:
 
 properties:
   compatible:
-    enum:
-      - qcom,mdm9607-rpmpd
-      - qcom,msm8226-rpmpd
-      - qcom,msm8909-rpmpd
-      - qcom,msm8916-rpmpd
-      - qcom,msm8939-rpmpd
-      - qcom,msm8953-rpmpd
-      - qcom,msm8976-rpmpd
-      - qcom,msm8994-rpmpd
-      - qcom,msm8996-rpmpd
-      - qcom,msm8998-rpmpd
-      - qcom,qcm2290-rpmpd
-      - qcom,qcs404-rpmpd
-      - qcom,qdu1000-rpmhpd
-      - qcom,sa8155p-rpmhpd
-      - qcom,sa8540p-rpmhpd
-      - qcom,sa8775p-rpmhpd
-      - qcom,sdm660-rpmpd
-      - qcom,sc7180-rpmhpd
-      - qcom,sc7280-rpmhpd
-      - qcom,sc8180x-rpmhpd
-      - qcom,sc8280xp-rpmhpd
-      - qcom,sdm670-rpmhpd
-      - qcom,sdm845-rpmhpd
-      - qcom,sdx55-rpmhpd
-      - qcom,sdx65-rpmhpd
-      - qcom,sdx75-rpmhpd
-      - qcom,sm6115-rpmpd
-      - qcom,sm6125-rpmpd
-      - qcom,sm6350-rpmhpd
-      - qcom,sm6375-rpmpd
-      - qcom,sm7150-rpmhpd
-      - qcom,sm8150-rpmhpd
-      - qcom,sm8250-rpmhpd
-      - qcom,sm8350-rpmhpd
-      - qcom,sm8450-rpmhpd
-      - qcom,sm8550-rpmhpd
+    oneOf:
+      - enum:
+          - qcom,mdm9607-rpmpd
+          - qcom,msm8226-rpmpd
+          - qcom,msm8909-rpmpd
+          - qcom,msm8916-rpmpd
+          - qcom,msm8917-rpmpd
+          - qcom,msm8939-rpmpd
+          - qcom,msm8953-rpmpd
+          - qcom,msm8976-rpmpd
+          - qcom,msm8994-rpmpd
+          - qcom,msm8996-rpmpd
+          - qcom,msm8998-rpmpd
+          - qcom,qcm2290-rpmpd
+          - qcom,qcs404-rpmpd
+          - qcom,qdu1000-rpmhpd
+          - qcom,qm215-rpmpd
+          - qcom,sa8155p-rpmhpd
+          - qcom,sa8540p-rpmhpd
+          - qcom,sa8775p-rpmhpd
+          - qcom,sc7180-rpmhpd
+          - qcom,sc7280-rpmhpd
+          - qcom,sc8180x-rpmhpd
+          - qcom,sc8280xp-rpmhpd
+          - qcom,sdm660-rpmpd
+          - qcom,sdm670-rpmhpd
+          - qcom,sdm845-rpmhpd
+          - qcom,sdx55-rpmhpd
+          - qcom,sdx65-rpmhpd
+          - qcom,sdx75-rpmhpd
+          - qcom,sm6115-rpmpd
+          - qcom,sm6125-rpmpd
+          - qcom,sm6350-rpmhpd
+          - qcom,sm6375-rpmpd
+          - qcom,sm7150-rpmhpd
+          - qcom,sm8150-rpmhpd
+          - qcom,sm8250-rpmhpd
+          - qcom,sm8350-rpmhpd
+          - qcom,sm8450-rpmhpd
+          - qcom,sm8550-rpmhpd
+      - items:
+          - enum:
+              - qcom,msm8937-rpmpd
+          - const: qcom,msm8917-rpmpd
 
   '#power-domain-cells':
     const: 1
diff --git a/include/dt-bindings/power/qcom-rpmpd.h b/include/dt-bindings/power/qcom-rpmpd.h
index 83be996cb5eb9..7f4e2983a4c57 100644
--- a/include/dt-bindings/power/qcom-rpmpd.h
+++ b/include/dt-bindings/power/qcom-rpmpd.h
@@ -278,6 +278,27 @@
 #define MSM8909_VDDMX		MSM8916_VDDMX
 #define MSM8909_VDDMX_AO	MSM8916_VDDMX_AO
 
+/* MSM8917 Power Domain Indexes */
+#define MSM8917_VDDCX		0
+#define MSM8917_VDDCX_AO	1
+#define MSM8917_VDDCX_VFL	2
+#define MSM8917_VDDMX		3
+#define MSM8917_VDDMX_AO	4
+
+/* MSM8937 Power Domain Indexes */
+#define MSM8937_VDDCX		MSM8917_VDDCX
+#define MSM8937_VDDCX_AO	MSM8917_VDDCX_AO
+#define MSM8937_VDDCX_VFL	MSM8917_VDDCX_VFL
+#define MSM8937_VDDMX		MSM8917_VDDMX
+#define MSM8937_VDDMX_AO	MSM8917_VDDMX_AO
+
+/* QM215 Power Domain Indexes */
+#define QM215_VDDCX		MSM8917_VDDCX
+#define QM215_VDDCX_AO		MSM8917_VDDCX_AO
+#define QM215_VDDCX_VFL		MSM8917_VDDCX_VFL
+#define QM215_VDDMX		MSM8917_VDDMX
+#define QM215_VDDMX_AO		MSM8917_VDDMX_AO
+
 /* MSM8953 Power Domain Indexes */
 #define MSM8953_VDDMD		0
 #define MSM8953_VDDMD_AO	1
-- 
2.51.0



