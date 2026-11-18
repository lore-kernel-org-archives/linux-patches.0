Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055937;
	b=puJNAJnCV0QYg/MWVMaSeHO9rwxJCh45EgcFwwCpkPTXxQL+6utOctgdrkGuMVx9v9Dt
	 GijLR0gp+u/BxcofYIW13qUvYG7bgbRVePWaNrOrWfsnKGuAj8e8uK/xWyFnVVMTrOAMf
	 MgFC2lbYfi24Nj1ZxXE+CRizhdqx8CWPWg44cDF27o6J8qtvO2ChsYXgnEm9FhiZaziT/
	 abRYZfXQnQhZWHj+8X8dlYQwLZyqJ87bghMo6l+2bhVR1RUwOYh0LXv2nVjufm3B+W4yB
	 pHm9y60LeeLxekoDT8SCB6z5B9Iv3Vlm5mCVuEmV528pmvf+kJEA12bH5pENMzZiWFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fBGj5ozqIl2fztkMEhjtrwW6iXDEQmtK0la5ZFXZPyY=;
	b=dAX0sTip3G41KOCX7JKC8EO7e83dmWYWyY3Ki0obZPZzaUMy5YUvf81vWaKdU8YYNFHn
	 d2SLfqQgAepcAlQgQ6jq70GKGeSjk5AlLS9MJx1douMoysLN+G/sy45Lg6eW9n6oDSkZi
	 H8EH8TGnrURDvNvwmMp9n3JmIzAPASxOWeT8u5gEL43zK9Ww+dLDqNleOns9Fg8lcWaDO
	 t9R0DzchH97jHePfZ7gxdvFF76nkDy7RMk+HNhI8mPY19BIFNz4srHKznjl0CBzJTMamd
	 vhjVadmYJ8R68RzoMJg6Kum2ijJJHCD6M5pFK5REeuj1CDUf44e8CHQy4CtF0Ms/aNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vk501zro;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB13606A325;
	Thu, 19 Nov 2026 02:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vk501zro
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C001F000C4;
	Thu, 19 Nov 2026 02:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055937;
	bh=fBGj5ozqIl2fztkMEhjtrwW6iXDEQmtK0la5ZFXZPyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vk501zro4IG5/isSmXX6Whijx2OF2cqsCmnUjGZxCp8UFuUtSLK2sSAQGHIDAGFHi
	 lvFkNxbEAbXLE41Q3aXL6MG9DjEiUemMTDOEm4hKrudCkLBahqyW5VsJxSJSCamT/Q
	 5iHdRhnXL+1k6q/naKUGNdQ909mRCh4nNSLgXdiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1808/2214] ALSA: core: Simplify snd_power_ref_and_wait() with the standard macro
Date: Wed, 18 Nov 2026 15:58:04 +0100
Message-ID: <20261118150123.815572156@linuxfoundation.org>
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

[ Upstream commit 8c0ae778e2874f3742bd619000b791d178c187e2 ]

Use wait_event_cmd() macro and simplify snd_power_ref_wait()
implementation.  This may also cover possible races in the current
open code, too.

Reviewed-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20220119091050.30125-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a69138357354 ("ALSA: core: Add missing barriers for power_ref vs card->shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index c0e7d4962bbc9..e9465b31f9fda 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1154,29 +1154,14 @@ EXPORT_SYMBOL(snd_card_file_remove);
  */
 int snd_power_ref_and_wait(struct snd_card *card)
 {
-	wait_queue_entry_t wait;
-	int result = 0;
-
 	snd_power_ref(card);
-	/* fastpath */
 	if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0)
 		return 0;
-	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&card->power_sleep, &wait);
-	while (1) {
-		if (card->shutdown) {
-			result = -ENODEV;
-			break;
-		}
-		if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0)
-			break;
-		snd_power_unref(card);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(30 * HZ);
-		snd_power_ref(card);
-	}
-	remove_wait_queue(&card->power_sleep, &wait);
-	return result;
+	wait_event_cmd(card->power_sleep,
+		       card->shutdown ||
+		       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
+		       snd_power_unref(card), snd_power_ref(card));
+	return card->shutdown ? -ENODEV : 0;
 }
 EXPORT_SYMBOL_GPL(snd_power_ref_and_wait);
 
-- 
2.53.0



