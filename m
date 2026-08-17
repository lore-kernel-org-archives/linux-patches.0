Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1478A3DA5A7;
	Mon, 17 Aug 2026 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978126; cv=none; b=g8JpsDCvRkxUsAMWiNVxueIZEvFDtmOHJcAu0PPucjQRqnnnQdFFzqK2ICkYS0TQTxOyIf4FBLxdgzC5vzPzKiLeMdGj5r8yTFGceB4YW5DCUpP0YFajvMUsPFm+smxcMEZGxRCPFcF9AcLXUk5mi/mL4RE2EtFkOhPbS9LTkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978126; c=relaxed/simple;
	bh=BrbSvNVDDXvHxjAI4sxrihnzOyoXB3j2hIjGwN0c06o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHbue+DyJqnkp7DftiH26CNW52mgf1P8w1Nlgn4aQDsm8vPwdalQOQFYVFZdwTT3yywsp4JMlaaQ1cNIi8nZcG4DhOXniwWOMIfcAQtHRyyG+4PcJTFfM0h/sboQJPXw35HG16n5oeCQwUP/IhhqO/q5DYyhrNu/MJWK5W/kWEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1tHvMHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1tHvMHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7921F00A3D;
	Mon, 17 Aug 2026 14:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978125;
	bh=Llq0/cekY2rLzNkjLtjnc1ZLhGCYT5LZ248uPV1RUcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1tHvMHNpZ++4uUjYtFoIFJMWsOo1yLLDOfqwdUvDx9J9l1BW3YcSeI55aHnTK/Il
	 68kOla8wSxxtDh3YleZaofYqC2+mHgHqyEhgHp8sSI8u2A54IE333w9yrsk71TV03M
	 0nlPdpWVyxOPTlMOKLeUjqfXWkGHnKyenpZ7a3a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/181] dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk
Date: Mon, 17 Aug 2026 15:33:23 +0200
Message-ID: <20260817132539.796415293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
index 0304f074cf085..2793afc7f85c4 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -25,6 +25,16 @@ properties:
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
@@ -42,6 +52,10 @@ examples:
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



