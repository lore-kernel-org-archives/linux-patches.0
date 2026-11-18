Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022907;
	b=aUJbqNivaTHB6yq+sPteu6cFeNuebzVLgVttMi/h3jKOOPIZlf+IBMpUxeNBZNQSHfeS
	 HKsmAZoxOXWngaijQfSHAfP0eJbNaMVp/MaDSgelhhlTCafZpTc4CGZRa0Jwa8V/vEwqq
	 H791WnMfwxppq5V9kJin0pqLLTuq/P9wughEenid76M1EU0Oqx7JaBPnQ4SAiZHrdyix/
	 b0nGUrBy/eFZk96t3GmtEYgkBY6mQf4MN5ufklX8YlWzT7ahiEDgL7qOGLcLy+U4c+W0w
	 dGYdA+Y8KnBFRn2nfkTu4jtVIce+RVgq4RBD9vnzx6GQmTx5m32QjOdC1DUo7iGdO4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sheaHlG46p4qXwqxvhrULzvrrtraCjN0kmfdZomcgvg=;
	b=CWv01UIE/EFNFMS4695SHRFpfeidEjRTiy5/mRvqeSD0FxxVcPRBN7Fdo9rxJfDw0481
	 6QLeB9eWEhGzYe5t/qRTnN6zwH6MBpz2GcaJwCfzBDLn7ntRDa0Wt00F5PQrVE++kZQDo
	 Yuep1f81YkFW/uaPevHry7wLqPBqqNRbq9XCwN364TjfGX/Ec3OQuP+8VFi//FCh6Yc3j
	 rl2wRGdryld4sp+gaAtkBFQfOY+CQELgBdGnmRG3LPLXslT3LVAWQrkKvTucgSf5Tkkb2
	 /ECd+mwULUkiRMxpqWa8szvE+UJrsnGd9ojo3u1WGqLdtZwucw6kyxCRCBgeCrjJdLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ma04Cwnm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF54606A745;
	Wed, 18 Nov 2026 17:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ma04Cwnm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D04A1F000C6;
	Wed, 18 Nov 2026 17:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022906;
	bh=sheaHlG46p4qXwqxvhrULzvrrtraCjN0kmfdZomcgvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ma04Cwnm9A42FJEyDjfW/VDZsJw1ueT5ay5rxWlB96XcGR+1/VrslXyyC3SNhttyh
	 ocYyvCbRhPeG8/1UmrcU3hAv1xJ0bzGNOp0A4QCLV9eegSucc9G9I/akEfHhlET1Sx
	 /K76r0JFvHiqYFIcirfGTTWgdM90HGaSzSnoQA+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0178/2151] dt-bindings: clock: qcom,milos-camcc: Add missing power-domains support
Date: Wed, 18 Nov 2026 15:31:53 +0100
Message-ID: <20261118150128.215541451@linuxfoundation.org>
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

[ Upstream commit e0f335a4e17f5c80b24b8bd2060802bac072775c ]

The Milos camera clock controller requires the CX and MX power
domains, along with their performance state votes, to be enabled
before the clock controller can be accessed.

Document the 'power-domains' and 'required-opps' properties and add
them to the required properties list and example. Since these
properties become required for the already-documented qcom,milos-camcc
compatible, this is an ABI break for any devicetree using this binding
without specifying them.

Fixes: dbb9d53b7197 ("dt-bindings: clock: qcom: document the Milos Camera Clock Controller")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260806-eliza-mm-cc-v9-v10-1-6ba52dd14343@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/qcom,milos-camcc.yaml      | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml b/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml
index 707b25d2c11e6..c4aba40e316ca 100644
--- a/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,milos-camcc.yaml
@@ -29,9 +29,21 @@ properties:
     items:
       - description: Interconnect path to enable the MultiMedia NoC
 
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
@@ -43,6 +55,7 @@ examples:
     #include <dt-bindings/clock/qcom,milos-gcc.h>
     #include <dt-bindings/interconnect/qcom,icc.h>
     #include <dt-bindings/interconnect/qcom,milos-rpmh.h>
+    #include <dt-bindings/power/qcom,rpmhpd.h>
     clock-controller@adb0000 {
         compatible = "qcom,milos-camcc";
         reg = <0x0adb0000 0x40000>;
@@ -51,6 +64,12 @@ examples:
                  <&gcc GCC_CAMERA_AHB_CLK>;
         interconnects = <&mmss_noc MASTER_CAMNOC_HF QCOM_ICC_TAG_ALWAYS
                          &mmss_noc SLAVE_MNOC_HF_MEM_NOC QCOM_ICC_TAG_ALWAYS>;
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



