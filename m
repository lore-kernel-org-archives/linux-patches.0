Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBCD18EFEB;
	Mon, 28 Oct 2024 06:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098415; cv=none; b=d7GjGFe83frOG6WF/Te1Oe5d+FZQg58HSW30D4+wt8Qk0OGNq9byJDgxToydjzPlfxemhM8oLgrz079Wvh+9KdDww8SW0/7CRDohcg+j3YigQdA1JgqgNwWLfPwtSo00a+kHKRK0mKfxe8AAKXSokod6gP8SaUFubrVnpRQhkZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098415; c=relaxed/simple;
	bh=GY6s1z4yp5Nw4yfuMvPBmL9tVsKsLuyV1+igRjcRbv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npEFWNHbcMXE8nSZ7lJUY93BkXE7WDdxjTUQ6MxqSMU0kRg4UDXWXNdKjTFym4eDmoGs3HH/YIDl78tQtWmHCv1WqLmn2BT1Mwu3MHvcvfbi2wmCf6mWX8FcTgPZEeCpK44q6UJtCrQzG7neqqTZ60z73iF4WTIDGDIEoLQ2NY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWfj1bUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWfj1bUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A113DC4CEC3;
	Mon, 28 Oct 2024 06:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098414;
	bh=GY6s1z4yp5Nw4yfuMvPBmL9tVsKsLuyV1+igRjcRbv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWfj1bUi8akcxLOYeH4m5Dhti7n1TLLQHwN7aNfnTH0M9zX3lDKk5tS2Xn+zNTCph
	 7jVaHTAlhIQuKZepKtuiAKlXPdwwmKKaOdUlbJx8srTCWOZGId7COP7bbNDyrRb3yq
	 w2qf6qYSnIcED95+FiGTjopqS+XBKcJoFBQmME1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 181/261] ASoC: dt-bindings: davinci-mcasp: Fix interrupts property
Date: Mon, 28 Oct 2024 07:25:23 +0100
Message-ID: <20241028062316.543166110@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 17d8adc4cd5181c13c1041b197b76efc09eaf8a8 ]

My understanding of the interrupts property is that it can either be:
1/ - TX
2/ - TX
   - RX
3/ - Common/combined.

There are very little chances that either:
   - TX
   - Common/combined
or even
   - TX
   - RX
   - Common/combined
could be a thing.

Looking at the interrupt-names definition (which uses oneOf instead of
anyOf), it makes indeed little sense to use anyOf in the interrupts
definition. I believe this is just a mistake, hence let's fix it.

Fixes: 8be90641a0bb ("ASoC: dt-bindings: davinci-mcasp: convert McASP bindings to yaml schema")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20241001204749.390054-1-miquel.raynal@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8380dbf1b9ef ("ASoC: dt-bindings: davinci-mcasp: Fix interrupt properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/sound/davinci-mcasp-audio.yaml          | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml
index 7735e08d35ba1..ab3206ffa4af8 100644
--- a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml
+++ b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.yaml
@@ -102,7 +102,7 @@ properties:
     default: 2
 
   interrupts:
-    anyOf:
+    oneOf:
       - minItems: 1
         items:
           - description: TX interrupt
-- 
2.43.0



