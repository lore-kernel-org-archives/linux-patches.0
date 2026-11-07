Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063523;
	b=pxJondaJWIoFCleI6YwNVaGf6ibVLaef3Kt8TEw8dDLR3Kcoka8cCrR9ReOqWZmdCYKY
	 KRUO9n6mENN6XWTI07sy+9iw6j1nBZ9a5ocaKEEHTFaJo6Y8x+ALVG8PMLLKtkxNkHg97
	 eMV1Tfg19UBcT/qCH0WnvuNTb0fxuDmdEvdMPx+4n8N0mA7Orx9vV3/L+ulDH7Wrn3lhA
	 CCbGoErIgwT65zE82y9VsdXP2h/ypixDulhHOLgDkuT5LEULCmTkr6nRQ2qXLFd7KDl0+
	 WnGM+fLzYxSAAcBubFLPwkbIuxRWD3d8KXAUpQWZpx3MuJGbhM1NaV/max/LqDLT6jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BTIUVGuV5wPVJUl6V13YFKcplMC0Zj0M4MkFqz53h0Y=;
	b=IVuU0d9hBxX7svmbcU3mFS8qAk+2UqsRJDqLkv+LBrqQGpo+arJ5JRs9F5oll8Tig0IY
	 bdaWlw+ifs0ifYwc/9o5vWGRdISxt18d7prbGQfolrL5xl9SXNDM+4oElHx7jx4DV+bPT
	 Egj5QW2UscE4SY1ajBB+2n8BZBJt15IV6bpNqVkYrTwDTbdJteUolZt/bBwF50tGDVYFs
	 muBLccMuYW129i9wLqQ3QRjMolB1+pMZmFRas6QM6La+O2SYuXRMNZ9FV47SlKMzoec6C
	 G7UOw1H2k+odT6WA4PP1dPQWpps7l6Kf5ZD3tAIH8BP615dWSZDsoJnsQnp9XoQeIqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozeRaijg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C1F606B8BD;
	Sat,  7 Nov 2026 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ozeRaijg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8F51F0089F;
	Sat,  7 Nov 2026 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063523;
	bh=BTIUVGuV5wPVJUl6V13YFKcplMC0Zj0M4MkFqz53h0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozeRaijgML8d5zjuVG3uET1vKaeqaKPAJ755S6SLUOmmvpaPJrNtzjlu6PCM8jxw5
	 2cEwCym75qQhGG8GR5xD3/3wx2MAULmBo2BFja08g6PO1titRgngTy6CahBCD83gF4
	 npgbfggy6VJAKOyCiVDgCE1bqbu78vW2ruz7cMM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 663/869] ALSA: mtpav: restore negation dropped in guard() conversion
Date: Sat,  7 Nov 2026 08:55:45 -0500
Message-ID: <20261107134915.640049409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit 47c3d5b885a4fcf65238c0cc525dd3c1cc65aa89 ]

commit 316e0074ecdc ("ALSA: mtpav: Use guard() for spin locks")
claims to be "Merely code refactoring, and no behavior change", but
it accidentally dropped the "!" from

        if (! (portp->mode & MTPAV_MODE_OUTPUT_TRIGGERED))

in snd_mtpav_output_trigger().

Restore the negation.

Fixes: 316e0074ecdc ("ALSA: mtpav: Use guard() for spin locks")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261020090959.570101-1-wangyan01@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/mtpav.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/drivers/mtpav.c b/sound/drivers/mtpav.c
index 1ed6d4f0cb625..288a873a27e61 100644
--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -443,7 +443,7 @@ static void snd_mtpav_output_trigger(struct snd_rawmidi_substream *substream, in
 
 	scoped_guard(spinlock_irqsave, &mtp_card->spinlock) {
 		if (up) {
-			if ((portp->mode & MTPAV_MODE_OUTPUT_TRIGGERED)) {
+			if (!(portp->mode & MTPAV_MODE_OUTPUT_TRIGGERED)) {
 				if (mtp_card->istimer++ == 0)
 					snd_mtpav_add_output_timer(mtp_card);
 				portp->mode |= MTPAV_MODE_OUTPUT_TRIGGERED;
-- 
2.53.0



