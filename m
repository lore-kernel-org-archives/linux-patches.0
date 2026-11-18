Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052199;
	b=eXS7v2l0Yajhtwc+3rC1Grt5fWgSmHcqxcQbnTooKmRAOA6Bl5zNoP0ngzz8AYtFHUtP
	 PJfiNixGp+FE0wLkVlzMyPkujYrrw6V8GusZRvX11yEeFGVddbPogo5aHDUHrSMnGpL+W
	 uUbhFWqQjLQWQRGzzSko1lm4ypN8LUzrYDoYJiZtWklWtnorNOwmdi4+osIQGPFag0nO+
	 o0HzOtiUIIAPxkexqSxQJqbiTE02rv5b4zOFCxEa+DzbfpyDB1r/6vQWklZ3EoC5lsBmJ
	 HEsYnUWJyMH4V7FrUZvkjY7ENQ+Nq7G5ceU2xOZqVRT4OUy03Nsv81hCgqkN3v2bd9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i71Tk8TXhxfr5bqwCi352xbxWhShv8GQcNoUKIyJjks=;
	b=2zO3koMr+qIJKNL7zNHMGocFlpmNShiHlpdPMM5CbGdQjZyKUwQ93WKJp0lfExSUZARF
	 yHA/mrf65VS5BCPbJJif1oWofWcwe2qWUGiSGt+NdbO1Snw/95CmgbM/15bvyG3QTWSjj
	 uOQnRmE8X54LhJJvejaTTFBUHtp6dizQfPCWP1evCHp2I45AdukSTW/lytWu3EAoVufvr
	 NzzCO+ynXm3WNPddDlETkECvw/ad5VrREZJ8e9hqDUTGjzqFlzqSm0srQL/ypvPfMyBjG
	 3N156KGuEVbg493YwltkGuXXBumfLXd9gsAkihLZrzS7kDsThCPISKrWEFbal0/LfHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPT4ZvQ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9E6606A320;
	Thu, 19 Nov 2026 01:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPT4ZvQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280661F000C4;
	Thu, 19 Nov 2026 01:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052199;
	bh=i71Tk8TXhxfr5bqwCi352xbxWhShv8GQcNoUKIyJjks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPT4ZvQ2aXhQRVWHexFG0N1YLCQPzdDwPsZjSBNDHSiZ478/URYGJINteL9HtqMY6
	 xiZh8O9R9DBP7Ce+pHS2ZQmyeMW74w6Dg2BjrVAqWzuz1Hy9YaIqrB0BDtRHi0nh/h
	 wE6HnpX55ChUoyqjJfgJtTLo6Hw8Oi6734ba6wRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+cb43e758a4dc84dd467f@syzkaller.appspotmail.com,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0480/2214] media: vivid: round the height down to the vertical subsampling factor
Date: Wed, 18 Nov 2026 15:35:56 +0100
Message-ID: <20261118150030.389858178@linuxfoundation.org>
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

From: Maxim Skokov <skokovmaksimevg@gmail.com>

[ Upstream commit a2ec28dd2a88d0721fc4a30242861e2be01d4023 ]

syzbot reports a vmalloc out-of-bounds write in the test pattern
generator:

BUG: KASAN: vmalloc-out-of-bounds in tpg_fill_plane_pattern drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2617 [inline]
BUG: KASAN: vmalloc-out-of-bounds in tpg_fill_plane_buffer+0x2063/0x4160 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:2705
Write of size 720 at addr ffffc900038f9d50 by task vivid-000-vid-c/6017

The reproducer requests a 720x49 NV12 capture format, i.e. an odd
height for a format whose chroma plane is vertically subsampled.

The buffer size is derived from the height by a truncating division:

	sizes[p] = (tpg_g_line_width(&dev->tpg, p) * h) /
		   dev->fmt_cap->vdownsampling[p] +
		   dev->fmt_cap->data_offset[p];

For a single buffer holding both planes tpg_g_line_width() returns
720 + 720 / 2 = 1080, so 1080 * 49 = 52920 bytes get allocated.

tpg_fill_plane_buffer() however emits one chroma line for every two
luma lines, i.e. DIV_ROUND_UP(49, 2) = 25 lines, and thus needs
49 * 720 + 25 * 720 = 53280 bytes. The memcpy() of the last chroma
line runs 360 bytes past the end of the buffer.

An odd height is not meaningful for a 4:2:0 format in the first place,
since the chroma plane would have to hold half a line. Rather than
fixing up each of the ~10 sites that divide the height by
vdownsampling[], round the height down to a multiple of the vertical
subsampling factor where it enters the driver. Adjusting the format is
what TRY_FMT/S_FMT are for, and it keeps every later division exact.

Formats without vertical subsampling are unaffected and keep accepting
odd heights.

Tested with the syzbot reproducer, which no longer triggers the splat,
and by streaming NV12, NV21, YUV420, YVU420 and YUYV at heights 47,
48, 49, 51, 480, 481 and 1081. v4l2-compliance gives identical results
before and after (48 of 50 succeeded on the vivid device in both
cases; the two failures are pre-existing and unrelated).

Fixes: ddcaee9dd4c0 ("[media] vivid: add support for single buffer planar formats")
Cc: stable@kernel.org
Reported-by: syzbot+cb43e758a4dc84dd467f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cb43e758a4dc84dd467f
Signed-off-by: Maxim Skokov <skokovmaksimevg@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-vid-cap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index 127837e25ac9e..48b43eea3d7ea 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -571,6 +571,7 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 	const struct vivid_fmt *fmt;
 	unsigned bytesperline, max_bpl;
 	unsigned factor = 1;
+	unsigned int vdiv = 1;
 	unsigned w, h;
 	unsigned p;
 	bool user_set_csc = !!(mp->flags & V4L2_PIX_FMT_FLAG_SET_CSC);
@@ -623,6 +624,18 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 		mp->height = r.height / factor;
 	}
 
+	/*
+	 * The chroma planes of vertically subsampled formats hold
+	 * height / vdownsampling lines. If the height is not a multiple of
+	 * the subsampling factor, then the buffer size calculations round
+	 * that number down while the test pattern generator rounds it up,
+	 * so the generator writes one line past the end of the buffer.
+	 * Round the height down to keep both in sync.
+	 */
+	for (p = 0; p < fmt->planes; p++)
+		vdiv = max(vdiv, fmt->vdownsampling[p]);
+	mp->height = rounddown(mp->height, vdiv);
+
 	/* This driver supports custom bytesperline values */
 
 	mp->num_planes = fmt->buffers;
-- 
2.53.0



