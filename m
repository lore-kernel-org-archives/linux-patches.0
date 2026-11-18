Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058164;
	b=a8WlqSJPIgndih8irIWmGP0crMpOXb0F7UoHHUGIxGba7GAKDo5PWOb94LAlEhJP1D5H
	 x3x0lXAa3GvRigbtcg9D9S3PRCGlnqVtP4F/2aGPTnV+VAN+Q1DeAn59D7DlkiojJE720
	 J/IyBM2Sv/GgnufArb3P7W869cBP+teL3DVFvXYJvsHUXv1z2/q7XnI5ig/RAIIm8qGRs
	 Qgsqqs4w0qB7uEvg5eT2d//rM1ciYEggpwuXEE+MUr7jN/PdQU0fsS69Ng3bfVy117GN+
	 /0K4g6zPXO3saaDCRTAtyxIcYytFTtGjVZZ9xtta6D8YcHTGjB79AjaBoFSN+Q+DDPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HedZvEDUifgVrMgFpMISUrF8/XVShRRQpCFEsPhV6NE=;
	b=z697reMd+ffXre6nHjS4Wp8soggNxD8ZOPAe6lo0WVZh7MeJ3wPv1INiWH66C/zvSOjA
	 VQfUzBOvz6JIM6nQcNpKUw24Rz0iIyC3JFBmYTnxQ7Ax7ObA2rOy1aYHQZgTTqkrf03zn
	 KfdwD86qUCwgeeedxllpklRhX6ocz5avz/HWmmOVMxL6d/8FF9RTQghkBHCdHDj8r/1MU
	 8MhJamuGnpCxeXNHaDfNR7d0ih3CdBH5QETDuHi6pyoi+yveMk6jLEIDl8ld6vgXWnIMq
	 9yRC/CMJLJzYIT7jZ7NYICLR0TPCjXPI/oqrdOjziw25ayYvR//QTJLIT+GpPC89QFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7WUGZAd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C70606A320;
	Thu, 19 Nov 2026 03:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y7WUGZAd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411141F000C4;
	Thu, 19 Nov 2026 03:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058163;
	bh=HedZvEDUifgVrMgFpMISUrF8/XVShRRQpCFEsPhV6NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y7WUGZAd9oj24D/6N+XYo/IYNZzG8oP047n7Ug+Uog2eyimSwD5LhhhjSrjSLzKux
	 Yq0+MV70Nclmo+mwMFPFkxtG+S7IHrnj6QXVo/rw+uFQmGgAy7zwiLhHtf01JSZOIo
	 n9loqp7AukxZ4mAx6x+ytosyrs1+zBKo61UQVlpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0387/1848] media: vicodec: zero-initialize stateful decoder heap buffers
Date: Wed, 18 Nov 2026 15:40:25 +0100
Message-ID: <20261118145929.863907070@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 27953c044974baf7e24dee3e9342fe0103dea80c ]

The stateful decoder leaks uninitialized kernel heap memory to userspace.
A process that can open the decoder video node gets it back in the CAPTURE
buffers it dequeues.

The reference frame and the compressed frame buffer are allocated with
kvmalloc() in vicodec_start_streaming(), and the decoder can read them
before they have been written. The first frame is allowed to be a P-frame,
in which case it is decoded against a reference frame that was never
produced, and the padding rows below the visible area are never written
for any frame.

Use kvzalloc() for both allocations.

Fixes: 256bf813ba39 ("media: vicodec: add the virtual codec driver")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index 8a24ee814ff32..6052a46280fe3 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1608,9 +1608,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	}
 	state->ref_stride = q_data->coded_width * info->luma_alpha_step;
 
-	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvzalloc(total_planes_size, GFP_KERNEL);
 	state->ref_frame.luma = state->ref_frame.buf;
-	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
+	new_comp_frame = kvzalloc(ctx->comp_max_size, GFP_KERNEL);
 
 	if (!state->ref_frame.luma || !new_comp_frame) {
 		kvfree(state->ref_frame.luma);
-- 
2.53.0



