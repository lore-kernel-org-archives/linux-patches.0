Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058158;
	b=mopB+jDKh9zLpDncJMAzKVfnY0+VmhapRDCaMf+9q4mKmC7Hdzpns5qLNViYd90Oz8oX
	 DnlxydBAlDAk1Kj6fjaCm7Dg6H8452juKJBoMgptuhFRzniYEAUCZ/F+dzQ/NXZdopwqk
	 Hdy9b6+3HBVUsK4mdWuPwbDcN7V8htz9x+7BuG1YgEh4gvn2Z5B7WHRY8YX1hjYvk9TPq
	 wcBE2F9/xOZBAu+xnKZi1AKxgNXlagISMqteCjV+DW3kYRVquSxEtTO7hEEPHrQPDGh8S
	 Eq8Q8/GD2VyL9+Qo3nMKCAiqrmWkP9h3tVeXpbMAPNaSwRR6jer6PLXPLMyBE8D+cQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4l4SqY2nrwLwtXhMA9cHq68Pfl45PNtyBz16DeFJE0=;
	b=iZH+1CCq6DTMEXvicNbU5hiRpxFNSfAUGiQpX7qTa4gD+JbCHE6nbBkoXYyv0fxmai93
	 yFfbSGQJIpPZQfNzGKKzyN8u6GnPahojgCJhw1GIh54Q4ywWJQ3p/mteJN7odZqKy05P9
	 QLQdH2tBWK+b/fa8266OxHSw6T+LloRbN1btxvuTdeznzo9TOOet9pwEaquxD2h+Zb9c0
	 4lEx+6vWraNVr/gYtTz7pn03qDI7SI0T2/9cgXqy/mo38ANZB/XjD9XrhDL4VCw5E9Nkl
	 C2upeYQTfWU4wuCBAAWuSNBqltpTg4rMyQdVwLFbbZXXFwB4Q306U2gy6+J399/f2xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ntl/UvkD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B5606A31C;
	Thu, 19 Nov 2026 03:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ntl/UvkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51B41F000C4;
	Thu, 19 Nov 2026 03:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058158;
	bh=V4l4SqY2nrwLwtXhMA9cHq68Pfl45PNtyBz16DeFJE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntl/UvkDTDKou2T+shA4TVX5TjqKeggn2QipRhLkwjOWNyO5IFh89U5nhYR891U3T
	 c9zpNIE2hw0z4544b93IY1PjcUwht5RbHRjEefJ6iV1yaiU/KrkhgeMqFo+G0jUaP5
	 +sXL8Lx6MpPTJCt5QE6KaKML37oM21+NPDYgybxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+cb43e758a4dc84dd467f@syzkaller.appspotmail.com,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0385/1848] media: vivid: round the height down to the vertical subsampling factor
Date: Wed, 18 Nov 2026 15:40:23 +0100
Message-ID: <20261118145929.771044294@linuxfoundation.org>
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
index a6bcc7cc4bcf2..22f2c54003ef0 100644
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



