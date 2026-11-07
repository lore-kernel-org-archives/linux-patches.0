Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064461;
	b=KfOdjtzMv5Dz16FXWFU7djbgfctocEeOtb2wBoUEHl81RN6Izbn2UzkZoCbJVi26vXND
	 LSH1yTuumobtlxCgyGP8qn/WsNTeuALev3DUeeXvwDa9um6Zg4wtUpEOuh6DFXVvSwZ4H
	 R49GJWgclTFCfEaaJnbUyIOEFNCP4enwxc8Z1B0rnOCRkfdHNFcJ4Do3Ve2sK2wXSkGfR
	 KdAQrrWKMAvxo79xfnPUkt2TnM6oCW6F4iNln2rv/OdIkkiqhGN30BjbvHCYnCRGw4x1k
	 N3OuhZDHxJoseOC2iKAzjJOcRDyN63i4NRwwYEOycgig+u5rx4HRWEIiO0p7TiN9nEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h+vY/VEegiDafKFsZkueMPTIr/PUPQdNJWSeIrYxxpg=;
	b=uO6Uz2dpOCCRgnd89dtIYua4XM4wZ6jQh6EeFHbaxH0CaGg+3/lN2W6Volttg1A5n4VG
	 S7JFmaht4RG2XJeC8LMK5bfX7VPh97VfR3xfiLgYBxRETolYc0SSykubVCrxlvteB6F3t
	 FMMr7Depdz2R7krc7FlHTIkw2Df5Zu5NIjYFdxLREoPtKIDGhwqmgW73SOtk3r62klNCK
	 X9E9111kK+Ov67A7oT3OGRYPSyNbIt7Xu25TOrOSaY1kap626Wk5ODrQzO7pocwkYR/vF
	 xzwWfIOK7cURFqef6Zh46PqfKAjiPw3CPhS7EdDqcdUN6stjVXTlkInXYQSq79I2fjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1hnjMXv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F28606A9E7;
	Sat,  7 Nov 2026 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1hnjMXv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1201F008A2;
	Sat,  7 Nov 2026 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064461;
	bh=h+vY/VEegiDafKFsZkueMPTIr/PUPQdNJWSeIrYxxpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1hnjMXv+vPreiyVoLNS6jtThcWggUPxXbifF8LgNVXTQt+hqz0hY2aQwDuD/ate/
	 /oBdccP9pUxPrX2BdgulYbGNh18QsOFQ+ig03MShSnWsdWz9pIrqe+x8/YT8S4kPzv
	 SUqaxwJXfIMbZY1OVLO9Jg+ytv5NJBxE7pJjt7/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0465/1257] media: vicodec: fix NULL deref on oversized frame
Date: Sat,  7 Nov 2026 08:46:01 -0500
Message-ID: <20261107134952.304469904@linuxfoundation.org>
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

[ Upstream commit c657eb609197e289b054bc2c4e86a0fc32dd7ebe ]

job_ready() only honours the is_header_valid() verdict when
ctx->comp_has_frame is set, and comp_has_frame is only set once
comp_size reaches the full frame size. Since the copy is clamped to
ctx->comp_max_size, a header advertising a larger size leaves comp_size
stuck at comp_max_size, so comp_has_frame stays false and the failed
validation is discarded.

Control then falls into the resolution change branch, which calls
update_capture_data_from_header(). That function re-derives info via
info_from_header(), assigns it to q_dst->info and dereferences it as
q_dst->info->sizeimage_mult, with no NULL check of its own.
is_header_valid() does check that same info_from_header() result --
if (!info) return false which is precisely the false verdict
job_ready() discarded above. info_from_header() returns NULL whenever the
header flags resolve to no supported pixel format.

Drop the comp_has_frame conjunct so an invalid header always bails out.
The resolution change path is unaffected, as it is entered with a valid
header. Oversized frames are then rejected by device_process(), which
already returns -EINVAL when comp_frame_size exceeds comp_max_size.

Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change event.")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 7ea024b14f0e9..a6d12ab66a0f3 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -654,7 +654,7 @@ static int job_ready(void *priv)
 	 * if the header is invalid the device_run will just drop the frame
 	 * with an error
 	 */
-	if (!is_header_valid(&ctx->state.header) && ctx->comp_has_frame)
+	if (!is_header_valid(&ctx->state.header))
 		return 1;
 	flags = ntohl(ctx->state.header.flags);
 	hdr_width_div = (flags & V4L2_FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
-- 
2.53.0



