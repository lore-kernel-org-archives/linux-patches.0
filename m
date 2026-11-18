Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044833;
	b=0NTLKjt0uycTYg9vfQjMKEQ+8M6LLWQcbl2uIqGOzdAndO3JzqjQKtUQyQSC6yd3PeFz
	 SfgXvRprSRT/6rwgPRJsSI8r9fwjSEdSfSi9HRE6P3buAoGlTsJnBfsGqqYmdmFvin1HD
	 3dZAkb06Mvm0pDJdDU58fxf/rX2/LjrSZldHJ+IgC64dxEk7BRqKzhkK77QFt/etWKoNG
	 YSYN5s0snJjUtH0xjaLfNnO2zwDNlxK9gsBWnxu8G9pYQQ782chwwqY00ZAANjM2Unlj8
	 U0tPBOa8Zj+BFRRpJuhtbaP64lHhUDQRL7l60qN5khwnSywcc7ibQRtOCJtd76hVpdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7yBCw0CA5y/FTAOA2hpu0enoSUJStbG+iO3/fBWMBq8=;
	b=MWXYu+YvxX/Ac4r3DDb23bFb4a6h96L8H6gEPqNaFb2v0BJgYSQcbNXimxA5qbPKT9sX
	 Y6NAPTYkW5euBH4PZTm9D8csUUbC51P1BriX2njI2ZRiv+r7akOLgdeBjHwayePCk0Rp2
	 rDV7bmrBPH4iBM4LuQHv16TKc/PVcoINHTYkfb1CRztgTc9WJXOdrCWVE+iyMUOtgC9/G
	 lEQrQlBYRzJbEr1MjTYDne8UaU8dXa1dgJrYgRdAvSF3C+dGxknLtXIIP41LKF/SjcQfV
	 7OIhOvrZnTeR8zTqryaikXuWG3zGnPA+qYgW9niJ8m6n0MILBuEidSoZQ6v6vyDWV7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n0/DoFWc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A675606A9C0;
	Wed, 18 Nov 2026 23:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0/DoFWc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636E71F000C4;
	Wed, 18 Nov 2026 23:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044832;
	bh=7yBCw0CA5y/FTAOA2hpu0enoSUJStbG+iO3/fBWMBq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0/DoFWc+tp2b5xzvyC4FyheaL2Jd9sfgScy6dpqff4uCM9r0EovDB5F+Qrj80Eni
	 lVdV+8m+9mSqEBa9OwLraKAuvcDMMwkmH9PyBbmUw3P9tpCDTndvMlMP6IMOLcD8la
	 Di0FrNOP5HO9VzUB9/+2JUbY1K38pR5d+v0wyN3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0707/2857] drm/nouveau: reject zero-size notifier object allocation
Date: Wed, 18 Nov 2026 15:29:01 +0100
Message-ID: <20261118150227.009189600@linuxfoundation.org>
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
index 5bee655e7e63e..9889ec61f8475 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -558,6 +558,10 @@ nouveau_abi16_ioctl_notifierobj_alloc(ABI16_IOCTL_ARGS)
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



