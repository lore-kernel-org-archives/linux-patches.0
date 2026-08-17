Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690D2441037;
	Mon, 17 Aug 2026 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979709; cv=none; b=tT11gDtluzMjmHMTB2p4FjIM2bl5uLZqqPsYmCg7o+bU90d8Qwr2804dSDMjGZx0X4ZFT0raWwlEVat6cUscwe9RTbgc60fBtRDE9/1CYGWaaGSWMabcWSvdWbHkGHqHG3GfWyjFOnapoyQzjVsSTqxP2dx2x2U98V28uOYSY2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979709; c=relaxed/simple;
	bh=TjcXXnQii8uz4gGFoFvEimoO/M2z/xvNZVBToouAhV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYPgP/M/iezyAs9w06maIXoqUkO0lJwWLam+0JWLPp/1dg/gPaaSnoLEktZukLelUIr7OOZGW6HVt5UQ2xJaUtK1i6Kbs2J9TU8UxEUwJ7f/fIuSQpJDzOh5H/k7JHKMYuZ4grxcaU6D4eCp/K97EY78HpMHFWOcgLpyfNKdFs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stKUFQ1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stKUFQ1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A251F000E9;
	Mon, 17 Aug 2026 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979708;
	bh=BIiRumifYPs2t7tzhZYaJ04nU/TKGEc+9+dClLYW7mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stKUFQ1kXS9M2mUAWxfQjeTKVB7sr5zHxDwOHDkqecnZTimkVPun1UmWNyX0k2YAT
	 puaEnWUboepJd96SFTUHJcGclvICtDYheoRsnHSFwxw4SgaiMYN6u0TVTP7Gl2TE5F
	 /5c4UYoKRz/wRAoSIBwXc7ruTajgMX37eaD55Sng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 282/609] drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:29:38 +0200
Message-ID: <20260817132553.610694537@linuxfoundation.org>
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

commit 6302be10b521f5106ce01eb5a724b9e7945a5061 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b71604f8685b0eba07866f4e8dc30f93e1931054)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -978,7 +978,7 @@ static void gfx_v9_0_wait_reg_mem(struct
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -5178,7 +5178,7 @@ static void gfx_v9_0_ring_emit_ib_gfx(st
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -5213,7 +5213,7 @@ static void gfx_v9_0_ring_emit_ib_comput
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -5247,9 +5247,9 @@ static void gfx_v9_0_ring_emit_fence(str
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


