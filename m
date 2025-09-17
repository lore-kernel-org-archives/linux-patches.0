Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C261EB1AA;
	Wed, 17 Sep 2025 13:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114106; cv=none; b=hyDVfC3Kq0CeDtLCSElhUyGZ2iCjwix+qCs52FnvXnq+0o6JupkUOKLG3xGSQKYUGvsvi63ozrQ10BzX0GU/d8zUzKARTnDIOx3o3Xb2P0taGd7qk1pJMmE6umK9DNADiqGXI/Xpp6B3iLWhdqh/ylsaQPMbsBpCcm3YC+6hhiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114106; c=relaxed/simple;
	bh=ogRs+uWNrbkKcy7HyoHYpL16XkamHxSJNCYyMjxnx/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+YZDOl6JqHOLnEMFf9H93ZkRJaKv9aiLMCYeNtVE3vs/n9vPgqPHJoK6iFc7NsirGN+fDdWV8944ECDo5GiJMAkmO+0JFhQCqnRjaotvQJ7gMBo4U8M79OqNq4doSaCB8KA7nVZTKgdoyEnIF1PQUFjN/90H+dN5/0jEQmtfZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0+c7PBSf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0+c7PBSf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECD6C4CEF0;
	Wed, 17 Sep 2025 13:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114106;
	bh=ogRs+uWNrbkKcy7HyoHYpL16XkamHxSJNCYyMjxnx/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0+c7PBSf8SjHTMpTgD8R2Mw0JSZ94yw8YWjkNh3QEjBF+LjEFBm5YDMCcZB8948BR
	 BobHIg88l/AX8tz8pOQ4CP671vSWT61pU1OPSiWBprd0fA8GG9BHPDELU5+ACWrg0O
	 htn1XycE75mXCWPAw1gEwZWNnoDd6gM+Mln5txPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.1 48/78] dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks
Date: Wed, 17 Sep 2025 14:35:09 +0200
Message-ID: <20250917123330.739416052@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ee047e1d85d73496541c54bd4f432c9464e13e65 upstream.

Lists should have fixed constraints, because binding must be specific in
respect to hardware, thus add missing constraints to number of clocks.

Cc: stable <stable@kernel.org>
Fixes: 88a499cd70d4 ("dt-bindings: Add support for the Broadcom UART driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250812121630.67072-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
@@ -41,7 +41,7 @@ properties:
           - const: dma_intr2
 
   clocks:
-    minItems: 1
+    maxItems: 1
 
   clock-names:
     const: sw_baud


