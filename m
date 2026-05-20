Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C9B3F9296;
	Wed, 20 May 2026 18:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301542; cv=none; b=oKJaU395Jm3kc4bD0IqY8BjgKewev97JZrYEhhNGpJ+xvzG/H5+mUDnQh5yN5gWyrZeOXdgi4vtN4r64XIeZLW72ZwRPbYROZVIFkLYUHMItAUv+2mSkh1N/QYV9CNL1tF4JemqiY+emDzgHLYKxZBw+tOxNriBQn/G+uf/YirY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301542; c=relaxed/simple;
	bh=Pkx6ZhZkoVFcVtfwMWtK2QcanRyF/ofk9PAjiUTLTpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SuTbWVEh03hVJhNFW3fxBjHrAeAHLyne8TVkgtzOUFx6mJ6ULgiNo2qJhBfLN95mfo1VBZ1cdievuNqdnEdDWaD0sAPAYjLiwnsPVX8b2K1jiKinoF6Ghv4DPrNRy7CEbmfk0sBO6sH1nAC/VzDFfDJg9nD+KXuaI7WdbtNmLyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6id5YhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6id5YhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99471F000E9;
	Wed, 20 May 2026 18:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301541;
	bh=zxM8vB49ySBk50bgUqEzlsecIDH9DARrxmOUL6i1Kfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6id5YhN4tqrewvPqTM3Bbb6NR9sfJnYpeyxbhE2SxjWcroEIW7y/ObpwaZEfz4Z4
	 fz+0axKmC3rmvZMsJYm6YKu8zWMwpUeKZRzIx+EpurihjL9lMensRUSmUPD13DFSGz
	 yCEhPuyMpW/9R3Cw3QFWWFS23mZ9NrzwpbA+CMmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 567/666] drm/amdgpu/jpeg: set no_user_fence for JPEG v5.0.0 ring
Date: Wed, 20 May 2026 18:22:58 +0200
Message-ID: <20260520162123.556653163@linuxfoundation.org>
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

[ Upstream commit ea7c61c5f895e8f9ea0ffffa180498ef9c740152 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: dfad65c65728 ("drm/amdgpu: Add JPEG5 support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0f43893d3cd478fa57836697525b338817c9c23d)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
index 61288104060de..d0f800e7938dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_0.c
@@ -644,6 +644,7 @@ static const struct amd_ip_funcs jpeg_v5_0_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v5_0_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v5_0_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v5_0_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v5_0_0_dec_ring_set_wptr,
-- 
2.53.0



