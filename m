Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032154;
	b=SEVKP4IUUI7ibLbgYyFYnybZSq2+0mejx9znlleVVDgXwfu7MvW7i30UFO+mnpGpadpQ
	 zCYVvXXdlOMR3Jpm9Ofrr8Tm0NHhXMBmjpUSrARHlveTILDZK6qT13x2VSk0+4x0RYxLF
	 0up7SEy27S4RhNxYwrWDPtOesChFKrNKaiFPMcCyyXOILF+/hEndpYbPQcWKrhkZrda3Z
	 fgCXFHzTUfj6t4lHuFBDMTU3OrunBE4YEfB1dlRE5ghDtPL81YyPriq3hD018R2QY4WnY
	 W3AHRk5+w9yFB1CduLDvoCz0lNOsGV18lxOZ41gZIs23dk+BlcGaoZ+z7XbemntqFfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EgpMRrarpCsjlww6ctVRV97TM50VOpGDdm2m43ctGUU=;
	b=HJE8u3+NqRcWK7h6Wavxh1EMMNKtaPqyrBCp0tnlnLZMDlUtT46mJdLXWr9UlkPeNbcu
	 4j2mc0OmVpSWAJ2XKCLJYkyU2TtVULYVWbjVCSyo9LvE8HkJkxGqDh3zLjnp8qnkuuoBk
	 dCqsmKdLC6W/i12OmI4W+ymxMrU03hpReHKbBCtqmba1Qkw1Nl2m5xDA2r8IBGz+F1F4x
	 duMu0pvKGwDUtA1mjj+rUtv7/prcplgx4cPlxj0KHDyIvGl1wan6AFfRcd49xMYMQyXdH
	 u+O7YOOuESD32UWmCX6skYeOIk0nElXbBbAHWP/a0FoEQzqSP0EvXNHHa2Lnpmui+rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfsz3WC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61206606A320;
	Wed, 18 Nov 2026 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfsz3WC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AA31F000C4;
	Wed, 18 Nov 2026 20:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032154;
	bh=EgpMRrarpCsjlww6ctVRV97TM50VOpGDdm2m43ctGUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfsz3WC+LS9ulUwFbf7SMv+T47rehX2ZlSvrh95dNK4hAzTTzuMhTORy8aUlHJHrf
	 XbIQf7+ouh4QKmbUGDgtpP1oRtPBFiqPf4VBknQ9QQMQfx/irYWuEYqBVKWL1JbQEl
	 dQBCiMVp6Dp/oWckOpbIZDejZBTPEtvw1VsHo0FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1310/1756] ASoC: mediatek: mt8195: Propagate IRQ lookup errors
Date: Wed, 18 Nov 2026 15:57:17 +0100
Message-ID: <20261118150101.630654970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 9d5dedb285fb61a40e04f337d9e06fc59c065857 ]

Propagate the error returned by platform_get_irq() instead of
replacing it with -ENXIO.

This preserves errors such as -EPROBE_DEFER for proper handling
by the caller.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-12-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 592b5956342ca..543b4990c7bad 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3134,7 +3134,7 @@ static int mt8195_afe_pcm_dev_probe(struct platform_device *pdev)
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
 	if (irq_id < 0)
-		return -ENXIO;
+		return irq_id;
 
 	ret = devm_request_irq(dev, irq_id, mt8195_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
-- 
2.53.0



