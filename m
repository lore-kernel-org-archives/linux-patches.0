Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6658513AE8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9472C433D2;
	Mon,  8 May 2023 11:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544741;
	bh=HEJV+Lotp3IBxBJ+/F72JGs+LnOFiSGreSYufmq/dts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGk2Q538ATKsNGjaqMYrYuL8D51W1Ac2UvvYvGOAY2mr3dH23OkH0+ROE4Fa4UVXN
	 rA6nzOqChxPW4pZkRn00JdLZjcyjglZ5ILzzXBR72GyGSUcIEmu9b7KY1MLNPVNH/i
	 5r5qwRcfMY2vakABwtNfmishTeOcXnpcrZIhmSH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 508/694] dt-bindings: serial: snps-dw-apb-uart: correct number of DMAs
Date: Mon,  8 May 2023 11:45:43 +0200
Message-Id: <20230508094450.623260587@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit dedd376e0c7096daf4171d54957a679b4dfeadbf ]

The "minItems" alone does not impose any upper limit of DMAs, so switch
it to "maxItems" which also implies same value for minItems.

Fixes: 370f696e4474 ("dt-bindings: serial: snps-dw-apb-uart: add dma & dma-names properties")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Acked-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20230317155712.99654-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/serial/snps-dw-apb-uart.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.yaml b/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.yaml
index 2becdfab4f155..8212a9f483b51 100644
--- a/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.yaml
@@ -68,7 +68,7 @@ properties:
       - const: apb_pclk
 
   dmas:
-    minItems: 2
+    maxItems: 2
 
   dma-names:
     items:
-- 
2.39.2



