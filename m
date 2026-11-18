Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055945;
	b=xy31sI4oSCXvl//EQ5MsVRHl+vENhAM9Jh9b3t+o9YOnE6Q60kwHn8lcBjS57e+4yyKo
	 ZZOxhtZJVWs3lAlWaRqDKY9lD+wVZa2CfDbpoZdaCZdpFUyUzfmAimBz/JgZzVm3U259I
	 70AeK+emtpsel/WCPmCEejY+ou3n2e3yLpkfR9s5uGNg1Py0DDIEegVNwoyS95lI6c/tA
	 qHIZAAe8Rqs8S5pbYpQEIjmUJkWyXS5ZdvqvlD/pKAYKhR7deiGKkHEyMGf/iwSbCKP9Y
	 l82+h/lcOoKQyT+bGxCIOvER0tGn5ebVmI1Bs1HtkPSyHj5aFACyk/oBSw85Swy9DaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s46iNCBMlm0ICrWBRvsDVNZ3/bsGeVe13twci7HPP/Y=;
	b=Vbf5v5DIg6SXqIZF1urYQvoLJz+xZqwx4KbAEbNAcyLyapck2GzgWnUa7h/jfCAUHtjg
	 3Ezev7awjCZbGqAJz/jt1BLx3MAAvV/Iok26ktE7uB7KMOrp9lept7h9BhRTQzHBpUyEh
	 2wqQDyPsJImFP8H/chdd6b2JhirWCLhQjGpDBFBhrf4wPq4/Qfrw4iLJM0Kn3A/TeLI5Z
	 F6bLDQO4wTHkrbuGEjeNKMlXvj3TG39RGEi044d3bDVU7PZKLonTWMd8Kaeh/rvPvKtof
	 iNIQztfLIrioiKnZb0RucwLo42720R+8ENilUn+zL5WZtPrREH3Ph4B9HEwlMquW8SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKHdnHjZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70044606A31C;
	Thu, 19 Nov 2026 02:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HKHdnHjZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2C51F000C4;
	Thu, 19 Nov 2026 02:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055945;
	bh=s46iNCBMlm0ICrWBRvsDVNZ3/bsGeVe13twci7HPP/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKHdnHjZGyIVaFjI0C3LbCNLK7KJdyZ5PDis9RNpKPmkbRsTc1bDDXvK3O+rHRQ/5
	 lAJVNz4f15RforoEsZL1q/dxudhVuts6RJYyYASx6Ni/GDE0OADdHLCQ3LzyswsM4U
	 uNnIhus+FeUb0doaeUDwCl6yhUF1SdV9I/AQSzG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1810/2214] ALSA: core: Remove superfluous CONFIG_PM
Date: Wed, 18 Nov 2026 15:58:06 +0100
Message-ID: <20261118150123.891659289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b915f4461ec23..29d7a9082352d 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -542,9 +542,7 @@ void snd_card_disconnect(struct snd_card *card)
 	clear_bit(card->number, snd_cards_lock);
 	mutex_unlock(&snd_card_mutex);
 
-#ifdef CONFIG_PM
 	snd_power_sync_ref(card);
-#endif
 }
 EXPORT_SYMBOL(snd_card_disconnect);
 
-- 
2.53.0



