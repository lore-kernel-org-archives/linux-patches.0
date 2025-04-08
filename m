Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF712676C9;
	Tue,  8 Apr 2025 11:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111288; cv=none; b=j6Znf/sRhapjy0xVmdUn4sRJAfVPLiXTa9N2/4GJSnBChgs6mG+0EoCWrdxzhtlXEE2MmyuKbelJTPV1Xe+aKw0si7LofbI2fQwFqKIwvN0rmETnDpQ94d9ly665Y00r8uT4ONzdrAwElv9418rMwawN19ShGbB4DTt5aDTU2+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111288; c=relaxed/simple;
	bh=5xRkU0mB1oVctjrFuv983Cm/PoH3Xp/Dn6R16dpVReU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaQ6q7es/5pSOzzYxbtNH+Pt7ZZsLhNPPPMJ4YsTFWhBmzyIvJYB7lnLsuer7xdAZksQ8L2yP6MYF3tQ3wUU8T9J7atSqZlUbv2eX9zXlloBn0LOnlsK9lgPCBb/GJhy5nVS0ykLfbKSdq5bjTiJo/Vs0oCFUnLPRzRvWQpxA1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bBFViiMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBFViiMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBE6C4CEE5;
	Tue,  8 Apr 2025 11:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111287;
	bh=5xRkU0mB1oVctjrFuv983Cm/PoH3Xp/Dn6R16dpVReU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBFViiMQjKz0L1h9vnWIztHI7BFfyMMH9Kpup9ClZDSziyakcxZxveQsq54BpVlFw
	 tQL0whEHC/KgGdMyd/BR69GAMoqa76U1i30xV5ZcKAlLBoFLvOJgABQxi4XImlKbuU
	 I3l/R7TT/AOX2jMqEuk1bwBfKP4hUKgpUNZgMuLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 340/731] drm/amdgpu/mes: enable compute pipes across all MEC
Date: Tue,  8 Apr 2025 12:43:57 +0200
Message-ID: <20250408104922.184273220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit a52077b6b6f7d1553d2dc89666f111f89d7418e0 ]

Enable pipes on both MECs for MES.

Fixes: 745f46b6a99f ("drm/amdgpu: enable mes v12 self test")
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index c16ad5f790d15..6fa20980a0b15 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -145,8 +145,7 @@ int amdgpu_mes_init(struct amdgpu_device *adev)
 	adev->mes.vmid_mask_gfxhub = 0xffffff00;
 
 	for (i = 0; i < AMDGPU_MES_MAX_COMPUTE_PIPES; i++) {
-		/* use only 1st MEC pipes */
-		if (i >= adev->gfx.mec.num_pipe_per_mec)
+		if (i >= (adev->gfx.mec.num_pipe_per_mec * adev->gfx.mec.num_mec))
 			break;
 		adev->mes.compute_hqd_mask[i] = 0xc;
 	}
-- 
2.39.5



