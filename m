Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A9C611F
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F07FC4339E;
	Sun, 28 May 2023 19:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303346;
	bh=0t5/Jf2pzqiVkqPdrBDRuw7894PBcg5OUxpWzXCOAxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+wtnVf5C5RYNccaOkB4qGK6zGEND3x9Prh2X04CiqaDaLRFKQIEzzpGbn4cPQKjw
	 cqv1GhAXNVC0UHZJ2+jYLHtWsj+ESVf2/DlKXG3EMh0NHgiRUsNkLigag+P0jCEr4W
	 jZGPZZk1cW09cmOFrwSKgenIdeQfpZSxEXx92ufI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/69] dt-bindings: ata: ahci-ceva: Cover all 4 iommus entries
Date: Sun, 28 May 2023 20:11:24 +0100
Message-Id: <20230528190828.502933386@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit a7844528722619d2f97740ae5ec747afff18c4be ]

Current only one entry is enabled but IP itself is using 4 different IDs
which are already listed in zynqmp.dtsi.

sata: ahci@fd0c0000 {
	compatible = "ceva,ahci-1v84";
	...
	iommus = <&smmu 0x4c0>, <&smmu 0x4c1>,
		 <&smmu 0x4c2>, <&smmu 0x4c3>;
};

Fixes: 8ac47837f0e0 ("arm64: dts: zynqmp: Add missing iommu IDs")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Michal Simek <michal.simek@amd.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml b/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml
index 9b31f864e071e..71364c6081ff5 100644
--- a/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml
+++ b/Documentation/devicetree/bindings/ata/ceva,ahci-1v84.yaml
@@ -32,7 +32,7 @@ properties:
     maxItems: 1
 
   iommus:
-    maxItems: 1
+    maxItems: 4
 
   power-domains:
     maxItems: 1
-- 
2.39.2



