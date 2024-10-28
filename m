Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4535118D649;
	Mon, 28 Oct 2024 06:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098417; cv=none; b=nwTa+e7EgOxwxWTHftNTgXopSmJkkXkGGlxsldc03caiVkDHf+wbGFbtd1df16wMEARsJFIC3HuunCARKcaYztOOXHeohZ/DlXfX8jPlgNjTkGDSzsFmQHb4sTOTwxHpAl4JK5xlKRX5DmSMjZr70CurefQOsxPyfI1ck14mnIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098417; c=relaxed/simple;
	bh=/LgpQsWwDUjXDyozNJpSHK/TWWJpdUTRh4u5OYXdlA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X+jt0iXhU2a8ueSZo4bIYq6zw+/ajzbk7XkaSJlP6HeABCik1dtY2WvLFktK6GwvP2CwHX7N8RJDZ7OgMohRygL1IssjEojlnjAZzXvbp2EHJOdg2/Dn9db45UewADW+FiicLVT1VK51L6t7Cky13BBFB6ssIuTyIg/rv4XtJXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOffi0CH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOffi0CH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9628C4CEC3;
	Mon, 28 Oct 2024 06:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098417;
	bh=/LgpQsWwDUjXDyozNJpSHK/TWWJpdUTRh4u5OYXdlA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOffi0CHYInyoXDqnnWPFfH/+hKCwWtngL6q62J8MrSv54GtimFxz/gZ/nHnGOkwh
	 n/ZQxy5qvS4Xv5Jk67JNvTl+iHw7lfJyfchUQNDVY4vhhbhl4gbeKvjQW5IarGyqAD
	 wKjyUtKvCaFRuafLfWir+31DA+vt+eOzh/nNuUXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 182/261] ASoC: dt-bindings: davinci-mcasp: Fix interrupt properties
Date: Mon, 28 Oct 2024 07:25:24 +0100
Message-ID: <20241028062316.567898795@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8380dbf1b9ef66e3ce6c1d660fd7259637c2a929 ]

Combinations of "tx" alone, "rx" alone and "tx", "rx" together are
supposedly valid (see link below), which is not the case today as "rx"
alone is not accepted by the current binding.

Let's rework the two interrupt properties to expose all correct
possibilities.

Cc: Péter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/linux-sound/20241003102552.2c11840e@xps-13/T/#m277fce1d49c50d94e071f7890aed472fa2c64052
Fixes: 8be90641a0bb ("ASoC: dt-bindings: davinci-mcasp: convert McASP bindings to yaml schema")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20241003083611.461894-1-miquel.raynal@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/sound/davinci-mcasp-audio.yaml    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml
index ab3206ffa4af8..beef193aaaeba 100644
--- a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml
+++ b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml
@@ -102,21 +102,21 @@ properties:
     default: 2
 
   interrupts:
-    oneOf:
-      - minItems: 1
-        items:
-          - description: TX interrupt
-          - description: RX interrupt
-      - items:
-          - description: common/combined interrupt
+    minItems: 1
+    maxItems: 2
 
   interrupt-names:
     oneOf:
-      - minItems: 1
+      - description: TX interrupt
+        const: tx
+      - description: RX interrupt
+        const: rx
+      - description: TX and RX interrupts
         items:
           - const: tx
           - const: rx
-      - const: common
+      - description: Common/combined interrupt
+        const: common
 
   fck_parent:
     $ref: /schemas/types.yaml#/definitions/string
-- 
2.43.0



