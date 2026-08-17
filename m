Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB72442B2F;
	Mon, 17 Aug 2026 13:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975068; cv=none; b=ZlWO3y9C1TZzvrlKsICwvBptPZdZOatDNmPnxyBEi+kf3GUH10CRdq45HBlItVZp9TJDl0VT5Gq8BZD/Z8Egn+yealA/hzspB6MvMeVYZDc+SFZKCuaBnTELiJme2yGdnsHQgBnUaunx2adil5VQXm1fdjnksxS+dikEmWBhQs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975068; c=relaxed/simple;
	bh=uDYdvX/MfF6PSKNJr8B2lPL2M2/GtFOtYKOfycWtmFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv21qHwtEXtYIlNznKW8dyRiq7M6kcy3usYgRG7JFxQYJWVAXfsVxkwSK/9vz/0L1hun4tUEiaViVcBlVRj57yHqD8if1/R0w6vL5zkGz6iLN4FaCWwUMRpjMiXKadX8VImsXRIAHAcyzfNHjrRFvghA3fKIN/GZ3FFHHPNy+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xN1cPmEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xN1cPmEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218431F000E9;
	Mon, 17 Aug 2026 13:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975067;
	bh=OH3ScFurLeC/VSGrOMKQ7UGeXzweGSYjY3cU5i/HsTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xN1cPmEvUW9y9t90Ol4BsqrOxCxfydYz+YUvjG/vNbqjA3GCizM9dOy3C3JvD8NPc
	 Qky4MAGkJ9f9kODriHiJkbUJBBV0rSXJNfdDxmJ1o+i2VXQPKV3o5ouGRlKQwQJ1Ly
	 gMgUVDizzEUsWtnVk7CalyfgWVkT71Nfjq+wUDhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Harshal Dev <harshal.dev@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/250] dt-bindings: crypto: qcom,ice: Fix missing power-domain and iface clk
Date: Mon, 17 Aug 2026 15:31:51 +0200
Message-ID: <20260817132542.676827551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 08fe6a707a371..70aa5193800e5 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -27,6 +27,16 @@ properties:
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
@@ -44,6 +54,10 @@ examples:
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



