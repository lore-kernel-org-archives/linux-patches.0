Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DF01D55F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsBjR9Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4ADAC433C8;
	Mon, 16 Oct 2023 14:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467653;
	bh=T8Sy1q2Hn5oflVpeoU2O3cdEHc9m83o5IApEFjLOx/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsBjR9Otf0HjViuUcuoo5hkHpAz/q4OablWQBshdSRCpAuHCJPeEFekeZntoL/AV0
	 ed0smj8Ly2PC1Fh+pPAGZV1CePbzh2xyZnwquE23KPFEgOqkUOERaYhoSyPFs7PdyO
	 rUnw1qAaazUkK49tYwpN6KbAOJWgG30r4zFB0o0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.5 024/191] dt-bindings: interrupt-controller: renesas,rzg2l-irqc: Update description for #interrupt-cells property
Date: Mon, 16 Oct 2023 10:40:09 +0200
Message-ID: <20231016084015.966084383@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit cfa1f9db6d6088118ef311c0927c66072665b47e upstream.

Update description for '#interrupt-cells' property to utilize the
RZG2L_{NMI,IRQX} for the first cell defined in the
include/dt-bindings/interrupt-controller/irqc-rzg2l.h file.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 96fed779d3d4cb3c ("dt-bindings: interrupt-controller: Add Renesas RZ/G2L Interrupt Controller")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220722151155.21100-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/interrupt-controller/renesas,rzg2l-irqc.yaml |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/Documentation/devicetree/bindings/interrupt-controller/renesas,rzg2l-irqc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/renesas,rzg2l-irqc.yaml
@@ -31,8 +31,9 @@ properties:
       - const: renesas,rzg2l-irqc
 
   '#interrupt-cells':
-    description: The first cell should contain external interrupt number (IRQ0-7) and the
-                 second cell is used to specify the flag.
+    description: The first cell should contain a macro RZG2L_{NMI,IRQX} included in the
+                 include/dt-bindings/interrupt-controller/irqc-rzg2l.h and the second
+                 cell is used to specify the flag.
     const: 2
 
   '#address-cells':


