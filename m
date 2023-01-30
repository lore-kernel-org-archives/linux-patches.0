Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CDA28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD80C433EF;
	Mon, 30 Jan 2023 14:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087746;
	bh=/tnghT1D09Nt123/1AO7Ae5/si0ZjEEbhzKYyHQkw/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x04pn2BBUCf+HVjXFmglN0a+tfhU/1bvB3gGbQxe8k217vC1jCFMlHgA1RQAPVcKJ
	 0VMmw0h1eLwCOGwSES9jbSuI4rJa/aEKwVlvEAtDV2gjj1IQOtmD5rtc2KK1wAuzdW
	 0OD+cpZ/Zbrda9xrubqms0mhK4zMONEx8yXRj9Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 6.1 311/313] dt-bindings: i2c: renesas,rzv2m: Fix SoC specific string
Date: Mon, 30 Jan 2023 14:52:26 +0100
Message-Id: <20230130134351.236693583@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

commit 0a4eecf96c640886226f1ca7fdbb11bb20bc55b9 upstream.

The preferred form for Renesas' compatible strings is:
"<vendor>,<family>-<module>"

Somehow the compatible string for the r9a09g011 I2C IP was upstreamed
as renesas,i2c-r9a09g011 instead of renesas,r9a09g011-i2c, which
is really confusing, especially considering the generic fallback
is renesas,rzv2m-i2c.

The first user of renesas,i2c-r9a09g011 in the kernel is not yet in
a kernel release, it will be in v6.1, therefore it can still be
fixed in v6.1.
Even if we don't fix it before v6.2, I don't think there is any
harm in making such a change.

s/renesas,i2c-r9a09g011/renesas,r9a09g011-i2c/g for consistency.

Fixes: ba7a4d15e2c4 ("dt-bindings: i2c: Document RZ/V2M I2C controller")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/i2c/renesas,rzv2m.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/i2c/renesas,rzv2m.yaml
+++ b/Documentation/devicetree/bindings/i2c/renesas,rzv2m.yaml
@@ -16,7 +16,7 @@ properties:
   compatible:
     items:
       - enum:
-          - renesas,i2c-r9a09g011  # RZ/V2M
+          - renesas,r9a09g011-i2c  # RZ/V2M
       - const: renesas,rzv2m-i2c
 
   reg:
@@ -66,7 +66,7 @@ examples:
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
     i2c0: i2c@a4030000 {
-        compatible = "renesas,i2c-r9a09g011", "renesas,rzv2m-i2c";
+        compatible = "renesas,r9a09g011-i2c", "renesas,rzv2m-i2c";
         reg = <0xa4030000 0x80>;
         interrupts = <GIC_SPI 232 IRQ_TYPE_EDGE_RISING>,
                      <GIC_SPI 236 IRQ_TYPE_EDGE_RISING>;


