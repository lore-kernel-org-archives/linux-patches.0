Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055970;
	b=IR5q66XV0Cz4+qa4fD8ZS91BAEWtFcbowlOXwW8QcNlMD4aH6Jm4azw8x5xxGBAeYtHe
	 4e4x+ta7Tz88q/VOdoWWnEOwJv567KQOz/WxAVFKg9wYad1583EmcaksQ0YZm9niTQabn
	 S17qMJJbTuOhQxxLJsokEBU66S4d9sAcC/EeY9MyeJPZtRzlRol7eZPMV28BmdyG7DThR
	 2IexvWhsebfFf7i5lm7OqJMJ1OJ2mF4bopKGgz+ulaW3grbSnLhOviBDb+mxe7PYSyGGX
	 zMHFfn9TZMkFFJ4QpV0SUmnW6vhgtPjUrCL+t6NcEHvhUG2iCk74Rn8NtaT8RFowrYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LoztX/2S5Yc01m+Nih4wadIACawTYY7mFU604qFtbUU=;
	b=BarqDa/QJyCr4auC6Zv3rkH/Ya+98IHglhE/AGkCJN+mMnA4Bu6dVmCqnPOxI34klIOO
	 Eo97VaJ0BSmLXsAiWakAnebbRDWLUwkz76LnMOSMjNrJNtMeoifr+ef9BRfO04p4Za/bc
	 EqpiENdnvUoUQMkWrooGwKF8loIf+G5MAIpE/L8jWBP5YZe8Kpa0PZD+DavQ4QF2gLTaZ
	 uTk2DhZUQNCJg9ZiHHyiV+fz9qX6nCEJfL2nPjgGUrXvfW0LBbiwAY5GG4fHyOEG8q6Aj
	 EpI9Ql3e+u2q0lVrTLyVUmFw3UfrfW6vgoV6YZXPDrlwtfxovGgttwfeDBohZXiVdUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CS8qlwt9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B14606A325;
	Thu, 19 Nov 2026 02:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CS8qlwt9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8421F000C4;
	Thu, 19 Nov 2026 02:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055970;
	bh=LoztX/2S5Yc01m+Nih4wadIACawTYY7mFU604qFtbUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CS8qlwt9SLbZxLWMPreGhaaXVGC7VuJ7Ubyotl3kucGkOWMNL/KKavGxu7m3/cftV
	 Zojlv8IpY4UHkDzSJp6P87xrH8LyU0OjjMyEqloH69PGXa6kNYv1HtqDEXspPlQsAt
	 iHKh5FstXkxhOwcjHV5SNrorm+GTmLjbBYkUR8sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Takashi Iwai <tiwai@suse.de>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1822/2214] sound: usb: remove third argument of usb_maxpacket()
Date: Wed, 18 Nov 2026 15:58:18 +0100
Message-ID: <20261118150124.347422297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 80b2b03bacfc071ceaac034fa81d535d27d57b31 ]

The third argument of usb_maxpacket(): in_out has been deprecated
because it could be derived from the second argument (e.g. using
usb_pipeout(pipe)).

N.B. function usb_maxpacket() was made variadic to accommodate the
transition from the old prototype with three arguments to the new one
with only two arguments (so that no renaming is needed). The variadic
argument is to be removed once all users of usb_maxpacket() get
migrated.

CC: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.com>
CC: Clemens Ladisch <clemens@ladisch.de>
Acked-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20220317035514.6378-8-mailhol.vincent@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e2ef553dfe92 ("ALSA: line6: Reject too small max packet sizes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c           | 4 ++--
 sound/usb/midi.c                | 4 ++--
 sound/usb/usx2y/usb_stream.c    | 6 +++---
 sound/usb/usx2y/usbusx2yaudio.c | 2 +-
 sound/usb/usx2y/usx2yhwdeppcm.c | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index c785f73718ade..7325482dcaebb 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -560,10 +560,10 @@ int line6_init_pcm(struct usb_line6 *line6,
 
 	line6pcm->max_packet_size_in =
 		usb_maxpacket(line6->usbdev,
-			usb_rcvisocpipe(line6->usbdev, ep_read), 0);
+			usb_rcvisocpipe(line6->usbdev, ep_read));
 	line6pcm->max_packet_size_out =
 		usb_maxpacket(line6->usbdev,
-			usb_sndisocpipe(line6->usbdev, ep_write), 1);
+			usb_sndisocpipe(line6->usbdev, ep_write));
 	if (!line6pcm->max_packet_size_in || !line6pcm->max_packet_size_out) {
 		dev_err(line6pcm->line6->ifcdev,
 			"cannot get proper max packet size\n");
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 70084be58f0fa..e0020956a100f 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1361,7 +1361,7 @@ static int snd_usbmidi_in_endpoint_create(struct snd_usb_midi *umidi,
 		pipe = usb_rcvintpipe(umidi->dev, ep_info->in_ep);
 	else
 		pipe = usb_rcvbulkpipe(umidi->dev, ep_info->in_ep);
-	length = usb_maxpacket(umidi->dev, pipe, 0);
+	length = usb_maxpacket(umidi->dev, pipe);
 	for (i = 0; i < INPUT_URBS; ++i) {
 		buffer = usb_alloc_coherent(umidi->dev, length, GFP_KERNEL,
 					    &ep->urbs[i]->transfer_dma);
@@ -1450,7 +1450,7 @@ static int snd_usbmidi_out_endpoint_create(struct snd_usb_midi *umidi,
 		pipe = usb_sndbulkpipe(umidi->dev, ep_info->out_ep);
 	switch (umidi->usb_id) {
 	default:
-		ep->max_transfer = usb_maxpacket(umidi->dev, pipe, 1);
+		ep->max_transfer = usb_maxpacket(umidi->dev, pipe);
 		break;
 		/*
 		 * Various chips declare a packet size larger than 4 bytes, but
diff --git a/sound/usb/usx2y/usb_stream.c b/sound/usb/usx2y/usb_stream.c
index 992eec233675d..7f6075059ac23 100644
--- a/sound/usb/usx2y/usb_stream.c
+++ b/sound/usb/usx2y/usb_stream.c
@@ -51,7 +51,7 @@ static int init_pipe_urbs(struct usb_stream_kernel *sk,
 {
 	int u, p;
 	int maxpacket = use_packsize ?
-		use_packsize : usb_maxpacket(dev, pipe, usb_pipeout(pipe));
+		use_packsize : usb_maxpacket(dev, pipe);
 	int transfer_length = maxpacket * sk->n_o_ps;
 
 	for (u = 0; u < USB_STREAM_NURBS;
@@ -171,7 +171,7 @@ struct usb_stream *usb_stream_new(struct usb_stream_kernel *sk,
 	out_pipe = usb_sndisocpipe(dev, out_endpoint);
 
 	max_packsize = use_packsize ?
-		use_packsize : usb_maxpacket(dev, in_pipe, 0);
+		use_packsize : usb_maxpacket(dev, in_pipe);
 
 	/*
 		t_period = period_frames / sample_rate
@@ -187,7 +187,7 @@ struct usb_stream *usb_stream_new(struct usb_stream_kernel *sk,
 	read_size += packets * USB_STREAM_URBDEPTH *
 		(max_packsize + sizeof(struct usb_stream_packet));
 
-	max_packsize = usb_maxpacket(dev, out_pipe, 1);
+	max_packsize = usb_maxpacket(dev, out_pipe);
 	write_size = max_packsize * packets * USB_STREAM_URBDEPTH;
 
 	if (read_size >= 256*PAGE_SIZE || write_size >= 256*PAGE_SIZE) {
diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 85cbb799ded70..9dc312729413d 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -422,7 +422,7 @@ static int usx2y_urbs_allocate(struct snd_usx2y_substream *subs)
 
 	pipe = is_playback ? usb_sndisocpipe(dev, subs->endpoint) :
 			usb_rcvisocpipe(dev, subs->endpoint);
-	subs->maxpacksize = usb_maxpacket(dev, pipe, is_playback);
+	subs->maxpacksize = usb_maxpacket(dev, pipe);
 	if (!subs->maxpacksize)
 		return -EINVAL;
 
diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index bcf5d2242c5f9..2ea3396438689 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -321,7 +321,7 @@ static int usx2y_usbpcm_urbs_allocate(struct snd_usx2y_substream *subs)
 
 	pipe = is_playback ? usb_sndisocpipe(dev, subs->endpoint) :
 			usb_rcvisocpipe(dev, subs->endpoint);
-	subs->maxpacksize = usb_maxpacket(dev, pipe, is_playback);
+	subs->maxpacksize = usb_maxpacket(dev, pipe);
 	if (!subs->maxpacksize)
 		return -EINVAL;
 
-- 
2.53.0



