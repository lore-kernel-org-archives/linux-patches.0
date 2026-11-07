Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062695;
	b=BJisY0gTt1ATk6MyKssEWQVdXGhpOw+xuWNJLmUZX8z4qA8+03lE9Bie4SuCCcX6P8Nv
	 I4J493Dgiyg8GBZRaWo1omJTnyrK+GtAJEzAr1Em61ls1XM9v4vfWp6OB1bC89Ca0gyka
	 qetW68K97xpmLHpNjysfOlpXgWocfa721V5nRH0sscy8b6fL4HW7PxXt0dNspMPhlQdYg
	 FG5An4bjbG9K91ywXC16F3F4FVxr34mdvqT+eS4ED8IOoDJFIiLa7KHyzwr4bRN6/1B0L
	 pG4X+UH1LxMHcOlrcv7YLi4mCVMGRKK0fhRYacukO2XoWVi3PHXmkkDouWqWdHwcziQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062695;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uMKym/ukL9nxU7BcJ0CBHlQjPnV5E6ljoG9PF5UR6Ck=;
	b=cOcr3gI2D5uFAnIdsme0sKg/kqNdaBMdYtA4AJkMWz4ahxqoMIgZiAaqcXt2QwIgWEB3
	 Sb0R4zpYHzjgyvvss7VihADA4nzgu5TQBY8w8kW21VLYeIh5tJ0Taa7DKmtDq6L0P2so6
	 xP/qd/jZ+v5yI2X0GVEn11/+ZpiNTeMIqepNFH2Oorcn3HDXsw+FThpEM2g7l6vhNNMIC
	 ImTvvFwvL06suByOLj830S+Tth7EDekbuyYknDc4B7asmq3mGcq9N8bF1E7eBGvszpmUd
	 1kgROiz3kxhDC+shfoaLzcxFPnXIXWIx3u35SZzd2QCNooiv/kLmqC8o5ZFpYuza2Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Am637xzT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB8A606A32C;
	Sat,  7 Nov 2026 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Am637xzT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA041F0089F;
	Sat,  7 Nov 2026 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062694;
	bh=uMKym/ukL9nxU7BcJ0CBHlQjPnV5E6ljoG9PF5UR6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Am637xzTezWbTleOUQlRVefn+2juAiVpRlafwo9b1R1br2Krkeg/+AUrEI+7SKpl4
	 sUTMOoHu7ltnN+7N6i8MvVdNnxGsE9CnvkmP7vlhdwMtoc4+3CXQ+ESXdxErueF3l1
	 7kqjEc8RWd0erXYrcZE94qlPb5CMqyfbHWw0SGDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/869] drm/nouveau: reject zero-size notifier object allocation
Date: Sat,  7 Nov 2026 08:45:03 -0500
Message-ID: <20261107134852.788941894@linuxfoundation.org>
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
index a3ba07fc48a08..a067c7244e7ec 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -631,6 +631,10 @@ nouveau_abi16_ioctl_notifierobj_alloc(ABI16_IOCTL_ARGS)
 	if (unlikely(device->info.family >= NV_DEVICE_INFO_V0_FERMI))
 		return nouveau_abi16_put(abi16, -EINVAL);
 
+	/* zero size yields a zero-length node, underflowing args.limit */
+	if (unlikely(!info->size))
+		return nouveau_abi16_put(abi16, -EINVAL);
+
 	chan = nouveau_abi16_chan(abi16, info->channel);
 	if (!chan)
 		return nouveau_abi16_put(abi16, -ENOENT);
-- 
2.53.0



