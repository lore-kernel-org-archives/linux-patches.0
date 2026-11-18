Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054393;
	b=fZC/G0toQoTmz5Kelw/dI7A/cOEhhFdYRW6gudNPJNJkyA6o2htrPPFTBZBOLiV5FGD0
	 PKvR7ELIIPXErrq+KpcUs2bmbR0HEDE3XbK5dWcrfo3d5YI0pbtEQPngVSt0tc3LzRJfy
	 kJHUtiKXZQj+h8FUrLqINTyNUCClcZBDlhEOymW7n9cggqVr3rrw9IUH6xDzc4B0tymIo
	 z4kZ9GoTM2z7QeNrYmV8QCGl+dDL9+49naQX67SBBPoUwIm5X/HGcnd2GDaFrTcgh1//S
	 HV6CCvRZeinHYiviyeZ3eMqMkqIUV/+BJo1cBNFdiBntfJInsYBVNEmGC+R+k3Psm2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MIivP/PYYBJI7vDVw70rQYRkh5CLR5Eev3EK49Ux0js=;
	b=R7428HfC9J3Ck+oAnpVgSTqCZWBqk1TFdsWZlSoa7NH6wHPavlqiAYeKPLIZN5kbMhy4
	 acDTrZzo8/5dMZUc7eCbSIcytktl3NrZKw58z716va0KJMBOwxeQCi6Hxcj5/Kx5YrRC2
	 LTGSHCBXUY7jPMUq7uK8oi2GrjloARVEm596eALDBFSuVgw7QFw+vbW7GB8FEiswdq74n
	 v2h1MjJIkm+vmGN4Q3KIZiSXJMRBF7WSXCCM1OovTz4Dj130r6FNNB3WvGJVsxHS91fRT
	 iv7EDa+jKi7oY6xXlEi/EpEKU43jk3CHcOWxynYPVQ8Gn1CRQ3ZevkEgdLC/2vJ4DIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2zXS1sB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C8F606A31C;
	Thu, 19 Nov 2026 02:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2zXS1sB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787671F000C4;
	Thu, 19 Nov 2026 02:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054393;
	bh=MIivP/PYYBJI7vDVw70rQYRkh5CLR5Eev3EK49Ux0js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2zXS1sB64JrcvYfd+Lu1TttIH4tGz0CvXrrycnsa2kf+MeLfP61A0DC2r/BlaRcj
	 i4Qb39XywIJyexaGT+ujvDG74epXi2fIVnHRlVM8J1Wm9eaUm0oyy+wQFp51Gs8EBX
	 YmdY0/ncOIzQ8lF8bdS+u+ILvUZF3j1A+CoSG4vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1259/2214] drm/amdgpu: keep the CS user fence BO in GTT
Date: Wed, 18 Nov 2026 15:48:55 +0100
Message-ID: <20261118150102.018388662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted p->uf_bo accesses to the local bo variable in amdgpu_cs_user_fence_chunk() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index b28e98ab94ece..b461e31b91c25 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -62,7 +62,12 @@ static int amdgpu_cs_user_fence_chunk(struct amdgpu_cs_parser *p,
 	if (size != PAGE_SIZE || data->offset > (size - 8))
 		return -EINVAL;
 
-	if (amdgpu_ttm_tt_get_usermm(bo->tbo.ttm))
+	if (amdgpu_ttm_tt_is_userptr(bo->tbo.ttm))
+		return -EINVAL;
+
+	/* The GPU writes the user fence through the GART */
+	if (bo->preferred_domains != AMDGPU_GEM_DOMAIN_GTT &&
+	    bo->allowed_domains != AMDGPU_GEM_DOMAIN_GTT)
 		return -EINVAL;
 
 	*offset = data->offset;
-- 
2.53.0



