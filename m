Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CB244AB85;
	Thu, 30 Jul 2026 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427918; cv=none; b=ZoYBiriLfz55YlUeGfseCShV5e0cDZPnfOVjngobRQoNvCJaerO8uptcdUF19snXIZuk6SiQXW7oAHT0u8am3lz3I2X0S8JDT4YLq2kjUni7214/E7jwSqWY4PcTJb+Qk5oWQZUOuX6jWlPFs8LEEHyQI+4EUtUvtSjHbEM+YNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427918; c=relaxed/simple;
	bh=GX+oXAbm8L4lFnw0mRlqedRmnsimBSOzWQiWd6x7xNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlzTJaaE1wULLtvP+kSVgTE0rz3WiomFj6C+vNOr2lSUkhmwYQo9dVvVds7sLfNMxp7XzSVSF4JgZZL9VKkAhLvhaBoGWolmIHIEt2lhNQbEmh8H06dt3WcNRkyE9YwLEhoNddFf25pYbI3JjmuwNq93vMAH1sstZFhrIEfbcfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZoBMTKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZoBMTKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC871F000E9;
	Thu, 30 Jul 2026 16:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427917;
	bh=QQP+TH2Nv6BZnOIVs9r6UHKvWy6xu+Im3paWfh1/gN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZoBMTKI9ko3SjdsW0J9y5idohN0IfgwSJSWOE2VGd9HwMMH+FomVCjmJUafzT3K7
	 v6HcWRAoDP93zYFP7xtfc08Xr+ltlB0hxoNXew0X/vtORnMQMKqTpyBoOBBrtMLCFk
	 P9J4Miplb5anowAX3SMbkCwcshglXJLGh/oNgx7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 340/484] drm/amdgpu/gfx9.4.3: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:13:57 +0200
Message-ID: <20260730141430.867321062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -236,7 +236,7 @@ static void gfx_v9_4_3_wait_reg_mem(stru
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -2529,7 +2529,7 @@ static void gfx_v9_4_3_ring_emit_ib_comp
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -2563,9 +2563,9 @@ static void gfx_v9_4_3_ring_emit_fence(s
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
@@ -2625,9 +2625,6 @@ static void gfx_v9_4_3_ring_emit_fence_k
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


