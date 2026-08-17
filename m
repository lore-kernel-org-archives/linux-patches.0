Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E07441037;
	Mon, 17 Aug 2026 15:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979307; cv=none; b=Fn5B6k4FkO7jVAXDWw1YuyPtK9v6H3blKj5Sjd4ygeh8Vv/5nnFuvA2Oq9N92VFfvdf+rH0/kimB976FZcrl1SNtp+pAueuU8C+SciytHwDkphEEaU9fDlBgSwZPBtNuKIR08gWFbEtEtZjA5fHlXLMIld20gd8nd9Fy85s7UCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979307; c=relaxed/simple;
	bh=iTLkuZbPrHEl+6EkwYt3r1gAz5NCie1LQH5HnugUF/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efCXoo5L3CEPAIouDViPG5tewBJSxgJx31pb4wT9Q0yCB9mluF2vLmYTaE2rcaWavBbt2r04qNRNh3bTj53UIzU4G1nA8JW4svgrLNLVYCzcHalSjA3sMbJ2k2ga9t2TcU0LAb9Skg4S7f6d0ohcdr3XCbEI6MNAK+Ut9FzftWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCAFy1dT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCAFy1dT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED3E1F000E9;
	Mon, 17 Aug 2026 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979306;
	bh=RH7/TDfdwV6EG43FbdSdizzFtavTTPyrjClSiPiClR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCAFy1dTwVOJcbSR4YNYFdjF3mu/hAkqPKtqNbL1jeGWhacvHl0wMZMsX/61goM61
	 h5p7pb5oMUfyhNDUDG+HBxuRJayZNMMIiSxEyScaH276TNR2Vq3PuQh4nZEHVp0rsP
	 3iWkhrOZP2tHJAwuHKxUj+cG45i0lRcPcKCAyrc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 179/609] drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:27:55 +0200
Message-ID: <20260817132550.059785169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b9dd618a635d39fbb211454b6e8837b2a7f10fb0 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ae658afc7f47f6147371ec42cc6b1a793dfdb5af)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -390,7 +390,7 @@ static void sdma_v5_2_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -401,7 +401,7 @@ static void sdma_v5_2_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


