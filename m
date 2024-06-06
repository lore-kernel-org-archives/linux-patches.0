Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E8B1990B7;
	Thu,  6 Jun 2024 14:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683545; cv=none; b=mqygDnbZihXgC80te2k/HRLUlb0w231i4aOrORRBOIKrhOf0paKAAxuPvdejmcnDECkxPmt00AUnKNUukzQdzOnUw6ka4Lkt7PPMikOyjBRqforeRZ2qt4pLuCXhTXerCiZPTULOfGzVsZS+/t6CGdiZdUtcL1hx+KhkjsPgZig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683545; c=relaxed/simple;
	bh=M6Uwt9ci9pqRrawe+EvKQqOvaJdYdXzt0znlRmPmq1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDb86LdGRxLLbg8rjywEsL4LhmwRrD4WelKxeHCclOZGQkkQle6u54WoYLP/h2+EXfoSTsTrzpD+aiPCKuS0e6Y/ZLS8XFlrYEASlcaYeqHPklIsOnyyJsc0IzSdiwmjhBKgEchr3KRHquY2tOKNBRqIM8N08qoOZ8pcbgtr+Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1nCoORm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1nCoORm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287FCC2BD10;
	Thu,  6 Jun 2024 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683545;
	bh=M6Uwt9ci9pqRrawe+EvKQqOvaJdYdXzt0znlRmPmq1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1nCoORmdMtX0xlWcAVZVJ/XMwd5cqNOeVeV0CsL7zihT/Z+HcPph8l/gJy+9i7fO
	 F1TLW07EDJPBhVflMlOzMIhJb5eGqUofSRSLkKHTtNdhvao7d3bdxY8DAVP7LAAmi+
	 ix5U/tzRo5jQUTyg3DGzhGvnRJBTAgJJXJkwO9x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 484/744] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: fix msm899[68] power-domains
Date: Thu,  6 Jun 2024 16:02:36 +0200
Message-ID: <20240606131747.987478157@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 59e377a124dc9039d9554d823b1cb4942bcee9a0 ]

The Qualcomm MSM8996 and MSM8998 platforms don't have separate power
domain for the UFS PHY. Replace required:power-domains with the
conditional schema.

Fixes: dc5cb63592bd ("dt-bindings: phy: migrate QMP UFS PHY bindings to qcom,sc8280xp-qmp-ufs-phy.yaml")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-2-f1fd15c33fb3@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml  | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index d981d77e82e40..a6244c33faf61 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -71,7 +71,6 @@ required:
   - reg
   - clocks
   - clock-names
-  - power-domains
   - resets
   - reset-names
   - vdda-phy-supply
@@ -130,6 +129,21 @@ allOf:
         clock-names:
           maxItems: 1
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,msm8996-qmp-ufs-phy
+              - qcom,msm8998-qmp-ufs-phy
+    then:
+      properties:
+        power-domains:
+          false
+    else:
+      required:
+        - power-domains
+
 additionalProperties: false
 
 examples:
-- 
2.43.0



