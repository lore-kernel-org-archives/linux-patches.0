Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015317;
	b=rjAybnIR1B+vDez/lLpjsVoAlNHXDfa+brV2HOVPiwLX8qREcLDAvK5FATNxUEbKlkYq
	 sMfBMNMW8VeBFIA6J0hrD+DZmcf6hY83O9Pq9diK5IscwwdjFjAmWE4eEL7IxCvmT/1wN
	 SeqLzR512c/0QdSRDBl32tl/Jnc/kKsbpJ7nBthao5kelNILosyyW9ukvSN7eSBv8+Zl2
	 dIyS6eolzQ1TRatsRPCbm5j2QWfzn8lFfDd44MVFuU3NzHYh1S0ei5je4sqGpHNUvbf12
	 81ceqT8HPf/c1LZzW01rNrQFuo9/ERbdZcl3lypXzZohtkOE6F9kWDMrPOwmTzRd+dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6YK7K94zKeGDdUyNPh4kfd3uR9QkqWhbxxC4XfA+yn0=;
	b=0nN2MFj9i4aJ1bsw1n5Bltey+bzgpxvEzDBIGGlVH7BXWb59kZaOwU+Hb79rnc20U/jz
	 q9nAlb5l95Cc+zujEq6jQ4f/MESOVitCWNAqyQKtOrEJSYsPxd4aEJtUY5UtrqG+fqqoD
	 5XSoco1raD8/28gc7RTqW2QfT4Nmf8CQZ9wAhF75zT+NOj1icgrWDPYm/sxDXlU6Vy31q
	 5HmSGGAYMO8+DVK8wuaLmnRe7SxBK+Fp/DzXqkQflzCA3Cd5Xlt4Ds+itj7cxUZZwOzdj
	 Au1QStTWV7PXMyZYoHRfhv6ICQX6gqG0+wydyCpzuLYUsff2EwpvDvDVB8C0bgHyOsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLqSvN7z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405F0606A32F;
	Wed, 18 Nov 2026 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xLqSvN7z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FFC1F000C4;
	Wed, 18 Nov 2026 15:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015317;
	bh=6YK7K94zKeGDdUyNPh4kfd3uR9QkqWhbxxC4XfA+yn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLqSvN7z7fjc02bF7QOEimljHR7WMJF9v8zEMpSLcaTQiAKxw/p2uXaXOjmGhJEua
	 MuYjs/YMPKbxzyjFEV7A+l1zGZ1AtqcO/JvZub0JhGC2Oj4qIF2JKSZEiyjqrw+Evq
	 MuGJlTxAAW72UrE+EfcEcNkNvkL2CAajCdalsjEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0131/2651] dt-bindings: clock: qcom,milos-camcc: Add missing power-domains support
Date: Wed, 18 Nov 2026 15:22:51 +0100
Message-ID: <20261118150252.572962776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



