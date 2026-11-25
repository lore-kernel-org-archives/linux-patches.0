Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620579;
	b=tfYe3NhliHSdAgBq1ZprzGMrkgusHXNBo8fDRqDjUEWR63zDq167RrKEvs1zb2QA/0Z6
	 D0JLqs59UszzPo5b7r0wFeVA98r2CsJ7JMDotUtKkURpa5P+bgh5amriV6MElUkiKIeTp
	 KMaV6HzcQYe6k3BJUTHJxkN1xyd8Ga36pR8iW6M90uTJKQVwyzmR7neMQVzbf0YLUBnL7
	 v2qUpstqLjHJStaMtVanthXPr57mXnhWEJDyxb4LiTOL7j3tCUR/f71vpvdZf9vaW4PrV
	 ehy99EyzSHjNmo9kITRalxlPwtfdH+7OZNGfHM0j9ywrJDuv1PYeoyf1QqwbW7hz90Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U9NWZWYSSaxYvE6GtdkhT3vj2e8U82cr7eePCnAdynU=;
	b=oHiJi4nnzmfJi4WMd3Fv4cGSlPaj/fCHyJ+OsQR1o/uOzlDCqMOHJm9LKTetn/3ei4W0
	 tgoEm5o/Xc0Hnq4hRsTTmTgDrKRvpNR+I+Z4Qph2NeLlSW2jC72usYAiHrulhxSaZUwQ+
	 bPOpP80hJ8/rRUcz5s9X1YZrsLV7GG1AEAdWWxqcjvXISOFUmNnKbF5u9Bncadd/tlLTJ
	 CyAI1A8JpabOmbZ8P26t+O6+glUIN7DJmho/kuVKztMY/tfzf9NnN7d2QYT9teIuLhCL+
	 7iqJdLJNTYYno77ORGnYoObi6PZxVXQZbeF76sklF29/Jg7YUEFdTwE7qmD8U2T+I3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKGNXdwZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B586606A321;
	Wed, 25 Nov 2026 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKGNXdwZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F1C1F000C0;
	Wed, 25 Nov 2026 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620578;
	bh=U9NWZWYSSaxYvE6GtdkhT3vj2e8U82cr7eePCnAdynU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKGNXdwZ3imBSo6MQOAVG/ZyR5xL231YIbu/Y2ArBnaW+hwohxQgmvPF0Z0rPupia
	 Qnjfnvq7inmu2erdI3hCCW4iXDEUJ7LCpv4qVAtGglqNHvVOMo3D7bI4E0uzHEsn0P
	 88l13ZnLM/8crh2UVuR+eD0SmsPfnJlrGdS3hac8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0963/1005] dt-bindings: iio: adc: Add syscon property for multi-SCU SoCs
Date: Wed, 25 Nov 2026 15:38:21 +0100
Message-ID: <20261125143844.227491911@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -67,6 +67,11 @@ properties:
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
@@ -74,6 +79,18 @@ required:
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


