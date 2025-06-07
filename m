Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D69C15D1;
	Sat,  7 Jun 2025 10:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291083; cv=none; b=Fq8YSnyjOfdko+fgGKD5YkuLpCsIILtr4MWKhZQTgYfv9ptat1mIVQ/6DrFN8a9A/tVGapHLUiLon0Sui3wB3o7Yw9hK37GemnzGp+Oie/ZmP7BmRc/HRnu6dOoebPz7zdyOs9rDN2jesx5gvMms//XFZAFNFFQJx+7jXXwxQZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291083; c=relaxed/simple;
	bh=NYzW5wdIEESssFqgBmh1iT1WQm5ebFB/cAPUJUDkobA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EpmEDIH8eTB0VApS3bJiJ17dsTn3uX2kf8/07q8tSvwK7Cph+sKtVRZmnOQkgKAKOW7L+uQQovRg8/jMMtjgvIJk5Nr3IZhQfJPv4LnSg6NJld14uj70PaxOi8OMpD0Aea5R1lSHjWR1HQkUWnQA21KNCTkTabMQQBjnxKPpBbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhzIlG7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhzIlG7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E8EC4CEE4;
	Sat,  7 Jun 2025 10:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291082;
	bh=NYzW5wdIEESssFqgBmh1iT1WQm5ebFB/cAPUJUDkobA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhzIlG7J+EZWszgCEJ2oONb/jAVbpB/eXTHltIqWnYYnEMr1BmrmxaUCjtvHnO4+I
	 Rz20KUfN0aO1qA2K4jDTW0buzOGTsOltmQ54n4VJ+eWiqoHbqytiV9bciX4Pz9qJpY
	 2ovPeIFTIPV1MhmLYNLyQyc+xLe509px+frWbBxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
Subject: [PATCH 6.15 30/34] dt-bindings: pwm: adi,axi-pwmgen: Fix clocks
Date: Sat,  7 Jun 2025 12:08:11 +0200
Message-ID: <20250607100720.893179321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit e683131e64f71e957ca77743cb3d313646157329 upstream.

Fix a shortcoming in the bindings that doesn't allow for a separate
external clock.

The AXI PWMGEN IP block has a compile option ASYNC_CLK_EN that allows
the use of an external clock for the PWM output separate from the AXI
clock that runs the peripheral.

This was missed in the original bindings and so users were writing dts
files where the one and only clock specified would be the external
clock, if there was one, incorrectly missing the separate AXI clock.

The correct bindings are that the AXI clock is always required and the
external clock is optional (must be given only when HDL compile option
ASYNC_CLK_EN=1).

Fixes: 1edf2c2a2841 ("dt-bindings: pwm: Add AXI PWM generator")
Cc: stable@vger.kernel.org
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250529-pwm-axi-pwmgen-add-external-clock-v3-2-5d8809a7da91@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
+++ b/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
@@ -30,11 +30,19 @@ properties:
     const: 3
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: axi
+      - const: ext
 
 required:
   - reg
   - clocks
+  - clock-names
 
 unevaluatedProperties: false
 
@@ -43,6 +51,7 @@ examples:
     pwm@44b00000 {
         compatible = "adi,axi-pwmgen-2.00.a";
         reg = <0x44b00000 0x1000>;
-        clocks = <&spi_clk>;
+        clocks = <&fpga_clk>, <&spi_clk>;
+        clock-names = "axi", "ext";
         #pwm-cells = <3>;
     };


