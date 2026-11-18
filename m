Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044923;
	b=e7weOj2b7d0kRlsHTiS7L0fwH87C8UA0cFQEYZa7/JQUOXe57W+HAtmYjyQWpFxXGAbR
	 iHd9Q1jKi4i1mmmZHhWZkTw7wGtXd0rfWPUs+tWi5XltnjN5yfEiM8Bpmk9lUcHXeIHl0
	 7tpJXDBfdgIO56a6TanP9OeuV0atmBWasucc19R5swqKac0RDrVVz6+Ey5mxWzxP2t2AO
	 1v+ZR5No/6uqjX5SK9LWy0WETgo6EXuoMzwBivl9NLQrpqV/CnNgSRZdE8xKPyrbSvdL0
	 zN4d+zfJcKEdPEggcXPa4S8PaaKq3RVSKKvFsou8FM1js67WlEnd/6wUbI0v1Gspr2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VujqMPaDkTvXN7WgP6zHZQGup+276kRxRJKylt9SfzU=;
	b=VuqhnoUElU4Wir8H41LDpB3hI2IvUcO2J6wL1pv8UiCEjvFQiyOYZqtK545t4WKtTbwR
	 ufKYEjOwEwTLbEuYfMavmFEYEnwgZlRmcrv2A5oEeVchM9sH3gaFZiUV8NrEbrZJB/j1o
	 y48f/EnO3Ck3NBtEEPMEcgB0kZgcXBrYwur7H6frrJiI7lRayxp1S8FBsSY7fT8UCvo1p
	 J8IJ6cVmgtnujl+E/3DGmQw2X2H7mMiaHzwcJI/M87QC+LHqDUg8H265BqoOJEZF/my6/
	 YPlUg0BVBiKttu8xmNGjb5pTF0qaEn0QWA6Ge1Xxoj91h6mNKnzQOnG1OmCiRD4L8Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3Yqll90;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F96606A325;
	Wed, 18 Nov 2026 23:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C3Yqll90
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D282B1F000C5;
	Wed, 18 Nov 2026 23:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044923;
	bh=VujqMPaDkTvXN7WgP6zHZQGup+276kRxRJKylt9SfzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3Yqll90whSW1wDrSoehUx8yrFIwLx9nO3zL4jrJ3LJ3998Y6wR9OAAr/C14QrgMr
	 yLAsTueNfXtkopbIY0Xaw/ZBmNajWN9ZOyiSgvm2umSySABY8ctb/dE4CBMi2QmM1N
	 FS7t5D77HxYP8NwYsGDK9/2rkj9Us57PwlsRRcKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0741/2857] media: vicodec: fix out-of-bounds write on under-rounded coded dimensions
Date: Wed, 18 Nov 2026 15:29:35 +0100
Message-ID: <20261118150228.232932122@linuxfoundation.org>
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



