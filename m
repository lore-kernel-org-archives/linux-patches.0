Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035807;
	b=zSyp+nYa4Q7k0MSAtupoVzLse7qakYVJQmvgMwVg0wxF+Dp8N9Wo5O9kakrSTU905cjJ
	 wwq4W7fIFx2Ca0cL2XsqCP8umbjQvcYVFsuUX/FscuqOMQb2D3lfyU54BPAa3lkPBMgQa
	 dK5FHg0mVWrn3pdMJypN65jrHsKd0rJ4erZbUmV/qpsufeG2zLmH1G8tyOJIplMQRQGeI
	 ax+sG7DnsmCZK0FylFDFyxCbvble+2Bogf9O8MF0LGXS3+lXfG8bPHVmRO1QNdL5pp47s
	 Lfoo/Tj/8PAias/y7KL/qxu7fuIXqbRPkA8y1AJYK77jk4K4T48TkcsUHgc+hDd4Mpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pJ392qOYgb0mCFbMmtXKVHngLV6uRzg37UWJ3EMwOLg=;
	b=4NzzwPn+0/vLRX7drO9TaNs/j3xjEERMdY9e563svtj2oY13804KJE2EWTWDJrlvv2Ck
	 /Ola/psP46hnQRW77tHPAQDL7yRkeyDLbLvNwkFKtIVWZ5Xy2FAQCiQ5A6NvQF3ni9PSj
	 4yuoDkeC2LU4kZwHeqUA0YzeX4yCWhr+U4qfuY7JW5yVWMfLv9+XjCp50dv2oidn2jll+
	 VL10Jog1sXf43ZmZtXYe3qvqhznJ7FGx3wwsEQO/nxQgh5si1m13n3vI/X3qWhaeBtrT6
	 +Wogh67uKKoJ3OywxbwcOqUkitBne3nym1/KZFR3lmHpnccrxjTUaQaO+YKfh2z0DXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XO9n6uPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25394606A320;
	Wed, 18 Nov 2026 21:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XO9n6uPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3C41F000C4;
	Wed, 18 Nov 2026 21:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035807;
	bh=pJ392qOYgb0mCFbMmtXKVHngLV6uRzg37UWJ3EMwOLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XO9n6uPA7TqU4WeOTQv0TM1z4Zo8KQ/jiBpDMYhTN6GJx0xBANUjuZ+jUQ3HYUiIG
	 1d1wgRrkCl4qwiQOgLOwXB/9ONAul8iEW7y5ttEjx03TxR4WC7Epb055wf/oMmwbJs
	 CAcpXDZsOI7A3MEUs6yz97+AlB24RmGfCGBBvUTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0792/3318] drm/nouveau: reject zero-size notifier object allocation
Date: Wed, 18 Nov 2026 15:23:34 +0100
Message-ID: <20261118150342.647034837@linuxfoundation.org>
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
index 2e177ebab3039..2283beb8837b1 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -614,6 +614,10 @@ nouveau_abi16_ioctl_notifierobj_alloc(ABI16_IOCTL_ARGS)
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



