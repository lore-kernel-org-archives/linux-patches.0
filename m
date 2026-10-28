Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208337;
	b=4Nr9m0gf3MAh9/mAHUAf030bYyDik+EdXsfo2NgupjmzuO6F49dhCH0tTrPAacIsDfTo
	 N60jAgYwaWFjm3dKkyPtalOZeuhZNpPc7y0lMynXxDaRCfsUcvOzMmzqr9ojLmG+laKyk
	 B+xixiW9O+REesl/oa4xi4q7bLiOHt/GZI+Zn7npFhV2VQMF0X7mBWIwLVF2alFkKq4Tr
	 XZoDalTMmPIkDAHkkeMjlFUtgEk+cKgvaKX7l8/dQG9YVqaEqDFfMt/CwUhmXd00aWbQr
	 b0CNetVudhgnLNfWu4HA9oQutNp5WE7x1rutkWxBItGkkPqN4F6J67ZpbmWQtkAyOsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h1ZdFJxrkAL9hk7U2BTYHKH+GWyqBAr+oJJlAiclVPw=;
	b=yeu6LgDA9n3XdOPG7INOleZek7ldTonzACkKyH+t0jkt85X9BsvCc8hVIjibiRL1oiSi
	 jPQFR1g0FBlaS67jVL0rio/abMXcTDWs8vXrxQ1caeM1WFL+Ub+fhURvFrHlfXy4vVYt3
	 UaxCB9frGfspor5X3Y86Rr46Z7kPqDECKr3ObPBuazt736YCyF9HuYSxFFJHtRX46lT5z
	 eg329u398xCZSZ47Ql0puZen167UFaLAHoL7BST359F5LkPUoOEKhN2wzBFB+olskwzqM
	 vLrkiywLXhkMrnJ2xmTXlUICnp1EmJNrR4YLvDvQ4CdCaVVGEReocdfZDDkeHRzcHCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="g9AcPtp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D64D606A31C;
	Wed, 28 Oct 2026 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g9AcPtp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD27B1F01828;
	Wed, 28 Oct 2026 17:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208337;
	bh=h1ZdFJxrkAL9hk7U2BTYHKH+GWyqBAr+oJJlAiclVPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9AcPtp/jlKjcMQTE05RZlfrJg/pz2S4GgchDohoSzIbATP2dTqtOVDwUpgZeR1W6
	 DucZpOQWLzexGVT99FN+KHPQvtu5rgyS+ijjEC/Gts8IsIUKpjaZ68QKBey8rmQZAI
	 7RQhqv9lAVz845FjMbrBEzsd3sx8B70Np1vjp9Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/516] ALSA: parisc: Fix assignment in if condition
Date: Wed, 28 Oct 2026 17:53:55 +0100
Message-ID: <20261028170005.484153993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6ea9a2b84cc354ffd028195edb4e3d60d47f7bcb ]

PARISC harmony driver code contains an assignment in if condition,
which is a bad coding style that may confuse readers and occasionally
lead to bugs.

This patch is merely for coding-style fixes, no functional changes.

Link: https://lore.kernel.org/r/20210608140540.17885-67-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 33abb7491e89 ("ALSA: harmony: initialize locks before requesting IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/parisc/harmony.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/parisc/harmony.c b/sound/parisc/harmony.c
index f2ca0a701987f..1440db8b4177f 100644
--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -915,10 +915,9 @@ snd_harmony_create(struct snd_card *card,
 	spin_lock_init(&h->mixer_lock);
 	spin_lock_init(&h->lock);
 
-        if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL,
-                                  h, &ops)) < 0) {
-                goto free_and_ret;
-        }
+	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, h, &ops);
+	if (err < 0)
+		goto free_and_ret;
 
 	*rchip = h;
 
-- 
2.53.0



