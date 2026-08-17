Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEA93FA5CC;
	Mon, 17 Aug 2026 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979706; cv=none; b=G0GlM0YstsLsD5MpVarEXNUl69BxnARCdTmmtsmZRQ9TKmtWRDf3TygG49tu2e7F/dRCpFQI6sCjoTsmsbChbwkkSeTrOu0IZixe2CLr8MU8Ovy2Lp2zazDlb/Hx46NCNdWyuZfenG7zSrPspAYRfhdmCPtPYm3EoWfn4QcqqRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979706; c=relaxed/simple;
	bh=s1qDy6UfP1cnvNu6asPvi39KGRV2/TCkWqKyDFM71PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2VVeLvqfcbHcVxg23CaxqQyo4ZYKyVjFmLIV+iLSn/oZDgHFf8h4vOi76VIbtnhNw4Nw9eUizs8kz6wU+mcy9zF5KbNyFPOOxleyps4wpEGKuX217gyP8zd6tYHXQLCgY/GNrI4AK/Xqv6x8sCG96PbgVkCZXG5s9InPaHiDFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1MruUn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1MruUn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FF21F000E9;
	Mon, 17 Aug 2026 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979705;
	bh=4kvnwIPqSq2OX2hJHbCmNtEBonu/erxw+qWVVUXgCSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1MruUn8ivP4Ah+OGpWQ2LC5SE/i8vuoiMKvwP6GrGkV4Mr5eclm8O729W1K3tTP9
	 Qy7zXPz5QxKARGeGNfbL23loLxN968weIkESUyTnS+YFp4UuURqJokPzUc/EtWXJxK
	 tONUO502VH4bylF+iHgHJ5dN2ZL8v9FrBicUAYIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 281/609] drm/amdgpu/gfx8: drop unecessary BUG_ON()
Date: Mon, 17 Aug 2026 15:29:37 +0200
Message-ID: <20260817132553.564126173@linuxfoundation.org>
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
@@ -6291,9 +6291,6 @@ static void gfx_v8_0_ring_emit_fence_com
 static void gfx_v8_0_ring_emit_fence_kiq(struct amdgpu_ring *ring, u64 addr,
 					 u64 seq, unsigned int flags)
 {
-	/* we only allocate 32bit for each seq wb address */
-	BUG_ON(flags & AMDGPU_FENCE_FLAG_64BIT);
-
 	/* write fence seq to the "addr" */
 	amdgpu_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
 	amdgpu_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |


