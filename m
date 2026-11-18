Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031268;
	b=iEoQyaes4RRB62Arkw0f1w2poawtY1JGBlfhdNI5NWKasnnaUx4EqrFJog1Rri+prrib
	 jnnQ2/Lp1gpAqVtxv7Oc6kZjCvpGqzZcmSi2LqNM7DcaMD3TvC9uI8eZZ8SSZyqZBOXVy
	 7rJy3HZYrYpza62JwnMyrkNWINK+x6VHHs6ZZp9eOnF3oZfoBX9pXRZB2ARNOayQJ1aIp
	 j+bOb1FpL7akxm1P6t5WpaqEtAeCYwMnKi1SZpouiBHwDJiN2aOa7Lgu3IrhtcevF5N+r
	 QW+ZGN8C2tGgc7HUEJMVmL0MI05Rq8wgZIMMzsOrOFX13r5IuBoIeKsiW/dRlp5yRaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DHWDixjPaktyNypwjJISQJpi0NMsFyS/hNlu0GNRD98=;
	b=2Ha00xz1DFmcHz6zAqVlYeT/E09NtgDuAaY2Ejy9S7s+nFf1xJyNCH2Kryx4U1uuo2Cx
	 jFu+QyF+y4btFqQRZ4ZN9xzDwGsPMJCPgZBY8b0Q1Oo4OhkM/3wcljDwzxz317FIWU1te
	 1Ys7STRfo0sp1HQGkzNX2AqLevGMnzz7z9ShhiGjzqDaRXJv+Tn0xVY/CigHm3Wnx8Wc2
	 ds8cETkcsI9m53aWh5hb5nnC529lIqV8qmWgCvnL10t4/vwlAAXGLRDMpksHfVLysAMXM
	 5qJ09GnXARwXgoQ2Sr7lzdRTeVaogU3zZurc2WKc5tLQlf/aUY2xsGMHnjyqkCtCQ4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M78ynsQF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43729606A32A;
	Wed, 18 Nov 2026 19:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M78ynsQF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404731F000C4;
	Wed, 18 Nov 2026 19:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031267;
	bh=DHWDixjPaktyNypwjJISQJpi0NMsFyS/hNlu0GNRD98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M78ynsQFHet3XygQPcGJkphzIOh7koysp/ImjXnlMEWp3S0ORtS6ZeY6TnkVfXVwS
	 PqdkIweuFLtqHX/7yJdbwUdfA5hgLDhA0rWn4+H+5yKbLcDSCEHAx6/qEWEwS1rVD0
	 y51sC9epfVM3QdUI6E/VUMH+HU7TekgHTsdj3C7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0997/1756] ALSA: info: Fix memory leak at card removal
Date: Wed, 18 Nov 2026 15:52:04 +0100
Message-ID: <20261118150049.867204741@linuxfoundation.org>
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

[ Upstream commit a3e8eec7692eac706ba0934fa18453e46acd1a08 ]

The fix for potential deadlock at disconnection by the commit
c7a606519533 ("ALSA: info: Fix potential deadlock at disconnection")
clears card->proc_root pointer at snd_info_card_disconnect(), in order
just to be sure.  But this leads to a memory leak of card->proc_root
content that should have been released at a later call of
snd_info_card_free().

For addressing the memory leak, simply drop the card->proc_root
clearance at snd_info_card_disconnect().

Since card->proc_root might be still looked at in
snd_info_card_id_change() that may be running concurrently during the
connection procedure, add a sanity check there, too.

Fixes: c7a606519533 ("ALSA: info: Fix potential deadlock at disconnection")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261006174002.703431-1-tiwai%40suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-5-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/info.c b/sound/core/info.c
index 1f5b8a3d9e3b6..ce5caf28f041b 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -528,6 +528,8 @@ int snd_info_card_register(struct snd_card *card)
 void snd_info_card_id_change(struct snd_card *card)
 {
 	guard(mutex)(&info_mutex);
+	if (card->shutdown)
+		return;
 	if (card->proc_root_link) {
 		proc_remove(card->proc_root_link);
 		card->proc_root_link = NULL;
@@ -555,7 +557,6 @@ void snd_info_card_disconnect(struct snd_card *card)
 	if (card->proc_root)
 		snd_info_clear_entries(card->proc_root);
 	card->proc_root_link = NULL;
-	card->proc_root = NULL;
 }
 
 /*
-- 
2.53.0



