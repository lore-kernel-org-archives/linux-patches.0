Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061872;
	b=xlrs4d7KukntJzaVgzrulLT4IehUqEsDlcAkFKONOpe83YzZ4JKzQ/8mSCAuPK3U0tgz
	 5pQcEQLDRQvv/NePUzXY4VC8G6r5TkrrBVLJbI/xaLFBTGdQA1Hqud7EE4Ge19kYnMO5T
	 tgfR0zDOJLScLFF1bgIQDZ4v1ULA76yK8Kms6L5XdI73VxCBVmVhNbvdREzdnZgrmBm0K
	 rX6m/+SeDhyV9ax4CTasSc1EBv5gyNYHmw4A9KNDjEJ96v5dHLPNXhuF7N4NmzI2VrIu1
	 mP/RnktpxdHE8wUjVyiS62yY85hgCvmydMTB2UzsSEXcQSYnAbqh4sDTTZY7EbDPMBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s9yCLRk2E49nQ9XeFQzDF9N/TYqAMAP+cJdVasdZH+U=;
	b=LHKSfDu2nvXj9vagUm5qJEQrJbuD5Xu/cmCtGGWehnsxOEPdZCj744kYVogis9tB+LeX
	 TC4K7s/BIlqgAquvzGPJYfJ62PNsgBecS8N9UQ+23TH7bCmubNx8imThKsH2OKI+iTw7C
	 K1a9ozzEJFBBDivwbV/0+MtIfPanYQ9OAB1tmvcs8mZgDSkq9UV3y3/jeXq/QRKb3/PbB
	 BXRN+4KfhvXCe+UUKdlTfTEqit0xgZO88S0+WGMYsQqZtijrvWHtxBM5JrTnzSLl7vvNn
	 p8XAcNS/MNUPrR0lIAZ07IYTeRVGyqDPUhR6Lqs/MM1TsJsUSnfVvoQGLZpnex/JSMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9aneOlx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD700606A32F;
	Sat,  7 Nov 2026 14:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9aneOlx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA601F0089F;
	Sat,  7 Nov 2026 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061871;
	bh=s9yCLRk2E49nQ9XeFQzDF9N/TYqAMAP+cJdVasdZH+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9aneOlxpvE0PBJds4IErX0AgFBieN3CwjCAtAHuupFrVfA+icE6FtHmGnuZejxBX
	 iUm7gUWyzlSQ4R+sskDLCA1TLzFfJ0V484U50Q9EDgqUNg+vs0fuGJxz2d373KR5YN
	 ZF2muuO9is+PQ549qKcUY2fvRDOFadEnBGIQFTUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0886/1536] drm/nouveau: reject zero-size notifier object allocation
Date: Sat,  7 Nov 2026 08:48:22 -0500
Message-ID: <20261107135022.509326435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2a0617e5fe2ac..aa4e46b9d1968 100644
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



