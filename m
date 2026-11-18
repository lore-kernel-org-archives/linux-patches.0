Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058055;
	b=cclWyNud/2LFLB0KitsdiqDI2COkhg65Bs5+JrTphJQA1GyXnGkybRzZumovUs/Rz4fJ
	 8C2/bH5hxBB2wc+iO0zbORYBcMYIYo5LgLSKWzZQ/SaZnM5j7zlaikVtu9QH3JQy7JbII
	 OJ65uISPfDW6nTvsLFezXDlVEiP07afcLIxInKPkcM5xCckTZ6eEUJ8E9T9M9/fV3Cbr/
	 ZBGSYPEhs5cz+24jnz0wJr17+Z44nLOzwy+2B8FaWad43Ped7b7ypKx9hi38N9+62cK3x
	 IOQH2lwjxsIeYi6ebHFUvibSBSkmFwXwROrxIan1FCiM5jQzD1YAnJxsa0s6OEuCgOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yIHGgUqgleQ+8zznRkNqDpXd5fun/IARwtepC9U2zIk=;
	b=eaywJ+yufhk6c7HepbYR4EoWK50b7kzAlyDhVjCqbcXopT3umLkf+0i+fCJgEfH592+A
	 kp5G/Ezat87jaf3H5eYcnzKdqXAkeHCcs6FZNKYmAUFMgNMecqaYnYGNXc9E/KOWn2l2k
	 2Tr+OEoirnhzlk87N7Lck13cOh3X8iOue8qh85fJrHeIbUujoVYEJvelwOrNLi+PBiSB8
	 VrRKiqKRyncy36HlCWa3zJ1+dltIIkKoMcn4oh09tafzv+doddVchGeVI/SKGDdTx8ZoU
	 BVZ4wvLZ7xnGpV8LYHDipDeD/nbLe22/QCEeAbU+RHL4KbsZwaLhwt02X5XC9b0uYVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bb7tHJpu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4FB606A320;
	Thu, 19 Nov 2026 03:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bb7tHJpu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA5D1F000C5;
	Thu, 19 Nov 2026 03:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058055;
	bh=yIHGgUqgleQ+8zznRkNqDpXd5fun/IARwtepC9U2zIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb7tHJpuyZGuyUw2Ep8+1E3pwnAFkF42YxCn2poZhyS7ipARht+8VgIDWybTDSu8K
	 uWr4E+g0lQDucRJEN2azQ1kHgPPwyfndBk/mJbuAbt3+PGZLvpwoO6xjkV59O6kASt
	 wWwIL8ewjzyGDIT+CT8Il62nsZBUSxbDC/NXrvSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0347/1848] drm/nouveau: reject zero-size notifier object allocation
Date: Wed, 18 Nov 2026 15:39:45 +0100
Message-ID: <20261118145927.182160396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9a5be6f324249..16cf7c0b74967 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -533,6 +533,10 @@ nouveau_abi16_ioctl_notifierobj_alloc(ABI16_IOCTL_ARGS)
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



