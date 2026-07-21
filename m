Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAA0231829;
	Tue, 21 Jul 2026 19:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660559; cv=none; b=XKEZB8FOvIygJuCYp/axUcloDYcfhNeVmpUIMUB6N0Qi5p1jh8ZHBHDgScjjXa/apSGFJEZkhSFg/7qwvwOEjPJOcgiJpTyH/mGq0FMWcA7IsqKNmO0NLcZmHME6FbDjJLN6TNRGSmIJQgaeafJdxSsXUx7jvct50v8R8DzKXms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660559; c=relaxed/simple;
	bh=+99zQMOq+xtEk3RX97JfLAvDQ9wZ+r8v5UtGJu/ZcKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Es6quT+68Qz8GmTw8dippy0jfBfeuRE2WJi0h2w6mfBNUM3BeJf92Wwfl1iFTR5/sc4pP7ebanrLrJthFc/njRpcvyrgnQfwdlP0m5SJZ14dylgbS34HJEdiaVoRNam4/lunMezbf4BZM+uBN9iUCoonoUFMh5aKX3Ce9HRghhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhbFnLbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhbFnLbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4870A1F00A3A;
	Tue, 21 Jul 2026 19:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660557;
	bh=wjYEhLXZ0EHWkjT5GAd0yo+QL6bcL5E9EHicRFh3mAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nhbFnLbfrOW/cymGYSIBPkmnDxaAoEg67XvvXClP2d29rKevCSYgriQMTT+wZZJLB
	 FLBA3ZOfSlmq5XYyyXA/2ntaZ0HQcD2zSNa+BjXm26HLZKsceZ1Qq0ZoD01R6cjON8
	 YLYfzjC+49c0A4n7VMUVQa9ToAdci1H1O6+LEQRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1026/2077] dt-bindings: dma: snps,dw-axi-dmac: Add fallback compatible for CV1800B
Date: Tue, 21 Jul 2026 17:11:39 +0200
Message-ID: <20260721152617.019218642@linuxfoundation.org>
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

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 7524fe142b5a772f8421aeee2132cf7e21a00103 ]

The previous version of the binding change only add compatible
string without adding the fallback compatible, this breaks
backward compatibility. Add the needed fallback compatible to
fix this.

Fixes: be3e2a0419c6 ("dt-bindings: dma: snps,dw-axi-dmac: Add CV1800B compatible")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260511063818.463877-2-inochiama@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml b/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml
index 804514732dbe65..0a30a455b0ee54 100644
--- a/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml
+++ b/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml
@@ -21,11 +21,12 @@ properties:
       - enum:
           - snps,axi-dma-1.01a
           - intel,kmb-axi-dma
-          - sophgo,cv1800b-axi-dma
           - starfive,jh7110-axi-dma
           - starfive,jh8100-axi-dma
       - items:
-          - const: altr,agilex5-axi-dma
+          - enum:
+              - altr,agilex5-axi-dma
+              - sophgo,cv1800b-axi-dma
           - const: snps,axi-dma-1.01a
 
   reg:
-- 
2.53.0



