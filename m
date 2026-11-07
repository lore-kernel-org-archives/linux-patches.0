Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063104;
	b=bQrgt3oLRdcBFRlsNrdHp5EDkEh1WtiAFGFXNVY/LOO6mbgC1RhDWKlBBPeHHrhVu/h4
	 okHu1+u4iYsRRPrXIS/o7V/Pk8CENhwg8VpS/E7pplW7wOChgkoPkSZyYwSBUc4zv27Lc
	 tshNLHn0XKcLAoDV3Sa4eUk+/tQvgz8O/orS2BsOhV0er8bACvmvpzrxr1XstZ2HYkv1r
	 PWozqSGFt97S+D7Hj7DUbyCoEqf42JaTA0BHg/43v2AWYpnVgtGANCyw9YgB4NTIFOKeu
	 wsrMF3113QYl6784nzuTeumZeG86gTxQRrvCE+zdMadHmk5u2DFOHi9j6bGrHslT0eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nS/Z3ANDvMp0BOkcwT6Az7SagajBX7W7oBMWlUffNDk=;
	b=epTiXuh24yGBhbr+m/Ed8DMfbVRJBPkut/8RM1dK4Igs0+DlPAp0Yd7KpYgQNVCHIhBv
	 J8+rckN+4v6LXtwmvhP93hVUcP8w4E4i+nGgO5nDNakrcwDrbUKqWlJl4vwgME2mmpfYV
	 Gp14DJ3RxAwjTz+pecCUHzJPGFQlOKaBe0gQNnvPacDbEmbyjso0A4vgLj9zPgR/R31YP
	 9nOVRDTlcKWjj4pV7B/nqBkIk0xkiCisASR7mSjr+OiKhTWPmIeDYMy3RNiILeAaiv/mN
	 inPSyT9YH77bH8rYAxWvWymR8usm5NBwFBe7omW5vmFBMiCYbzI5FxaEbpmW6UkD0WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0ZjC/+2i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A7C606A33B;
	Sat,  7 Nov 2026 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZjC/+2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED47B1F0089F;
	Sat,  7 Nov 2026 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063104;
	bh=nS/Z3ANDvMp0BOkcwT6Az7SagajBX7W7oBMWlUffNDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZjC/+2iWvdIvu5p9Xb1g7OrZNBKahFTSSoVwghERVWzT4Allohhx3nl+MtjU9VBe
	 kUN2lz+231B45ttEyLfWF8H5FJW0L7LzIdjuk5JS8RdebRUzNIxpmaN8XnpoNVuDEf
	 /czfXE9rU+Gb5VYRVIqQDqjyXI66OFrtoVP+6LeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 338/869] media: imagination: Fix value clamping in calculate_qp_tables
Date: Sat,  7 Nov 2026 08:50:20 -0500
Message-ID: <20261107134903.860594975@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c8454a41da59d51fbcc5743f8c71a03b096a770f ]

The local variable 'val' was never clamped to 1 or 255 because the
return value of clamp() was not used. Fix this by assigning the clamped
value back to 'val'.

Cc: stable@vger.kernel.org
Fixes: a1e294045885 ("media: imagination: Add E5010 JPEG Encoder driver")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imagination/e5010-jpeg-enc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/imagination/e5010-jpeg-enc.c b/drivers/media/platform/imagination/e5010-jpeg-enc.c
index c4e0097cb8b7f..a36a2acc896c9 100644
--- a/drivers/media/platform/imagination/e5010-jpeg-enc.c
+++ b/drivers/media/platform/imagination/e5010-jpeg-enc.c
@@ -175,12 +175,12 @@ static void calculate_qp_tables(struct e5010_context *ctx)
 		long long delta = v4l2_jpeg_ref_table_chroma_qt[i] * contrast + luminosity;
 		int val = (int)(v4l2_jpeg_ref_table_chroma_qt[i] + delta);
 
-		clamp(val, 1, 255);
+		val = clamp(val, 1, 255);
 		ctx->chroma_qp[i] = quality == -50 ? 1 : val;
 
 		delta = v4l2_jpeg_ref_table_luma_qt[i] * contrast + luminosity;
 		val = (int)(v4l2_jpeg_ref_table_luma_qt[i] + delta);
-		clamp(val, 1, 255);
+		val = clamp(val, 1, 255);
 		ctx->luma_qp[i] = quality == -50 ? 1 : val;
 	}
 
-- 
2.53.0



