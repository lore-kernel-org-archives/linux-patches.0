Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209413;
	b=VF5RgMT6QafVHO2a4vCDUsX5jGhCLPIaBhCAVst1AMETJHiai5eqd7Zs55iDJVGWUEw9
	 UG4uTOKUiaMi92BM6Dcc+Iy8f+1jutleOSYwEMJSo9JDVE3Bwz74vv7QcV8D8HNf/a8zt
	 kKdprGRyzod5ilw7MpPsHulGJKniVPmdG8OJGDf4ku/8M6tt6mQl0uEIHj2nkk9jpcYvy
	 SOBq+jr/fiIPl+wg1/Z2l51nB3JY4R1TAQgoAsDOOIgPYBUZru+Z+UgATtTOQewBhgDIy
	 JQQMJbtA+gaRM8IQpULhxA+TvYNaWSEZEcNOQqdlwatXJ2lLYIyG8jtR3xFut+HdiJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KQBRKdGB9uKHMBTLQoHp6QWTd0QwJ5JoVQ5vg2SqvXs=;
	b=RfelgMyi2CaNolYxXtdoGq9lW9N/Q64lZLYj8uq/+51VgLWLj2sTNMzQILTbEk/oamyk
	 XB4KDAgTWKwlrUUhP6nB70wQIyisffkazHZ2zDRg7lK1+4Rix6D6LXjNifosQQwPmYLId
	 +aG8ZiTfxsHH0q0Ch5PluO/YulBt3nA0rLKbOc14rbc+wbd8L0bSiJnKxYFF5Fg6trfpA
	 djre27K4mFApofgwicZ94fmg0wDX9lyE3dVoiRP2pmMKEvRj8LYjXM8UZUjsTBYjNjLla
	 c4kZQCKOn87u0BuGLjKIvKI/2TALDl3cQLHHO1fI3EfocBJpqbbIk+MdkLWWNcMPC4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8tSaDAI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8DF606A31C;
	Wed, 28 Oct 2026 17:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8tSaDAI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD481F01825;
	Wed, 28 Oct 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209412;
	bh=KQBRKdGB9uKHMBTLQoHp6QWTd0QwJ5JoVQ5vg2SqvXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8tSaDAIAhvDSNYpBQ9VZiS8luQpibeGaUm6NCKuQrRi2biCqt2q0H0TqMFKe9oaw
	 XtA+bZrDfaMpKpj+YvK8leHTjJujXC5IBNAHVSAZxSTjbtp1SInJM0K0wm4zl1KF58
	 +Nlyc0vSflrWo50uKMbHCNSYjqyDDxPpr33CQ7zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>
Subject: [PATCH 5.10 460/516] drm/amdgpu/sdma3: Work around POLL_REGMEM / FENCE hang
Date: Wed, 28 Oct 2026 18:00:12 +0100
Message-ID: <20261028170014.375814975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -458,6 +458,9 @@ static void sdma_v3_0_ring_emit_hdp_flus
 	else
 		ref_and_mask = REG_SET_FIELD(ref_and_mask, GPU_HDP_FLUSH_DONE, SDMA1, 1);
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(1) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_FUNC(3)); /* == */
@@ -483,6 +486,10 @@ static void sdma_v3_0_ring_emit_fence(st
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
@@ -491,7 +498,11 @@ static void sdma_v3_0_ring_emit_fence(st
 
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
@@ -1043,6 +1054,9 @@ static void sdma_v3_0_ring_emit_pipeline
 	uint32_t seq = ring->fence_drv.sync_seq;
 	uint64_t addr = ring->fence_drv.gpu_addr;
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* wait for idle */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(0) |
@@ -1070,6 +1084,9 @@ static void sdma_v3_0_ring_emit_vm_flush
 {
 	amdgpu_gmc_emit_flush_gpu_tlb(ring, vmid, pd_addr);
 
+	/* Hang workaround */
+	amdgpu_ring_write(ring, SDMA_PKT_NOP_HEADER_OP(SDMA_OP_NOP));
+
 	/* wait for flush */
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_POLL_REGMEM) |
 			  SDMA_PKT_POLL_REGMEM_HEADER_HDP_FLUSH(0) |
@@ -1579,11 +1596,11 @@ static const struct amdgpu_ring_funcs sd
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


