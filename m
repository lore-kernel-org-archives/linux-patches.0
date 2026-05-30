Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBA032B11D;
	Sat, 30 May 2026 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160808; cv=none; b=ARJg4cBi6rX017xYiUoD7H/ZMtTH4zjepxD7gvdIxjK3AQsaZzGb/wRBoPXf+adrpozO1IsE1R41KUPuxkIlyeL9vVvcJidHrrTHNfu+HDdDPkI1f6oBfD10wpvsdUsDVcx67PEBR1iDof6/PLtj58UQBHtjP32uiHRCQB1RkBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160808; c=relaxed/simple;
	bh=RZVCzyU4GqrullJ/zQWeT94p7p/zA1hy4i7jGAcdcuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hw8hoatFF9wWEpgdChkNVoPBAMFEanKQh4Kpv3sBa33TmW7R8vomx8e2O1UXvqZS/61twIXHPwrdWTPlZM/fU7toO7x16bqYXlzPLOs2b2vZ6U9PVA7q+Xne8TW++78H/lRoHKn4pwp51WMoXcxgO1aM1infwFnGN41ufP4i/xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZt8jJUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZt8jJUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8146D1F00893;
	Sat, 30 May 2026 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160807;
	bh=BOdfjv4ontZHZGzdTzU0CadUrbR5WJImlQ8jt3AuY6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZt8jJUBmN+x8+Qd5abiohUB3xeVB4mow53leMBOwWtCxuhbp4FvtLOJmGvEmYQD7
	 wMGHDQMnCew8cl7UAzkdQzodaAfQt46i/CZm0PBv5sRmqDaEqUn8gJDDNFGWvsKWCl
	 lx5dXexU7ZasXmaBgT8CdHPU35b3/w2Kgr2nAhwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"John B. Moore" <jbmoore61@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 411/969] drm/amdgpu/gfx9: drop unnecessary 64-bit fence flag check in KIQ
Date: Sat, 30 May 2026 17:58:55 +0200
Message-ID: <20260530160311.630018097@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John B. Moore <jbmoore61@gmail.com>

commit 7bbfb2559bcec39d1a4e1182d931a2046112c352 upstream.

Remove the BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT) assertion from
gfx_v9_0_ring_emit_fence_kiq().  The KIQ hardware supports 64-bit
fence writes; the 32-bit writeback address constraint is an
upper-layer convention, not a hardware limitation.  The check serves
no purpose and should not be present.

Found by code inspection while investigating related BUG_ON
assertions in the GFX and compute ring emission paths.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: John B. Moore <jbmoore61@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1b1101a46a426bb4328116bb5273c326a2780389)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -5316,9 +5316,6 @@ static void gfx_v9_0_ring_emit_fence_kiq
 {
 	struct amdgpu_device *adev = ring->adev;
 
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


