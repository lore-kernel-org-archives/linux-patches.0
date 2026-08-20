Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3FF37F00B;
	Thu, 20 Aug 2026 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238086; cv=none; b=ohMqwo1TEbkATwuCHvAGQ4O2aTf1MHKN817KCQcPUU+EjaKKF4byMqME+w986pyIPhnjbA7KjH0wBy9EoLs9WLeGZllf5FT44I7z2EAYTczgpbtQgvIPtLdNUPOgWdWINfoylJ+E3+BBiPJIYO+tsFL/d08E7D2MvUGeU2/wafI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238086; c=relaxed/simple;
	bh=xvrzFPFqXIxjeJSAANdUakJy9VVrTkGQ4gRQkKmSMrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TqQyIKSuynZFbY4zdRWkoutRtTg22nruMNlxpeFO6OeypXVj/3m72QowCOAHN5949b4YycKqlLBVL063/EkILIxt99uiYpCF7Ov+kt6mq2qgFra0GUDCq2BU950B6vcmRNIglYXRZNNTy3LQFYSR3pOW9YmbYMMQwxMXvkEUxYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPBDFs9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPBDFs9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99B61F00A3A;
	Thu, 20 Aug 2026 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238085;
	bh=eCNZmfa7jYQbDnpYRMT7h0aAHglPXToWlJwADkyGly4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPBDFs9Bgy4D40Mhu/PYVD9FV86DEf6tNdxdEydDDO9fgFmdAaWTjFBSYPNsnZcMm
	 9s/ZhK2qzK5MGwlGnHvSKWUR9WM4iwcmml/T4E4c/oIFwqCnaUNzXWiy+bVo0oaXwF
	 V+B/MZUHKWNq0AYFvQAOZixH6eGErs0m7JGtzqVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiang Yu <Qiang.Yu@amd.com>,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <maraeo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 028/228] drm/amdgpu: read TRUNCATE_COORD_MODE on gfx12
Date: Thu, 20 Aug 2026 16:52:50 +0200
Message-ID: <20260820145245.310633222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1823,6 +1823,11 @@ static void gfx_v12_0_constants_init(str
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


