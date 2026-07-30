Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A17175A6D;
	Thu, 30 Jul 2026 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423320; cv=none; b=N+q6oLK1QkzsyKl4JNGXeVttrClWvkt04I9xr/aF9+yKoaWnTAi47/nqEu1oKC6K8USjPQl6UhhiognDCBQK8RU06WnIUiOH5I6qrQ3BTjrvOa+2HjkYXwfR+bckwE+Zz2UBE8dIXRPtwxkSWVqmCmdQxWQYXPZtT1wai+gBACk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423320; c=relaxed/simple;
	bh=xRgXImKp7Gj9DSGlcU6lWieid03rfkVIX0gOLD5rUGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNQmKffees4pY2ARRLfp8rzkouOkwObrYUVqUDSLO34UeMeyEYDb8QpSHCci8UuI8qxTnCxx0/z3q6a9mi21wadPyBjisGa6UVRYOo4Yx9L0LZKLKljMJ5X0tyMXSTBDw0CIpHwpbbY6cCVVEI6IjMvjuVvQXcmFaLvqi/lgr24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUbz6kag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUbz6kag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726D51F000E9;
	Thu, 30 Jul 2026 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423319;
	bh=QrZR0XXNMpEctaer49XASxkJ2kgV2hYgOPbE/aJ9S70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUbz6kag5c0RMdzoDFHI9TSQjPzJuZdrMv5Hgc9fuivrN0Z/aHZZdB2bDtwGTpPox
	 aVMEaUkMtT7uadMd3Bng0NMdU/LD+gwvMgHLR4Ndyy5MteR+2Z0Z7OSw14tfa2nu4A
	 gbatZdM+RAEdALseyXbYm5wVNAVfmJvnm+JMZfYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 699/744] drm/amdgpu/gfx12: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:16:12 +0200
Message-ID: <20260730141459.129521832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit cd3b3efa1ced05528d9128755338baa62a6b562d upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f952076f76d62f783e8ba4995a7c400d39354ccf)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -440,7 +440,7 @@ static void gfx_v12_0_wait_reg_mem(struc
 			   WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -4459,7 +4459,7 @@ static void gfx_v12_0_ring_emit_ib_gfx(s
 	control |= ib->length_dw | (vmid << 24);
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -4478,7 +4478,7 @@ static void gfx_v12_0_ring_emit_ib_compu
 	u32 control = INDIRECT_BUFFER_VALID | ib->length_dw | (vmid << 24);
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -4509,9 +4509,9 @@ static void gfx_v12_0_ring_emit_fence(st
 	 * aligned if only send 32bit data low (discard data high)
 	 */
 	if (write64bit)
-		BUG_ON(addr & 0x7);
+		WARN_ON(addr & 0x7);
 	else
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -4559,9 +4559,6 @@ static void gfx_v12_0_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


