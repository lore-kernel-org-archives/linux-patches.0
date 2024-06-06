Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AD719EEB3;
	Thu,  6 Jun 2024 14:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683546; cv=none; b=mLtcYsKOQpPW4frC5facDO40+2VfOBHafixAnUrXGNaVk5aBtE7olWGt1z+DGm5yRLqO41zsfM/6kLpLOj/YOLtURTz4OdFg0MhmrAqfnSEmFiBPG/SFLj4IoFr81lU1iaNMz2w8rMcofOG58vEHvhnheU43PnkCNrJe/+WRb4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683546; c=relaxed/simple;
	bh=Gxvhj/Te6+XYlovXdHhjx7c8V311ge2hIZITbqxMo6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA5TfChhsxlOTc0fjfPSzx6B3xejEnrqjz21guTGBGYwAUWgSmhqKG5DNfqF0hkJTlYu+7tL4E1WIhT5+waPJS+9sAYq54we5IT2POvzOy/Og0fMLifl8uCNPpYXzIMo13yAQ0mVutKsNIy3hB9CQXxTIuWD7B+GAI/nwAY4pxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4TYD6gT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4TYD6gT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE61C2BD10;
	Thu,  6 Jun 2024 14:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683546;
	bh=Gxvhj/Te6+XYlovXdHhjx7c8V311ge2hIZITbqxMo6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4TYD6gThrIvbO5ZSABtqtr2PwulhGQvB6ePlDwQejxzWeZE0zeMrN8NpyzPRiQsj
	 yVLrWYyCBx9zYItgFKMGDdQ4zYXCE+1m22mLXlzygHvjiA0Sxcs8shSHOi3jhPq1RL
	 38mipm0JkQoCEwIr1KtMz2fISyBMMlVw95Y79hKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 485/744] dt-bindings: phy: qcom,usb-snps-femto-v2: use correct fallback for sc8180x
Date: Thu,  6 Jun 2024 16:02:37 +0200
Message-ID: <20240606131748.018583963@linuxfoundation.org>
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

[ Upstream commit 960b3f023d3bda0efd6e573a0647227d1115d266 ]

The qcom,sc8180x-usb-hs-phy device uses qcom,usb-snps-hs-7nm-phy
fallback. Correct the schema for this platform.

Fixes: 9160fb7c39a1 ("dt-bindings: phy: qcom,usb-snps-femto-v2: use fallback compatibles")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-3-f1fd15c33fb3@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml       | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
index 0f200e3f97a9a..fce7f8a19e9c0 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-snps-femto-v2.yaml
@@ -15,9 +15,6 @@ description: |
 properties:
   compatible:
     oneOf:
-      - enum:
-          - qcom,sc8180x-usb-hs-phy
-          - qcom,usb-snps-femto-v2-phy
       - items:
           - enum:
               - qcom,sa8775p-usb-hs-phy
@@ -26,6 +23,7 @@ properties:
       - items:
           - enum:
               - qcom,sc7280-usb-hs-phy
+              - qcom,sc8180x-usb-hs-phy
               - qcom,sdx55-usb-hs-phy
               - qcom,sdx65-usb-hs-phy
               - qcom,sm6375-usb-hs-phy
-- 
2.43.0



