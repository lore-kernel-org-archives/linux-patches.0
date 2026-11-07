Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063895;
	b=oLCbHIWkuXCHigfSkw51bFPNP3fdvnlCrC3dtsVbAgwXJALohmHU2MOZAkjlI2pNNTsJ
	 eTB8WFYJ2bpM9/NaNqJlMS27M+dl/wn6HRr7o0i3L5i2DGTPiyxv/JjMRDh5x7DN4gAnI
	 FAY1pZUw3m5S4nEF0JgW2R+rKzn9XlF0qDusyKVpNgd0tsTr0F7I55vmMUtF32wRO3j1w
	 uWdWA5vFlHu2Iuy4tmqXJIcnOJR1o7OEP2E3VgcFgX9YRA8A+SZfHcoBE8/QY9LwPx/4f
	 OFyuGVUncmIQmX6L/aTdttcRL9r5cf5/MIiiqfPY6rkxoK6hkIm4iunQisTgCei0c6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dLDz0USCdAB7CF++9qiEMsgk0DkRTwUyTqrfluUvoAA=;
	b=vs5E2sPbTU5xy6WYr47LKZ1wqzbDVXZ+n8MHr9ezl7KdBtszzWRFVqS0NF9bwEGmx8SL
	 5kWkP2Tyypp10yH+WFbUO/Y1iQXW6kgo/HYbGn2z9JvpsesvyCnzfyrBK641oLAs9AOSy
	 cvLNhZ02GYCm542Qt5kiAPNd30QurYH+DAnge+XH1of/Xg3TRBOIJwIvidHcqWpLEjssw
	 1Ji91B54vQXxd8c8C6Z7B5bpWorXrC9Y8VFg9fVMHb2+T+mW5yyDzFfe49zHUrVGKIHOV
	 UEg8YxGvFzVUogdL8OheKV/kgoVub+ozngqcjmpj0826MeP/7HF0p0Qp0jwm25thkDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAZv82wX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B485606B8A6;
	Sat,  7 Nov 2026 15:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aAZv82wX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7151F0089F;
	Sat,  7 Nov 2026 15:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063895;
	bh=dLDz0USCdAB7CF++9qiEMsgk0DkRTwUyTqrfluUvoAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aAZv82wX3v72juAXvG16JhepC7XKqOTadm0oed3XBt9eXayS3UEEehdDm1JLHy6Me
	 DlEPvhq0Kbgpshbolh5d/BC5meCf3iiQfiRdhJoEXD8XtcKnF8l6YcuLbykXLctPfv
	 rxUSfRyc+98i2iNdWBd9Jv8bLb+yxo7y8rj7phtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0097/1257] media: vicodec: fix out-of-bounds write on under-rounded coded dimensions
Date: Sat,  7 Nov 2026 08:39:53 -0500
Message-ID: <20261107134942.036145065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 0183746ebca4c478027e2261b904f844f1443b19 ]

A capture format whose width or height is one more than a multiple of 16
makes the FWHT codec write one 8x8 block row, or column, past the end of
the capture plane, and read the same block out of the reference frame for
P-coded frames.

vic_round_dim() is documented to round a frame dimension up so that both
the luma and the chroma plane end up a multiple of 8, but it only rounds
the chroma plane:

	round_up((dim) / (div), 8) * (div)

For div == 2 the result is a multiple of 16 in every case but one: when
dim % 16 == 1, dim / div is already a multiple of 8 and the macro returns
dim - 1. encode_plane() and decode_plane() round the same dimension with
round_up(dim, 8), which yields dim + 7 -- one block more than the coded
dimension that sized the buffer.

On a KASAN-enabled kernel, a 641x360 YUYV P-frame triggers:

  BUG: KASAN: slab-out-of-bounds in add_deltas+0x450/0xcc0
  Read of size 1 at addr ffff888009070800 by task trigger_bin/70

  Call Trace:
   add_deltas+0x450/0xcc0
   decode_plane+0x1916/0x3390
   fwht_decode_frame+0x173/0x620
   v4l2_fwht_decode+0x751/0x1120
   device_run+0x6bb/0x1850

Round the dimension itself up to a multiple of 8 * div. The rounding
changes only for div == 2 and dim % 16 == 1, and MAX_WIDTH and MAX_HEIGHT
are both multiples of 16, so the rounded value still fits the advertised
limits.

Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change event.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/codec-fwht.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vicodec/codec-fwht.h b/drivers/media/test-drivers/vicodec/codec-fwht.h
index 0eab24020e9e6..4b4d390310899 100644
--- a/drivers/media/test-drivers/vicodec/codec-fwht.h
+++ b/drivers/media/test-drivers/vicodec/codec-fwht.h
@@ -61,7 +61,7 @@
  * both luma and chroma components resolutions are rounded up to
  * a multiple of 8
  */
-#define vic_round_dim(dim, div) (round_up((dim) / (div), 8) * (div))
+#define vic_round_dim(dim, div) round_up(dim, 8 * (div))
 
 struct fwht_cframe_hdr {
 	u32 magic1;
-- 
2.53.0



