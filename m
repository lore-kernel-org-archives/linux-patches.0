Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B162C231829;
	Tue, 21 Jul 2026 19:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660563; cv=none; b=TLfe5A3/7AZBdCSY4tRt7Ger4JTLvuTHb7rnxG+7JA1B7F+oPDLZClrVCalgTOEn9O3ddMByH6PGUdUgYYMSPyhv9000Ts+c/DcXy4dAN7mu/NTwTjeDsrrqR34Nw7SKv4fadHULLifI8tMGz30C+74mPptGYNS744Lho1XaC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660563; c=relaxed/simple;
	bh=nqy2TwDIWGQmD33kqM528yvWzCllsPcBm4pE6CrIXtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3581gthv6nO+J7LnT2013uGXmQ8P8FO4xbkdviyDniC76t3e/RAKYrTzEk8Zdebn7Kkfb+qyxKYt44Z4AOU9Ok6qC/eFDrAP1v00D5VKrnj8Qt/yyPOeWW8hsF/Iaf55Gm8CxvgMiP1CWnAHSbvI7pkF6kxsWsirRgpGGW4qS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qpz+hwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qpz+hwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025031F000E9;
	Tue, 21 Jul 2026 19:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660560;
	bh=xE/oVsbPMJ3Xvs2iewlDZmfbzOhjSEmRcANQrZJ+FRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2qpz+hwTb/ljJTUt+F0vN2AADr5nY1ZxC5M6Vne6i/6P1cK8AM6v9qII9pmpC+s8S
	 CCdDAZi3r4A45OkIFvf7EvYCfo0ExUdC41LVFZ+BH/yBPfbMChbijRJ7AvBHKrpo7B
	 m+hQcyCsVQo9TET7BuWqNefmaW0TYITVcHT1QelM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1027/2077] dt-bindings: phy: sc8280xp-qmp-pcie: Disallow bifurcation register on Purwa
Date: Tue, 21 Jul 2026 17:11:40 +0200
Message-ID: <20260721152617.042606022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit b3ee497970c63cea37976aeaa84bac39611fe0eb ]

Neither of the two Gen4x4 PHYs found on Purwa supports bifurcation.
The PHY is however physically laid out as if it were to, since there
are two separate ports (A/B).

Split out a new if-then block to un-require the bifurcation register
handle to squash this warning:

purwa-iot-evk.dtb: phy@1bd4000 (qcom,x1p42100-qmp-gen4x4-pcie-phy): 'qcom,4ln-config-sel' is a required property

Fixes: 2e1ffd4c1805 ("dt-bindings: phy: qcom,qmp-pcie: Add X1P42100 PCIe Gen4x4 PHY")
Reported-by: Rob Herring <robh@kernel.org>
Closes: https://lore.kernel.org/linux-arm-msm/176857775469.1631885.16133311938753588148.robh@kernel.org/
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260610-topic-purwa_phy_shutup_warning-v2-1-951c1fbfe9b2@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml    | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
index 3a35120a77ec0c..431e8cb5df84e9 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-pcie-phy.yaml
@@ -136,13 +136,22 @@ allOf:
           items:
             - description: port a
             - description: port b
-      required:
-        - qcom,4ln-config-sel
     else:
       properties:
         reg:
           maxItems: 1
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,sc8280xp-qmp-gen3x4-pcie-phy
+              - qcom,x1e80100-qmp-gen4x4-pcie-phy
+    then:
+      required:
+        - qcom,4ln-config-sel
+
   - if:
       properties:
         compatible:
-- 
2.53.0



