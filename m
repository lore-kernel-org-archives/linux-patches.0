Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB7B340A57;
	Wed, 20 May 2026 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301513; cv=none; b=EAHimfKINBtuIfBFxPAmr+w4zhe/GJGX1+npTsnLBbEALU50IBsk1tAohKugBgRC/7U4puKFby0ZIoGtPS7fgy8HNz1unDqMTJsSrol3mGpU6YPxTbu/Syi5tfhZoExd79G+2mTIrIv8h65Nkkuq2A7LiUDvg4t8PFL4VLGifmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301513; c=relaxed/simple;
	bh=/76vE1tb8HBudI7w0U3kiQAn7UoYy/zb0kEBXJmotk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5X2N7/S5i/+UsL616dZb3k2HC0/zka3ZSzsp4Rla2vH7/+XljKcCO4BiaXoJmNvt+mcf+7+D18cNwpmMCDIZT4KkW/biO+V++gqnIR5eQe137G7RddPnXTuaZhskiQ4qgcPkEQakwagHWANPPC38/J6OO4ET02nGPyWiSU3MHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JH8x8L3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JH8x8L3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F301F1F000E9;
	Wed, 20 May 2026 18:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301512;
	bh=WyJ604DM/04ABbYIMi0XqWjdTqXJdh6LHFXTP3q3cU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JH8x8L3tbqjV/G5yYv/j64dgQV3HUcPVTBMZ3d1zeIVyt5Kx/iV70K2xn13fYC78b
	 cdVEDRJtlGoUSHq2py3JZsUOSNk28QzSYvjoz1U/AOyJzne5OTcIZgOgbq0EO2k2BQ
	 QrNgjVq88W/2cAbH4Q4WH42a5SPsems6JXxhhJ1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 566/666] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.5 ring
Date: Wed, 20 May 2026 18:22:57 +0200
Message-ID: <20260520162123.535631681@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit b65b7f3f3c18f797f81a2af7c97e2079900ad6db ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 8f98a715da8e ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_5")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f05d0a4f21fc720116d6e238f23308b199891058)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
index 48ab3e0a62d25..78a9fb26bce2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
@@ -765,6 +765,7 @@ static const struct amd_ip_funcs jpeg_v4_0_5_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_5_dec_ring_set_wptr,
-- 
2.53.0



