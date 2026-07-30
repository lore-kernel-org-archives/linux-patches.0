Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95293B6366;
	Thu, 30 Jul 2026 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423329; cv=none; b=InZog8VYc1YqMSM5Vf1zLQwC1sY2vCJ13acayJd5Ft4mhAIjJ9yJ85WmS0g4eMgRq2mUcwBWyGFAwg9oPTenAs5JbX+388ALle078rCrweBUX30TUYPU5VTxk06JNOUnnZEyP2KV7bu1u4Wc0wJ35+AAP5Gvvg9oAjNZd3YfK7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423329; c=relaxed/simple;
	bh=8Kzu8szJTYtbp1bsJnSlbO3bpaXBAc34W3mvruxD0PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssozGHxkQ0n9SV6N4wuxKxvU7poKMT0aB83kFdEzlDuvCEKdZod2LjYjHEZg1iVRgRZkgh3ki69oWFzK6GGr9DCwmnpHstr+SjZa0LwmprSS+im/2JPe8/q8haSdjgREfATUAjoei67BjaRWZE8Su0OG23L8t/OxNWfuso5tssY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHIebwmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHIebwmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076341F000E9;
	Thu, 30 Jul 2026 14:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423327;
	bh=NEIl7xBmMDETd5LV4GR4iS2Go4kn2lq8Z6zHH8p4gWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHIebwmFZn2IWmFsBZ0qOI1IOztRaLwRzqagtYINC6ESTv9jYArgVn5fb+csiWJbO
	 WziXn10V3Qm1qy6FGjNh1Klhlt3dErcthBN4K4Hv6TmC9d02NtHfXLUvhpe0i7bKNF
	 6sh+Nqt4/wdOPO1GIRojlO3t+dGtrnHGl3fILyno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 702/744] drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:16:15 +0200
Message-ID: <20260730141459.195370754@linuxfoundation.org>
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
@@ -1183,7 +1183,7 @@ static void gfx_v9_0_wait_reg_mem(struct
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -5466,7 +5466,7 @@ static void gfx_v9_0_ring_emit_ib_gfx(st
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -5562,7 +5562,7 @@ static void gfx_v9_0_ring_emit_ib_comput
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -5603,9 +5603,9 @@ static void gfx_v9_0_ring_emit_fence(str
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


