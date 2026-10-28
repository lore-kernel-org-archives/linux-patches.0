Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217037;
	b=tEWtfycoWks6MErOTcAt10mN7gkDxKPQ2XNeSgjwIPWK2Kv1H905Thzhqr0w6noAzMG8
	 VUMGCcgjpnJBLy0W6TgkMdYbMYgx7yx6YWKAy7gg8m0rXKcNeWBERTZwTy18mDOP+/9G9
	 XM1ffwtEU8A8T9Pq73rbp76V09aBiv3FnDR9VzFFL3CD/f3F2WPeqTz2Xn5Enp1RuubY9
	 pjNUbJXx8TmuuR8p2KxT1njLeXn+D10AMGCpvECHZA03mUufitT/FltTSohMm6Vp9mKbZ
	 jDFw92RknhRrQoAB7f1cPCcMY1GcoHIWRml5BbCVz7N4RCuwRIfLkLDcHFMcvyPP3gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OffEVIDy/nzOvR4qCiCbjY8ydkFwXTdjFkoxZR02vxM=;
	b=oJqdfgL79CEveNzClfP95nSREU7oI5MBdsAceW6jrALCZXFk0SbwXrMoU8CusMNMch6S
	 VLYMkya221hAtxqbYGvHhtIr0o0YgaQpG4wKgThFerMEvSDtG/AxQ9ZMWfR003/CsjyIs
	 0eSzIjFQYYeDM1zFB+nP8KqvBpc0JvFD/7wfuVDXXac4zDv2oQaeqwMXKfP2hd9YQGPc6
	 Mc9HyW4g/2wQcPcKrCnDZj1LdU0tuj0uywRz/QCdCVkKjjQVscHg20WG+LJHDKzJAeMut
	 5yy36ysamsJXm084QAAgln32zSEgB/lQS+y/5HssAAzq1N7zydNhZ1KOLMNYZg7V2Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfUIEQzn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA6C606A321;
	Wed, 28 Oct 2026 19:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfUIEQzn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75E51F01825;
	Wed, 28 Oct 2026 19:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217037;
	bh=OffEVIDy/nzOvR4qCiCbjY8ydkFwXTdjFkoxZR02vxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfUIEQznJ1sqUZinkCxTywJOTUNSSyxAC5P4ibpbvynM3jlcG8EjQ+r5BPGphpkWE
	 H9+c6dOunNOlf7WNl0NPFeAsoj8dT8ztgJD9EtxdpZIv0RI8no3of0f063aTGtZ8KW
	 RneiqlqBXSXyy7uULIQGWeQiE1CgKFcLNcDIDL14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1766/1887] drm/amdgpu: Fix VCE 3 ring align_mask
Date: Wed, 28 Oct 2026 18:04:22 +0100
Message-ID: <20261028170539.643587886@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

[ Upstream commit 2ee9836545e690c9e66ec203445d7705959fd7a8 ]

The largest frame is 20 dwords, so 0xf mask is too small.
This was always wrong, but we were lucky with the VCE_CMD_END
commands inserted after fence and vm_flush.

Fixes: 8897ea8c761b ("drm/amdgpu: Implement insert_end for VCE 3")
Cc: stable@vger.kernel.org
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David Rosca <david.rosca@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
index eff6e2f1c482e..27b2c4c7c63ee 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -959,7 +959,7 @@ static const struct amdgpu_ring_funcs vce_v3_0_ring_phys_funcs = {
 
 static const struct amdgpu_ring_funcs vce_v3_0_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCE,
-	.align_mask = 0xf,
+	.align_mask = 0x1f,
 	.nop = VCE_CMD_NO_OP,
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-- 
2.53.0



