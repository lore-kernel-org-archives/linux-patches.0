Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651AB1494CF;
	Tue, 25 Jun 2024 09:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309308; cv=none; b=YTw1zUE0V4FrHr9Sbj/t3BCCGHhmGCNzW7izTnGI9bWYN/4qHNHPS/LDEEaL8ob1bjG6r1FTG5Ras7SQbIg9Bwok1VFnX0sNOUySpONADxvjQ4XKaNpYMTgYfXunhZfIS+ia/llv+Tc7ZwyRj0AJKNb4hWPLWyh6ZcdSUSQth4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309308; c=relaxed/simple;
	bh=2WEUoatAIpDPRQIdMi5p7TnTFDHU9EpNRHjlU1O4OZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXRL9fLspBPdI9XmGeyfSWrXFC0eJSJJ6AgIJRzxJwqCzk3FYKsSSIUVpT3o54yV+oj4egSmrjAAVCRUInYN1gcOysbqplskEi/5GtkadqzSZ7mP8/5HbFCe3tJc/cD/livd9vpa4KwfoCANVDZMZ/fLI06R2H/yJpHJMcVlID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0d4CZSb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0d4CZSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2032C32781;
	Tue, 25 Jun 2024 09:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309308;
	bh=2WEUoatAIpDPRQIdMi5p7TnTFDHU9EpNRHjlU1O4OZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0d4CZSbHpIim2fbG7+LFh/80uRjGtAAjadIo4efeAPqV/ubznGchBY+CDUslkBmr
	 nnxdHKQBNaTvFeLO0Hb9vMa0nWyn9WumSqkrkKpklNU53BM6EbcR62aHLECvMInduI
	 Y+Ru0BqCIDlD09R7jmNehyVPmcaPdOODWmml6bm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 166/192] dt-bindings: i2c: atmel,at91sam: correct path to i2c-controller schema
Date: Tue, 25 Jun 2024 11:33:58 +0200
Message-ID: <20240625085543.533223073@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit d4e001ffeccfc128c715057e866f301ac9b95728 upstream.

The referenced i2c-controller.yaml schema is provided by dtschema
package (outside of Linux kernel), so use full path to reference it.

Cc: stable@vger.kernel.org
Fixes: 7ea75dd386be ("dt-bindings: i2c: convert i2c-at91 to json-schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
@@ -75,7 +75,7 @@ required:
   - clocks
 
 allOf:
-  - $ref: i2c-controller.yaml
+  - $ref: /schemas/i2c/i2c-controller.yaml#
   - if:
       properties:
         compatible:


