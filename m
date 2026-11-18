Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019307;
	b=dB7nX0OK2e72+xFmYqzTiQ6j4jiheBKyJoWnl6OTY+h/bZ5/WQVndLR5pjx4HkTvC+tt
	 f9PWbuKsQL1Yg3baKQccw9Ph0uMeRw79MB6gyxsB9U8qZBeI8cZtDdd1rSNSUqND0qosM
	 pxWRqCpKRGcuEg832HEUHs5RQCshePBie2a2FblBKNJLdp2dpCkXm8zCkf/b3gKSuQQf7
	 ViP7Gb9fLulCHufR9GfwhpSj4Ag1hLrXMFjFMQstMDbuUs7ECuEVKxhuwEjt2qx16RXMg
	 JZ7mECUal4+UL/HtX/AK8SRoO/0XylA4eylI6JKbo/M2acHXvcpipZpMx9ndyfQd86w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w0khpCUcG/LcU13wiRIA4IBB0SweL2k9gUF+PvbvsME=;
	b=nwhLATVCqbVn5HnAWada3x+tWUYsHjWTzxrRiaEX45U4kHkYXGWpsseoMgUu83IdHRas
	 vBTyYuBfBDDoaCKtqKOPwvnRFVfrwUZLr+oHLDsoARq/UiDKNLYQwqQEa87fM/I5ONCRk
	 bNJI9p4LwgJjIs6Z6UwGxUprvIqNWxilWULLjSwNdRzjBsjUKhGzXGaAyIDNSNy5u/c/4
	 XKPGBSWs34RYLIfzYb4E+3zR2RZMuDwj9GfRQkqC2DR1KNti0Atc5jBf+SeNWD8GzRMPz
	 DD3OOfAgpjP3IAaiqEYAFqSjIm9tqdf/7aIecA2ugAYsJwSOoPn95vB1gQvffueidzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VUomiJ/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ED7606A330;
	Wed, 18 Nov 2026 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUomiJ/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B978D1F000C4;
	Wed, 18 Nov 2026 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019307;
	bh=w0khpCUcG/LcU13wiRIA4IBB0SweL2k9gUF+PvbvsME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUomiJ/dJM7e1ZOy4f7Bagw4peT2Jb14EQIrGZMXn/JBiTYTrb4/MIaMAZCyB50HN
	 g3Eo8AF9iIJ7ObJVXq13p0pDG41+qrIuRbJ7ecDeTo/RVH2q+i+BGyDinERWool1DL
	 uAtEW2mcFTewyoRJsKHZ78lUjYc1XUyTaU7TZPHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1549/2651] ALSA: line6: Reject too small max packet sizes
Date: Wed, 18 Nov 2026 15:46:29 +0100
Message-ID: <20261118150343.728032828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit e2ef553dfe923959632e580bcad8583d922868ac ]

Although the LINE6 driver has a sanity check for the given max packet
sizes, it still has an implicit requirement of the minimal size being
bytes-per-frame; e.g. the impulse test signal assuming the fixed size,
and when a too small size is specified by a malformed USB descriptor,
this may lead to an OOB access.

Change the sanity check conditions to reject too small max packet
sizes for avoiding the scenario above.

Fixes: 3450121997ce ("ALSA: line6: Fix write on zero-sized buffer")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-10-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index b4c594add1aeb..f30d82cc0fc1b 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -562,7 +562,11 @@ int line6_init_pcm(struct usb_line6 *line6,
 	line6pcm->max_packet_size_out =
 		usb_maxpacket(line6->usbdev,
 			usb_sndisocpipe(line6->usbdev, ep_write));
-	if (!line6pcm->max_packet_size_in || !line6pcm->max_packet_size_out) {
+	/* reject max packet sizes smaller than bytes-per-frame;
+	 * (the magic number 6 is taken from the playback case)
+	 */
+	if (line6pcm->max_packet_size_in < 6 ||
+	    line6pcm->max_packet_size_out < 6) {
 		dev_err(line6pcm->line6->ifcdev,
 			"cannot get proper max packet size\n");
 		return -EINVAL;
-- 
2.53.0



