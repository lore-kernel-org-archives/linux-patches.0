Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57FC3F4DDA;
	Wed, 20 May 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299543; cv=none; b=dYYgm5mFR62cxKVmOrOy8jpnoUVg4uaRWhcBKdzsHelGJZaJ5MK7R+Kfetda8HUVnBixe9Ska/UwAiN21hbbL5ZQz5kcl3f3evN/ghaVVDV/9DvYDzgQmsfEHhR5giQQn2aIsERYPbSzNB4nDQ4339uQIY01KiZi22U3xNzvI7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299543; c=relaxed/simple;
	bh=V0sV4hVdgWdQZeAWu8NXHLRcsbrD5zogju2Kv8CkC7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CGKQSsBEhpDs6eptVXrrDLRE1xLBX8tKnzVGN2VeZ1Y5G83ra5ZQMBOPF7wmQVcQQ22dzmDPq5JzlOLP9p036WVwItT5J4PjnEcntRqoxImITbPmXqiqjcjqlIKPXGrwz4f5wSSKlm4wtuPS8m3oY4ULguBQN0ipsnPGr3568IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2NHdeeu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2NHdeeu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268C91F000E9;
	Wed, 20 May 2026 17:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299542;
	bh=ViNrVFAY6VThzSX4lTfuVekRPgpcIqRfuKaLZxNJfcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G2NHdeeuHC7HJ68j9fmJBC18zebPpnZy3aWhDOHgoPNJN5buRYlNyxLsVZKWEWn/S
	 Yk7PQO1iGbEzJlKqibuKKf8PffePN6fpPjVfSeokIHCr+tj4n/iRFxIuhSLGltCk2U
	 hK+sfkwok2yjSHTM3/bN+NI6iCng8npgG7u9ufZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 813/957] drm/amdgpu/jpeg: set no_user_fence for JPEG v5.0.1 ring
Date: Wed, 20 May 2026 18:21:36 +0200
Message-ID: <20260520162152.197749411@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 2f8e3da71a1b469b6e157aa3972f1448b3157840 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: b8f57b69942b ("drm/amdgpu: Add JPEG5_0_1 support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 742a98e2e81702df8fe1b1eccee5223220a03dc2)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index ab0bf880d3d8a..1fb2386352ccb 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -875,6 +875,7 @@ static const struct amd_ip_funcs jpeg_v5_0_1_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v5_0_1_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v5_0_1_dec_ring_get_rptr,
 	.get_wptr = jpeg_v5_0_1_dec_ring_get_wptr,
 	.set_wptr = jpeg_v5_0_1_dec_ring_set_wptr,
-- 
2.53.0



