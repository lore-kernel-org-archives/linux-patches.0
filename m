Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064275;
	b=Fgu18G1otEFC6hS+6rMZklJW1wIA+MkZVeZWs/3oN/F2FFJNv40mTNXrzF1yXGH6qxY5
	 2QDWgDyxEP29o0L88PjNUpp1Je548GEgM/iKLj24qwgSARUnb2H3u0IW/EHVjfYML6GrW
	 P2czhik7sHOw+uaOoaON16SGFoDqRtUcfshPYoeymI4ueWN6jsjgip3/2rteZDb2WZgr6
	 FF7OMMi/avajtcmDUVpnSACixn7GhO0cLxrID36vlhxTlcJSehbuo6VE56Ud5r6Hj5qqj
	 alJ68WLJUDvFUw15mziXE1Ot1OuJ09O6zqpDJ8mYeNBNz5Ukhw6wb8e47wSwt0hLbPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7VytiESweGaNeJYQEonrMm7WRnG+XO1/ATKPgI0ia7Q=;
	b=Ua/20/P1Jr9JlUiUuFY/68/coozxa6qM6i80zQk+WshXRzbCFOa8BGsmkO7yxlvlgTks
	 W6YBqMUfHGp0yw2Mh6CALVU42/992cSMbsx9J7d0PuS8zDishk8tGh7CutbiQBUVRKBqu
	 Mq4bcv1VYWejGkyTQnt6jrYiVQfPVlq65jILGvZgfHtLX/QESJNCetz9fGeYBeGJvvyQo
	 JbcZ8Qpocw1rjfOcn5fLco1g6WbdXHQZOyYMgPgqTaSLaaIz/XdlpbDQg6ES4/W4LSGjx
	 NwP6F68lkkIvmINXNaiKWOqR4P9SxPKK/R1so1C5jh075CCf0oeQYf4g7VELeK3R92A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q0mwJYBs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A9F606A334;
	Sat,  7 Nov 2026 15:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q0mwJYBs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EA71F0089F;
	Sat,  7 Nov 2026 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064275;
	bh=7VytiESweGaNeJYQEonrMm7WRnG+XO1/ATKPgI0ia7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0mwJYBsqfsQVs7qt9X6H9Oh7pT4VAN7XkGymQOaQ9rIyJJSGtotBE6I4izl4u2u7
	 1lEqyHOkx6m0S8iN0F3tM3vPU08xwjeverUFJR9AIptZb+JPgPzsmqmiCh16M1bkGq
	 fWKP4kA9zfZJs6EI7eO3WbxaENDmQDID2nzb6Vvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0371/1257] ALSA: core: Check shutdown flag at D0 power-state, too
Date: Sat,  7 Nov 2026 08:44:27 -0500
Message-ID: <20261107134949.806005170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1bcb6a2e75507..a51b71812fd9b 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1174,12 +1174,12 @@ EXPORT_SYMBOL(snd_card_file_remove);
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



