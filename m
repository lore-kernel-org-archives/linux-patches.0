Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BF18E36C;
	Mon, 28 Oct 2024 06:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097465; cv=none; b=APuuN7sQvvoTESaz1JB/CDrSv64GqP3sztmj5eZ0/T8miNN03bFB+QFmCAHYPAORZ/903GEskQQJ4wUvnnWAUCq+lY8rLt0sL7naX6Yg/rFNEG5x3kgYXCgQn4tkh7iSLgtkFWQVwpeRzPY45ifCqAQoW2zzLDaWtlfS2jrB9Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097465; c=relaxed/simple;
	bh=MLoETPwR2ZUmvN+qd4iAQ2bEbPTpXIAxn4Rv8aAPKOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTS1/vVMA9bCcQu1YFJXuGcImV4MuXli0NDLnKCry532Q9HzFSk/SnRqTZ8PBknUKhfNqh81dWOXk+QaiSNdPNi1iHg0QZgoyZepBwm++EwD1nBa27ScZmY4r96cJMFE7Ao0aovJeA7H6zfotz7Wv/H5kALHaihZK6P5CVKGxyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6OwVKc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6OwVKc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5A4C4CEE8;
	Mon, 28 Oct 2024 06:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097465;
	bh=MLoETPwR2ZUmvN+qd4iAQ2bEbPTpXIAxn4Rv8aAPKOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6OwVKc0qiSWtuvO7hxA5urhFSoSNGilPWWoWmDYdkvzSVCKhvAfU4UODRutPF/Yd
	 yonn4T/1gNrQVVzOTUniBUcHGq46c652olnBUBojRq91ZrPvt7CBAvEbnYcEtYNmXX
	 /qHKAk0peTn7RIlFyJe/0zmm9mqT+FlEesYMz5SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/137] ASoC: dt-bindings: davinci-mcasp: Fix interrupts property
Date: Mon, 28 Oct 2024 07:25:45 +0100
Message-ID: <20241028062301.734503334@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f46c66bc6b2d8..b181f7481a951 100644
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



