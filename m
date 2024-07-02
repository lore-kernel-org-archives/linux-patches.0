Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5067D1514DC;
	Tue,  2 Jul 2024 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941266; cv=none; b=Knd3COYs1hGOyZwEkHV27ZlXOO1LnYL7IaSezd376MjrM5LyyDpR550yqW8HqufYMv+wOeIOU9l+T2STDg28Ni3qibpqNGOcBiBdR9kxny/OQxWNfv90namUJjaaG1rhTo5Q2rLAN2yMOGdPaAcwOc/vJ3zw9Xfix3YGk8zPqyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941266; c=relaxed/simple;
	bh=vrf1uZ+aV7Cwy3V1VRQs+2U2YaPTbP5oKK04ct4NakM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAR4NThDAnLnUSep/UPldbWHFHcbi27PVZ+Kv1ykvYpVBd4mFkdBss1S9+YjmMzw1UKWEm9qT6KXpojtnhnlf3uXxaGBy9+/Ntw7D3mRIv24moyUOJnzZa60qvRn7QZVs6hy6Y0F5OQjRsv3+ubG3L04SQe7DOuU5pR71jTCa8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNfrr0IX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNfrr0IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95C8C116B1;
	Tue,  2 Jul 2024 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941266;
	bh=vrf1uZ+aV7Cwy3V1VRQs+2U2YaPTbP5oKK04ct4NakM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNfrr0IXyWLFGjTT1izYq+4ImkPqAAoGtayqadIHQpic5u5GNTEZgN91EQcO7I0ve
	 N44r+pdU1npe5fbizWuG5K0b3/CxcVArWUU7TAZFVZbOakWG4ezbjFLLmJrU2fBxzY
	 o7JaQDP6Xpigob1oywLPQ5472taY4lGGoaxQg70k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/128] dt-bindings: i2c: atmel,at91sam: correct path to i2c-controller schema
Date: Tue,  2 Jul 2024 19:03:35 +0200
Message-ID: <20240702170226.773034119@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d4e001ffeccfc128c715057e866f301ac9b95728 ]

The referenced i2c-controller.yaml schema is provided by dtschema
package (outside of Linux kernel), so use full path to reference it.

Cc: stable@vger.kernel.org
Fixes: 7ea75dd386be ("dt-bindings: i2c: convert i2c-at91 to json-schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml b/Documentation/devicetree/bindings/i2c/atmel,at91sam-i2c.yaml
index 6adedd3ec399b..c22e459c175ab 100644
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
-- 
2.43.0



