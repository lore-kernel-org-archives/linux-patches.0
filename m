Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ACC382F01;
	Thu, 30 Jul 2026 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426492; cv=none; b=l9rqU7dPud8S0GYASu2T0O/M/kMO/i2XA4ahrklD6/177y6tV3hTSKhbNMy/ed4oGyZyRWtkuQeQeYKI0ywEqJDxY0Rz3sAdabBqdGwOZRLVCKbYzKHQ1pRKX+WOR2BYJEwRwKZrsvndD23EQX+xmrOgyuljauNJBVBBUVtkUTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426492; c=relaxed/simple;
	bh=V/nY+PIJkNGBLVD9qDkMG1VoUSHo0tBZ9e6kKylEMio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIUA0App4oPIaMsl51x1avVr8cWHk7pHyX7VwgwXs0uyWeMAUkpS0PFOrQNlh5+TRlcJfYn3/9wzW2K8aHCxvhtZBMdntV8GFXgMIMHYUPNFraRuyRTsWIjcvqlo/RG2kdAPqkBLJ43zLhoextx73T1bl6stXIgk0xlrUeMYVVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8nlxGxu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8nlxGxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E40D1F000E9;
	Thu, 30 Jul 2026 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426490;
	bh=KgTqiUbFFTz8JIt8cUp/k1Y3zgP2kHA0nWiXJ1ZJU3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8nlxGxuNaUbAwpuJ1Yh7ZU2KpDxPG1VlNMtHZF6Rz87OUScaOK/tJ5OrjaOj9SaG
	 2mFSMNTpnZAL9lRP/pMaDmSeKaFIYbEOBtLrIACLsfbciLUpBn3HZltjRnB5TFUN/s
	 6sBmpj6KoUvW8tXU0EWvPd2svlUPKwvDJ+orkSdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 439/602] drm/amdgpu/gfx12: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:13:51 +0200
Message-ID: <20260730141445.189720106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -409,7 +409,7 @@ static void gfx_v12_0_wait_reg_mem(struc
 			   WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -4338,7 +4338,7 @@ static void gfx_v12_0_ring_emit_ib_gfx(s
 		control |= 0x400000;
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -4361,7 +4361,7 @@ static void gfx_v12_0_ring_emit_ib_compu
 		control |= 0x40000000;
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -4392,9 +4392,9 @@ static void gfx_v12_0_ring_emit_fence(st
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
@@ -4446,9 +4446,6 @@ static void gfx_v12_0_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


