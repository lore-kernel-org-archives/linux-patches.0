Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211801;
	b=VEO+e5bhPvDtYsaCxlQdYDuvwsPCym9rRKpT/AOzWDUPse39Qxg6CtwIaOA11qwEMoOY
	 gwHg9RR08Hf5GnwexJmeVd7yDrYsO2Bvdyx0WuHlbMypi0/j96oQkwo6Gb1OMlR+AG2tp
	 mCYVnlCM3ap9g01Vzzc2gfzV5Sc9X5Ar0mDhfN31TvDvL/ZiMpcYE5+qZEYuhvzlqUDQe
	 PCrnXZHm2yxZ+H8KuyqK5WvkBM88exmBzO5J7gSLG7FkMjgX9/d8qnlYgKOfMOsE1/YaD
	 5jiMk07dJN2RU/ubEf36cnzP4deEKzaRRCjXUkPoqfyYFXJC6SsrdwqiTAKncbwovFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=5rsIZZ5Cfo6zmYAp9sZl7rZOr4vqzt5kGuLdIP6c4ko=;
	b=XxD1+VzVXfmOMNi89GJCQ4mRob3/lSz3Vh3DsMakWreNwI10LPKa4PM9tuo1HXS1/WVo
	 MFLuizGV7U0Zpudpe4kpgGF6eXk/1o4M2VbRiFUhkEhRXNR8hRJUzWuEkks4eOcDOkS1E
	 PT857sq6vVaW9irMMcSbF3kJq4N3K/Uxg2dVygnFd4tG38jKe2qIjD96kbpNSS6YHOC5U
	 jN9uxsfVRzNqwSJdP5YwIq+7sr4eBAeBktykpyGy3y17JxgVHCqqrnkvxOZW396VyioxD
	 UouFauT3eqWx4GhYYN8EWSrLpIWOsL58S63KuKvxsIprCGV5jKtRdb4BSF4gziQcNzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5hz3CmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104FA606A31D;
	Wed, 28 Oct 2026 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5hz3CmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0271F01828;
	Wed, 28 Oct 2026 18:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211800;
	bh=5rsIZZ5Cfo6zmYAp9sZl7rZOr4vqzt5kGuLdIP6c4ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5hz3CmY+qnJsb2BAV8Cym0UW/loxNmnYfbxXuz6lDwqPTl2SbfynxMYC+hABjZvo
	 GOwD3rE+i+oDBGeV5TOeHT0mPP6L49JY6NaOXRUsgspIZgbNr1k2ppk0vmlxjlZV+/
	 3VQoOeUf6vMqwnmeFI/5vn9SFMuO7UnFWpq2we5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 5.15 503/571] drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE hang
Date: Wed, 28 Oct 2026 18:00:50 +0100
Message-ID: <20261028170019.964738002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit 752480ad62964edf0254e151110d3e53a7cb37de upstream.

SDMA can randomly hang on Polaris 10. Hard to reproduce,
but has been occurring sporadically in the Mesa CI
on the RADV Polaris 10 job even when Mesa isn't using
the SDMA engine.

When Mesa actually uses the SDMA on Polaris, the hang
becomes more frequent and the reproduction rate goes up
significantly in the CI system.

We don't know why the hangs occur, but it seems
that inserting a single NOP packet before each
POLL_REGMEM and FENCE packet works around it.
At the moment it's unclear which GPUs are affected,
so let's apply this to SDMA 3.x for now.

Note that this issue is not documented or acknowledged by AMD.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c343a27ed90823d08de125f7c447d96d056b75d9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v3_0.c
@@ -460,6 +460,9 @@ static void sdma_v3_0_ring_emit_hdp_flus
 	else
 		ref_and_mask = REG_SET_FIELD(ref_and_mask, GPU_HDP_FLUSH_DONE, SDMA1, 1);
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(1) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_FUNC(3)); /* == */
@@ -487,6 +490,10 @@ static void sdma_v3_0_ring_emit_fence(st
 				      unsigned flags)
 {
 	bool write64bit = flags & AMDGPU_FENCE_FLAG_64BIT;
+
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* write the fence */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 	amdgpu_ring_write(ring, lower_32_bits(addr));
@@ -495,7 +502,11 @@ static void sdma_v3_0_ring_emit_fence(st
 
 	/* optionally write high bits as well */
 	if (write64bit) {
+		/* Hang workaround */
+		amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 		addr += 4;
+
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE));
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
@@ -1049,6 +1060,9 @@ static void sdma_v3_0_ring_emit_pipeline
 	uint32_t seq = ring->fence_drv.sync_seq;
 	uint64_t addr = ring->fence_drv.gpu_addr;
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* wait for idle */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(0) |
@@ -1077,6 +1091,9 @@ static void sdma_v3_0_ring_emit_vm_flush
 {
 	amdgpu_gmc_emit_flush_gpu_tlb(ring, vmid, pd_addr);
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* wait for flush */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(0) |
@@ -1584,11 +1601,11 @@ static const struct amdgpu_ring_funcs sd
 	.get_wptr = sdma_v3_0_ring_get_wptr,
 	.set_wptr = sdma_v3_0_ring_set_wptr,
 	.emit_frame_size =
-		6 + /* sdma_v3_0_ring_emit_hdp_flush */
+		6 + 1 + /* sdma_v3_0_ring_emit_hdp_flush */
 		3 + /* hdp invalidate */
-		6 + /* sdma_v3_0_ring_emit_pipeline_sync */
-		VI_FLUSH_GPU_TLB_NUM_WREG * 3 + 6 + /* sdma_v3_0_ring_emit_vm_flush */
-		10 + 10 + 10, /* sdma_v3_0_ring_emit_fence x3 for user fence, vm fence */
+		6 + 1 + /* sdma_v3_0_ring_emit_pipeline_sync */
+		VI_FLUSH_GPU_TLB_NUM_WREG * 3 + 6 + 1 + /* sdma_v3_0_ring_emit_vm_flush */
+		(10 + 1) * 3, /* sdma_v3_0_ring_emit_fence x3 for user fence, vm fence */
 	.emit_ib_size = 7 + 6, /* sdma_v3_0_ring_emit_ib */
 	.emit_ib = sdma_v3_0_ring_emit_ib,
 	.emit_fence = sdma_v3_0_ring_emit_fence,


