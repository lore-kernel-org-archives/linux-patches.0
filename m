Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F16D3A641D;
	Thu, 30 Jul 2026 14:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423234; cv=none; b=XCP9FDyQijy/dPAgw1DnPEYMZKeiebYLXOKjEVsY+gcIiADJxP+uA+s4KeoakIJwm6TGuQZ+YdVGlH47cEnj9HkKRF9qQk7QzHGPuvP3FovBkyVAhDwNzt5Aoh5F8cqXSzZhHTdjP5I4QJ9KLyI8LNTOSf+7uiH9HTjLuT2mBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423234; c=relaxed/simple;
	bh=2Wfcz/37+G6V9jA+C5Dn7ed4bfZpcIlWzlPnjcZqV70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZrrUdgrv+8BM87B0VQpnkQQpYJJD1EoUc2+1AEoErPvRIFKPGngrsn4Ul9q/IWdKAGU/dCZpG2ZoLdi3vDJ+hiaBn0+/x02rOFPN/0LnV6q1KTywtfqqrOlIcWGJoR+/Wb+kKd8vxn+xiNXE8lc0pkjp1zKV8odierF/PKE8Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gON5UBoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gON5UBoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C7B1F000E9;
	Thu, 30 Jul 2026 14:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423233;
	bh=5oRmULlRg2yfGQ77xhfRyIRmWDcPmhOtaCm493IUnSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gON5UBoPImaHCvKPtaNB1M/aN9dLd7au+YPTeB31jkWQ6A++sJLyzK0CQweKQeAPF
	 np645IrtxtIT+YJdITgBBsO7qA0NlMMWJHPYqVOQCHPS3tecjx7wlR62KZXvU0jk7s
	 yRRcf38MKacnV8oJ5Uerov0EzFgfxt/TKaS5QcXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 696/744] drm/amdgpu/gfx12.1: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:16:09 +0200
Message-ID: <20260730141459.062686691@linuxfoundation.org>
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

commit 6560e6bd76127844e39f09fa591c2791dc7932e8 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e4d99e04b2e9b13b97d3b17804c735f62689db23)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
@@ -248,7 +248,7 @@ static void gfx_v12_1_wait_reg_mem(struc
 			   WAIT_REG_MEM_FUNCTION(3)));  /* equal */
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -3373,7 +3373,7 @@ static void gfx_v12_1_ring_emit_ib_compu
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -3406,9 +3406,9 @@ static void gfx_v12_1_ring_emit_fence(st
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
@@ -3455,9 +3455,6 @@ static void gfx_v12_1_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_DST_SEL(5) | WR_CONFIRM));


