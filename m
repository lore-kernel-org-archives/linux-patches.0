Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041142;
	b=nOzcQqaWI/4QHzMOcQiSMROtsJykGuzIK7LapZvj7EphfZvFnVZVHZUdtUXfpJe9hhvB
	 1/9DgLx6BPUM1n8xG+/qCLwePwbUEyrEsz5TTwQ5Ix9TQs629T8vz93k9ZLz4QoJ8QQvE
	 c0QydnW8Vcn/sCB+mxI0LuSvEikxo+XTfJ+EWyXzE1xUSLZUrGzNiVTV+xXBfN6bkI7Mr
	 U7bscNIYUM5v7a5UugEPQKetFaIFQrEL01PzfEBgSMoLDHcEjtwXijvJyJzG+rawu5V9O
	 XCC8RRl1nE+CQEsTrxdLD0q+T1k/zNI3/tUvoSauz1R8nni4uSM186vlhFjjyFMeWEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Oko9HR5tQ0doObUCIkqhtteUiCwEwT5rlzDu3/es1I=;
	b=mir2Tq8sRQbcZZCyyk840sQUkomuO/M/cI098z1DbMSISGUTEYp4bIPamk4FyYcsSusn
	 hwwv0ibyqic0lHv/i5A6g/xNd/Jr9hCc3P9XhPMVzHYQ0zgnIXYYJqn3KuddZZ1+G3fd+
	 nI9yXa4N/HYWKbO/wsqvDDqtz3MKJLWX3C3OAeX1O6whFi+MeB5rLR32R1ir7HNPcTigM
	 MXjcUJg/H0N+liS8yaZuRQNLT2HGuiop8A+l+BLtqR9VrvKDHnrsxB1detu+Sw6dm8cbG
	 nprRfxISUEeigJ0CejwyaBy6m8SE4udwGw0NsXe274G0yRRpFAEj6qeNpeKJaMeE/7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xO2rCw7L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32E8606A320;
	Wed, 18 Nov 2026 22:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xO2rCw7L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245201F000C4;
	Wed, 18 Nov 2026 22:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041142;
	bh=8Oko9HR5tQ0doObUCIkqhtteUiCwEwT5rlzDu3/es1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xO2rCw7LP8xodfeG6CW0rE6rridQ+2TMI4IU8L74imJt1fNtFCwti9xlLy2sYPhGm
	 WgdXCY58BaXfGJyWVEzkCwNoqbiXDF8zC3dFQNnp8AMXaDOjoyJMuh9vLU5NXs0SQE
	 G4BZoXg6Y9BR35sJ3IqZ82TMo/GPjYkCxN9sKYt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2707/3318] ALSA: line6: Reject too small max packet sizes
Date: Wed, 18 Nov 2026 15:55:29 +0100
Message-ID: <20261118150442.107335412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d7ea10c98ebf..4a84a3584ae09 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -561,7 +561,11 @@ int line6_init_pcm(struct usb_line6 *line6,
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



