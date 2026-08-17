Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E8439F71;
	Mon, 17 Aug 2026 14:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978603; cv=none; b=nEBhk/uXfIC5kHImeW8Gbp46weTUcIMu0hZ3ML/nZH56IKpQUwdVta7FANK1TEUbQTP1QiS/c93ydqSR9LqeDMKQMkAiYoARraoGrT7rVUvabccp5AoJ3Mv2aDClAobZyAIMXYvIANUTZwXILtILBy8sPPwE7beJn75BkTFfcp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978603; c=relaxed/simple;
	bh=XZsYzUlMkpeAdCpQj9VqR/AWgKwiQMBXi98raS5d2O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQmejolqkoTfA0LJ6jgAQsDNpQqrhOSGtDRirgnaF6jID23HvRkttpqoPHbodP10KLrLT/uNJnRpJKRcsMp2rM0NZ8moOxU7hoZ0n4N/GR81FvTVq7V/7usJ+f3s6bAa/WesiCyNS+uvUWYJIs9LYYyUY3PofpxKH4ElC3pgIWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wf32PADQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wf32PADQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF0C1F000E9;
	Mon, 17 Aug 2026 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978601;
	bh=2/W0dcxvb1JyhXF5laFKkYJSGVnYLqt3iDuQB1XW5vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wf32PADQ+J4wY0nYIEuzSJyVdSFTdlkOdlR9vDEr/J9FedeAoank7p3AdVm2T9X9N
	 h3NePy3elhVs+/tZZQhZ56REPFUIYK/mjl/EdYiMOc1FORellcPQzEKKlVHqnnKQvd
	 8QjXk5lN9d0Yx7/zPeiv89IXhKIdNXBg6lyyP6OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/156] dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk
Date: Mon, 17 Aug 2026 15:33:48 +0200
Message-ID: <20260817132538.296283688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Harshal Dev <harshal.dev@oss.qualcomm.com>

[ Upstream commit e27264daac7d9ce892a2a5b4a864d6d9a3c9276a ]

The DT bindings for inline-crypto engine do not specify the UFS_PHY_GDSC
power-domain and iface clock. Without enabling the iface clock and the
associated power-domain the ICE hardware cannot function correctly and
leads to unclocked hardware accesses being observed during probe.

Extend and fix the DT bindings for inline-crypto engine by allowing
description of the iface clock and UFS_PHY_GDSC power-domain.

This patch has been adapted from the mentioned upstream commit to drop
references to Eliza and Milos Qualcomm platforms which do not exist
on the stable tree. Thus, patch now fixes the original commit which
introduced the DT binding for Qualcomm inline-crypto engine.

Fixes: f6ff91a47ac5 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../crypto/qcom,inline-crypto-engine.yaml        | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 7da9aa82d8374..69731ff62c653 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -21,6 +21,16 @@ properties:
     maxItems: 1
 
   clocks:
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core
+      - const: iface
+
+  power-domains:
     maxItems: 1
 
 required:
@@ -38,6 +48,10 @@ examples:
       compatible = "qcom,sm8550-inline-crypto-engine",
                    "qcom,inline-crypto-engine";
       reg = <0x01d88000 0x8000>;
-      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
+      clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>,
+               <&gcc GCC_UFS_PHY_AHB_CLK>;
+      clock-names = "core",
+                    "iface";
+      power-domains = <&gcc UFS_PHY_GDSC>;
     };
 ...
-- 
2.53.0



