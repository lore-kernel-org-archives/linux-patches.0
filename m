Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB364119F8;
	Thu, 30 Jul 2026 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423214; cv=none; b=cpc6H11asNoh2EKGFnDhWmOcTyf2mLLbxtA3Kz15Epm6whh2/6kGmD+LEPUllOVjsdk89KQ3IBGXDBMADxNWKQVwn5D7f8wPW0ubh4UYrKMANQaAOVH+nwBVyV3GU+kQeCDsBSniCCM+hI2ndnap95petzwd2H3My+fPj0t8MUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423214; c=relaxed/simple;
	bh=mwiWtDkGEbYRzZEnergu9hmk37wC5zxSMF6hhDdOgAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meWnSJnETiuJrr70uDt/l6FaAKFssq+eAepcvH7JOx2EG84qx52hpXcfsVSuitqeke4CveosCiZPOqkjKCoo2u5mzktIHNdBLI+Y0bW+5GJzqXTzwyySkVniGRMI4g5mzAqnkOeYYBTwR4ODFRrcb3//3L44GfPjlGIKEUJnZns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA8lVXyv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA8lVXyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023021F000E9;
	Thu, 30 Jul 2026 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423213;
	bh=wW3/frX7pYnzYgsi2gyycCo0poP/40MZJFqO0f1ZeZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA8lVXyv+0oZkHAEZIZHBHd1DLR9ujW8/gQy2+YFCnAxvaw8FmRP/vOn7pQ8h/hBS
	 55jVk0bNQz0FhZWcMtTAKC78YsqXey7SV5xlhZqtxyztikU6cU5HNYIzE6EWgOhv8O
	 U4TPMnkMpH+GaxoR5lKnja44KaSQ7B9JbKUg5NaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 707/744] drm/amdgpu/sdma7.1: replace BUG_ON() with WARN_ON()
Date: Thu, 30 Jul 2026 16:16:20 +0200
Message-ID: <20260730141459.304506705@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 767648c18d7872bbf54481ba846e055f7e1c0213 upstream.

There's no need to crash the kernel for these cases.

Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c4f230b51cf2d3e7e8b1c800331f3dbed2a9e3f5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_1.c
@@ -331,7 +331,7 @@ static void sdma_v7_1_ring_emit_fence(st
 	amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 			  SDMA_PKT_FENCE_HEADER_MTYPE(0x3)); /* Ucached(UC) */
 	/* zero in first two bits */
-	BUG_ON(addr & 0x3);
+	WARN_ON(addr & 0x3);
 	amdgpu_ring_write(ring, lower_32_bits(addr));
 	amdgpu_ring_write(ring, upper_32_bits(addr));
 	amdgpu_ring_write(ring, lower_32_bits(seq));
@@ -342,7 +342,7 @@ static void sdma_v7_1_ring_emit_fence(st
 		amdgpu_ring_write(ring, SDMA_PKT_COPY_LINEAR_HEADER_OP(SDMA_OP_FENCE) |
 				  SDMA_PKT_FENCE_HEADER_MTYPE(0x3));
 		/* zero in first two bits */
-		BUG_ON(addr & 0x3);
+		WARN_ON(addr & 0x3);
 		amdgpu_ring_write(ring, lower_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(addr));
 		amdgpu_ring_write(ring, upper_32_bits(seq));


