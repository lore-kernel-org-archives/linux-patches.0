Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025E3274650;
	Thu, 30 Jul 2026 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424394; cv=none; b=IABtLGYpBghGaiHdXA4iWlxjl2MzAnsPCDOdlmjQjUNy9qF9uEa0wvsJh4yiNAGGP95zH4zy1QLZX764fZdD0ZL5kBAbLIaekjyYhv6vfE47DCj2um0UuhtUgd13s29UA22IbOxNXYIQHf5te3cmC+SXumjwdB/ynBsS5Gtw2dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424394; c=relaxed/simple;
	bh=XyNQ669b+48vaC+K46jynJIZXOMafgoiUiXASFmE4Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubHW5gV6TKegPZlKrbprNdQHSIWHeGIGoMi4YTkcFCn8j9SHqp6P5sYIUsgjwMDp1kBLD9x9P7ERpz6n96eamKZ5+dHjFPEmRRVZRweBjEi3oQ4n18FrmR1+sbaCjBm1ffL0Lv/S0YtDZaI91f2dUATniPpMF/W94N8AE+F1nEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtyXBsjg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtyXBsjg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0A51F000E9;
	Thu, 30 Jul 2026 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424392;
	bh=cslCVssCM9hKdgf7OJqD9DaMV4J0zU63tHPslQgMQtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtyXBsjgp9BugdgSzCGTzv5jJQ0jBpO10gU3gO0Aztym08YcNCXMfKDLagNx7gaAf
	 8R5BLbgeZUyiP75sfz+Ot5NQ5CaP5z6NDDPObXnbAfL7Ri4NKvxF1yMh7OZMvIeR2a
	 Y3U039n4P8N69bER9cKVdEETr46AvM0riWfeJsOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 361/675] drm/amdgpu/sdma7.0: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:11:31 +0200
Message-ID: <20260730141452.804507753@linuxfoundation.org>
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

commit e80e28f398f5d9f6e361ffb56382d2e74fc87556 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9723a8bed3aa251a26bee4583bac9d8fb064dd44)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -364,7 +364,7 @@ static void sdma_v7_0_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -375,7 +375,7 @@ static void sdma_v7_0_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


