Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049353;
	b=UNeftyvfDt5NqC8oDWC5l0MoPonkV+kEsfM/AhVKGzJT0Hb/LYQlOaMB5FPT+HOAxcJT
	 3d4stGMDYKPMseCRj26swDDeCH3IkbWvPDsunPC5KEairximLh4FAtOQOVP7helmSlsGl
	 jCQanhVm0ZUc5+OXty0pclQsU9gXcxkudVPfufBLXyegXvxUsRcg8asezArwMGmVNSKYG
	 RX27cbCzItLFHNk+8H1zJKMWMrPg20HxezbVnrKSUtps4apFls/DtrGd96u9Xs3VylW9M
	 6M5HrVxRg+ClJ3N3dFJfZeMyb16mmgmFIOZnTEeLxsHDTMDRAZ9w5C8/zuyCwgLcZRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTG43dKiOfSnARixBkCbmdpbr2wVUYXgLT93mzREn9g=;
	b=Jd52bdYFH4Nw+S0SGWJjALMvA1a78bCkrWZwmCCL4U7KmuPZHvXbhPVo6g3LqGgqN3Si
	 0qAbsn/KPsu1ywm5TGsOq1oErbg1n2ax5i/xoB3HhuFLg5Nqelh2S0H25K50Cc+vF7P8f
	 h/ScAsIUZuYTnZG3VHXtdb38xPP9oNzQe90xJn15fFFwAW0ZWxm9dxE0M9eLtSFwI+lJT
	 djFbxSRibGyYevTQHeATCM7wwzHdUAaJMV1RU9a3rOgo02S+9junTRB5NIpHhtORi5c+U
	 McdlqSIAxXY/IekGfgBOYIZDpytoF2uBekFE/R2X+yfqHcQup+6+ovUWPnE5vwgOIfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCETFlKs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3F0606A32C;
	Thu, 19 Nov 2026 00:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CCETFlKs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8271F000C8;
	Thu, 19 Nov 2026 00:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049352;
	bh=QTG43dKiOfSnARixBkCbmdpbr2wVUYXgLT93mzREn9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CCETFlKsq8vXrSPWLKWl2PoRLUjLGjDZM7ZwM/WoT39NW0uzG97K08maUY8NMz88h
	 WtKJ6s1a4WJRamS4s/4X6EAxZ4/mf4pDJ3EeSP9ZCZgo3qix+CdLR7LjaSBLzROj6a
	 k2PyuCKNKq5HaWt0QFFmPLsRaCIzM4TqUOSow6cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2280/2857] dt-bindings: dma: dma40: Restore disabled-channels
Date: Wed, 18 Nov 2026 15:55:14 +0100
Message-ID: <20261118150323.552804995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 38d97b1122e02f6b8859e660990aaeda1c32e00f ]

The conversion of the DMA40 binding to YAML omitted the optional
disabled-channels property from the original text binding. The driver still
parses this property, but additionalProperties: false rejects any device
tree using it.

Restore disabled-channels and constrain it to the physical channel range.
Also constrain memcpy-channels to the limits enforced by the driver and
reject duplicate channel entries in both properties.

Fixes: 23fbc87c8ae6 ("dt-bindings: dma: Rewrite ST-Ericsson DMA40 to YAML")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260918-dma40-dt-disabled-channels-v1-1-0f691109d8d3@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/dma/stericsson,dma40.yaml  | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
index 69094dfd9284f..3f754fc17c382 100644
--- a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
+++ b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
@@ -145,8 +145,22 @@ properties:
     items:
       maxItems: 1
 
+  disabled-channels:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    maxItems: 31
+    uniqueItems: true
+    items:
+      maximum: 31
+    description: Physical channels that cannot be used by the DMA engine.
+
   memcpy-channels:
     $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 1
+    maxItems: 8
+    uniqueItems: true
+    items:
+      maximum: 63
     description: Array of u32 elements indicating which channels on the DMA
       engine are elegible for memcpy transfers
 
-- 
2.53.0



