Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172536BFBB;
	Tue, 14 May 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683452; cv=none; b=MMqZss+ulW2qf8Cjx5JGGoWqinqZF5M24rpFT2R7BJb2mthXRoPkmsvIa2dsHlQCWMJFTNVNpEz3RiAyNicggKve08NPHjNVWs3RDFX4JWYXLXJj5J6E8oYPVR1VnS5Ef4lVN1LIa8QJyfP1wV8gOOKSyleBpdVvklnLL+JMtGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683452; c=relaxed/simple;
	bh=312FFyGUHSCTnybX8ftzEW0F2gN3iSzsOifGkJoB7zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8d+Jb6BgIDpqN40vDeeU7LjtkYle/KNDjpqptnwMApDuXdQSy85XRz5y3fPHVpK/BizEuBMI6c8WhOcIAPFUuh5IamqOsUA6XxwZ7VIPxjcmfcfPyu5T4by41BY6DYm1EIgmCFXamVCsFZ7RtDO8Xh25YIZG7qlQaHT7iRtZhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmfJZbuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmfJZbuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C859C2BD10;
	Tue, 14 May 2024 10:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683451;
	bh=312FFyGUHSCTnybX8ftzEW0F2gN3iSzsOifGkJoB7zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmfJZbuPmI7NkULi7fcPeC/QdSzmgEVEzy62n9L+tgx6d95rIJ7r/CiOLMy28fdhh
	 JzAhqmEpMylT4mKxsApEKaeYEqlznDfaepLvurYYK2+ZkBu2GEHIZBzuxQhgCG0G+5
	 OAU1kMlIsmn7+MtWW4rOquzTaK2WI39PkAOcoJJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 219/336] dt-bindings: net: mediatek: remove wrongly added clocks and SerDes
Date: Tue, 14 May 2024 12:17:03 +0200
Message-ID: <20240514101046.883724137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit cc349b0771dccebf0fa9f5e1822ac444aef11448 ]

Several clocks as well as both sgmiisys phandles were added by mistake
to the Ethernet bindings for MT7988. Also, the total number of clocks
didn't match with the actual number of items listed.

This happened because the vendor driver which served as a reference uses
a high number of syscon phandles to access various parts of the SoC
which wasn't acceptable upstream. Hence several parts which have never
previously been supported (such SerDes PHY and USXGMII PCS) are going to
be implemented by separate drivers. As a result the device tree will
look much more sane.

Quickly align the bindings with the upcoming reality of the drivers
actually adding support for the remaining Ethernet-related features of
the MT7988 SoC.

Fixes: c94a9aabec36 ("dt-bindings: net: mediatek,net: add mt7988-eth binding")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/1569290b21cc787a424469ed74456a7e976b102d.1715084326.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/net/mediatek,net.yaml | 22 ++-----------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
index e74502a0afe86..3202dc7967c5b 100644
--- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
+++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
@@ -337,8 +337,8 @@ allOf:
           minItems: 4
 
         clocks:
-          minItems: 34
-          maxItems: 34
+          minItems: 24
+          maxItems: 24
 
         clock-names:
           items:
@@ -351,18 +351,6 @@ allOf:
             - const: ethwarp_wocpu1
             - const: ethwarp_wocpu0
             - const: esw
-            - const: netsys0
-            - const: netsys1
-            - const: sgmii_tx250m
-            - const: sgmii_rx250m
-            - const: sgmii2_tx250m
-            - const: sgmii2_rx250m
-            - const: top_usxgmii0_sel
-            - const: top_usxgmii1_sel
-            - const: top_sgm0_sel
-            - const: top_sgm1_sel
-            - const: top_xfi_phy0_xtal_sel
-            - const: top_xfi_phy1_xtal_sel
             - const: top_eth_gmii_sel
             - const: top_eth_refck_50m_sel
             - const: top_eth_sys_200m_sel
@@ -375,16 +363,10 @@ allOf:
             - const: top_netsys_sync_250m_sel
             - const: top_netsys_ppefb_250m_sel
             - const: top_netsys_warp_sel
-            - const: wocpu1
-            - const: wocpu0
             - const: xgp1
             - const: xgp2
             - const: xgp3
 
-        mediatek,sgmiisys:
-          minItems: 2
-          maxItems: 2
-
 patternProperties:
   "^mac@[0-1]$":
     type: object
-- 
2.43.0



