Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FD1442FA1;
	Mon, 17 Aug 2026 14:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977195; cv=none; b=ef4ww1ysfV5++sJWoJe8Wd6kwibwJ9TgHeEUHxSaDRCGXJPY1O1iwZ6k5TCqC7snv28GTFTDBDTXeXr1dSuC83JvtXcfmMgleThzG20QsxQPt4XxJIHd/Wyg3Ttodwi3cigYnchlodmXKkn589bVOT43GEE2SHGCBTsd36T1AGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977195; c=relaxed/simple;
	bh=HvP9lUN/Znm2PIs/g5qvvmYOskYiOpwes8/8hXe0550=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bX84njL8KMe8qtOwMi8s5m6bBL8C6HFPpyJFngu0Nb3mOwA51zJwq6QhRQijkdsLF6D61R/8Lj707zhbk8dnR8OiY0+Tb6fdGQRu4VjHdb8rmEtrgoam4TmJiOAOhlcz9ghPRRs5Sx4tNpG71gwXqxcM8nqtv7k7aifn2gf7wRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEtOWcHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEtOWcHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDAC1F000E9;
	Mon, 17 Aug 2026 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977194;
	bh=YtzLkCIFp+dBWhjs56W552atZSCbzHdwdEfmXkLL7BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEtOWcHhcS6wcnuFH43fJ08P4leqikd6E+3nKm4H7P3ca20DyfRG51rkgr7BhooxY
	 haLYcvuACtR/9+mYWA8U6CRDjy+I4zdz8o2TrBPteEEUl6c/uX95U2NRPpZT3wPyV5
	 xSGEIw6W/YcgMibje5Lk41t8NcOA4DcY6YS0f03c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 228/456] drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:30:18 +0200
Message-ID: <20260817132549.050592031@linuxfoundation.org>
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
@@ -1052,7 +1052,7 @@ static void gfx_v9_0_wait_reg_mem(struct
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -5395,7 +5395,7 @@ static void gfx_v9_0_ring_emit_ib_gfx(st
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -5430,7 +5430,7 @@ static void gfx_v9_0_ring_emit_ib_comput
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -5464,9 +5464,9 @@ static void gfx_v9_0_ring_emit_fence(str
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


