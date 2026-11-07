Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063834;
	b=hPmLmCYy4bv4RbNwRbr/T1IJbe8UCgUGGMBDRi7DYWV/SewmkqUKGci6IHq/FYdZDVuR
	 AoZhxEOiqRPI2634xCmyZHR0B0xtYEuCuj2isoOctLYxKpdH43+KhYMdQxXSofV23nNeP
	 VhUDfo13sRIaX4SWQ62jxX1FQ9BmkbaRATqGJDID7sz8v70cjWOtYEZ1BM3lELKygVWsw
	 RMerTmzxU4Mk1lFfkPP3EJxK5euRyDsJrZMOuQrjgeQFIAwxhqt3koFvjqeH/Ryj8dhYm
	 /nogR0T9p27yrt8k12+R5ncRkzLgVVlX+uyQnfTU6E0tHJ/Ya+LX2drCRNwZAZr3H+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=81O3iJdGP6FTv5Qbt9wpDr+MDjIU+WnLoyPsMMaKkWU=;
	b=BvjEX7NIVCdEAQX8RC9n6TnkrEQjK6tOQH9Ml2MvVH3qtbSpuXyf1nz28RRIPQ4WKnbU
	 4MnL7mxlEmj9mZU+dk+wNW2Gqh9d6L/t7nlCAOWDT7vGODwgq7u2ezPb6zSMt+NtHWwhg
	 ik8+aFq7h4OlXUPtthPi1QQWnbVWPyDgwhY40RHflaUq0UNdvU4I+Q4M1ZhBrp/C0wx9h
	 oR7LAvU+FgA7a8p9kaqMUpCNpDYAlf0AR9uHs/iuIHRYgRZ6BPbv6HAV7VRw6D52YMwrH
	 FkBXVXLJFbD56EVvgqT1MFlauf00CZmJyMUJVzOeW3UNIqJxFwX3l8nFiSUkkASggNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=182mDdRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192C1606EEA8;
	Sat,  7 Nov 2026 15:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=182mDdRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB61F008A1;
	Sat,  7 Nov 2026 15:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063834;
	bh=81O3iJdGP6FTv5Qbt9wpDr+MDjIU+WnLoyPsMMaKkWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=182mDdRBLxHITDHWa4owe7f05qAZUOSRPkZweMs+wGFNotBqqdf9zQLkwdbWtWPG7
	 NY4J0wasnCp0Sgcwl0UFg5o1Md8F33grUrrXNuCz6uX9B2mVJY/O4aMxXfuaH/qJFU
	 +/fndltFb+DEBxS3LFjb3RNLpdavIyuXyBT6XPcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Zhenhao Wan <whi4ed0g@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0014/1257] drm/nouveau: reject zero-size notifier object allocation
Date: Sat,  7 Nov 2026 08:38:30 -0500
Message-ID: <20261107134939.817452822@linuxfoundation.org>
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
index b776030460f77..e876f154963d0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -666,6 +666,10 @@ nouveau_abi16_ioctl_notifierobj_alloc(ABI16_IOCTL_ARGS)
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



