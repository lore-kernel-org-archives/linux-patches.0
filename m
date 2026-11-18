Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052169;
	b=SXSLnYKOpLxd45gEWIHBf2pci2W/fEvglx5fgEb2OTiKi5dstRGHcJLRh5nLsR42CUAE
	 zYjNXXyKE5uijvkgeK49MnG2eeQI4wUrKH4RGJANbttMOOYWYjBuc76nLmtJSRpCTgmE0
	 Bw/9Ir1t7cN+NVzM1nmgxPpIruz1ueepJnm4Zfy96fH1wNN+2GrOvLeiGN+EnFi2ljkGy
	 djpBejSOOtSkiasasFCr26Efqy57C64gM7NrOdjr2SHH1nntAe4iuLgQ8Syn53g2T5NTj
	 95AWssYU4Za9nwKGPF0GfDNKgnd/m2nV3P7vqivpiGurOdeWxvBd9tbt4i+KxgUo6dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5RatWBlNqYZxpQr1XdqIuxuzCP5vbM56qQGq8UqKWa8=;
	b=hKOpuZLzHyt1092vrPzq25M3XImfVlLKMMk9tc3/uNzz8Fy+XwDPFLpT/9+mUbSbjxbn
	 Od+UBdWpvULZ/T8yfH4FUzEJbZr8MIg9013sAGJdp+5+Y/7fFe8Rbdcxld8bRWjldCH5u
	 B3CkmahySPEPysV3tmmm5n5D5njuNg1Fh4fPp7oHHOFOQNrVkdUmo4V1l+goa5tVGfVyz
	 hUGYCY/J5fbWsg9aYr8MCemPimsAInw1qVep31+q4Um/VS3su/+OsyQjsRJo/53GugViv
	 lDqnU4nU2zUcOJNBOA4236CyKkEP2GDpylXncAJ++bkS752qOHEZTGq1s2kdNV9XfHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AVJxH/Ha";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BDC606A325;
	Thu, 19 Nov 2026 01:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AVJxH/Ha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7881F000C4;
	Thu, 19 Nov 2026 01:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052169;
	bh=5RatWBlNqYZxpQr1XdqIuxuzCP5vbM56qQGq8UqKWa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AVJxH/Ha9OhOit9OS2FfdPYACUPJv7R+W7wqklkwfove79bsGs9tEhHidkcKTW/iI
	 Cm66aNuLW+bVbnlep8zNa4aIPvN/Ne79GzuhGexPN34Ahc/bKOwLgGRaxhxD5QTzns
	 tkLr+LmRtmebPDq9AUQQmFEXT4NM4TSBWWADl+Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0465/2214] media: vicodec: fix out-of-bounds write on under-rounded coded dimensions
Date: Wed, 18 Nov 2026 15:35:41 +0100
Message-ID: <20261118150029.810017203@linuxfoundation.org>
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



