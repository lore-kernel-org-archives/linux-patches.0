Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590484;
	b=JRwlH3sqhlHeVUt3YtPYugek5yVsoAksGRwffK06h31DD+aASSFeq7wyrXsYS0GHkMXo
	 1UBHt/pgcxtzNxc4XKGQv8AdQohv32EoFwYrbc6eg8Onl1EosVykQ8QMP3qqOE0md65iU
	 gjBNu9Kw3HhtUvUtL/DmGcOYxOQQ68/2vyyICdKAO7WMcJNWTfk84k26sa8LV5+6WPlgs
	 Kv4wLmRjPvuBsv+ycSUDG0aWk1y6D5s0JKTQD7cG/5hTGQ17HzakpGyBYFc7BaBaAI/0E
	 +AYAOkFFiK3zaHICpggyjog9WZQSrSUzYmKUJYddz4xzTt+uiKA8TR2mDOH9/oWh2mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4FP6gIWmPfxJ6LfnAZYi3LaR9AXCxD4b1bxXkDThFTs=;
	b=e4f/lANeoTLQ2ZkED+ZowFD9iS8UkFTeaO4wMN8kILb69HrA3zkOA/39c3CcswVNKph7
	 k+KOdFmKAYMROJLc/Y8aHMYOBqf1MQvY0nqb27BHk6R2f9CNZt1wJMvROYzBaH79RZeUm
	 cZ1X1pasGJWTPmrTpi1GXzJxpNwzVnCJmFG4arNMb/mhqRrJ7OdMIyymoNPi/WjUvUCr9
	 YiyH1woYkSUEe3fnYNIEEMtgki67t82Qk2XVqjd4R1ys20AYcSyh62fJf3OXmYJNXMxtB
	 n3fEoZODXvIEmY3QSR/UE2F6oAPMpLCujl8JAOSKstMB4yDYAAHkMjET0qNO0m5ZSOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="JOb0/Bkz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414D7606B802;
	Fri, 13 Nov 2026 17:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOb0/Bkz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C534D1F000C4;
	Fri, 13 Nov 2026 17:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590484;
	bh=4FP6gIWmPfxJ6LfnAZYi3LaR9AXCxD4b1bxXkDThFTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOb0/BkzV1mnnultXxpinQYEcCaYJeisXAxnfJWkRdo6qF5xTywGtl5R6SewS3n6H
	 75RSO107m6CaC4Q5guGiha6dcmiwCxjZC8rhNvtCjBUyQjUqxbDQPO7f+ZG/Gfizag
	 CGyFXYYdXVRn3rknTb6af1AiqbWW1yj947HtbZOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/686] ALSA: usx2y: Require a buffer of two URBs
Date: Fri, 13 Nov 2026 10:49:28 -0500
Message-ID: <20261113153835.647231707@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Sinan Turunc <enscrpt@pm.me>

[ Upstream commit 4cbb826b3b36df6c275454287ba1df4564a5370b ]

usx2y_urb_capt_retire() wraps the ring buffer once per packet and
usx2y_urb_play_prepare() once per URB of nr_of_packs() packets of up to
50 frames. Both assume that the data fits in the buffer, and the hw
constraints only require about two 1 ms periods, so a packet larger
than the buffer on capture, or a URB larger than the buffer on playback,
violates that assumption.

Constrain SNDRV_PCM_HW_PARAM_BUFFER_SIZE in snd_usx2y_pcm_open() to at
least two URBs, 2 * nr_of_packs() * 50 frames, for both directions. The
bound is in frames and derived from the driver's own packet limit, so it
does not read the endpoint, whose altsetting is only selected in
prepare. Two URBs rather than one, because the position advances by a
URB on playback and only moves when a URB is less than the whole buffer.
Keep a guard in usx2y_urb_capt_retire() that drops a packet larger than
the buffer, for the case the constraint makes unreachable.

With nrpacks above about 163 (S16_LE) or 109 (S24_3LE) the bound exceeds
the 64 KiB buffer the substream preallocates (twice that with the
preallocation raised to its 128 KiB maximum), so hw_params fails for
those module settings. That is intended: the driver cannot be safe with
a URB larger than half the largest buffer.

Reproduced on 7.3-rc7 with a USB/IP device presenting the US-122
interface layout and 1024-byte packets into a 512-byte capture buffer:

  BUG: KASAN: out-of-bounds in i_usx2y_urb_complete+0x1285/0x1ac0
  Read of size 18446744073709551104 at addr ffff88800e448800 by task vhci_rx/83

Tested on 7.3-rc7 with the same device, S16_LE at 44100 Hz, nrpacks 4,
so the bound is 400 frames. A 128-frame capture buffer and a 200-frame
playback buffer are refused at hw_params with EINVAL. A 400-frame buffer
streams for 30 s in each direction with the position advancing inside
the buffer and no KASAN report; the capture guard did not fire. The
same 400-frame capture buffer with S24_3LE, which selects altsetting 2
in prepare, streams for 30 s with the same result.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Sinan Turunc <enscrpt@pm.me>
Link: https://patch.msgid.link/20261104122136.1518-2-enscrpt@pm.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usbusx2yaudio.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 1ea181e9bb283..12b1c890812ba 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -51,6 +51,18 @@ static int usx2y_urb_capt_retire(struct snd_usx2y_substream *subs)
 			dev_dbg(&usx2y->dev->dev, "%s: 0 == len ERROR!\n", __func__);
 			continue;
 		}
+		/*
+		 * snd_usx2y_pcm_open() constrains the buffer to hold at least
+		 * two URBs, so this cannot happen for a device that keeps its
+		 * packets at 50 frames. Drop the packet rather than exceed the
+		 * single wrap below.
+		 */
+		if (unlikely(len > runtime->buffer_size)) {
+			dev_err_ratelimited(&usx2y->dev->dev,
+					    "%s: packet of %i frames exceeds %lu-frame buffer, dropping\n",
+					    __func__, len, runtime->buffer_size);
+			continue;
+		}
 
 		/* copy a data chunk */
 		if ((hwptr_done + len) > runtime->buffer_size) {
@@ -890,6 +902,18 @@ static int snd_usx2y_pcm_open(struct snd_pcm_substream *substream)
 	runtime->private_data = subs;
 	subs->pcm_substream = substream;
 	snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_PERIOD_TIME, 1000, 200000);
+	/*
+	 * Capture wraps the ring buffer once per packet and playback once
+	 * per URB of nr_of_packs() packets of at most 50 frames (see
+	 * usx2y_urb_play_prepare()). Playback needs the buffer to hold more
+	 * than one URB and capture more than one packet; use the URB bound
+	 * for both, and two URBs rather than one, because the position only
+	 * advances when a URB is less than the whole buffer. The bound is in
+	 * frames and does not depend on the altsetting, which is selected
+	 * in prepare.
+	 */
+	snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_BUFFER_SIZE,
+				     2 * nr_of_packs() * 50, UINT_MAX);
 	return 0;
 }
 
-- 
2.53.0



