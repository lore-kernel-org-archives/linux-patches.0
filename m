Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D924400DE1;
	Wed, 20 May 2026 18:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302797; cv=none; b=oDKuImzJCKdNu92BBGcwd53jc6z3546vvAmXsAvMR62uDKkAPz3s640RqrohD+HNmeso7rDgYiGM8Qw+9Kr2+8jk+/ExwQpq+vYRLtpTJGdMwM1HKp4ajrV/Pt/igzDP5f1nqR/UTqNt69zS62Zp8WTHMqG/pwTDUrYtzXO+AvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302797; c=relaxed/simple;
	bh=SLnFjvbAKMZxXBNnGRqwbLMnm0vQmfgz2rtbUbe4xDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYn0YSyMyn6aQMUWf4bb0QPohtSVJFCKzw8lpAfupTXkhbEtHKGAej3l9+0ttDwkEFVE7iTKNAzc2H4r7Y6c9Svd31blPZe+vjaXbOcjE8SNTZD2RqorQvSp0sesYBDdxJZLsEgCwNHeSsdpDXRemkH8GY9/Hjvu+Smk1lV55uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRLqtKQN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRLqtKQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D7D1F000E9;
	Wed, 20 May 2026 18:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302796;
	bh=YEymhbQ1T6UvoBJzq0Rm2S4qI1NXgORjdZkFQcmol7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRLqtKQNjF/KNUvsQk/3gsl0ryFbL8URRML8MFCv/MVt5uT+4uVAVLMBr3RhfQW5Q
	 JQy8Fbhd3+7zR0hqMDW0eZiTTrZeVtlBNuuriZALxZrnv2HY0Ykf64qUKBoo1Tp0Wt
	 l0caoKQMwXpIWKycTJFmkHCvIut4XCQiLZfh4AFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/508] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring
Date: Wed, 20 May 2026 18:23:47 +0200
Message-ID: <20260520162107.364880878@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 79405e774ede411c6b47ed41c651e40b92de64a2 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 14f43e8f88c5 ("drm/amdgpu: move JPEG2.5 out from VCN2.5")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3216a7f4e2642bda5fd14f57586e835ae9202587)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index aadb74de52bcf..1d2e5201bbca1 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -657,6 +657,7 @@ static const struct amd_ip_funcs jpeg_v2_6_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_5_dec_ring_set_wptr,
@@ -686,6 +687,7 @@ static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_6_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_5_dec_ring_set_wptr,
-- 
2.53.0



