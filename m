Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061656;
	b=gQoq+6cbj+pezPGP3duXO1YWlNryADGDGrMqrFB5Dbm5OP63KG1JyrBgR7AiLkQjP61Q
	 NKQzyNYvxPKKBqgEUt66UxSSP4wBC8e3kt+C6KiRc69bP13e24OImBRCrVQ7Yg34tFmgR
	 JRjBkq96ZqjN0LobyYNeZ+SKb061MFovEh5pDmudvv1XTiO7rLxjhWx4PvZZdcrDQNp9c
	 Fh/PQiCbN+DbKleludESkxcEPPyIQtiS6XDU0Z0d9yakEMOrMD5pq0dR/kZh9spxNlD5a
	 MKh/d3M7nQc/kHCN872PnjZ1c8qyn0V029O/2rBvbSBMJbs/uWfYcRKlTQ7sgW5r7zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D2rLkXtHSgsfQwlKvbQHj43AmZe59HGIN5bdyyAxO3Y=;
	b=t7mgXD667KrsOB4PCszbtrbMJHN68B9ZcoFE8uvQOa1A1a78jJzECDaz+5mn9RWSSeWd
	 SWQrrh0qb+TfwIxWmHUizqx+Mg4XfJDDapilO6OKtXvSCNIrINYOa9yohDkp2R+P+4lBa
	 3C51pIFMnVJxDrUUy6+q5Pf9vTa4eDNMb8RCN0iJe9iS17lS7kWzIioetyiSIHZQWAqr3
	 QrK4frEL/mSArzMdWDtWu05HzOuLVardmB365yVe4koSA4uZLtNM+qhd46M86Uh7OcpAH
	 MaagvKeUHcT6NgoSpopFSzVwXJLZmjosmzhtEEbgUTKjEh8PTKquPqb2N+lSr3Hn//A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qBeNomT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31CB606A32C;
	Sat,  7 Nov 2026 14:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0qBeNomT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3B21F0089F;
	Sat,  7 Nov 2026 14:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061655;
	bh=D2rLkXtHSgsfQwlKvbQHj43AmZe59HGIN5bdyyAxO3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0qBeNomTcNgP2KtwVAJF9i3JcRoQ2wpwR5HneS4SpiCto7VcE7DhGW//Os+lI09uZ
	 YlVDAJcAwnKeZ9Fjx+XeoUwVy0ERHilLblP95g0+sMDqH9/VtXEizSkZUpmP2fH1i+
	 +4Zi9ievUtOFETXhd0ahdH8aLjfaaThXeiSmjVYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0715/1536] ALSA: usb-audio: Use the right limit for PCM OOB check
Date: Sat,  7 Nov 2026 08:45:31 -0500
Message-ID: <20261107135017.583257073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

[ Upstream commit 70b4db7d258118a7464f039112a74ddb49a95b06 ]

The recent fix commit for addressing the OOB access of PCM URB data
buffer caused a regression on Behringer UMC2020HD device, resulting in
choppy sound.  The fix used ep->max_urb_frames for the upper limit
check, and this is no right value to be referred.

Use the actual buffer size (ctx->buffer_size) as the upper limit
instead, which also avoids the regression on the device above.

Fixes: ef5749ef8b30 ("ALSA: usb-audio: Prevent excessive number of frames")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220997
Link: https://patch.msgid.link/20260121082025.718748-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Backport differs from upstream only in indentation, since the for loop sits one block shallower in this tree; the changed lines are otherwise identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 3a4666e3bf277..5aadd1221f725 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1505,7 +1505,8 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 	for (i = 0; i < ctx->packets; i++) {
 		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-		if (counts < 0 || frames + counts >= ep->max_urb_frames)
+		if (counts < 0 ||
+		    (frames + counts) * stride > ctx->buffer_size)
 			break;
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.53.0



