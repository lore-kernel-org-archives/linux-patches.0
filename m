Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575A843E081;
	Thu, 30 Jul 2026 15:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424456; cv=none; b=oR/S6d4Mos8jNfie4Xoj8z3q1M4dEAZKToTAzcBMBFh82w2gc9bzf5mvJIJUuKHzpqwhPZc33W4MzrpHPoK8o7PQg4PdK6Lw9oBwhWL1wI01+ZYXCUlKrBZRqaJyJJOPJsv1rFPV2ordjuH2KWnz3GzXQSqoep/KItiDa3Eihn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424456; c=relaxed/simple;
	bh=hAeouxnXLmIcIOalJ40sQZSYYRbQpcJO5DdjP0mv2xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq3fvF85scCDXaf8UIuIRWWsbiS8RlDa/KFFT274w73jZ7L0kOgGhLUPo2jhRaTQRo5S79QuCx5dRReFZusJWVv+W3U91kHfWj4/nB5RAZXxqvEmZC3KfXq3XX5vvAzDhrzgFwuIi6sZ1ZumT6B9cbKnwEVPvJYjRtswjGZ+NKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0eOJzhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0eOJzhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA891F000E9;
	Thu, 30 Jul 2026 15:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424455;
	bh=ccBd1eubvUd2igZWXyMOfAtE7YCatiM7E4e4+t0e0cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R0eOJzhjVT6xrnWvE6zW8vxeYkBeZJGyuLRcKiL+U6vwfmbZvFO9yNmDpQrecH8T4
	 2dJKRJTpTLTERkikQ1fUIG2tovpX2wXAEVBHUMLwjcxSFvgorKetpLvoI3tgIYKeER
	 pt7BAhnNHqmJL23aIhTSDGn8jf5gsoUVoBk5lgb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 363/675] drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:33 +0200
Message-ID: <20260730141452.845270315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -378,7 +378,7 @@ static void sdma_v5_2_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -389,7 +389,7 @@ static void sdma_v5_2_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


