Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213EA30C143;
	Thu, 30 Jul 2026 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426503; cv=none; b=M1Lyxnmbrb7zDxtekmN2PsakifihXPSazvvyxBA3M9CoIlhAhaYQ5f3True28YapkHarnatTALCgxeMAvdaF+Z4Lj4KZmUjkHRw1qTmw/SJnSAqCAr1ijEnMmdTq7K3Lql306pwu2YTVKpYmuCZX3Vj+9N2mYzWdrDUg3ywf5CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426503; c=relaxed/simple;
	bh=fc+AfXAUbqa64a+Mc13TmAkvcl6rHU4BUSmNI1DW5Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPgNbcP8O8WQdCmCo2923JGXBXBlZuMWjBtE5tzRj27u7YTtzU0LttBkvxXL3l7bFs7/EOWO5zxU2u1gLz4Q+T7CLMT4st0tDmucaSoEs1DWn81vx4/BY/WMEjVuQfvl1wCcYSpbnLsbRDFW3NJSrEGDN/81x+PQpWc06n2bIAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QScHxkV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QScHxkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE341F000E9;
	Thu, 30 Jul 2026 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426502;
	bh=yDb8+Azsqspk6glycPPV9qnjEu3O5uLo2GOQOvXoDD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QScHxkVVBdSkW8OMh3knsSwkYG2KNhM+Xi7/BvPEtEXTDJ8mnCF3nPoRO+p1dY4P
	 4a7oiVjbV38pBdR7AFv/KjQp3kW8AjzJGGFl2+jmKjaqej7wzkwnq/bKonx/vaz3H0
	 uEFJcjx0FG67xaetNq2CtB3RIgm4Z2v8Fp+m+jms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 442/602] drm/amdgpu/gfx9: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:13:54 +0200
Message-ID: <20260730141445.252115707@linuxfoundation.org>
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
@@ -1156,7 +1156,7 @@ static void gfx_v9_0_wait_reg_mem(struct
 				 WAIT_REG_MEM_ENGINE(eng_sel)));
 
 	if (mem_space)
-		BUG_ON(addr0 & 0x3); /* Dword align */
+		WARN_ON(addr0 & 0x3); /* Dword align */
 	amdgpu_ring_write(ring, addr0);
 	amdgpu_ring_write(ring, addr1);
 	amdgpu_ring_write(ring, ref);
@@ -5415,7 +5415,7 @@ static void gfx_v9_0_ring_emit_ib_gfx(st
 	}
 
 	amdgpu_ring_write(ring, header);
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 		(2 << 0) |
@@ -5527,7 +5527,7 @@ static void gfx_v9_0_ring_emit_ib_comput
 	}
 
 	amdgpu_ring_write(ring, PACKET3(PACKET3_INDIRECT_BUFFER, 2));
-	BUG_ON(ib->gpu_addr & 0x3); /* Dword align */
+	WARN_ON(ib->gpu_addr & 0x3); /* Dword align */
 	amdgpu_ring_write(ring,
 #ifdef __BIG_ENDIAN
 				(2 << 0) |
@@ -5568,9 +5568,9 @@ static void gfx_v9_0_ring_emit_fence(str
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


