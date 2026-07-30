Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B43175A6D;
	Thu, 30 Jul 2026 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423322; cv=none; b=r+wDTVhF1u75NYKjuty5HmEKWJkNAvqrOJ9RJPEi5NjJIs3sc23627nOgZkCQBiLt7pf+6i6X1wL4JOx/5IVJOjy4izmDXyedeIR9/0hcapMoNOUHZ33ocTvfyFgLPwYDSuTtkFQpnUVSsqeJ2XE9GVf+bIFgGR1+nHOkGSu1II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423322; c=relaxed/simple;
	bh=n166mx+xkHb81A3DRMpEL/BhjvUj1Ybb706X4qAI36k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0z5KTJVWzEHSlLc1i/6G690945vAITBTifEuGuvfS0luMqlAvSVyL26/NbliYmS79CvelMxy6w4oe9hMuJdWzx0itxHkYfxU3JnJZhbQvRa42sl6tOtPPZnlxU3QxatXgTVNAUWPqcsVBJSe/OZhJOEq835llhoJ6XVBFaK0G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+Wv582H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+Wv582H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489F41F000E9;
	Thu, 30 Jul 2026 14:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423321;
	bh=Xg9x1JqnXvbZAHn0KUP/g2w4S7n4mZX5r158Wadk0Mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+Wv582HdHhI2D1kT7WRafgLyeJSlV34NFdSMO2ly0dnWP3hLnchD5SPGk4GIpAAU
	 0sZ2XY32eBEVFamTt0Pfqq4LaE1tQWoa+A1Sf4Tx70kJ9qIN31LHiUhuOBaOzHJBjf
	 EPK+5zlcUImrV3EYovZDl2f6ZlHFft/RtwJiJr3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 700/744] drm/amdgpu/gfx8: drop unecessary BUG_ON()
Date: Thu, 30 Jul 2026 16:16:13 +0200
Message-ID: <20260730141459.150684255@linuxfoundation.org>
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
@@ -6252,9 +6252,6 @@ static void gfx_v8_0_ring_emit_fence_com
 static void gfx_v8_0_ring_emit_fence_kiq(struct amdgpu_ring *ring, u64 addr,
 					 u64 seq, unsigned int flags)
 {
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


