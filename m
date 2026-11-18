Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052078;
	b=Mv7/BvOsTLN8vPbjp2LjOrf4hKg7W/6k8jYzhZq/9y4vCqPFiGZC3fizwRRfu6+Momo7
	 wTwEfGYoQUqmDKq1CzGCg4UFGuCrNGAdrhHUsXJKFHiCmlRb5Dl80JJ/EkJTVHDFkb+QJ
	 LrsvL8kO7Lv4xu/DH83zbupHgY4p6j6Ut0dUb9oHPCUO8kYcqO1fPgRkj0YlL+vG6NyNz
	 BlbSjtcRXOSrIPCRSuIJ3smXFB+I8XEH/zBPlKtyitlS2dv/EQI557F8blBa5FE/cpbaW
	 wbLmn2OFXTz2Pxgg2058bJJP2EsR2MH6KFGXFOFBskuV/tWNxl0v1EJwb2Ir4Fr9u3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMzECntjlWnkvIozsxIICQPGvz2SA1TXLiYxJCUC7BU=;
	b=ak8RwDAx0jvHJumjeng/HUVmTgOrc8/Le/t7W2pbUmjQWyISJ4dldnu6/Uq9EZMimsnP
	 H0c43gyVQuCsLmf6gJ5+hotp4SPjBcFbVlJBg77/KAPXmIXgkPatriy2LSVOqZKg/XOj2
	 ksyEqL7JJX02Lj1lIxq7+8hie5tM5sgcwFt9D5/V3AiqYA+kIa0W9fEUx+jd6NsRz5cxI
	 fwQw5PmC4zy3dNI6TaKgvYyR/AjaJtcuwFGjo48ds4mLlUfWiCMpjR0uB5SfVIqOp07lx
	 zMzQpvYLrhsRqQTPQA6KGNh9ylPXGN8JBpW/tlZVPmEhf6Hj2zcBMK80lHZeMYIG7Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jeN2wENi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E90A606A31C;
	Thu, 19 Nov 2026 01:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jeN2wENi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3C71F000C4;
	Thu, 19 Nov 2026 01:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052078;
	bh=EMzECntjlWnkvIozsxIICQPGvz2SA1TXLiYxJCUC7BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeN2wENinHYr2/Hxzr4rYKQ3Q8KsFFPJM17SN5Ev0i0E1JlOSSX/9nTbr4yxsW0j0
	 wENGbZEK5L7mKGC9xuS+Dl3+TLC7iYRJE0GpfCh/0kiyBLgetGF2a0ruGVhf8EAf/3
	 b3JnElSHhHXRX7Es8ufURyzSJiYgj7yLpzgzzzic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0436/2214] drm/nouveau: reject zero-size notifier object allocation
Date: Wed, 18 Nov 2026 15:35:12 +0100
Message-ID: <20261118150028.469602735@linuxfoundation.org>
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

From: Zhenhao Wan <whi4ed0g@gmail.com>

[ Upstream commit 38125d38d850bd2fdd5d7840c3bd52d9d208995b ]

nouveau_abi16_ioctl_notifierobj_alloc() passes the userspace-controlled
info->size to nvkm_mm_head() as both size_max and size_min without a lower
bound.  A zero size satisfies the allocator's "e - s < size_min" gate
(size_min == 0 makes the unsigned comparison inert) and yields a
zero-length node, after which

	args.limit = ntfy->node->offset + ntfy->node->length - 1;

underflows (offset 0, length 0 -> 0xffffffff) into an oversized ~4 GiB DMA
window.  The dma object constructor only rejects start > limit, so the
validly ordered [base, base + 0xffffffff] range passes and is programmed
into the GPU DMA context.  The ioctl is DRM_RENDER_ALLOW, so any render
node client can trigger this on pre-Fermi hardware.

Reject a zero-size request before allocating anything.

Fixes: ebb945a94bba ("drm/nouveau: port all engines to new engine module format")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Zhenhao Wan <whi4ed0g@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260813-nouveau-abi16-notifierobj-zero-size-v1-1-20dee38077cb@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_abi16.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index 4107b70065398..f8cb586a5d078 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -534,6 +534,10 @@ nouveau_abi16_ioctl_notifierobj_alloc(ABI16_IOCTL_ARGS)
 		return nouveau_abi16_put(abi16, -EINVAL);
 	client = abi16->device.object.client;
 
+	/* zero size yields a zero-length node, underflowing args.limit */
+	if (unlikely(!info->size))
+		return nouveau_abi16_put(abi16, -EINVAL);
+
 	chan = nouveau_abi16_chan(abi16, info->channel);
 	if (!chan)
 		return nouveau_abi16_put(abi16, -ENOENT);
-- 
2.53.0



