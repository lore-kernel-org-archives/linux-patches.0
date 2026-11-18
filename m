Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049350;
	b=cVhD9IDR915AacEu4of/JmMV/u2vZ+N2lnKjWbKWVmwQJgX7zOxboazLcE5s4+0/owIE
	 khrRNv19X438HWNebbB10ePH2caQfZJ22vORzCgVY890W4K0HnrSaxUKEbvHPWh5Jyj1D
	 cEQkhAP1AXWcTqK1S5v9WSi2yA+N1sEgthpZwoXu/WO6uvpvoiGyVUYNHmlDcZDx6m9zD
	 T6YOgVQ73dTSsNyTOa31QwCXIUKY1Rll4ovdwOuFukrJxtUTchWvJW3/hed4lWrRQsOyE
	 UTphAbJtE+PLd9cj8dP7MYzaQqSLh+28kC9a2JSrIlLjtCe4kGigUlaYNIcMXOdqFmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bpNGoQhmhb1Aax7H5wexBAcxI3zxRXn7vIM2j+e826g=;
	b=fxMcP7hUoV6Cs2BrNrEbnkDzJN15QMfq6J85NvbT+sjJjXIHO4M9gCgeGyrLcXt6K+8y
	 /acyBHJfYvVxWWlx7b0qm00ZCSyrZYLKIvQ4Skj8Mjz/i9xxKWRPLwXdVvawmbzg6rVQ8
	 R2w2wNmJSbh1UqMGEg+sav7S3BqPYjX4GWZEqhetjXTLVIz8ONVAkg6Pi8jPtxjEscNMd
	 UpUlyILC0RLEAVNSJttu1vqONC5FMVFf4HobJ+4KDKZXrqAthaqJYsDOfgNiyZ4YHE5lt
	 eRwxsZi/cDL2E6XuWIFKN8h/PRL8R/Kvj3289jMJmolokmdO+ngh4oM6CB6h5kSadRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zM9vExnr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AD2606A320;
	Thu, 19 Nov 2026 00:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zM9vExnr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61ACB1F000C7;
	Thu, 19 Nov 2026 00:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049349;
	bh=bpNGoQhmhb1Aax7H5wexBAcxI3zxRXn7vIM2j+e826g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zM9vExnr9BCwowAwviBZkLy15t8JTIUkT59TbZEOStiHowRLvM6/53Ap4RzCn3Xbl
	 4wdbY5iM7uPZluQhAr9QhnyrHumTLQ22O2G7ISOhmlt/Ow7CR9T+x9DPN71Gg3a7IU
	 B99JzaEywE7BFzAbprZUsu6o4Vif6HC3SHJ4PL+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2279/2857] dt-bindings: dma: dma40: Prefer to pass sram through phandle
Date: Wed, 18 Nov 2026 15:55:13 +0100
Message-ID: <20261118150323.517700206@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 4f080c77ec53ec619304c0bbee5f6762fe3207a0 ]

Extend the DMA40 bindings so that we can pass two SRAM
segments as phandles instead of directly referring to the
memory address in the second reg cell. This enables more
granular control over the SRAM, and adds the optiona LCLA
SRAM segment as well.

Deprecate the old way of passing LCPA as a second reg cell,
make sram compulsory.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230417-ux500-dma40-cleanup-v3-1-60bfa6785968@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 38d97b1122e0 ("dt-bindings: dma: dma40: Restore disabled-channels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/dma/stericsson,dma40.yaml        | 36 ++++++++++++++-----
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
index e847ec8bcc372..69094dfd9284f 100644
--- a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
+++ b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
@@ -112,14 +112,23 @@ properties:
       - const: stericsson,dma40
 
   reg:
-    items:
-      - description: DMA40 memory base
-      - description: LCPA memory base
+    oneOf:
+      - items:
+          - description: DMA40 memory base
+      - items:
+          - description: DMA40 memory base
+          - description: LCPA memory base, deprecated, use eSRAM pool instead
+        deprecated: true
+
 
   reg-names:
-    items:
-      - const: base
-      - const: lcpa
+    oneOf:
+      - items:
+          - const: base
+      - items:
+          - const: base
+          - const: lcpa
+        deprecated: true
 
   interrupts:
     maxItems: 1
@@ -127,6 +136,15 @@ properties:
   clocks:
     maxItems: 1
 
+  sram:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description: A phandle array with inner size 1 (no arg cells).
+      First phandle is the LCPA (Logical Channel Parameter Address) memory.
+      Second phandle is the  LCLA (Logical Channel Link base Address) memory.
+    maxItems: 2
+    items:
+      maxItems: 1
+
   memcpy-channels:
     $ref: /schemas/types.yaml#/definitions/uint32-array
     description: Array of u32 elements indicating which channels on the DMA
@@ -138,6 +156,7 @@ required:
   - reg
   - interrupts
   - clocks
+  - sram
   - memcpy-channels
 
 additionalProperties: false
@@ -149,8 +168,9 @@ examples:
     #include <dt-bindings/mfd/dbx500-prcmu.h>
     dma-controller@801c0000 {
         compatible = "stericsson,db8500-dma40", "stericsson,dma40";
-        reg = <0x801c0000 0x1000>, <0x40010000 0x800>;
-        reg-names = "base", "lcpa";
+        reg = <0x801c0000 0x1000>;
+        reg-names = "base";
+        sram = <&lcpa>, <&lcla>;
         interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
         #dma-cells = <3>;
         memcpy-channels = <56 57 58 59 60>;
-- 
2.53.0



