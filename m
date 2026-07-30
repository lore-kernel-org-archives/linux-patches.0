Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCB043BDCB;
	Thu, 30 Jul 2026 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422430; cv=none; b=lCnrF7mrwhUz0u5VMMkrLZpBUV+Fhn8azLE0I/WTcK6mxSHcBVLLSACxTnz6rgIzd18OyDEkdPYlvrqTvmEBud0fy2Tpsi6Oi5BbmMmqKafyElNlU7+ekgAFt9eQzHlEsplAQOltFgCMuyEQTHk4qmu1qIdSFJtmlzOFxs69+Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422430; c=relaxed/simple;
	bh=mtbTSUHSp/D60jx2g2p5ODWb92pNqXXlDQw4p3or0Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIU3tkatdNLZzw/Z3eUZXUPd+CJczR9APi8tL12coKQHxsaPxoltze6dUVZqI9CVA/90POInA1B7TtzzMu2DYquBoLHYEm1UA+ur6rz9kUNB6t7QlnWbq6oiggoXHlCjd0WXK5/llhAMXU0/Pf9eqG6SHjACwe/rgRmUFz9q75I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhN+rMdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhN+rMdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FF71F000E9;
	Thu, 30 Jul 2026 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422428;
	bh=ERDkESvZlNq63QHylvBFEb4yX6tBA5SxhK8SPT3CLNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhN+rMdTZPu8P+eHjUf4Ah4gR2q9RNQW/3j3vAI2wmDHi5cyloCgZ8h0P6tXQIku9
	 JuN1tkXAAyY0vdnp7kpveZ0+SR6Dgmn/aukh74r5ns0adgDBlafCspHJAd/2ieSKrf
	 mbD1MxfQkA/+jTTvRHmttQ6QZRSgAW4nC7S0szBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 435/744] drm/amdgpu/gfx11: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:48 +0200
Message-ID: <20260730141453.544003457@linuxfoundation.org>
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

commit 0eebcab1ea2a77f086a04108f386f82ee3496022 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit daa62107452d2451787c4248ca38fa2d1a0cbefd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -542,7 +542,7 @@ static void gfx_v11_0_wait_reg_mem(struc
 			   WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -5953,7 +5953,7 @@ static void gfx_v11_0_ring_emit_ib_gfx(s
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -5988,7 +5988,7 @@ static void gfx_v11_0_ring_emit_ib_compu
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -6021,9 +6021,9 @@ static void gfx_v11_0_ring_emit_fence(st
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
@@ -6077,9 +6077,6 @@ static void gfx_v11_0_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


