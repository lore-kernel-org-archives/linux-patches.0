Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064F23B995E;
	Mon, 17 Aug 2026 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979698; cv=none; b=ld79JaxZMUxQG8iqudFJdmIHxAsYj9y5Q7SihRqgI9cJkY8ZAYG4dpyEgk9BqB+h6slZJPmomMoYUhnG9D1CGatYQdK6KTueBFF+6MmMHW45G2Dpmt60PTuib7I2uWshqUqCrXWnr3oPhz5p+5ntJHYanpE4c+OqsWLdegNag2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979698; c=relaxed/simple;
	bh=JW5ckiHZ6/0naZRQpNUnrwXrE+MwdfKJSTpcg2cR3cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLofRAnyto0QGz5jdR5Y7FkP30DzfkyHtXtE42GfCnmwGnEFaSyEhqwqToo4t8DZz+lGSLuSDd0WvFFxXgv3/TOOHIja00YMOvDEt/p5J3hMVgiRKUqlfb7JLhFKMwAn4cOII4tUh5lhPMHfxmcHWsVm4qfiMxka6Z0s3Ocb94Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dhwleyX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dhwleyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603BA1F000E9;
	Mon, 17 Aug 2026 15:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979696;
	bh=RhdSFTZo8lKNv+TSEHzKtbV9QuzDMRMQ+4Pj4FTR90c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dhwleyXsVkGHUcCuEP1jVsolNTQsISRGHxz3pGKT5nTV3ot586n9TKavagJE3oIS
	 oj4FGtvnLGuhyk0fH3Fqb3F7+skk0bmMMlpf8Y4zmtWw9BrhhZXhgQbltobgjiDZvB
	 yilC66q0BLYB1r0JSqN1I2avLx0CKlGhRSnQN2Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 279/609] drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:29:35 +0200
Message-ID: <20260817132553.494900016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3769,7 +3769,7 @@ static void gfx_v10_0_wait_reg_mem(struc
 			   WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -8513,7 +8513,7 @@ static void gfx_v10_0_ring_emit_ib_gfx(s
 		control |= 0x400000;
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -8552,7 +8552,7 @@ static void gfx_v10_0_ring_emit_ib_compu
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -8585,9 +8585,9 @@ static void gfx_v10_0_ring_emit_fence(st
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
@@ -8639,9 +8639,6 @@ static void gfx_v10_0_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


