Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899883E3C62;
	Wed, 20 May 2026 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296902; cv=none; b=IJcbUsJy6wDi4pBJ7wGajoyZTJmPr1XYyEM50tcrpNDpl6y040o312b2MECiXUe9hObvSchgxJ0hFCRAqvul0U7nhsoJTb1Fz7lYfW6gwa11Hrm0owAV/NJQA6nVixn1gJZkftuARDLhZ5XbLBJr7W/7M4f50H/PrxHllFTy8us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296902; c=relaxed/simple;
	bh=nY2wW3wwTXzBfONUQMVpiQrIra7aiqDr8i1FJ9UiExc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYSpwNAx5951TDh1BeqALcjDdlxUlPdzZSZpba75zju4/zD4JGPoeGen0oQ6eIYxjp3oTNSgaSWf4QfNOplxuB98cRJ6kzHgFlQYklGPGt1qh1fqMqtFdQP0ShtbopSqrGurjT8NYQ8tuaFkmY2t+77b8a+WwaiTP6qZXOZ4jW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unLn8LPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unLn8LPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F088D1F000E9;
	Wed, 20 May 2026 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296901;
	bh=rA8S4+jEqhRlXAFbywR2qWjgh69eNgPvJTlrXJbw1x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unLn8LPU/xQSOLY5BhSKIRKzgrf/E0sMxlXo8DLAlMjcX6R/ibpxUjx3WNZ+8YuNL
	 rxgQbvMiKe1HnztyDOqARidWkRQz2BYCdX6l92JzwrYIVXp+c2v3wIYneYTDilghD2
	 vRhJSax3uyfVl03joS2Zyy2jvDD829zH/v4I4Ijc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0975/1146] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.3 ring
Date: Wed, 20 May 2026 18:20:25 +0200
Message-ID: <20260520162210.296838663@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 83e37c0987ca92f9e87789b46dd311dcf5a4a6c8 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: e684e654eba9 ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_3")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2f6afc97d259d530f4f86c7743efbc573a8da927)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
index 82abe181c7309..0c746580de113 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -1219,6 +1219,7 @@ static const struct amd_ip_funcs jpeg_v4_0_3_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_3_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_3_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_3_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_3_dec_ring_set_wptr,
-- 
2.53.0



