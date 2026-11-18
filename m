Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049397;
	b=GmUxoKDxNkmyrn2cd1whAnb643s3zWNN7Z3YahIO4ElnO9MZl7oCjS6NxHAnK5oEEhju
	 S7u+j5gF5UbLiEEGpgb3AdKpRU4bZ9rOginXKN//Djb9lJlVk+xoUQndr4bLrcUsbmngx
	 pbJ0BBDGJ1hL30VWilCUXq0gVoQK9fY5lzQtyXEo0sLT0811HXIvdYbV5ycH++Gzj/FZr
	 imzpLxnF5QZEVv2Mwr214b57sG3p5x7C9Tw35/SzjZU2fA2Klzuuo/qG5FzsjPQthemh7
	 x5KWkx06O0ThzGBXfCuMDKzmeEphqOF0yiADvBWXOKkcoQBguAvu8Bmdv2LwzLLDOFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXLvKtBLl0E3J3nYuGQNoNtxd6yvIu4BoaLJkXiQMy8=;
	b=tYHzNQJpff8iuZCAkywWp0wjPeVO0ajqJEToWIItExh+SuBXEouTon6m1cwV7j/ZYOhM
	 qj3ef9++0Uz6KfkPMQoPu72C3ezrJV9UKMf07aOj5CzNnvlZtFdlhi1GLAQge3lIyNYrO
	 TdCovJMQEoVxxIsnh5MOBwhJstqzhJAdKC/zX7DCfdle26FXCu6Lrjj6KXNP1J24qQyeM
	 HlRQ6wWUAc8QK9Qn5zbhcFZ1WWg55hbcPppUvfWe46ayVv/R9vW/IDwHY9+qus1hi1J65
	 SqkcOlvC1GSxA4MTzpLJbzngjR0XfprG2u7yGgEONzz+oBfABXZFMziBfftbjk5gKfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1RITaWL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB44606A32A;
	Thu, 19 Nov 2026 00:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1RITaWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3DC1F000C5;
	Thu, 19 Nov 2026 00:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049397;
	bh=eXLvKtBLl0E3J3nYuGQNoNtxd6yvIu4BoaLJkXiQMy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1RITaWLNllEbV/svRkYAKwzLV5Y92e9sdhGWMj7VSgcdK9mwRgrxJl31f8GnFePq
	 GvxSl6UzNdMKbrXlrbPAIYAC/foHFpjX0W1z8yVaDvI+H7TW7b60UPreDmUfsloAyS
	 veoGLzsyydOTqAur3L2HqL6hwEif0nkuvq6ARmUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2337/2857] ALSA: line6: Reject too small max packet sizes
Date: Wed, 18 Nov 2026 15:56:11 +0100
Message-ID: <20261118150325.681092654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7325482dcaebb..59b7c6beef6c5 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -564,7 +564,11 @@ int line6_init_pcm(struct usb_line6 *line6,
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



