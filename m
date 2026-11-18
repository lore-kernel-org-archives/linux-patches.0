Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045309;
	b=FfTu43wXedhdVesFm3McKyBrXNzhYSLT1t2EB6pMsZFGF8CZgXwEOhnYhk3K54b25sIU
	 KxyhVL+co9wzutlVJ75hxo34j0IA2B6L+IUVVVK4F/qAIjk8S0TzJ1tR8SfdQsWEjbvtW
	 qUCbNhPRr4KPsicAYlKTP2r2/huLwZDtLOuCvvCHj+EKfzspcp7ngqquRwS+NTYbEtlAb
	 Yj83ZplFrs7FTNOBFTQkjyCz/XBpC8LY6zmOYMpFAbYN74ta8elEQQsjTbGf5g/YKTf99
	 qaVJUDkVm8F5HGbk0YytXgPZGS5c9kydL8L0RGInAazRGS4PUNj8bYW4BwUoDc/ZxCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eVWQZPNUuBhj0OPqHk4pQB9VYnbvjkOrzImWQTyLlrY=;
	b=LxJ/mieMZm8o+EjX/cVPjmxud6+KcIoORFjRPeX8JqOUBQkGkihsHNwAPiDNGf6ZDXMK
	 fFJQzjcAY00tXxp1wwHZzFHdWrhBuvpfoRNd3q7fNTu/PZ1WsWZWs7TUSjtP2MrYt/NQF
	 vpqTzSfESbVh5hHZVQAR2f6F8QPv52R+vbTH6Yasamxv6egCObYYbg3hgjr6HkRii/VA9
	 BDuFzr5QAPeawTuumc7DuchOiR35guHPiewVYSWXBqsHwePT8i5fJbhRqbRTr/Nkmngg/
	 qdw8JcRDJQf5MIclblUtwmZVOkW7+yRopMDyxD6R7cmcLg/JIvFcsanZdVoyzqx+Mhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sehdlruq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68BB606A31C;
	Wed, 18 Nov 2026 23:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sehdlruq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479B01F000C4;
	Wed, 18 Nov 2026 23:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045308;
	bh=eVWQZPNUuBhj0OPqHk4pQB9VYnbvjkOrzImWQTyLlrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SehdlruqNa9Sf0r/luHRQ4mHnEM0uFcEJja6aE/1lxVYhuRNJ/Nfl6VkVTYCWsLak
	 yM24UDro8JkTSoXo+fgKa99PXstMe+YDPEwImPI2pMPqbnE99r72KwDzb23/H2ZMC+
	 7XTRqW+yMNPPZtiWwEtSc50I9/FDdTW3T20wQeBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0840/2857] ALSA: core: Check shutdown flag at D0 power-state, too
Date: Wed, 18 Nov 2026 15:31:14 +0100
Message-ID: <20261118150231.820285738@linuxfoundation.org>
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

[ Upstream commit ad63c5b62843895e8c3cd7291ed07cc659df0355 ]

The snd_power_ref_and_wait() skips the card->shutdown check when the
card is already in D0 state and immediately returns as successful, by
assuming the all-green in D0.  This assumption makes the code after
this sync point behaving as if all power is up and ready, even though
actually it might have been already at the disconnected state.

Add the missing check of shutdown flag there for the more consistent
behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260929125346.1478631-2-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 4d8c77deed185..b3a7df3c85df3 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1146,12 +1146,12 @@ EXPORT_SYMBOL(snd_card_file_remove);
 int snd_power_ref_and_wait(struct snd_card *card)
 {
 	snd_power_ref(card);
-	if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0)
-		return 0;
-	wait_event_cmd(card->power_sleep,
-		       card->shutdown ||
-		       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
-		       snd_power_unref(card), snd_power_ref(card));
+	if (snd_power_get_state(card) != SNDRV_CTL_POWER_D0) {
+		wait_event_cmd(card->power_sleep,
+			       card->shutdown ||
+			       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
+			       snd_power_unref(card), snd_power_ref(card));
+	}
 	if (card->shutdown) {
 		snd_power_unref(card);
 		return  -ENODEV;
-- 
2.53.0



