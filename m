Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C2A3EAC8B;
	Mon, 17 Aug 2026 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977024; cv=none; b=kIUqcFs0oUCVRBllMg2R75jO8bXQqgL548egnIcrfbO4d3NCwnf6Mh41roq1NfLkTxUK/efhqcLsPTjiiMyK/1z33f33D5LUNZHo6hmT0NsRkS6SU4K5gBPElk/Hjr9m5z3vtoRaEo5P3B+/ZKeepTvAtl7gAr77m0bDizadOFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977024; c=relaxed/simple;
	bh=WdpcTxHGOnqv/8WksxSJiwn4BoUmELIGhit3SB65i1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEvxoGQEpUfdrWenVmKY+0RKFrpW0gtJTCboW1JvPZgJQLWsL7kPZsdSLPwgmfIKwCK286w+2hYsIqkz0g9k2gEDY8M25BEPBA/2Un3QoS1Ml3pHB3OJcmjteioGQ5D+VtCzrqEsqvmCURBINdziBcLzI/5v4CA2pkiiVVK20Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxB2r/Go; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxB2r/Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD5E1F000E9;
	Mon, 17 Aug 2026 14:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977023;
	bh=p45tzRO9hfIQLOJ5SO+u9hNbgH0UC1UJKVpCevls6/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxB2r/GoO8+ms0ILoFFole7y7ewflTuKUSO8Ya/y9CBCvuvSlm3aw27xbtXISVofw
	 +WruC9+ib6rkphH/iTAooQ9wUZI8fHaWSuAmuk505g+LD2nFUNrNO8CHOw3BdssLkC
	 Ni9OGTpCfsrYj7hzpK5qniW5mmywyYbENBbYeD+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 146/456] drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:28:56 +0200
Message-ID: <20260817132545.792023636@linuxfoundation.org>
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
@@ -449,7 +449,7 @@ static void sdma_v5_2_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -460,7 +460,7 @@ static void sdma_v5_2_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


