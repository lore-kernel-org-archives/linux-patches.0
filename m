Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049475;
	b=ctx31FjnOhbHJzFVkhNGdiMVfHR9ARaS7q7HlJl9ibT47GvPcMOVNPvIG6jBxX7PXPG2
	 4J/1s2grH3U0jcD2hOCfpMJJQsOiIpLbzKdje+TjY1CC08idmrv7XObZuh6ToPQdXf2+H
	 hI7oxlo2A3PuQ41U5IiUr5Vi5JzFzsDT1l90wA7SU15/2o8mzq+b0YINYU0z8b6nwlIal
	 BPfY+dYxyk8hNKhBPW+pP6iD6hNGyOzSsJ29oMUQ65jGT1/sxYk/awN/Paziyjqsf0bBh
	 Xk8jbRIr0xFelpLUTpXb4PoWWC5dC2HfhO8zPh9rdwmMsIE6ApGIAi9X1Fe26+VW4iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aqwAtDPBcVgVl3PVkmTRszdMEfyoOiKuZy3CmQ7TBBI=;
	b=S3YfxbeZ3njUFX36iB7CTnJYywqurppYlBYJqRGtAfQb3+1keXaQXnxau50wLC9z0ib0
	 SIJPWPCBj66azFTANTmsAK0jNF4cUxwkgQPsR0Pp4DRe/2M81oqkZsFYm/Df1kwTtXunb
	 lVvS8n5FvRcs/uxBZ6n8+SX2Ue3oa5rv0AKYzNsqVp+6MzvXpvcPZyWQyTP+lGntZVjWu
	 FfuA5MRQs9EazLvpAtAwtb3+btG82rPky9hkan05SEzciDqA2GF2TvrN/zwXAYautB05b
	 4D02NxF2ONk2OmKLpG7kMJ2+tQ/WwP0y7JJuOnqgeG+shUMYAQoG1bO7LhfLOOAnuYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQb4BbqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BB8606A325;
	Thu, 19 Nov 2026 00:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xQb4BbqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D2A1F000C4;
	Thu, 19 Nov 2026 00:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049474;
	bh=aqwAtDPBcVgVl3PVkmTRszdMEfyoOiKuZy3CmQ7TBBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xQb4BbqYHNADNi9Ueg8pX/RKfnE34VAEQrcK8QBFygQFIv+8pD4pOA29YoT+nkPzF
	 YzxQd5RnjDVNsIrlZ7GVCJONQI7+Y6GRpJ0hY9kiGokBHAwtLFlDzDGQ2YbpzfjC7d
	 1BiPFBBh75eMZQ2L0cnE7OE8eP/u0e5qxP+ZSgmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2323/2857] ALSA: core: Remove superfluous CONFIG_PM
Date: Wed, 18 Nov 2026 15:55:57 +0100
Message-ID: <20261118150325.178442555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit da0713fff528112890aac02fea08937b65d5c8ba ]

Since the recent code change, the conditional build with CONFIG_PM is
calling only snd_power_sync_ref().  As a dummy function is provided
for this function, we can get rid of CONFIG_PM gracefully now.

Link: https://lore.kernel.org/r/20240510125128.6058-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a69138357354 ("ALSA: core: Add missing barriers for power_ref vs card->shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index b3a7df3c85df3..d164646ab9602 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -550,9 +550,7 @@ void snd_card_disconnect(struct snd_card *card)
 		clear_bit(card->number, snd_cards_lock);
 	}
 
-#ifdef CONFIG_PM
 	snd_power_sync_ref(card);
-#endif
 }
 EXPORT_SYMBOL(snd_card_disconnect);
 
-- 
2.53.0



