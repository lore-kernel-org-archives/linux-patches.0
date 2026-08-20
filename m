Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6D36212F;
	Thu, 20 Aug 2026 15:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239392; cv=none; b=URiZxWP68xfdJxMU4q4imZJA/agT5OAdmRld5BRaB9pVCQYWzvQjOzPaupfajkWakNo0zcJWMFitY52V1ZzZCRe8kJkhK4ybb3PYOgmwB0L2bplIQDyewwZHyyZPliIRjlctYokLD1AIKlen1x7KmVK8GcKihMKmdVxlo600Cps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239392; c=relaxed/simple;
	bh=G0oTQGx/qgHUiFiIgwU/AvonuibXoj3EWrjid2j3rnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pgb5Lnq2eMxKiWwvkMm8qigMwJGoffoyjHJRy7c/Oq5tayWSWVi3xk+jzoSXLLSETRMxat6xOXr+hvaxAYDEu/J/JKD01Zag7e3prCLMBFy+YoLxt3oQK0qJz/rr5LNVgjwG4s//KZ7i1f5oCGwtz8yRcqy2CeJqrE4iLUjOUIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cvg7HEbs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cvg7HEbs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DFF1F00A3A;
	Thu, 20 Aug 2026 15:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239391;
	bh=PqKZcDF2h/WvjER4F2IL6RBEjHCqbcxBgwc8W20nTjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cvg7HEbs2qSmQnMNfrsWxkIATFE0YSOwLjfkjE3DHXP4z1+5IAxoNpQjFdr4JlVQ2
	 Ud994Mx06GppcMZB/MoeS259il7stZYPqii+wqlR0xt0tqPK1RpzCuY1OOB87OoFAc
	 dGARnwHl84fKn0QF9dPcfHuNTkF+ojZPq46uQgdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <Qiang.Yu@amd.com>,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 033/220] drm/amdgpu: read TRUNCATE_COORD_MODE on gfx12
Date: Thu, 20 Aug 2026 16:53:43 +0200
Message-ID: <20260820145224.495589952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Yu <Qiang.Yu@amd.com>

commit 2d69604b4d0b9c0c0ac71624b5fafb36cf249729 upstream.

TA_CNTL2.TRUNCATE_COORD_MODE selects whether texture coordinate
truncation is D3D9/GL/Vulkan conformant. gfx11 reads it and reports it to
userspace via AMDGPU_IDS_FLAGS_CONFORMANT_TRUNC_COORD, but gfx12 never
read it, so the flag was always reported as 0 and userspace fell back to
the non-conformant path.

Read it in gfx_v12_0_constants_init() like gfx11 does.

Fixes: 52cb80c12e8a ("drm/amdgpu: Add gfx v12_0 ip block support (v6)")
Signed-off-by: Qiang Yu <Qiang.Yu@amd.com>
Reviewed-by: Marek Olšák <maraeo@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4261cbc7b03f1f56e95aeaf1492b8690fa5a253e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1692,6 +1692,11 @@ static void gfx_v12_0_constants_init(str
 	gfx_v12_0_get_tcc_info(adev);
 	adev->gfx.config.pa_sc_tile_steering_override = 0;
 
+	/* Set whether texture coordinate truncation is conformant. */
+	tmp = RREG32_SOC15(GC, 0, regTA_CNTL2);
+	adev->gfx.config.ta_cntl2_truncate_coord_mode =
+		REG_GET_FIELD(tmp, TA_CNTL2, TRUNCATE_COORD_MODE);
+
 	/* XXX SH_MEM regs */
 	/* where to put LDS, scratch, GPUVM in FSA64 space */
 	mutex_lock(&adev->srbm_mutex);


