Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689268F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB3DC433C8;
	Sun, 16 Jul 2023 20:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538144;
	bh=eN9iYqE3h29MCPXsOIWVhvu5qLv12dE3Wtzh5T33h5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6cjqmedQB3nihEbCwnptL65rNR6oXbDh6tZqSckWb3PyQjm4BBYcb5YEOeEO/Xqs
	 IFg0T5GklOFUvyNhhIeB/x5+VpIxEqXjCkwouKqIieNMz39oCuLjYkZVQB2UsuZ3Ap
	 h/XbQTtEXCaPD0s5HfNwlUhWyF3ueIhIND+uafwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 345/800] dt-bindings: arm-smmu: Fix SC8280XP Adreno binding
Date: Sun, 16 Jul 2023 21:43:18 +0200
Message-ID: <20230716194957.094429276@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 84b8a7fe29205016cffd4eff91b45830d318b53d ]

The qcom,sc8280xp-smmu-500 Adreno SMMU binding has clocks, so fix up the
binding to allow this.

Fixes: 38db6b41b2f4 ("dt-bindings: arm-smmu: Add compatible for Qualcomm SC8280XP")
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230523010441.63236-1-quic_bjorande@quicinc.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iommu/arm,smmu.yaml | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
index ba677d401e240..6cb04f35642aa 100644
--- a/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
+++ b/Documentation/devicetree/bindings/iommu/arm,smmu.yaml
@@ -80,6 +80,7 @@ properties:
         items:
           - enum:
               - qcom,sc7280-smmu-500
+              - qcom,sc8280xp-smmu-500
               - qcom,sm6115-smmu-500
               - qcom,sm6125-smmu-500
               - qcom,sm8150-smmu-500
@@ -331,7 +332,9 @@ allOf:
       properties:
         compatible:
           contains:
-            const: qcom,sc7280-smmu-500
+            enum:
+              - qcom,sc7280-smmu-500
+              - qcom,sc8280xp-smmu-500
     then:
       properties:
         clock-names:
@@ -416,7 +419,6 @@ allOf:
               - qcom,sa8775p-smmu-500
               - qcom,sc7180-smmu-500
               - qcom,sc8180x-smmu-500
-              - qcom,sc8280xp-smmu-500
               - qcom,sdm670-smmu-500
               - qcom,sdm845-smmu-500
               - qcom,sdx55-smmu-500
-- 
2.39.2



