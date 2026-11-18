Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035931;
	b=wX7eqcMnBFVkB/oectalJzIlCOP/IpbewK8nL0ts4q3cW8gKsrv8Gi4uh+JcqIbqa66o
	 88DDWwfzTk3KtpNTdr71JDocUIx/0tuhxli7aoGNLECtxE3RUw2dIBwzd2ZpRK7FEtFLp
	 gvTf4V3Qnr1ag8VldfzZI00jYZSZYJ2uhJhGZewmhV/sMDnXfba7/F935MgcmB51S+Xk1
	 imC+Ac8gwoJcpNH271gnFfio/AzoN8cxL/hUHeAaPZ15bVk3SSPeaKYbHtaFATKB7aSQ0
	 3JIG8JpOpowm/ZF7Xi5tl53DWU78Xw0bQrreCc1i6B2RsbSNLTtq7juoabp1+IKXp8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fPKckSfff7WOZTvz8eZJhH5PxN2aD9OLnSFsNE51LGM=;
	b=t3R/ehk8U67P9hmmA2ES2cPSknatQ4Jtr/1sSoCJUo/uryYSFV253uM4CJ7pB8mMDj4o
	 GtEt17C48biuR/GfC5wuli4oXfbd1sLBuLNhg4dqXt0Qj0bBkK0nJkOQifnwAfU5si6hc
	 M1ubDUBgapzKjQNVPJ63HzHoN5eGxUX0llkQ8fDNjoFC8C/4g0RuxUXoDT7JUR0KRtAda
	 0IlGn4NUsYNIhsy0b80orOF6AeJ5ru3nHhE9aMrLknYhtAmBPZWpBGOc14bhn9eYeNjTT
	 bsA+tvauZJmoECkOF4mkHCfO65FEnyBnAap7JaJpEzWyJEa8DXa/aiJz7IiKIi6bQ7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ro7bRPRT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34665606A90A;
	Wed, 18 Nov 2026 21:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ro7bRPRT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867251F000C4;
	Wed, 18 Nov 2026 21:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035931;
	bh=fPKckSfff7WOZTvz8eZJhH5PxN2aD9OLnSFsNE51LGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ro7bRPRTMgglzCDxbSeTZpM76tB8dAjo9lqlDkGxH4d7Y95MHSzkxDgdOy+3EM4kS
	 /43SeV+6j1SYJ5LYg55gj4nWdkG/FcFpMH8PSBUozNSGhG2PPgW5RF3KTYRiLszlou
	 VnyGSOXnSQ5bUUS5mt8T5qVS9ju+xUiOQByBqdHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0837/3318] media: vicodec: fix out-of-bounds write on under-rounded coded dimensions
Date: Wed, 18 Nov 2026 15:24:19 +0100
Message-ID: <20261118150344.264942543@linuxfoundation.org>
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



