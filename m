Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018820;
	b=3qL4a6vLtwYT5tjgjCCsMkGVWZW5Nd8mcQLiWH89dmqYRdUH3LFP1/WELgkPUU2yvwNZ
	 4bPqU5VCnJ9yIUp/ZHvgSG3l1ilhdEDans2JzCpfZCRfN7jkblG3fJV0yAkfd1DT8J5iN
	 FHTGJm6EfQE/671eVu4BIrRKs/hxyqAXCf75rxq/UiBur6Clm5vv4vxCZ03wntFG3d5fY
	 4IibT/pail139TvTJwWJ6zM2JeZULxix6hHhjYhYQiSrqTvP/hV1wZJ3ETcvwwiTd3cAE
	 QrVGy+zr8mF0bRj7T+9YPtQ79ybXnghonLEOGyxzzKvu7bT6Dndb8BDVG6218jwIjTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t/VO+Jk6TntiP8L9XW5VFdRxllRNbMX8uHuSd/5IlZM=;
	b=afRZfwwhcvfQnQ7wBdj9vIAdVVJSqycVutGS1DkCxiKdwUkpWr7QOMYnVqtPnhumghO7
	 scqlsFJSOhrjdYqvIxEhOA+HNGJIlcTExOWrxTXA003bqCi4RwJ3L+/1MzArcLZvoAKIT
	 OpF+Tsuxf9pgbZ2YAW2xXJEnRApGlGIVXLleJlTsd4Bjv7DIsenM0dXlvGc8U3SNWPKJS
	 wxmy/qXBdO4Jbi/IEkymqhYhXC0dC3TUqFs4zIgiq9+ESGhzYmbKBvQ4z5N8Ti0e6YeYb
	 lsWLMN+1HuzcqNyZHRlkP6WpMg8aGhdr22UmjGZn/bMXjHYSJea2xQ34hORrLF9sZKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cq+OB+lH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AFD60A2616;
	Wed, 18 Nov 2026 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cq+OB+lH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84551F000C4;
	Wed, 18 Nov 2026 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018820;
	bh=t/VO+Jk6TntiP8L9XW5VFdRxllRNbMX8uHuSd/5IlZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cq+OB+lHByIU37iz/pIgWweJeOrVZNwYANK/QNhU3cd5mIEiILDSusB/nyYiho6nk
	 Jrj9p+5kSZz7qLiLYRGlGAGRv1hIOb637R63tX0bdo2/Fl3jsD4DzcEx98NxQwDntv
	 OitjvFJKYYP3l31Pgnav9ty0vrD5yUTqQHVw+giQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1376/2651] dt-bindings: dma: dma40: Restore disabled-channels
Date: Wed, 18 Nov 2026 15:43:36 +0100
Message-ID: <20261118150337.568645836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d8f92838f4c9d..81b83603ea798 100644
--- a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
+++ b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
@@ -140,8 +140,22 @@ properties:
       - description: LCPA (Logical Channel Parameter Address) memory.
       - description: LCLA (Logical Channel Link base Address) memory.
 
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
       engine are eligible for memcpy transfers
 
-- 
2.53.0



