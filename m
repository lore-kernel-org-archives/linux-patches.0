Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590441;
	b=KQvPRVCyTM0jcGkTAfcNaooJd/OztnFyYghxkBtJBduGv6PeaLOBEkCfoiBxzcGNI4hF
	 DNL8qa849EkTgc7xt/AJPXizmVJrX7TWkjv3Gjhup06IFZL9/OBOXywxBsVXS5/OLJVyS
	 ADqOJMjGSG7wSqCqsAvr3W0VVzkF4PrPKjM7FAKIFOa2DJlhHn5pLNoiF41A7tgRmSpu0
	 lBOLRJZ4I+O8p8YoFDhF3PHdfZZnxr6fvVtdMHedm0dVfHaXXItj3RLlPUIIC8Be8RQDK
	 RMZ8CI+UDbMMEegVvyPNA6RNMeRBUxeajOQqM5QDNg3tBrXDXB+wiuBr7eR6N4wgXrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wwTx7ozqT70vwzhgJgVdUbhzBvx3WdtyiGes06RZkOs=;
	b=CtVL3b3zlrFmL1kSAwfvge7sDsuiUOa1wQJSeJgn8api9UGfp7AtXgnn8djiLEKYCUS5
	 xNmWSiLmdxgnIKEXKYILIuSZ8H8iZouSzrdPs3EWhEwNoFPdBz/7dTVcl/goro55zgOsN
	 TDFT6DDei1Ah3PtEStZRpaP3bIsBXyxCeOMTG9+rNc7f33+zOn8rMn4R+181PSUJXx9d4
	 QJWgxQNHbUc94nkQMFtDRgf/oe8v2b6pvuzKcMiBqVHEFEuQnqgY129W6n++GL75uJnS6
	 LM+Hc2YjefJm6Vm9/CCv75oDyKwDwNrHrHHvHHz5Nk7yhMcdLo6SiHc6YPg9ydDnCVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XY8UyF01;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983C060703D0;
	Fri, 13 Nov 2026 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XY8UyF01
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449B41F000C7;
	Fri, 13 Nov 2026 17:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590441;
	bh=wwTx7ozqT70vwzhgJgVdUbhzBvx3WdtyiGes06RZkOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XY8UyF01mJpoDfWujG1y+YrUd+F5XNz4DVoR15UOmZ6C+1r11zYCrmXjhHaGIs4oP
	 srvPpbjHwdCuUPz/Th2XWkDl9uQmRcQOV05LL15VnbFv460VIrwTf/qROLLV7xfnEE
	 4W56rzXmY5Wfq8HSAfD5kwlJGez6hUqYpnpXqEHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 400/686] drm/amdgpu: keep the CS user fence BO in GTT
Date: Fri, 13 Nov 2026 10:48:53 -0500
Message-ID: <20261113153834.547294522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 7a56d929dc2304edaa6231e1eb5eb82b7e8b74a9 ]

The CS ioctl hands the GPU the GART address of the user fence BO, but
since the BO keeps its own preferred and allowed domains, it no longer
makes sure the BO is in GTT. A user fence in a VRAM BO, which only needs
to be a page in size, gets its address from amdgpu_bo_gpu_offset(), which
warns about non-contiguous VRAM. On navi31, a CS with a user fence in a
4K VRAM BO, or in one created with AMDGPU_GEM_CREATE_VM_ALWAYS_VALID:

  WARNING: amdgpu_object.c:1531 at amdgpu_bo_gpu_offset+0x86/0xb0 [amdgpu], CPU#11: cs_gem_checks/18393
  RIP: 0010:amdgpu_bo_gpu_offset+0x86/0xb0 [amdgpu]
  Call Trace:
   <TASK>
   amdgpu_cs_parser_bos.isra.0+0x4eb/0x850 [amdgpu]
   amdgpu_cs_ioctl+0x97e/0x2510 [amdgpu]
   drm_ioctl_kernel+0xac/0x110 [drm]
   drm_ioctl+0x2c6/0x5b0 [drm]
   __x64_sys_ioctl+0xa0/0xf0
   do_syscall_64+0xa3/0x4d0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

and BOs which can't be in GTT at all, like GWS or OA ones of a page in
size, pass the checks as well.

Only take BOs which can't be anywhere else than in GTT as user fence,
which the CS then validates there along with its other BOs. While at it,
detect userptrs with amdgpu_ttm_tt_is_userptr(); amdgpu_ttm_tt_get_usermm()
returns NULL once the task which created the userptr is gone.

v2: only take BOs which can only be in GTT instead of special casing the
    user fence BO in the validation, use amdgpu_ttm_tt_is_userptr()
    (Christian)

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f16989def9561d04d0f2e77216f5319112d29bf1)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 87305df456239..946c6bfe1f7f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -161,7 +161,12 @@ static int amdgpu_cs_p1_user_fence(struct amdgpu_cs_parser *p,
 	if (size != PAGE_SIZE || data->offset > (size - 8))
 		return -EINVAL;
 
-	if (amdgpu_ttm_tt_get_usermm(p->uf_bo->tbo.ttm))
+	if (amdgpu_ttm_tt_is_userptr(p->uf_bo->tbo.ttm))
+		return -EINVAL;
+
+	/* The GPU writes the user fence through the GART */
+	if (p->uf_bo->preferred_domains != AMDGPU_GEM_DOMAIN_GTT &&
+	    p->uf_bo->allowed_domains != AMDGPU_GEM_DOMAIN_GTT)
 		return -EINVAL;
 
 	*offset = data->offset;
-- 
2.53.0



