Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF3E2F8BD9;
	Tue, 26 Aug 2025 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207136; cv=none; b=dY+BpUCBQw68h6j254N1v4XYmEhmxXXUMhwidXPLrns5ras51KWJU2N3bnQa/miLqmvmSUAgW0zNq4JBsahvE/FQHOzSd0rvFo9U+aiEbpxSUMQTDrXJPeMsmYkck5qaoXgmFtEmIYx0hmde3i+k8BcqIcYh61OJ6R1h5LYXG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207136; c=relaxed/simple;
	bh=8feJ17hEz8m1XEvQDUzc6knCEidbPRfzyTBCdP4DWio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mecea0qpI+Xo8WNZCHXcrGsOvth2b2qJFhxwa+ZQsHH3+S5XFtSkKn8D4yIrH95DpPQvlVGa+9qzpK6whShVf+QH8VlSsgJ+eHtKHTrZ7Ebt6uuYcGt1aSZzpqJIfN/B6EGo+shDkdYz9aZG+MaEZWTLLc5Uv8g37MlUKlPVexQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sU28pnWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sU28pnWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6312DC4CEF1;
	Tue, 26 Aug 2025 11:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207136;
	bh=8feJ17hEz8m1XEvQDUzc6knCEidbPRfzyTBCdP4DWio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sU28pnWTy1eO2CGwCCEGHJtWczJSe/QnvO09L/9IjnaGekOQh28jkTnJviiKmY7/f
	 aRc8ON0EFTzzrukv/0WhNklhOAvKCWvoJEIzSdXtG9wF+RfdMEZ67Oq/j3E2Cp/XIv
	 YXGLXQsdQY557B47uJq10CMNxR3oZBAcWRdpjeC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.16 064/457] dt-bindings: display: vop2: Add optional PLL clock property for rk3576
Date: Tue, 26 Aug 2025 13:05:48 +0200
Message-ID: <20250826110938.942346973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 3832dc42aed9b047ccecebf5917d008bd2dac940 upstream.

As with the RK3588 SoC, RK3576 also allows the use of HDMI PHY PLL as an
alternative and more accurate pixel clock source for VOP2.

Document the optional PLL clock property.

Moreover, given that this is part of a series intended to address some
recent display problems, provide the appropriate tags to facilitate
backporting.

Fixes: c3b7c5a4d7c1 ("dt-bindings: display: vop2: Add rk3576 support")
Cc: stable@vger.kernel.org
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: "Rob Herring (Arm)" <robh@kernel.org>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250612-rk3576-hdmitx-fix-v1-1-4b11007d8675@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/display/rockchip/rockchip-vop2.yaml |   56 +++++++---
 1 file changed, 44 insertions(+), 12 deletions(-)

--- a/Documentation/devicetree/bindings/display/rockchip/rockchip-vop2.yaml
+++ b/Documentation/devicetree/bindings/display/rockchip/rockchip-vop2.yaml
@@ -64,10 +64,10 @@ properties:
       - description: Pixel clock for video port 0.
       - description: Pixel clock for video port 1.
       - description: Pixel clock for video port 2.
-      - description: Pixel clock for video port 3.
-      - description: Peripheral(vop grf/dsi) clock.
-      - description: Alternative pixel clock provided by HDMI0 PHY PLL.
-      - description: Alternative pixel clock provided by HDMI1 PHY PLL.
+      - {}
+      - {}
+      - {}
+      - {}
 
   clock-names:
     minItems: 5
@@ -77,10 +77,10 @@ properties:
       - const: dclk_vp0
       - const: dclk_vp1
       - const: dclk_vp2
-      - const: dclk_vp3
-      - const: pclk_vop
-      - const: pll_hdmiphy0
-      - const: pll_hdmiphy1
+      - {}
+      - {}
+      - {}
+      - {}
 
   rockchip,grf:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -175,10 +175,24 @@ allOf:
     then:
       properties:
         clocks:
-          maxItems: 5
+          minItems: 5
+          items:
+            - {}
+            - {}
+            - {}
+            - {}
+            - {}
+            - description: Alternative pixel clock provided by HDMI PHY PLL.
 
         clock-names:
-          maxItems: 5
+          minItems: 5
+          items:
+            - {}
+            - {}
+            - {}
+            - {}
+            - {}
+            - const: pll_hdmiphy0
 
         interrupts:
           minItems: 4
@@ -208,11 +222,29 @@ allOf:
       properties:
         clocks:
           minItems: 7
-          maxItems: 9
+          items:
+            - {}
+            - {}
+            - {}
+            - {}
+            - {}
+            - description: Pixel clock for video port 3.
+            - description: Peripheral(vop grf/dsi) clock.
+            - description: Alternative pixel clock provided by HDMI0 PHY PLL.
+            - description: Alternative pixel clock provided by HDMI1 PHY PLL.
 
         clock-names:
           minItems: 7
-          maxItems: 9
+          items:
+            - {}
+            - {}
+            - {}
+            - {}
+            - {}
+            - const: dclk_vp3
+            - const: pclk_vop
+            - const: pll_hdmiphy0
+            - const: pll_hdmiphy1
 
         interrupts:
           maxItems: 1


