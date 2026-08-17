Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773B03EAC74;
	Mon, 17 Aug 2026 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975660; cv=none; b=r23tk/IN7rkQPYayKlZ8rwDCehQahcp+/2OrjMkAsK6awiDqvdJJkekxyLVvOvdOLBrxgdGb2ZP2Fev9zQsqd8XxM5zYMlZX3vO8hFWkFrN98LU/ogVL0qwRGWXKeqOinHoh+Dm24RJ6eH2BG/8rMdQ+3Y83aC9u9oUbc+uBPGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975660; c=relaxed/simple;
	bh=RXzFT41/51OvzFmX9GYRHGGR6+hEDV65ISy1XXQ49pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It5JhF6uGIW+KtehXQD5R1qkvtHyG3eofVw4fAjVakORhE+UzB+90ZfYMgXcE2t2dZFAikKG4ksjwHdJJI4UiFDlplwgr2lX+UtcGFn8+lfnUzPskIfQN4CKU1plOuM/atywjReM09+i1pXbp278MEO6eLNtBqd1EypzRBaOhj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaZe7RDY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaZe7RDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0FC1F000E9;
	Mon, 17 Aug 2026 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975659;
	bh=/1qJYjEnnb33yQ3H2zZ0ZzkMEfV9DJui6JO+m5p/w4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oaZe7RDYyE26by4k+lqluJGYVbkC2+yYMSbC6ru58x0VABowgE5wKIX2uK43iI8g/
	 xMVLy8Ua/w7Z+VGSLn6F2OWYP6MGyZHgFTGYvb+OdF6UfqOcEai3N1TNKxmG6cnoZp
	 wMwxiEJLDOLOnmtoqbSkFIdTgs79vB3ZpSVFOlqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 103/389] drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()
Date: Mon, 17 Aug 2026 15:29:02 +0200
Message-ID: <20260817132543.166756305@linuxfoundation.org>
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
@@ -425,7 +425,7 @@ static void sdma_v5_2_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -436,7 +436,7 @@ static void sdma_v5_2_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


