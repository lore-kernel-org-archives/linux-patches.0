Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FC236607D;
	Thu, 30 Jul 2026 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426497; cv=none; b=MmsinR8TXctcYHOSw9sP6Nu+wprPbl0DVNoBbo34NgeYBYsZDOUcNppadIXuIfBK7fcXyzB3cawhTHYtxnFxRUHiQAHAPv4r7m0AssCIMD+tcfgs1SVl4nb9f9DSDqO+BQnIW51dktcYE0yCkwYs05wspUpgzcy6UMqKqbQFHak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426497; c=relaxed/simple;
	bh=ak6NL78k886/FIRtHllL7aIncRkEJk5YmYT0jIVilHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE11Xm5toUheDHwC1cZw6kpSnppkyTTllzrHRWJ8BJG7gO38IbTdSGvpbOf1NHuXYsAindGXo9hCXlXcIL1ilG0aiPIa4Nt3PgGfin4BA/g5CWSUGVVexlRw84D2JG8HOWvhPcsqqguXBaZwp51btj0lgZ3TZO2RBTBO1lkG51A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tFFAdxUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tFFAdxUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49AC1F000E9;
	Thu, 30 Jul 2026 15:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426496;
	bh=yQq1ia0AaK2OGaEwjr5G4VrfYwOjDpAn+kTpcmTBEic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFFAdxUhQAK+rDPsgtJKOjXdGGPbxOPreNh+CH/q8lOa7gpVr6vxQe00J2RjE2ZGT
	 C9w4bxA9liTxANRJQ8jTDV7h+zljQrh2dyF2/HxVy5rw7rU/XstaBtdWPMifLLMv57
	 Z2lGU7qxxUxlN6QPu3NpTdcqv2FPml8s4K6Gu/7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 440/602] drm/amdgpu/gfx8: drop unecessary BUG_ON()
Date: Thu, 30 Jul 2026 16:13:52 +0200
Message-ID: <20260730141445.210505343@linuxfoundation.org>
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

commit 84a1a8a952ab4b8c23c5dd1f2eea4049cb4914f5 upstream.

There's no need to crash the kernel for this case.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7c25208ca612b754f3bf39e9f16e725b828891)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -6272,9 +6272,6 @@ static void gfx_v8_0_ring_emit_fence_com
 static void gfx_v8_0_ring_emit_fence_kiq(struct amdgpu_ring *ring, u64 addr,
 					 u64 seq, unsigned int flags)
 {
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


