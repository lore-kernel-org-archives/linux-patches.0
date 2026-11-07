Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062827;
	b=ga8MSgXQl5otzOfuplUF/9+5RHKXFA9LrwHJel68IP1r3qKjXwZWgRRYSbIQUVaejobL
	 weVME9Q6Nan3Kv++IrhdYqR9Szz+OwqBBA9jMYt0dFUeyHpaTmvyo6I98WrxkMezkiCI7
	 Te0cpaVUNJICRD3febySZXP8aF8mnrafVDtEjLvfHZ3EnqcatJoVWdSckkCK1e94k8UDL
	 JGc8vrPTIsyLhhD1u+RLck6uPHpurSZqC0IHBJwdN+6ej/kC3R9LMQBS5fTOreYLjA9nI
	 STskDNQdr4QKZepQqln5FCefVGqspHK48mrxts6zdRlpiee77OxVhTIbxjYHrepFw5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKNkYlib6Y4cxu92YdIIhvlBtJ2YKFATtXi2crHsFXQ=;
	b=KkET/QB+CzXiPKmqac3O6ORlwER1SDxQO3F2EXRxINkMfcTcDxqO5yzYegKxAz0531DM
	 i4wjDaNPA9jAMPjLEOSDm/Udj61rEBGEYVhzgMAeh+J9/9ptIAmYapdZ8CM+etDN5wXkI
	 QnzK0H+FWL4qk+qgKxgNILoivQ6aK+Pr0nSwkVLzCoPHktQepRZhKO5nc3URQI08ig2Ur
	 2Wb3+KEuNolWYKTN38aiHP2OXnl3Q4msZQmw456uMhED+TCMUsmiYsH4/vdlJ32UZ2LQM
	 KbuQ2zJBRdEeLGwd44YdbAKs3yN0sXYckREs/AnXypBjUbqmxFr0UcL5m88KsXi4/3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBs6LNKN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B078606D80B;
	Sat,  7 Nov 2026 14:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBs6LNKN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4B31F0089F;
	Sat,  7 Nov 2026 14:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062827;
	bh=mKNkYlib6Y4cxu92YdIIhvlBtJ2YKFATtXi2crHsFXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBs6LNKNQvC7T372v2EdGDIKANqRRM/S2foAsE9uIAWSurjjXhDLpIP2dPfy9wmPY
	 sjjoXy9nR2gdkfEzD1d7VlUNUsClLL21MxcJCEwZEftN0bscqBgQkFO4I7864lnLR9
	 ws0bQet1cy5nMTbjGNOXBWYmUunKBqW2adG7jD3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+cb43e758a4dc84dd467f@syzkaller.appspotmail.com,
	Maxim Skokov <skokovmaksimevg@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 122/869] media: vivid: round the height down to the vertical subsampling factor
Date: Sat,  7 Nov 2026 08:46:44 -0500
Message-ID: <20261107134856.651155676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index d1c09bdb2f3b0..cc2b704717f39 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -568,6 +568,7 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 	const struct vivid_fmt *fmt;
 	unsigned bytesperline, max_bpl;
 	unsigned factor = 1;
+	unsigned int vdiv = 1;
 	unsigned w, h;
 	unsigned p;
 	bool user_set_csc = !!(mp->flags & V4L2_PIX_FMT_FLAG_SET_CSC);
@@ -620,6 +621,18 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
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



