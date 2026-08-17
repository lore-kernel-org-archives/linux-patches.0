Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47AE43BDCD;
	Mon, 17 Aug 2026 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975891; cv=none; b=UiPEeD7UZX+A5D9usNw03fBT5O1sw+oFUrQXrOVQc8QbBTQ4vciOUvk0NT15bkSV8lSk9IKA+1BzMW79lQMVT76HC/QGaOd9gNt4qktWNw/EO5xsChAmGqhd9xOvxN2m+8KWAgscuh8qbr0zqpSYP07LcNXOeQikqEub/NnsS/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975891; c=relaxed/simple;
	bh=ZBdHRwVn/LRkpdYVZhZ/CHav1UHpveXiW01KzpTGbyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxU0GceZp5gs+uFwAZn/tjOnWrR3N3RxJEvizGJjl5p/rQiM7lmPbmK+0X9Iz8NNv69PrHKkxMzTIFaa6oVznCrFAvQzzZhkT1Lzk53zDy4Ckcztk0AXgnTyr3XseSujgEGawlpRAeQ1f34WA+bMblVxvyzB0Wx41m9Sogac/4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogif0Z0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogif0Z0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D141F000E9;
	Mon, 17 Aug 2026 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975890;
	bh=Lp5aY4Dc7jIw5z01g3CI3RcFUcxYVgexpLO5FZcun80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogif0Z0zrJgqx9sjXvNZthNilnE7I+0LT1rlZUMk1EkA2XmDofR4Tk2/sGuWxYZ7s
	 VDoFuG6SHdDu8pRA5VaUfajZvSOKWgQjd+W9/kxEZgvDT0+Kq6Xbr6nKe+72BCpUox
	 FBDLS/dWRI1cpZYOCKeaoozinhO+6sZqeDglK8gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 183/389] drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:30:22 +0200
Message-ID: <20260817132546.325177873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d06c4173a7c38c7a39e98859f839ce714c7af2c9 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ac6f00beb658239bced4aaed9efbb04a35348d48)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3437,7 +3437,7 @@ static void gfx_v10_0_wait_reg_mem(struc
 			   WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -7811,7 +7811,7 @@ static void gfx_v10_0_ring_emit_ib_gfx(s
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -7846,7 +7846,7 @@ static void gfx_v10_0_ring_emit_ib_compu
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -7879,9 +7879,9 @@ static void gfx_v10_0_ring_emit_fence(st
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
@@ -7917,9 +7917,6 @@ static void gfx_v10_0_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


