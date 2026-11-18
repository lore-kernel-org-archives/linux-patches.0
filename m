Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059157;
	b=pdhCyujIC26I5ORmoi1IDRz+/5o9hysCI+ogDkSeFjKNcyh8IihZofIDQ5689GJnysgM
	 /51uoGhbR7E+rtUja3T9RiqfG3mx5JAGKr8iESX2Tfd3UN1K6BMPQUK9N1wbYsEfo6Rfp
	 nH2cUft5we44PnldTPzEWoft7QzaUVOB3G4z7gSAwWCKDjjbDlz8hwTZ/zJBbxkbd1wqG
	 CCxxMTA0CJQLJ+n+LUQr5XKjgMCMWL9kjjx2RoZ5mLAUMGeKmy/lGz+pnbwmlU1YKTobW
	 99nAdgbg5U8ViJP5kFPpdIXDJjy95rURpFfJyKjZ3S4Hjhxxh4j2xqJ9RTEH6h+/wTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tpvzeFAUsph0mkOgFEREpL+Oh10tLy3G0hwP735YZGM=;
	b=zsRDem1uQAbxmcXMqp6WQ3Fi0X91I07q8dcml7QY2gXzAgJ0xjp3fAx6bRskEHvM7Yn6
	 pn2vyAkdUV3ca1U1qpoTMWvFYc2+XdpHwloRvVN8H/G8yCJWYmDv5Nu5OPtTh8saZmDXl
	 ypN6PRwfjbMo50SddlmNPRRtCtUv+1SzCFc70AMqWaAcDgxo4+PK6nq3eRPN3l31TkeI7
	 ORR5yiMQHDU/Hfv8LLO3DYSnNLFgRX+lGUAMlN/4FEmGpaC4fYAmZAPtXVbnmBqcKU+bP
	 BqL8A9zq3vpcAaymCFqTEpDS7UPjJf17g0lY0r9ZNjRSPzgRbglV0CdfiATBo5EVo8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTmhCZkT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34933606A325;
	Thu, 19 Nov 2026 03:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTmhCZkT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9A71F000C4;
	Thu, 19 Nov 2026 03:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059157;
	bh=tpvzeFAUsph0mkOgFEREpL+Oh10tLy3G0hwP735YZGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTmhCZkTSC6Zg1wkagm0vyv2RV52p7eIJmguv7HCoBeDM8ox+pA/FQczB/o+s9s8u
	 vOIxrbKyfopGatV3gRYx/TXq1xp7sXMfB08S9/Cq7qyQ9wwHubfidxjfIQpsA0gT70
	 0SQL6iV7bCiWv+DBr1gy0EjgOlR9bB31LhuPd9B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0741/1848] ALSA: line6: Reject capture buffers smaller than two packets
Date: Wed, 18 Nov 2026 15:46:19 +0100
Message-ID: <20261118145947.368938459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sinan Turunc <enscrpt@pm.me>

[ Upstream commit db51425c9eb038a8e40e09b837afde015ae9e3ec ]

line6_capture_copy() splits the copy into the ALSA ring buffer once at
the buffer end and wraps pos_done once, which is only correct when one
packet holds at most buffer_size frames. The packet size comes from the
device's endpoint, and the per-device hw structs allow 64-byte periods
with periods_min 1, so a packet can be larger than the whole buffer.
audio_in_callback() logs an oversized packet and then copies it anyway.

The packet size is known at probe time, so constrain
SNDRV_PCM_HW_PARAM_BUFFER_BYTES in snd_line6_capture_open() to at least
twice the larger of the two endpoints' packet sizes. Two rather than
one, because pos_done advances by the packet and wraps once, so a buffer
of exactly one packet leaves the position unchanged after every packet.
hw_params then rejects a buffer that cannot hold two packets, and the
single wrap is valid for every configuration that gets through. Keep a
guard in line6_capture_copy() that drops an oversized packet with a
ratelimited error, for the case that should no longer be reachable.

Reproduced on 7.3-rc7 with a USB/IP device presenting the GuitarPort
interface layout and 1024-byte packets into a 128-byte buffer: ALSA
logged "invalid position: pos = 224, buffer size = 32" and the driver
logged "driver bug: len" on every following packet. With this patch a
1024-byte buffer is refused at hw_params, and a 2048-byte buffer streams
for 30 s with no report and with the position moving inside the buffer.

Fixes: 705ececd1c60 ("Staging: add line6 usb driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sinan Turunc <enscrpt@pm.me>
Link: https://patch.msgid.link/20261103132227.696-1-enscrpt@pm.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/capture.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/usb/line6/capture.c b/sound/usb/line6/capture.c
index 970c9bdce0b21..e77ef16c792f0 100644
--- a/sound/usb/line6/capture.c
+++ b/sound/usb/line6/capture.c
@@ -94,6 +94,18 @@ void line6_capture_copy(struct snd_line6_pcm *line6pcm, char *fbuf, int fsize)
 	if (runtime == NULL)
 		return;
 
+	/*
+	 * snd_line6_capture_open() constrains the buffer to hold at least
+	 * two packets, so this cannot happen for a conforming device. Drop
+	 * the packet rather than overrun the single wrap below.
+	 */
+	if (unlikely(frames > runtime->buffer_size)) {
+		dev_err_ratelimited(line6pcm->line6->ifcdev,
+				    "packet of %d frames exceeds %lu-frame buffer, dropping\n",
+				    frames, runtime->buffer_size);
+		return;
+	}
+
 	if (line6pcm->in.pos_done + frames > runtime->buffer_size) {
 		/*
 		   The transferred area goes over buffer boundary,
@@ -228,6 +240,23 @@ static int snd_line6_capture_open(struct snd_pcm_substream *substream)
 	if (err < 0)
 		return err;
 
+	/*
+	 * line6_capture_copy() wraps the ring buffer once per packet and
+	 * advances pos_done by the packet, which only works when the buffer
+	 * holds more than one packet: with exactly one, pos_done gains a
+	 * buffer and loses it again on every packet. The packet size comes
+	 * from the device, so bound the buffer by two packets here. The
+	 * impulse-response path copies a playback URB into this ring, so
+	 * take the larger of the two endpoints.
+	 */
+	err = snd_pcm_hw_constraint_minmax(runtime,
+					   SNDRV_PCM_HW_PARAM_BUFFER_BYTES,
+					   2 * max(line6pcm->max_packet_size_in,
+						   line6pcm->max_packet_size_out),
+					   UINT_MAX);
+	if (err < 0)
+		return err;
+
 	line6_pcm_acquire(line6pcm, LINE6_STREAM_CAPTURE_HELPER, false);
 
 	runtime->hw = line6pcm->properties->capture_hw;
-- 
2.53.0



