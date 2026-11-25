Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626248;
	b=eCOxmI4EM2A8diZlABXZxi6AA+s58QLKAOR99jK2ti9UjxuVFhb/F4+ku64HXj+o5p02
	 wn8PNvss22E51eTFmy/4ujR6jqlG3FZ/Vc2d8gFnkY8ldU25G/th2C0cq9s8chFXy73aa
	 /Q/3cnCGVVnH0SWtV7GtTr+2/kH47qOdKNMcOJLXb4Al9NhoB4eB4VKbI1T/bC3U30lbf
	 KFqP7G2OIGeXTuQ8o5V9APUx4Hxv6lDoPYVmE8cNCNYocSaTBWwttenZJfViFqLgLhT7E
	 iLWA6i/fdsrJUhlfVp8Mmb06udo1BsxAB8JTFTzPDr33M9XfZ3TOUNLTXDrqGpVhAFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BHJkJ7VHVbu3qPG3ulgVeuNx6xJ07/zBNONym3WCvQ=;
	b=hydxY8Ug1e2KjvikAOv9TrzuQ0FYe/n7/pHxld/SSGmhvY5lqycZ2ENRLFG4I50uPZYe
	 EJJy2SC5eaZ7+U0IPojEgBwodSxbFw+o9WOxc8bwQDx4vHg4gaB0WOYpNL2D8QyhWdiug
	 ysItsIHrBOT0qhAOq07cCWVRswUgo8O5SM7Kg4mQbeTuFzYU8pXKM7V8rdwdNkji96C6G
	 Rto7pnG7qEFH46imMwJbsKwU6UNG2GWs5XAiw25+Jo1MzrJpmUjWiG5Xv0T78I1l7nJv9
	 eqsuFsjvBwO8pGlkmWN/PVmqYSTve06Q5fDTEwLaNokVJAs8JtjPpoDnhoxBOU+a3Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+veMhUX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82725606A31E;
	Wed, 25 Nov 2026 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+veMhUX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A5D1F000C6;
	Wed, 25 Nov 2026 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626248;
	bh=0BHJkJ7VHVbu3qPG3ulgVeuNx6xJ07/zBNONym3WCvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+veMhUX9FwC5HQImkn7YHbx48kG1Rl1634RmF0zhmJlkjvQbdM0aDDw9W2KuwzH6
	 AqMPCI8dWX9epm49w5nRgW7v1F51v35vhZTnx/QfMEhL1IIJSgzjHVtywXK0vKO6e8
	 8amh/+I3yyYjrytxCHMOVSJfgjmshKDnXH8nUhIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 780/816] dt-bindings: iio: adc: Add syscon property for multi-SCU SoCs
Date: Wed, 25 Nov 2026 15:38:48 +0100
Message-ID: <20261125143907.228187207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

commit 6ec0623a7c77bc2c383e9971d7b0c9df3ec988fb upstream.

The ADC's reference-voltage trimming data lives in a System Control
Unit (SCU) register. SoCs with a single SCU instance let the driver
locate it without any additional information, but SoCs such as AST2700
that expose more than one SCU node need an explicit phandle to
disambiguate which one holds the trimming data.

Add an "aspeed,trim-syscon" phandle property, and require it for the
AST2700 compatibles since they are the first multi-SCU SoCs supported
by this driver.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml |   17 ++++++++++
 1 file changed, 17 insertions(+)

--- a/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/aspeed,ast2600-adc.yaml
@@ -62,6 +62,11 @@ properties:
     description:
       Inform the driver that last channel will be used to sensor battery.
 
+  aspeed,trim-syscon:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the SCU holding the ADC's reference-voltage trimming data.
+
 required:
   - compatible
   - reg
@@ -69,6 +74,18 @@ required:
   - resets
   - "#io-channel-cells"
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - aspeed,ast2700-adc0
+              - aspeed,ast2700-adc1
+    then:
+      required:
+        - aspeed,trim-syscon
+
 additionalProperties: false
 
 examples:


