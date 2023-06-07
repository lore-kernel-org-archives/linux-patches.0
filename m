Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D06D10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D113FC433D2;
	Wed,  7 Jun 2023 20:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169716;
	bh=6WZj0BXWB1MLar3oj/LZv3PvS5t2OOJL+zBNwsbacYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07eMmch4ZHVumYOZ4dF5yu563RNLZkSG8lo+NIIPGi/YZ7Kk7CS05rZHH1WEBU9d9
	 cCOGXUaN70XepSb0vrQFECpfuh/iZSjExrshFqC0Pv9seox4wTUdwMh1eIgY5wp0cv
	 YukExBsAzWDHdrJU0lz6+4XeRXw22hi64eIqi85I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 186/286] dt-bindings: serial: 8250_omap: add rs485-rts-active-high
Date: Wed,  7 Jun 2023 22:14:45 +0200
Message-ID: <20230607200929.349995680@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 403e97d6ab2cb6fd0ac1ff968cd7b691771f1613 ]

Add rs485-rts-active-high property, this was removed by mistake.
In general we just use rs485-rts-active-low property, however the OMAP
UART for legacy reason uses the -high one.

Fixes: 767d3467eb60 ("dt-bindings: serial: 8250_omap: drop rs485 properties")
Closes: https://lore.kernel.org/all/ZGefR4mTHHo1iQ7H@francesco-nb.int.toradex.com/
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230531111038.6302-1-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/serial/8250_omap.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/serial/8250_omap.yaml b/Documentation/devicetree/bindings/serial/8250_omap.yaml
index eb3488d8f9ee6..6a7be42da523c 100644
--- a/Documentation/devicetree/bindings/serial/8250_omap.yaml
+++ b/Documentation/devicetree/bindings/serial/8250_omap.yaml
@@ -70,6 +70,7 @@ properties:
   dsr-gpios: true
   rng-gpios: true
   dcd-gpios: true
+  rs485-rts-active-high: true
   rts-gpio: true
   power-domains: true
   clock-frequency: true
-- 
2.39.2



