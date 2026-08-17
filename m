Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1D2427FB2;
	Mon, 17 Aug 2026 14:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975897; cv=none; b=h8613vKV64KOFMpsUoGnHqb4WhNbGIeEA4pm9XKVTRVHPLGghK4O97pOcfcf9pG8m+ks6XQLmMwYid8hfzxcO/DCT+5lK55os7birG4PGROgg6BpSX5d4qt4zGJSwIGvIXhFPuw1kYL50rQBOgNY8QOHzSIPU82dqrvMoEOPd/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975897; c=relaxed/simple;
	bh=fo5lGqEJUc5LCjHCiYgu2Z5c3j9dUafQOHoQkl6jQX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7aRid8W1RxS82cAoYoaIo352MIs6fswuw7Wt/dg4fJ1gHrJTwioYTeUBTdIDVoM93WiNLoGiHjAM1g6/1FdCRAZKZoKMNALYU3zCI7LYPUpzAY+mB4FKQZx6ZgzO8gAYPCq/HhEhDc6jXZD0uGXx0ZSp0s6r2Ec1HKevJZKfCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9Szu/7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9Szu/7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2781F000E9;
	Mon, 17 Aug 2026 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975896;
	bh=wvC01/QtqW/0J+NvdHZlbg5fJysUg0vti8jWnN5vanE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9Szu/7Hz0UFdQ9wZFTO2VpkbbAAk/6ItCra/AhZTPFHUS6MjFCd+NScti511of9m
	 hFhsWFzv3b62Lb8PAIAYXQG9i3x3ji/2yNMiimpt9Qt+CeHbkI5AVpRJ/4UjPckci3
	 XJS/Eot7fg6VN8ItJekVd2E14gO+mIM2MvWOmEPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 185/389] drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:30:24 +0200
Message-ID: <20260817132546.401618423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1028,7 +1028,7 @@ static void gfx_v9_0_wait_reg_mem(struct
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -5295,7 +5295,7 @@ static void gfx_v9_0_ring_emit_ib_gfx(st
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -5330,7 +5330,7 @@ static void gfx_v9_0_ring_emit_ib_comput
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -5364,9 +5364,9 @@ static void gfx_v9_0_ring_emit_fence(str
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


