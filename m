Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062838;
	b=G5j2qxP8jgYDLEqc83XGXzfHVsGRvAoeKechteSK/2cct/RuIUT+QMSxbF50+iJfm0gs
	 ZfwlWx03aYj0gOz626ZX4aGRQGWqaPxmjZwkpsu4P0hCqQNn5Mq4/9VWSDCMnS5nCsQuv
	 Ut4mifEtvM/9OcNH8ZsUiisq/fiGyqw4km3HhJr+LfLik8n3aJnlNO4xQ9heVnr+MsRno
	 qEnKxw4884yCVgJPrWWlylrYkBi47SqxHmReTjN/K8t1JfV4HXChDt9/o0u97bSp5VY3X
	 UFg/BEQV5AyEJfRKA3Jax7lLTh6Zeh4+EL8aYUB4+DJU3fOWL3kbni5EdCNALcSN+ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NbzLX93PponeIYlonZY1D28imrVDEfuD1OBugW9Rq8=;
	b=Lzxcq1qkI6Lekj9z/12znJ+udGJVxgs7NDsiOb7lbOU38wtD9BN0NQtqrFVFkIl+WGe0
	 kXNYleIO+ZUBohZj/a3az/LAX/lz7Mm5PB5HNcqAOiN8LNkRJ3axywoDxf8K7EHN63trZ
	 QmSb+LFmZPTjrUoNeHctMaNq1rBstB6q/ZJ8mOPAO28dWl3UHo/yhMYvWbrhlu1u5mwPW
	 T3iJxyw/Ypg4y4nC9WmFh/KRBdq4bT46yCToT+TSZNf5jUjHiIxZxlQXl5DmkJLaUtqmd
	 LTTM6PjRURnRdVjNlNvoAnnuyGX6lCf7rAN2Ro8UxH8MiXo3WEoQMxoBvI8jy8uS4NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDE0lmyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA2606A334;
	Sat,  7 Nov 2026 14:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDE0lmyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893C71F0089F;
	Sat,  7 Nov 2026 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062837;
	bh=+NbzLX93PponeIYlonZY1D28imrVDEfuD1OBugW9Rq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDE0lmyx2hGCHtVadj+JhPgJIAr0YF6bz66APmXuLcYUM7KZ2ina+E8pjMpdof/RB
	 I/lhooCtv+NJC6IqwYtTPIyVhKw+dMYZbaYUX67/EpA6ByTzPBRxAvwOoNN3BPLjjh
	 r/MWiIXnnECr36gm8P3nyp2JEyK8EoOvBw3vGzyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/869] media: vicodec: zero-initialize stateful decoder heap buffers
Date: Sat,  7 Nov 2026 08:46:47 -0500
Message-ID: <20261107134856.735406190@linuxfoundation.org>
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
index cdc3af33b4bbe..841dc03d0edd2 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1606,9 +1606,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
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



