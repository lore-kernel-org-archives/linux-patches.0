Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065117;
	b=qhLPI88I/1cqz2Xu4IGMixYo6lISPYK/OTyx5zbU6X0Wk9xAevTPOLUhWeJTzTZSfyPl
	 wxUmdyju38C1hkZZ3KK9KARCKRKuycVSevpkb1y6S2x9B8BmMTj9gCL1OOvvuuKq4HFoU
	 soje5O4HP0u98ei/X4MRsvNbyO7OQbluzIKtNbaLAT/Nw6H+gPoc9+i5c2BUWYvpgWwl3
	 1f6iJH4GgKPFIRTY8+IKOCHLFdJCi57k4oNfasc7eRopcprdhNPVj/iBFBwKOqnfGa8Wq
	 QU//XBKrV814LDk99UfclnzCN3XZihp8W+zufi3KxRgc/fD4HsSqQcwZ5Zsx8UhwF9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=byygyrKwOPIScQiNWuFyu6T4ciWsJu9WMiXmQ+7Sz4c=;
	b=eBd+AZ6aLIyKrB5P0hfKG+pPLWBLcHAb7Mntmr+FtW3aQ2Woy/I6jisXoHI8yDVRyiSM
	 8BiGjDAps0vtbLu1PFBJHBLA8aZhx4g9VZNcU78vgyNAOtQ5Me2+C5+KvvXOItC7TUzcQ
	 cp0KLj+CXDtiRmNPcCvqkFE+kPTDDfDpMFGfVrDSHsco/gVmwRcOXManPElupeoPJx4rl
	 qUy7GFjBnnx/KvCzvSm0V4Aq4lykDoB2T+PYl00LhyPKUg52+aQT7izZTxseqGsjpAqKQ
	 mHnkwEdDzRFtAM6UpSrt1wzVOr1vokh747otdMRxHFRIYmK3UM5rgUfqjtNi2rFyQSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TuEjqsWS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04333606A326;
	Sat,  7 Nov 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TuEjqsWS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EB71F0089F;
	Sat,  7 Nov 2026 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065116;
	bh=byygyrKwOPIScQiNWuFyu6T4ciWsJu9WMiXmQ+7Sz4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuEjqsWSOXMSgy6oyRqPti4cLGzNOXvpk2qG802/VOW0/7Q7vBEvHLvexENC/BEQA
	 4Yq0GDzAJV6Vt5BhjNDStGyXfxSy4jI6vv/irijG5JrJTjmxnfC/nolYJA9t6xg4ox
	 pKtZPuiNAEundsIWyAEHaAEv6IGsKmMJ9hWcrKpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0942/1257] ALSA: mtpav: restore negation dropped in guard() conversion
Date: Sat,  7 Nov 2026 08:53:58 -0500
Message-ID: <20261107135005.370386415@linuxfoundation.org>
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



