Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061978;
	b=iIzCs9YkJO4Gw3R5GYy2VJLziJLKtV0VemP5PkZqiBcZrxo0ZdaQF4TRxmQYNOLHzHzl
	 aWgTmDUvg+harAtJZk1KgHAN6Hu+jDJM/5Gt6Nb3GstRW9tDK8nxcwWcuhF2MqPOm66mi
	 Z+EwrBhQNt0RcNAo3IZSlujYVRVHyDrvdh543JSkkjs8kwDQAdIO5NTAqDWpLVtI4Yh5z
	 xeSe7R4FcFUBAcCL306I7W+H0p8txtIxI1oXflNFhyu4a5Fic4DH29eWKGzfUDTv2hHCU
	 5iedjUaruwySB6N1eIo3PImMByy5BQ9aK2W1AUCAVpcQ3ibccF7S9m02ZQM99WP0wEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m/ZNUhEDiVfxF/JODznYlhHVXzdBS1caeso/BIAobQ0=;
	b=0vsFKsrrM18Qxqu3qsd0zdKoBWe2jIZXF1ddCmKmj3LSZbEhUKc8UmBu4RwzQsc4VDyo
	 IiBEnbC0vBVGCU18YES+7DogP1aHHcliLwVvHX2bkSsxLZSfp9268aD0GprXE4FzL50sO
	 s4mi8XzgWlTxEfuNpl6kIhxHqelX9YDbkEWjRBO1X+ibnksuIRCD3GE0gNjEHu6f45Kbf
	 rgkFSwnx85IhF9NTecs7O1OtllPmF9JZNK+mx9ZpGzo4sgu05tznsNR/Mbr+jiG95hw4Q
	 tEHOuPCCu8sR6MMsyLMXqRUsomLefs8Njt1SYgFvzmqdxDnsd0b536qRNNelnajLtVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yxzwjY2X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707FE606A332;
	Sat,  7 Nov 2026 14:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yxzwjY2X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57FB1F008A2;
	Sat,  7 Nov 2026 14:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061978;
	bh=m/ZNUhEDiVfxF/JODznYlhHVXzdBS1caeso/BIAobQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yxzwjY2XpvaRXZRoW75u1QeSqcg06fDbujbSxqNkrN3tK4r5PY4Z2veojv9TLwj6y
	 Ys62YKSD+cYJF3rZuURgJABP3O3QXqPzRdtSvWdTzdDNUNVHHhOO63don03JFm+GBT
	 eNy1XXJ92yvCIUgTKJ/pK4GJM+JRe4kr3ShXu0rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0972/1536] media: vicodec: zero-initialize stateful decoder heap buffers
Date: Sat,  7 Nov 2026 08:49:48 -0500
Message-ID: <20261107135024.946385993@linuxfoundation.org>
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
index e7cea1816bb11..29e9f8db664a4 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1604,9 +1604,9 @@ static int vicodec_start_streaming(struct vb2_queue *q,
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



