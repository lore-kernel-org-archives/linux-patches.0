Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152B6364CB;
	Fri, 24 Nov 2023 18:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSd2Nrx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A09C433C7;
	Fri, 24 Nov 2023 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851090;
	bh=+9G5QHUXFBI/jhwJNEbY9uIjYAw+JnSro+YQ1BAw+mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSd2Nrx+8YRow0FSXu0opnccBiEKenh5AZ91zTWCh2QtF/KeY6YeGfpJrJzyT/Cck
	 g6bo59wa9qCp2YM+Q+M8urJ+4gmGrW0FGjJCddmLrx5GAAk+RxVdFE1Cyeml2kcrGU
	 s/kRxT53zPOQNhSmfWs9fYHxDo2OYx+KgpOL3Eug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.5 310/491] dt-bindings: timer: renesas,rz-mtu3: Fix overflow/underflow interrupt names
Date: Fri, 24 Nov 2023 17:49:06 +0000
Message-ID: <20231124172033.876913082@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

commit b7a8f1f7a8a25e09aaefebb6251a77f44cda638b upstream.

As per R01UH0914EJ0130 Rev.1.30 HW manual the MTU3 overflow/underflow
interrupt names starts with 'tci' instead of 'tgi'.

Fix this documentation issue by replacing below overflow/underflow
interrupt names:
 - tgiv0->tciv0
 - tgiv1->tciv1
 - tgiu1->tciu1
 - tgiv2->tciv2
 - tgiu2->tciu2
 - tgiv3->tciv3
 - tgiv4->tciv4
 - tgiv6->tciv6
 - tgiv7->tciv7
 - tgiv8->tciv8
 - tgiu8->tciu8

Fixes: 0a9d6b54297e ("dt-bindings: timer: Document RZ/G2L MTU3a bindings")
Cc: stable@kernel.org
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230727081848.100834-2-biju.das.jz@bp.renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../bindings/timer/renesas,rz-mtu3.yaml       | 38 +++++++++----------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/renesas,rz-mtu3.yaml b/Documentation/devicetree/bindings/timer/renesas,rz-mtu3.yaml
index bffdab0b0185..fbac40b958dd 100644
--- a/Documentation/devicetree/bindings/timer/renesas,rz-mtu3.yaml
+++ b/Documentation/devicetree/bindings/timer/renesas,rz-mtu3.yaml
@@ -169,27 +169,27 @@ properties:
       - const: tgib0
       - const: tgic0
       - const: tgid0
-      - const: tgiv0
+      - const: tciv0
       - const: tgie0
       - const: tgif0
       - const: tgia1
       - const: tgib1
-      - const: tgiv1
-      - const: tgiu1
+      - const: tciv1
+      - const: tciu1
       - const: tgia2
       - const: tgib2
-      - const: tgiv2
-      - const: tgiu2
+      - const: tciv2
+      - const: tciu2
       - const: tgia3
       - const: tgib3
       - const: tgic3
       - const: tgid3
-      - const: tgiv3
+      - const: tciv3
       - const: tgia4
       - const: tgib4
       - const: tgic4
       - const: tgid4
-      - const: tgiv4
+      - const: tciv4
       - const: tgiu5
       - const: tgiv5
       - const: tgiw5
@@ -197,18 +197,18 @@ properties:
       - const: tgib6
       - const: tgic6
       - const: tgid6
-      - const: tgiv6
+      - const: tciv6
       - const: tgia7
       - const: tgib7
       - const: tgic7
       - const: tgid7
-      - const: tgiv7
+      - const: tciv7
       - const: tgia8
       - const: tgib8
       - const: tgic8
       - const: tgid8
-      - const: tgiv8
-      - const: tgiu8
+      - const: tciv8
+      - const: tciu8
 
   clocks:
     maxItems: 1
@@ -285,16 +285,16 @@ examples:
                    <GIC_SPI 211 IRQ_TYPE_EDGE_RISING>,
                    <GIC_SPI 212 IRQ_TYPE_EDGE_RISING>,
                    <GIC_SPI 213 IRQ_TYPE_EDGE_RISING>;
-      interrupt-names = "tgia0", "tgib0", "tgic0", "tgid0", "tgiv0", "tgie0",
+      interrupt-names = "tgia0", "tgib0", "tgic0", "tgid0", "tciv0", "tgie0",
                         "tgif0",
-                        "tgia1", "tgib1", "tgiv1", "tgiu1",
-                        "tgia2", "tgib2", "tgiv2", "tgiu2",
-                        "tgia3", "tgib3", "tgic3", "tgid3", "tgiv3",
-                        "tgia4", "tgib4", "tgic4", "tgid4", "tgiv4",
+                        "tgia1", "tgib1", "tciv1", "tciu1",
+                        "tgia2", "tgib2", "tciv2", "tciu2",
+                        "tgia3", "tgib3", "tgic3", "tgid3", "tciv3",
+                        "tgia4", "tgib4", "tgic4", "tgid4", "tciv4",
                         "tgiu5", "tgiv5", "tgiw5",
-                        "tgia6", "tgib6", "tgic6", "tgid6", "tgiv6",
-                        "tgia7", "tgib7", "tgic7", "tgid7", "tgiv7",
-                        "tgia8", "tgib8", "tgic8", "tgid8", "tgiv8", "tgiu8";
+                        "tgia6", "tgib6", "tgic6", "tgid6", "tciv6",
+                        "tgia7", "tgib7", "tgic7", "tgid7", "tciv7",
+                        "tgia8", "tgib8", "tgic8", "tgid8", "tciv8", "tciu8";
       clocks = <&cpg CPG_MOD R9A07G044_MTU_X_MCK_MTU3>;
       power-domains = <&cpg>;
       resets = <&cpg R9A07G044_MTU_X_PRESET_MTU3>;
-- 
2.43.0



