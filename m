Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755F415B10D;
	Mon, 28 Oct 2024 06:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097826; cv=none; b=srBwCiUCYJ2IigQ6yruiz5ylfmE5t+e24z1OSSxVNtV0QUuayN4gqptc5k5KeWenfQjDqWCU+q50DZUVThuTTwAWGABYmuxoriqUXX9UmYrQWsGeo/kgYUb2UXvHhtv10zoW8wStQzNMmIfyTwKRafG824FoLSmrxQoKe9ZeOng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097826; c=relaxed/simple;
	bh=lFZk5nyrAzYOzqw6KF5Bh4mqdkOXkXaYCiPga1Yt4BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4UiZbqFRTmXndfXAMia2CsaFbgshE+frHWjk5NfeGJaSvChVCiL+LmmvY9C2BBuloJln6mpDDWugdxZCqtMroYgrh+zbQNiBxZv/B6gwwzM2xQIuS9sXvEmGKxm2D6i/C6Prug/j3fTSaydbR2SqtyxAwS318RaESe3LvLfmEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKoDW7y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKoDW7y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B0AC4CEC3;
	Mon, 28 Oct 2024 06:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097826;
	bh=lFZk5nyrAzYOzqw6KF5Bh4mqdkOXkXaYCiPga1Yt4BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKoDW7y7rEMH5SQ+OCzs1F/MMhjEc+97q6AlY32KYQ/KK/AomD8wB6FAL5jJTaga7
	 XoodHDQa223M5baETM3HKBQETLycwGL+sZsZZA0sdUDnAr5Gd2wAE7O+fNWOv6dppF
	 hjZ7OPRMIq/qJFti4XouKjB3HEz95UEajiPjLwO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/208] ASoC: dt-bindings: davinci-mcasp: Fix interrupts property
Date: Mon, 28 Oct 2024 07:25:44 +0100
Message-ID: <20241028062310.668861945@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



