Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C2730C143;
	Thu, 30 Jul 2026 15:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426500; cv=none; b=JfF//zQu4sPqSS7u0/i/C2bXaS6/+yZV6umRs8vqk9tXkQLWDtj/cuRJkKv9buHV4Jo/Li9hkticpLYNpWieuJm+My2a0GEZIyMqvALp5dDpO4862M0hr49MN4xhuLQMFqcFBKiKHT97wi7H2AKJp0j7dU8QgFj30w1RpKrsX4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426500; c=relaxed/simple;
	bh=gLjXIGO79gOOZ9s6CxK/8mlCcwiFQ2XzNhFcVlohvwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVCU5fG37XipyljuRWFap0Ul5R4wew4Ggtx3cQCjzXjvrjD0KDeoeqbEGidC7ni1e4fUynfgPBfNFDG998fMiI7q2jmdk0IQEKVt26wmvPLdLza7Veync0Bil3A0MTMXgT7rttEQkbrMy8IvMM7+83Tfhb9/V0vZmlLGACHwvCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uliImr8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uliImr8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81801F000E9;
	Thu, 30 Jul 2026 15:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426499;
	bh=mE4rW/e495g+lEHv98sQi2VoS0kyuusvNbEVXwcpjfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uliImr8qeeibGWjmq8+m9IpKAfHQ+uGjDHJyT0Y92qnAMiYbeFgpUlS9R3baFZE+s
	 sPo/CC1d9vZhuwMTzfC9dDVJIDRA2nOYxe8Wdq8d/Pp04d6yinkOpK1ghM6b/QzfFC
	 G1I5EO4Lf0st88+X3ZwqxNgz58kP998ZNQk40rAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 441/602] drm/amdgpu/gfx9.4.3: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:13:53 +0200
Message-ID: <20260730141445.231767746@linuxfoundation.org>
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

commit 00f4050f7c367d7bdce347ca279ce467c434cf15 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5676593d08998d7a6d9e2d51d6b54b3820e3755c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -409,7 +409,7 @@ static void gfx_v9_4_3_wait_reg_mem(stru
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -2882,7 +2882,7 @@ static void gfx_v9_4_3_ring_emit_ib_comp
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -2916,9 +2916,9 @@ static void gfx_v9_4_3_ring_emit_fence(s
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
@@ -2978,9 +2978,6 @@ static void gfx_v9_4_3_ring_emit_fence_k
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


