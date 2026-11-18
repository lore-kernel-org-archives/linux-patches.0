Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049347;
	b=hqw3HKaBRKWIXD08ghpnV5wVe/Y5PLRJTXsXRpiusmdR2R0SsuoW1mYGUNyxBl5rignr
	 FOy3QNS62wksKuZOxxmkiDAPNh44NyCptlGxcFIzlN7X9gGnA3hzN9epi3N13ZBY8ojAw
	 yAmNVBFFH8TLuyU4T6xPabjjRV1Oue9xdKzlused9gNppSUXMNyIp8QnmGb5l61zlJICj
	 3/udhvYQBfH6U+iPsdSeCcNgEU6E4rqqDSIbpGo7GXf6BavuKpaSLYe23xvY5LeVBxyVH
	 08tJ0g4gqd3KvkS/1EniZfVUyUsMwqZVblzxsl2EfZDC7Xwv5NBiNA5ntxUgz69w8gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bYRuYqUNvbUOgMtdRFfr/74HBABLG9fjCKvB5TdryYs=;
	b=bi+Uihkg0XJYL7larzZzEN4URmRDydVO6sDyOy722NAhAU21WCxrsFYNrRqRYNIKoWVN
	 53jpeZK422i8QunXmR4ddtAyGb9s7MTHwNwzsYEmPlGfTjuV0x6QXPcM4U7hhrQvK82n3
	 UhAG7Hv/twl7T2gXqVcxkPsLpbSAcnaaL9HbpzjYNyjb902XmvhvStSLWVAK6CJKcA/Zm
	 1ia3fAByDILn5QMz6wp3DnvRcwyansyixDGjzmv7J0iKyQBdFBSf1++SoLyKZCSChGJpw
	 3QM2kBU/fbqNn0baLz+XuNS8zg+nTE0HXzQvFJA5Z4+D0DLDglCrqrkcuE6bZJ6H8yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csfaYNuK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA7660A2604;
	Thu, 19 Nov 2026 00:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=csfaYNuK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843EF1F000C4;
	Thu, 19 Nov 2026 00:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049347;
	bh=bYRuYqUNvbUOgMtdRFfr/74HBABLG9fjCKvB5TdryYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=csfaYNuKG/94sDnvE6PbOlIu3OGFa+rGuwvIJa+PuL25ce1K8tlSz6tviDHokvRlB
	 mDtKX2VTOJnGgwDn7Uicsb8dS9QHC0qweIe6YjS0eDkXpvINvi4dDKL5SQpi1z1QC2
	 nwttJFpNjcRoNvhpE/4RUqeRyMKmMuANmv6kdN5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2278/2857] dt-bindings: dma: cleanup examples - indentation, lowercase hex
Date: Wed, 18 Nov 2026 15:55:12 +0100
Message-ID: <20261118150323.481788591@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 837b2fafd4cf3e336ab1127c3738c35eba866123 ]

Cleanup examples:
 - use 4-space indentation (for cases when it is neither 4 not 2 space),
 - use lowercase hex,
 - drop unused node's label.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20230124081117.31186-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 38d97b1122e0 ("dt-bindings: dma: dma40: Restore disabled-channels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/dma/snps,dw-axi-dmac.yaml        | 36 +++++++++----------
 .../bindings/dma/stericsson,dma40.yaml        | 16 ++++-----
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml b/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml
index 67aa7bb6d36aa..18b55a2ec7052 100644
--- a/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml
+++ b/Documentation/devicetree/bindings/dma/snps,dw-axi-dmac.yaml
@@ -114,21 +114,21 @@ additionalProperties: false
 
 examples:
   - |
-     #include <dt-bindings/interrupt-controller/arm-gic.h>
-     #include <dt-bindings/interrupt-controller/irq.h>
-     /* example with snps,dw-axi-dmac */
-     dmac: dma-controller@80000 {
-         compatible = "snps,axi-dma-1.01a";
-         reg = <0x80000 0x400>;
-         clocks = <&core_clk>, <&cfgr_clk>;
-         clock-names = "core-clk", "cfgr-clk";
-         interrupt-parent = <&intc>;
-         interrupts = <27>;
-         #dma-cells = <1>;
-         dma-channels = <4>;
-         snps,dma-masters = <2>;
-         snps,data-width = <3>;
-         snps,block-size = <4096 4096 4096 4096>;
-         snps,priority = <0 1 2 3>;
-         snps,axi-max-burst-len = <16>;
-     };
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    /* example with snps,dw-axi-dmac */
+    dma-controller@80000 {
+        compatible = "snps,axi-dma-1.01a";
+        reg = <0x80000 0x400>;
+        clocks = <&core_clk>, <&cfgr_clk>;
+        clock-names = "core-clk", "cfgr-clk";
+        interrupt-parent = <&intc>;
+        interrupts = <27>;
+        #dma-cells = <1>;
+        dma-channels = <4>;
+        snps,dma-masters = <2>;
+        snps,data-width = <3>;
+        snps,block-size = <4096 4096 4096 4096>;
+        snps,priority = <0 1 2 3>;
+        snps,axi-max-burst-len = <16>;
+    };
diff --git a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
index 8bddfb3b6fa0b..e847ec8bcc372 100644
--- a/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
+++ b/Documentation/devicetree/bindings/dma/stericsson,dma40.yaml
@@ -147,13 +147,13 @@ examples:
     #include <dt-bindings/interrupt-controller/irq.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
     #include <dt-bindings/mfd/dbx500-prcmu.h>
-    dma-controller@801C0000 {
-      compatible = "stericsson,db8500-dma40", "stericsson,dma40";
-      reg = <0x801C0000 0x1000>, <0x40010000 0x800>;
-      reg-names = "base", "lcpa";
-      interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
-      #dma-cells = <3>;
-      memcpy-channels = <56 57 58 59 60>;
-      clocks = <&prcmu_clk PRCMU_DMACLK>;
+    dma-controller@801c0000 {
+        compatible = "stericsson,db8500-dma40", "stericsson,dma40";
+        reg = <0x801c0000 0x1000>, <0x40010000 0x800>;
+        reg-names = "base", "lcpa";
+        interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+        #dma-cells = <3>;
+        memcpy-channels = <56 57 58 59 60>;
+        clocks = <&prcmu_clk PRCMU_DMACLK>;
     };
 ...
-- 
2.53.0



