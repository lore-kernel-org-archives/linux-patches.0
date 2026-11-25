Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623698;
	b=XqjzRQmdMBlmLu7WaZ8CqEKElZQivjnWyK9dWLPUq+UG4LRjy+gUP1w5yY6jUOmZ1x8z
	 8mNUziwV8S+Vro1XW16mGiuRq3j5gHzwNzzHTnE6JTu6cyPw/7zEXxRGtXAAeDFE3KamE
	 FLNVWpFBfdaghE2s4ayxaQU/Gxl/tS5A9WuU0KuQhF7pr2Uhoi5fAxAlCeR8wmLzmGSXk
	 bkq+dRh9fH+Y6aRTrvahDitxGarcYvXXXHWYXpnYCA2SxLQmW5Sax/epjaAfNjWTS4Xas
	 avZTko2+O3JHarpateVsPnU0h69yu14/65utD5iUqohZDdscNpH5Bb8CL3hrxnj5YWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEo7tnflaxKNgDGSw4VcuKIrNJDwC2tgL6P4aIY00KY=;
	b=zMt36ITcHCDpgshPqbnn2j5talaCeXbdQ5w0DQrSmCAukeq20YgSeVdwrwPZcGg4FPOi
	 LfUUte0HadVKxQK/8TgbkyhAng5XIfrJNmuPANnFazJTMMEHiho2niPjEARhv5b2XqpoE
	 DYP7RTfNacbAZsY7WiGpXDWsiw4kdnf2Pbyy7lsNGm3eS4xJM24lwl1COg4WGNGm/+rSz
	 412XEjFOOyqx/sH+TbIau/oQNDGU6B3/wz76fuB+4IkxS0I510+XqqLLgnJ3rsuFto5H8
	 UWn/6zKqK85HyXtEzNGatZEJmV/7At7wnXqbKK/3mXSEFpMPnyrBaswCtvTLzcpIz3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N14wMD6Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30E4606A323;
	Wed, 25 Nov 2026 16:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N14wMD6Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C191F000D0;
	Wed, 25 Nov 2026 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623697;
	bh=VEo7tnflaxKNgDGSw4VcuKIrNJDwC2tgL6P4aIY00KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N14wMD6ZGEYnd9H24Y7ggH2KH1Bw6o1wycCaSON1C6S1IjpuJM1BYT/j/wchpUWY2
	 fpNEf/099WWoZ3psJZCEZzSgQIKEKOtgQyMR5iFtO9PfrqPDiYnc/BUuk1IVXRzGH0
	 5+7RCQBz82qk982Q0nt4cc8DOijSwJ9IlS+nOIGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 943/990] dt-bindings: iio: adc: Add syscon property for multi-SCU SoCs
Date: Wed, 25 Nov 2026 15:38:30 +0100
Message-ID: <20261125143844.079225215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


