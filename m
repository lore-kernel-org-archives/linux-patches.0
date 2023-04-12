Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6238F2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD399C433EF;
	Wed, 12 Apr 2023 08:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288674;
	bh=Q3nXyWdG5MMVMqLsBi6VAT0PgR3rEYDlS0+SxbPXiYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puwc8dH6uadWtTySRRGpn089yNr8d/8WIq0+VLlOfOkrsZ7KFscbWGhAEegUd206y
	 yLNVKlVt6xPD9btPMfCdXW+1vHmvcD6qkj0okV6waP03QKxzU/n9asgoA57rVDEuB4
	 ZF1pWZOlrJtTcwhLM0zPgmvmQHPVFVNZDyv2zKxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 68/93] dt-bindings: serial: renesas,scif: Fix 4th IRQ for 4-IRQ SCIFs
Date: Wed, 12 Apr 2023 10:34:09 +0200
Message-Id: <20230412082825.987601571@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 7b21f329ae0ab6361c0aebfc094db95821490cd1 upstream.

The fourth interrupt on SCIF variants with four interrupts (RZ/A1) is
the Break interrupt, not the Transmit End interrupt (like on SCI(g)).
Update the description and interrupt name to fix this.

Fixes: 384d00fae8e51f8f ("dt-bindings: serial: sh-sci: Convert to json-schema")
Cc: stable <stable@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/719d1582e0ebbe3d674e3a48fc26295e1475a4c3.1679046394.git.geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/renesas,scif.yaml |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
+++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
@@ -79,7 +79,7 @@ properties:
           - description: Error interrupt
           - description: Receive buffer full interrupt
           - description: Transmit buffer empty interrupt
-          - description: Transmit End interrupt
+          - description: Break interrupt
       - items:
           - description: Error interrupt
           - description: Receive buffer full interrupt
@@ -94,7 +94,7 @@ properties:
           - const: eri
           - const: rxi
           - const: txi
-          - const: tei
+          - const: bri
       - items:
           - const: eri
           - const: rxi


