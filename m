Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031259;
	b=xSkTQaBdHPE5eX2h39AmEaZaeaXqLDswOfX017R0aCdbecqkuns08044w02LpAfz7umz
	 3Jd6K+Uh9oUyNbr3S6A6g2LxkLX+vqmiLEx0Tji0AKEtHg9zzK/zeFTnwJfrkuE0gx20j
	 2Yj8yWRaZRNnogztDNTkiPeE36FNzoJ7HEQ60HU9LqX0KMnrPe6eWA+lDNjbYs/yv1xGF
	 xpsqVRQj5eYSC0Q9WY+iDxjr71FVVkNtlgFVjignWV1LYh66+mhuG8YE++Q50rscJQre8
	 fu7QC1KkK/8JQXveN4MNB52sh56Vb8ZbGelpq3KvoLCrZk2d7KlkwzFmOXLkp7Bkm8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQk6yo3E4SCtzEA+i8ngUlX8/a3tyo96T0Yn4bWQaLI=;
	b=ztwoRPq7wTxjaULelS3erJUZQ5Tm4qHUVKvls1S1zvRCxFxXT45nPs8TdNxtAbbtB1j0
	 os8gf2/NwXbP/m+LmNwTKlk+XEHSSzUcQv8xTNgSSwRkuTTXl+ZjyS5mSTNr76eEecXA3
	 WJiU+mAYjCKEMoz5kHCylWfjQjU59x5uwN80xyzHdL6k5JyOqfbFZg+Y88Dg7JWBBByiV
	 wm6XZ25APZiyOgscAvaFuMzDAREmcTyN6aBgw95Ct+MbcWuT/sy47rbWLEaylh9UmqVa+
	 XQCCFvpHWxy/SsK8DYFDiZvNDM4Oo5QD2eSltmhpC5w9e0qgI4wSbDXuv3YdqafvuMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJGK5wuX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBB7606A31C;
	Wed, 18 Nov 2026 19:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJGK5wuX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37051F000C4;
	Wed, 18 Nov 2026 19:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031259;
	bh=SQk6yo3E4SCtzEA+i8ngUlX8/a3tyo96T0Yn4bWQaLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJGK5wuXYRCISXfJyNwtuFT6pMsW4N7D6NUhCO+huppRAzO25zAGBRBRKs2zGxGeo
	 z0BNu/trSbY31hIbIPDYzhyWI6UmMTQYIc5TZtbuur+uhbNkIj6gibJni+EkeECNsJ
	 mFtnlntNToG4WwTQEitAsU1UtP496aLtIBu9aiqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0995/1756] ALSA: core: Add missing barriers for power_ref vs card->shutdown
Date: Wed, 18 Nov 2026 15:52:02 +0100
Message-ID: <20261118150049.796339498@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a6913835735469751f56473f5212eb291a4805e7 ]

snd_power_ref_and_wait() increments card->power_ref and then reads
card->shutdown (and the power state) locklessly, while
snd_card_disconnect() sets card->shutdown and then waits for
power_ref to drop to zero via snd_power_sync_ref().  Due to the
missing barrier on both sides, the caller proceeds with shutdown still
seen as false, while the disconnect side sees a zero refcount and
continues tearing down incorrectly.

For addressing the potential race, add smp_mb__after_atomic() after
the refcount increment and smp_mb() before snd_power_sync_ref() in
snd_card_disconnect().

Fixes: e94fdbd7b25d ("ALSA: control: Track in-flight control read/write/tlv accesses")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-9-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/init.c b/sound/core/init.c
index b37269b86be89..d39dc0198370e 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -552,6 +552,8 @@ void snd_card_disconnect(struct snd_card *card)
 		clear_bit(card->number, snd_cards_lock);
 	}
 
+	/* order card->shutdown store against power_ref read */
+	smp_mb();
 	snd_power_sync_ref(card);
 }
 EXPORT_SYMBOL(snd_card_disconnect);
@@ -1142,6 +1144,8 @@ EXPORT_SYMBOL(snd_card_file_remove);
 int snd_power_ref_and_wait(struct snd_card *card)
 {
 	snd_power_ref(card);
+	/* order power_ref increment against card->shutdown read */
+	smp_mb__after_atomic();
 	if (snd_power_get_state(card) != SNDRV_CTL_POWER_D0) {
 		wait_event_cmd(card->power_sleep,
 			       card->shutdown ||
-- 
2.53.0



