Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40C943CE52;
	Mon, 17 Aug 2026 14:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977278; cv=none; b=etkjK0BXI+9cEoKMN24N8FT6KEExMix9evwF+tYpbV8R4tL6EEBRzJ7uHb/rRQaJxMDA0ARaXbE1X77iAHITYJ+POmllbgQq9Vyh7flyJoLv9AMQ9qUJ4Fnk7CCDSh4tctJr1yUD9ffjC5DWleHf5iA9bSw1GXkwJoz42EhhV5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977278; c=relaxed/simple;
	bh=rY8vKtVxDEcYju60Aha/85eKtBnYVzq/SrHmN72DSY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elw/JZa3XQPw3d8REKgV+Pb7SQDWR3hu1pZoWmNjbP+1vzVCK5a6wUQI5dU2auCEG1+vXjmR+FrzPwEAoiNZxgqE5r+wdlsv4pHqLr3SD8pmHoVL6XtZtyz00Qy+8xOEMH5oyNpNCDKYYrYgpw+26UsLWm74ya2BgeDlMMo4Gzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxgUoM44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxgUoM44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B701F000E9;
	Mon, 17 Aug 2026 14:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977277;
	bh=D5uFs8f5QctM4suQ4XcsC9wFDF/b++20sx+VqWynYrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxgUoM44guEZ3fJ1tONsuNnIxeL8hbT2CB1aiyVyXXVKjS1DY0Ns9hgku9smUnkm5
	 yUx6BNZGOGtRy7q8aFruuOWfnb2FsqXoHVBwYWz7EtpfzqdWfQ3Mi4Rv9f/0ZJ0Fzz
	 IsCf6eg651kG/WSVJ2R34SIrU2cGEfaRL1T9M7Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 226/456] drm/amdgpu/gfx10: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:30:16 +0200
Message-ID: <20260817132548.983508865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3854,7 +3854,7 @@ static void gfx_v10_0_wait_reg_mem(struc
 			   WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -8629,7 +8629,7 @@ static void gfx_v10_0_ring_emit_ib_gfx(s
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -8664,7 +8664,7 @@ static void gfx_v10_0_ring_emit_ib_compu
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -8697,9 +8697,9 @@ static void gfx_v10_0_ring_emit_fence(st
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
@@ -8735,9 +8735,6 @@ static void gfx_v10_0_ring_emit_fence_ki
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


