Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BCF4446F0;
	Thu, 30 Jul 2026 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424947; cv=none; b=LzE/6GDB+QGVrkpl9b9IM1+aJGRyAnzVjWY4onEtDZBgFhWvVrzM67DIZvzqRlZKc4ywd4uA57SpnxYnyW9TbPJIuYbo0+Qo3Ti3feJ1gnpl49OYlbl6onAlSmW//u1KcpEsDoBJ+TonoDGnJze5cQ3YWlRJrko7mPGV3ma0B4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424947; c=relaxed/simple;
	bh=Sym14bir7ojmQuZCygidZR5J4HWQvEgVe/wxu3nmDzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq0dRePMdlcgnN4+fvtsz3WIqI242ecwJPcLWjTA2YKRBtNqqsfYV/Rg8niHCUv9wCuCzSfk5VqZNL3mleyOJH4333yrDVlgwIK7ER4Hir2fHeAdmPB6stcpznrvMsZvHIyD1UpYyQKx9E4Fj+ixX9Iygl77jAj2TARvOfh6cyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1ycvzcJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1ycvzcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489DD1F000E9;
	Thu, 30 Jul 2026 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424945;
	bh=zux0XBCow9qUI0rWfiowb1KIsJgqaLucmIsUTmJ/JaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1ycvzcJf9fHlKNz2g5fBa8gPSFgbKpNOcQghWmSdpPysW51AoxdgvbntcO6jETYZ
	 ZNOuazsBaCQ/Rp3NCwfkoQ6rk/M4j6xqTSJs3O0L7xOSgVka93PSgpYMdzSlUM1qCB
	 E1+sRx5IwLQH5kfe0tvCjGf/TmS7RflwQ/GpHoeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 572/675] drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:15:02 +0200
Message-ID: <20260730141457.287008309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4022,7 +4022,7 @@ static void gfx_v10_0_wait_reg_mem(struc
 			   WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -8674,7 +8674,7 @@ static void gfx_v10_0_ring_emit_ib_gfx(s
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -8709,7 +8709,7 @@ static void gfx_v10_0_ring_emit_ib_compu
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -8742,9 +8742,9 @@ static void gfx_v10_0_ring_emit_fence(st
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
@@ -8792,9 +8792,6 @@ static void gfx_v10_0_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


