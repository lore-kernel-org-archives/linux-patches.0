Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217355;
	b=MyzN2L4qOvMi5XW/Ac7s4Nk1xBVxPnfGY0rAEC9BDqRcYs+CyTDjOFX3k6Ukrx1NAnMU
	 vUU4sVMt5JXXYr36I/Nhd9HR1aufW2P5KcCR8jW4UF1X8XhiHGYi0O+/ah677I5nh9TLm
	 4VnwXmtzjK811pNjPO0FncsNiYJ1IKlLAP8FJN0DkbTiRzt0dANRXOCTWqzkgPOqpTtDk
	 w27dQ7/vOQC7biIuk6t90Vy7jpBXkzLtDX47Hw2HPNwCHAIvtWCXXYSUalfM6Trvy0v7i
	 w/5Ck9iAdcB8NFJTBGPTJpF+cqjx/ZIajOvYQd4d4zetDQxso/hzGFS4HHiBo2YIWRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9v6T1CpFvU3CIOUxZNeXebm7XBYUZ8PriC+RFspv/yM=;
	b=npycCHmrc+mLggJuaMxPnQkypLesbC/y4R11SfWkNAr2eBRpJvbFjMotgvRFsntXsXda
	 jzyzZfNHIFOBjibX2uzkNyj28IdDRxhY6Lq5/AC3P167n3Rr9/VOBpaIaMS+7gjxd8wx3
	 h+D8tuD6SUIf2eYX9J9+WylzQ4TMH1OXwtIbRj5mUq0bg1Hs6avf+3MEGVXxTz8Jyue3S
	 R+kPF7VuaZKedQNLjPYk2G+jQ6C4TKIWYIi9FGyGA++0pxnIdqtF8+O+wAg+OVlD3v9wx
	 QIZkpaVnYP3toZ3xRqnKYPetX7h3Lc+HxTQGfsSqlptQEWbjaYNcljEGc1fC09vh3lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3OTBWsN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36316606A31A;
	Wed, 28 Oct 2026 19:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A3OTBWsN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561531F01825;
	Wed, 28 Oct 2026 19:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217354;
	bh=9v6T1CpFvU3CIOUxZNeXebm7XBYUZ8PriC+RFspv/yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A3OTBWsNoYTjIyU19ORYlbPnWpfTfn9h94I+eb94miv+9OQ7QKzs676jDBj1uKySZ
	 D/B76I56gWe7dQeVrieDuV7vBz+H0jC+T2uf+5UXztgpEwn//qwvjtQYapAO58laqI
	 l8H8xI+r0utQ3jZI133KbqzPJKSkECaNcRHZ1+iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1873/1887] ALSA: seq: Dont leak the extension cell pointer in the bounce payload
Date: Wed, 28 Oct 2026 18:06:09 +0100
Message-ID: <20261028170542.078132094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 59e1592d3c270ff4642d5d6dc55c545306eb0693 ]

The bounce_error_event() embeds the failed event in the bounce payload
by pointing data.ext.ptr at it.  When that event is a queued
variable-length event, its own data.ext.ptr holds the address of its
first extension cell, put there by snd_seq_event_dup().  The payload
goes out verbatim through snd_seq_expand_var_event(), so the address
reaches userspace.

That is the same address commit 705dd6dcbc0e ("ALSA: seq: Clear
variable event pointer on read") removed from the event header.  The
read path still clears it there, just above the call that expands the
payload.

Embed a sanitised copy instead, treated exactly as snd_seq_read()
treats the header.  A stack copy is enough because delivery is
synchronous and snd_seq_event_dup() copies before returning.

An unprivileged client reaches this by setting SNDRV_SEQ_FILTER_BOUNCE,
queueing a variable-length event to a port that does not exist and
reading the bounce back.  Eight bytes on 64-bit, from its own pool.

Fixes: efc86691e4d8 ("ALSA: seq: Fix kernel heap address leak in bounce_error_event()")
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260811131835.3837024-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 140e1510b8de5..5763ad14f5638 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -554,7 +554,7 @@ static int bounce_error_event(struct snd_seq_client *client,
 			      struct snd_seq_event *event,
 			      int err, int atomic, int hop)
 {
-	struct snd_seq_event bounce_ev;
+	struct snd_seq_event bounce_ev, quoted;
 	int result;
 
 	if (client == NULL ||
@@ -570,15 +570,19 @@ static int bounce_error_event(struct snd_seq_client *client,
 		 * For user clients, send SNDRV_SEQ_EVENT_BOUNCE with the
 		 * original event embedded as variable-length data.  This
 		 * avoids exposing data.quote.event (a kernel pointer) to
-		 * userspace.  The variable-length path in snd_seq_event_dup()
-		 * copies the event data from data.ext.ptr into chained cells,
-		 * and snd_seq_expand_var_event() copies only the data content
-		 * -- never the pointer -- to userspace.
+		 * userspace.  Sanitise the embedded copy too - a queued
+		 * variable-length event carries the address of its own
+		 * extension cell, and the payload goes out verbatim.
 		 */
+		quoted = *event;
+		if (snd_seq_ev_is_variable(&quoted)) {
+			quoted.data.ext.len &= ~SNDRV_SEQ_EXT_MASK;
+			quoted.data.ext.ptr = NULL;
+		}
 		bounce_ev.type = SNDRV_SEQ_EVENT_BOUNCE;
 		bounce_ev.flags = SNDRV_SEQ_EVENT_LENGTH_VARIABLE;
 		bounce_ev.data.ext.len = sizeof(struct snd_seq_event);
-		bounce_ev.data.ext.ptr = (char *)event;
+		bounce_ev.data.ext.ptr = (char *)&quoted;
 	} else {
 		/*
 		 * For kernel clients, quote the event pointer directly.
-- 
2.53.0



