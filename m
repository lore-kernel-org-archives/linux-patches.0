Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831182;
	b=hyZC7z4UN+iqz8IzoCk4aL68zoqOSUtiWg1U1tcpwq/DWPT/Hf5G+hjN4k3637W2pph3
	 F32Zqu38mEbnN3Hsprh2MH/xJHdjRBl6m8zSv8M7qtJgLiQsySH0DkeOWpqrINbZL6dgt
	 272djxgJeHHgkeYjpNt9z/QSPswRCnUygXwyR6JCUB+ItunRFzXZ2GeJF4IMcyRkyrg44
	 z6BcXFUT4CU8XF6ulVY9oL1vLfrauGAEnGxYfG78jIskCYiDLODfg2PvK3IlEzzEABfsb
	 ckMlKnarts9Dt+uUYv3Rf87P8eODLqGIo+Mdjn5+Qg7xTjyi/C/eivcV4XBOcaBnH3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uPJcqFpePhY52Gf4/O+G6s1Uz7FP3PWjXmMYg8Y7IFs=;
	b=V1kjvnLzwWr4sqTWTHWntZNMiIwA1HJIwRQ9td+TPTqOVzV5t3BQU2tvel0u57a/1wLC
	 Mfn4rLdsZkU/WpOzWWhDaOEm2muaVUYJMhRPZXbr9JfvCYliL29mMZL0lLXiEIOiDdgx9
	 UBGdNUBUXexJN1U3+VnaJ7F8sZHTdgcCY4hYWgYQ8J8PhBjjwZaR0Ph3w9N00dZW/PlsG
	 I1nk83ZRb0KWXFChZiAsQUJJZORIbJDnkIyCMLdFDWcfL7Oezi7htUAGSCgS6tx8/SPTA
	 CnktpCEtHhIujWpKUFkCcnXhxGRjZF3dlusIA3t97YP3d0zAoWQRQ60I2LjgXt1yyoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fX9ooKDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7809A606A332;
	Wed,  4 Nov 2026 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fX9ooKDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB3E1F000C1;
	Wed,  4 Nov 2026 22:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831182;
	bh=uPJcqFpePhY52Gf4/O+G6s1Uz7FP3PWjXmMYg8Y7IFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fX9ooKDEqHXqIvcXyDpxV7q+UOWETXY6G5ru6YkVwqpkATe2JrT34efm9KFKwgcT1
	 9mpT6A+d3pw0vZdDG7djruxnfbo7DHy+qYTN6sosFAlMPFBMXh0XmWhmeWftb1TYc1
	 ljIxZzbjKwsU6e+Egqp/D2vmlReG3BkrGE04pcoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0509/1005] drm/amdgpu/gfx12: set KMD_QUEUE for kernel gfx queues
Date: Wed,  4 Nov 2026 16:04:02 -0500
Message-ID: <20261104211058.192799280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 9fe5745f9d8eca38d31d9b672a1998edf856f651 ]

Set KMD_QUEUE in the GFX MQD and kernel ring control registers so CP
preserves kernel IB VMIDs instead of replacing them with the queue VMID.
Use prop->kernel_queue to distinguish kernel and user MQDs.

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 14741c01680a803050e949744089b57fa53e02f7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index 433381f806b2b..06fde713b9229 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -2733,6 +2733,7 @@ static int gfx_v12_0_cp_gfx_resume(struct amdgpu_device *adev)
 	rb_bufsz = order_base_2(ring->ring_size / 8);
 	tmp = REG_SET_FIELD(0, CP_RB0_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_RB0_CNTL, KMD_QUEUE, 1);
 	WREG32_SOC15(GC, 0, regCP_RB0_CNTL, tmp);
 
 	/* Initialize the ring buffer's write pointers */
@@ -3025,6 +3026,7 @@ static int gfx_v12_0_gfx_mqd_init(struct amdgpu_device *adev, void *m,
 	tmp = regCP_GFX_HQD_CNTL_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BUFSZ, rb_bufsz);
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, RB_BLKSZ, rb_bufsz - 2);
+	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, KMD_QUEUE, prop->kernel_queue);
 #ifdef __BIG_ENDIAN
 	tmp = REG_SET_FIELD(tmp, CP_GFX_HQD_CNTL, BUF_SWAP, 1);
 #endif
-- 
2.53.0



