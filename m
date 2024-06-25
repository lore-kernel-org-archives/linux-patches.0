Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7505514A0A4;
	Tue, 25 Jun 2024 09:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309314; cv=none; b=lwlkNow16ECQuNhzVuzCtlNnbkSIDeQbNgSOshJUv+LBUGEyoYdzAM1t34gjNldBUZFcpmcUSsJstc6lsXrJd/criwHdsi8h2fTP7oMZjN/pXu2Iysd/Kn+ewQggjDsKJ0dSMguZlgC3vZQsvNlCTuVFjMrsTdLIyFNieAJez34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309314; c=relaxed/simple;
	bh=YrivGJ3ZCA/5wixPXsOnHkO6oVqeyp/rfo5ofVwiIZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHwt/6z+TlfkH0VwEGMa2YJDQR9ug6ckzf7qkWjHlo47ncx2DAAnU/uVa+KEEXKl5NztTuTQLEv/tbxvonq5LTHFznhiHxF3Rd8xGF313yO5RwMlGyAxiS/f2jVYkfBMblFaJ9nvX/LxffJ9CurNaxl/JYj1wwUbXH8FJSVac8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjD6OIBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjD6OIBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01FDC32781;
	Tue, 25 Jun 2024 09:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309314;
	bh=YrivGJ3ZCA/5wixPXsOnHkO6oVqeyp/rfo5ofVwiIZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjD6OIBQgQ+84fvlLgyFWfTNEtpV8sP3J9FhsHFWK7k2mmCpNUN3DfePeZwME7YZm
	 IYAVjIpSUexzGKnzKwASHg55eNfYIxN5RoAROw1NnkZnwDArsTTSY00ERjTEL+wj6f
	 ZJnNEpl++yJed9VxfIuAFQ/TJv8JDmeyKDbjTq08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 167/192] dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema
Date: Tue, 25 Jun 2024 11:33:59 +0200
Message-ID: <20240625085543.571229678@linuxfoundation.org>
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

commit 5c8cfd592bb7632200b4edac8f2c7ec892ed9d81 upstream.

The referenced i2c-controller.yaml schema is provided by dtschema
package (outside of Linux kernel), so use full path to reference it.

Cc: stable@vger.kernel.org
Fixes: 1acd4577a66f ("dt-bindings: i2c: convert i2c-cros-ec-tunnel to json-schema")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
+++ b/Documentation/devicetree/bindings/i2c/google,cros-ec-i2c-tunnel.yaml
@@ -21,7 +21,7 @@ description: |
   google,cros-ec-spi or google,cros-ec-i2c.
 
 allOf:
-  - $ref: i2c-controller.yaml#
+  - $ref: /schemas/i2c/i2c-controller.yaml#
 
 properties:
   compatible:


