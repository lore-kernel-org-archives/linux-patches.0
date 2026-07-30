Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69243955D7;
	Thu, 30 Jul 2026 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427594; cv=none; b=PAmof6J4U6iTyKQG76i5SYddiEi5Yu/Miyt6DseUB2mw3YllI9vkgQuKtQhaMspnDw8rPBBH9udvSklIqLxaFMNVgLP5JYdbqn7kLhHffYlMl2445+cT4zwwWevGmAB3QrkR91uwfsXBAZjtFz1WTt2eIu9fbTyhIj2o8uAFoUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427594; c=relaxed/simple;
	bh=yHLaip84c/XrAr1NG5FneXoGUByZHxHXE3RQYnF7L70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAAYhf/3n+BjoWdctg/KIFmplWVIVlJvUZAXo8ZagoGFqYP09qZVJJR9+9ez07EZUOY403a4yW1Z0d5+0xFTZsRJdjBWohFbq3owV0Lr0iSxM0Qu78lF/EHXC2+OJSLucblJxnJ2AgSdcp3ZhbSx/0u60U9ad8V/5E0ywozvLtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fItdzAPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fItdzAPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFAD1F000E9;
	Thu, 30 Jul 2026 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427593;
	bh=Z+0j518wvTn7rsARpF+e19m8VWDf3vP+EBoVo3+c3gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fItdzAPcqlm/wAp2pmQ/9ioo2/G0esZcfCXDSSbsfh54Hfe7NhuESe32BJ/qfnBmb
	 GWC1QGacUBpJ42yR3OuwxL4+jXnOIay/PiTqyFQb6gYZaapkDnFICRZrAxKqMFokoT
	 IXW3rbu9cIJHe0Q3Sk9oK5lSdt6/iKk0AOuyACeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 223/484] drm/amdgpu/sdma5.2: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:12:00 +0200
Message-ID: <20260730141428.316443902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -337,7 +337,7 @@ static void sdma_v5_2_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -348,7 +348,7 @@ static void sdma_v5_2_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


