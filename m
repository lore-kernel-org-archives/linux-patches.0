Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D281D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r59cLzvp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B07C433C7;
	Wed,  4 Oct 2023 18:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443823;
	bh=wAkFdlRAphs7S/2vUT1E33CL0mfjbhw/7x6v+MgaN44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r59cLzvpjXeab816NvrDS/K1aCCXXmVKqwCgrpUgzqYQKKXp1u8Hi2rxf+PDPgYp2
	 5b4Mfu2amX+tfV0Vfcw9oqsnY5tAaH5Qhw1RliKTY5dHgsnMKIxv3mqtyQUpZUUJZO
	 hHVfYkpWdJNBRInBEjPcpZWCQr2n76mzk+W0nBig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senhong Liu <liusenhong2022@email.szu.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 033/321] ASoC: rt5640: fix typos
Date: Wed,  4 Oct 2023 19:52:58 +0200
Message-ID: <20231004175230.698970303@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Senhong Liu <liusenhong2022@email.szu.edu.cn>

[ Upstream commit 8e6657159131f90b746572f6a5bd622b3ccac82d ]

I noticed typos and i fixed them.

Signed-off-by: Senhong Liu <liusenhong2022@email.szu.edu.cn>
Link: https://lore.kernel.org/r/20230819133345.39961-1-liusenhong2022@email.szu.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 786120ebb649 ("ASoC: rt5640: Do not disable/enable IRQ twice on suspend/resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 24c1ed1c40589..10086755ae82c 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2568,7 +2568,7 @@ static void rt5640_enable_jack_detect(struct snd_soc_component *component,
 			  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			  "rt5640", rt5640);
 	if (ret) {
-		dev_warn(component->dev, "Failed to reguest IRQ %d: %d\n", rt5640->irq, ret);
+		dev_warn(component->dev, "Failed to request IRQ %d: %d\n", rt5640->irq, ret);
 		rt5640_disable_jack_detect(component);
 		return;
 	}
@@ -2622,7 +2622,7 @@ static void rt5640_enable_hda_jack_detect(
 	ret = request_irq(rt5640->irq, rt5640_irq,
 			  IRQF_TRIGGER_RISING | IRQF_ONESHOT, "rt5640", rt5640);
 	if (ret) {
-		dev_warn(component->dev, "Failed to reguest IRQ %d: %d\n", rt5640->irq, ret);
+		dev_warn(component->dev, "Failed to request IRQ %d: %d\n", rt5640->irq, ret);
 		rt5640->irq = -ENXIO;
 		return;
 	}
-- 
2.40.1



