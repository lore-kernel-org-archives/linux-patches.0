Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36918FC87;
	Wed,  3 Jul 2024 11:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005883; cv=none; b=NWySvZdK5sXmEF6JbtR5tULuwGTuC8mXzAnlyd3YPEmENexMxg/MgGoCx2EthGi1fHArIj+h9tZ8ClhBEGjfqkoglrpubmH9CwHoSGsZ5kPfX9O8Qss1N5fFO7rkTy1a0Iez93wpSrhRyl99l/8Yc+H5T/+zjYIxvMRQRdeYda4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005883; c=relaxed/simple;
	bh=WSahMg6e1LlV3Jqc9B7IA91dK9lJNoarwWZkNgLbcT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ofnqi3OBNOdtXfjNAEtIB72DFHJIeKJqnJbQ0dVQDMArVG1ogAZHLLK2GNES1Pq+4utKlUb5xfZ6fVergLmVpsURicWPmuGbqwxpVO9c2FvAPXLrRHWa9wzs/YvSUogqZJXXYQp5zp5Db5p7QH8ZM6i4ckjYF+r+w09E/ggf3/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPNCezJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPNCezJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42865C32781;
	Wed,  3 Jul 2024 11:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005883;
	bh=WSahMg6e1LlV3Jqc9B7IA91dK9lJNoarwWZkNgLbcT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPNCezJlsV4aiUrHC6+cQfmUTjcBsccHC0H8Mu1cmoavNcgXCSDgmWgnMFajQYPm3
	 G5QVfucaqkppJbfpii/GNPmliU5pHxGZYNskPQkkPDIRcB/8KXsiF3z9wSqbkH0sml
	 YFOf1uEbtUfVRmXel17yMEg3xefjU1ISjtzKnpyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 229/356] dt-bindings: i2c: google,cros-ec-i2c-tunnel: correct path to i2c-controller schema
Date: Wed,  3 Jul 2024 12:39:25 +0200
Message-ID: <20240703102921.776385635@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -22,7 +22,7 @@ description: |
   google,cros-ec-spi or google,cros-ec-i2c.
 
 allOf:
-  - $ref: i2c-controller.yaml#
+  - $ref: /schemas/i2c/i2c-controller.yaml#
 
 properties:
   compatible:


