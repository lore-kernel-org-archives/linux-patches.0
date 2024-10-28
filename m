Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B458C15B10D;
	Mon, 28 Oct 2024 06:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097828; cv=none; b=MHG7zWSxoc40bslK44q9dP40zwofGtIAp83a2DluwmlS0L0Oca4nMSgk2y0wwGYZvYL48qx8dKJihxwMPeB25g8K9sTkLGey60xQ5nBylLXVUG5IYG3065ZhSLfdOYL7RiTpYFVgSG25FTOOcA88zVuz87h4GdaGXo6V9wRlVXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097828; c=relaxed/simple;
	bh=K+pPh+5g7hPw63W6mWxPFllqfqtr6NAwz7Vj9+EbNlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9x5f2XOdJ8Ao2ZNkxKb4dPFuprjEonDF9TIR5YkGDzS7neFrauC4xqOgy1LsULneKDQPPAtbP9LE85bttDWMAaw6e6Njei+Bi/8mUo7+N482YpS3x5q5Wmx/0uDIj0uWidxtpySuXBL7UEASuuRs4SXEjX9lqPuf19MekUMXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs7KDA4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs7KDA4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558DEC4CEC3;
	Mon, 28 Oct 2024 06:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097828;
	bh=K+pPh+5g7hPw63W6mWxPFllqfqtr6NAwz7Vj9+EbNlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vs7KDA4JWu9OqqZoVQq7WZyQH9ys25fbmb3pimRU0Tump0K748Vi7TfZObTOdLYLM
	 yeDwn16LXLxkftNzlIVMf77NnmFWHqnIveY52hs8hdrBidcF6s9zajmRvi1rwTsZew
	 a0Qy4M7khS78xLpKmqbXoVqKpPvpBGsAlSbEY+BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/208] ASoC: dt-bindings: davinci-mcasp: Fix interrupt properties
Date: Mon, 28 Oct 2024 07:25:45 +0100
Message-ID: <20241028062310.693538827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



