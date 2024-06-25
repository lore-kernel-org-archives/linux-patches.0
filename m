Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEC11465A8;
	Tue, 25 Jun 2024 09:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308780; cv=none; b=d01QLOZJOqmy3k9Q0HkkEnRzBHDoRzRx6+ExfaxBDfKfnnRdvyFfUpzKwN3cGbKg/+1vUH9Kdc6C16mttZeLnCoELGL9dG9X5b1/Eg3YACpgugLgUwRn7PA7nwnH+RnUmxSdfZahqxU5CCUrIcGm/FQJ1VGpYZIiTMs67lglSjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308780; c=relaxed/simple;
	bh=/zfoDmTwd/6+yAXrzEc1n7OZucOprTqDN2D5Gho/97s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpbaiBpqBtTYZf+V9Murl6Qrfg/vi/GdcynDRIUpGR0GltnSNyyfZ0qorbgTHO9LZHiK61pD7xcrwymhJc7USRnZynGMq+KEzn6rabi33qlQ7aiOEgrbVOhEk5Gq5ihz2gs/1a27nNrpwAUhSLTcn97J6np/NTuPutioVLaK6vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UGRN6Rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UGRN6Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B89C32781;
	Tue, 25 Jun 2024 09:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308780;
	bh=/zfoDmTwd/6+yAXrzEc1n7OZucOprTqDN2D5Gho/97s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UGRN6Rnwke8DWV2uz++I88iJf5E8WRdZkH30ivrA22k7x1k6jxRPLTNNT1vGncUa
	 cmJN3l5DU53aqkPI8Xq01Q2KQj5ptIZoJuYVGJAvPN6i9CalhxXxCK7YtSNyK3t+bn
	 i3DVKu8dt1OOJ8Ky7L3tmVScBxgHFHayucuTjM90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.9 230/250] dt-bindings: i2c: atmel,at91sam: correct path to i2c-controller schema
Date: Tue, 25 Jun 2024 11:33:08 +0200
Message-ID: <20240625085556.882734793@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -77,7 +77,7 @@ required:
   - clocks
 
 allOf:
-  - $ref: i2c-controller.yaml
+  - $ref: /schemas/i2c/i2c-controller.yaml#
   - if:
       properties:
         compatible:


