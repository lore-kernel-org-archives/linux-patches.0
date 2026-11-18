Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022909;
	b=EyfWyaGkuoX1ThyIAOS3ZZatg5dYmlCgMTCmKesRI8JWeQUGKxjyK7vRetO5ePyqzbH2
	 NMGYKhiMJll9quBXkGD9UrNDnbun0JMcaVt8zyYH46fwdkSpES3/FcGrxQ8lT/KVMb9O6
	 R7b1hCBbZAbu06kb5ysOOqvpF2piBvxgtgRoq9dlYXu6qLypIamyDQeLHxMuVjuYkLC0o
	 WyEPo4yF3SmAigAd+nV1Z12vSrYd27D+BTajWTJTnWaEleSPQVC3UHPIWkA+EiYYmfxqw
	 8ejDVrTB/H6Q3rfh2QKIZvnv/w0WYH3Ma9+88DgI0DaER8vLB8TVko8MlDJ5l3LQNOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=54/X4mDSIXkQgOIHN/qllQQjIToxMYXxIHgr/G5s3Ow=;
	b=F81B0DXj8gIfdYLrdAxw0RyP1gYc2xCzmhisq50nCqIZ0ZNEKC40Qb2qjRnfvwKfn1lZ
	 90BsOv55GsOg+jTMRTU5YQbLpliOtdbZ4fUYwygr+3DBCwP67Bj4xM48aTMncGNtnT4hq
	 cMGUcyp+4cpgrHyxqQV2DJ/++nhJoTvavVnl1lJVY2dirqwSZcBgrK0fzUoKHNEkg76Q8
	 T3cElvxeRwfnliTFQLq5kHxgPkwi+gXXGqDdZp2exmBEEQ3yJkx7SCNbwySglzLE/pZmL
	 p5fjtjrtGKzKQAQFP9qDIEc9NcL3PJ8bUWkmeG49/t5P3SWHszHFUPsH6af9GeScoZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rSK2FtpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8E606A748;
	Wed, 18 Nov 2026 17:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rSK2FtpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28801F000C6;
	Wed, 18 Nov 2026 17:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022909;
	bh=54/X4mDSIXkQgOIHN/qllQQjIToxMYXxIHgr/G5s3Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSK2FtpT8Ju78zviQHmCDJWpl5a4916rTYVvZuxQwK4FHnLYYWn2ZUmRuX2sXaokg
	 GivTihKhprL/RlvYyqzT16BALXXEA/laWGbEfGWXHztk2E25/T3j15ipVWTIKqn9mJ
	 JeAaaMMenDHroEBL/kX4E14j3foE37YNPT2MhbH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0179/2151] dt-bindings: clock: qcom,milos-videocc: Add missing power-domains support
Date: Wed, 18 Nov 2026 15:31:54 +0100
Message-ID: <20261118150128.252626756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 3da90acddd2f211549032e9fdad40a5879803442 ]

The Milos video clock controller requires the CX and MX power
domains, along with their performance state votes, to be enabled
before the clock controller can be accessed.

Document the 'power-domains' and 'required-opps' properties and add
them to the required properties list and example. Since these
properties become required for the already-documented
qcom,milos-videocc compatible, this is an ABI break for any devicetree
using this binding without specifying them.

Fixes: a4937e974186 ("dt-bindings: clock: qcom: document the Milos Video Clock Controller")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260806-eliza-mm-cc-v9-v10-2-6ba52dd14343@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/qcom,milos-videocc.yaml    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml b/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml
index 14c31efe1308a..4d8d109cd304e 100644
--- a/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,milos-videocc.yaml
@@ -26,9 +26,21 @@ properties:
       - description: Sleep clock source
       - description: Video AHB clock from GCC
 
+  power-domains:
+    items:
+      - description: CX power domain
+      - description: MX power domain
+
+  required-opps:
+    items:
+      - description: CX performance point
+      - description: MX performance point
+
 required:
   - compatible
   - clocks
+  - power-domains
+  - required-opps
 
 allOf:
   - $ref: qcom,gcc.yaml#
@@ -38,6 +50,7 @@ unevaluatedProperties: false
 examples:
   - |
     #include <dt-bindings/clock/qcom,milos-gcc.h>
+    #include <dt-bindings/power/qcom,rpmhpd.h>
     clock-controller@aaf0000 {
         compatible = "qcom,milos-videocc";
         reg = <0x0aaf0000 0x10000>;
@@ -45,6 +58,12 @@ examples:
                  <&bi_tcxo_ao_div2>,
                  <&sleep_clk>,
                  <&gcc GCC_VIDEO_AHB_CLK>;
+
+        power-domains = <&rpmhpd RPMHPD_CX>,
+                        <&rpmhpd RPMHPD_MX>;
+        required-opps = <&rpmhpd_opp_low_svs>,
+                        <&rpmhpd_opp_low_svs>;
+
         #clock-cells = <1>;
         #reset-cells = <1>;
         #power-domain-cells = <1>;
-- 
2.53.0



