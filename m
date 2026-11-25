Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620537;
	b=FEOHedrY+f94Gv0nWeqKX1yOLqKkSVhYIux3keef8BRM5CpMcmGGnDRFk7uo5vhWdi+8
	 xoCR1heQepkPagQGNJwdduw1pFSkANBw3pNid/DNRffOLO6rPMG70ZWvB37tJG/l8ZBNy
	 V5X5Y1Kp3k8J18vX2HGDKo8zJqR/Gdh7alR2tZ1jJ1gmHJuqM1Xld0PlhvMXjl9uUmuCC
	 iguzgIJLaj7y/cBbdXtDQgSdotAJUrBqSPgLQEmxMDoQGHDwoTWTdyvSik1f5FZ8O03vH
	 du4x4WpxAJlD8DfgEYQCyNkrtCWD89M90sO9X3nEPPEwxoE0EN3sWYhEXxqXSnNaqWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kypwp9M34i6GBhpXFEAur4ecOaLZeCUO9WT/c5PZHh4=;
	b=0LOMp6wfh/WcygPLaGCdVtRpYwZK/hW/KaGBDm5dHd1k/Q17d1hycOUXkBC7/HL9ZUXA
	 WLtCF/KHpNlNT2J8teD63+K9Zo7Boz/6YV2ETku/hFRyz1NgKoWyZm88gZxmJzsPdLv+j
	 smV9cbDG0tE0vUi150rXOG0LBFOdmaw4arwagcsElsKDJANLhElZVkOZIZyt4Z2ZcuEka
	 mQmOnqdAf5jgiGVHh3SuVcMYBrtfXPV6pSvMnbOKCLN+obT56L+OH0KHrHwKcuuxOXNK0
	 s169MuoRQKX5ugp0RZniQjmMylP6votv9siTUyIEmZTMjQNF7MlnEpCfjWRf8G+p/qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t9eC3/EO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757F0606A323;
	Wed, 25 Nov 2026 15:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9eC3/EO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C351F000C0;
	Wed, 25 Nov 2026 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620537;
	bh=Kypwp9M34i6GBhpXFEAur4ecOaLZeCUO9WT/c5PZHh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9eC3/EOKBdnlf4lbumzjoxRHAGf4fYX8KazkenyypkDulz2TWiMjCOe/1J2naMA9
	 EhOaFwe6NXewjRzx9p9/LhAmo0/ti54uH4+baCBVI20Oh7Lr8hUR3F3mJqIqoTNsS2
	 bEaDf3VWV+DSUcr+SC9FAfRXwlCrPKAntR23Iw8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.3 0951/1005] drm/amdkfd: skip GPUs without a VM when checkpointing the BO mappings
Date: Wed, 25 Nov 2026 15:38:09 +0100
Message-ID: <20261125143843.951536885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit 1a5ca15b558bf0e6621602c84e0a633d237dd052 upstream.

criu_checkpoint_bos() asks every device of the process whether a BO is
mapped there, passing its drm_priv, which is NULL for the devices the
process never acquired a VM on. On navi48 with its iGPU, checkpointing a
process which acquired the VM of the dGPU only:

  Oops: general protection fault, probably for non-canonical address 0xdffffc000000002f: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
  RIP: 0010:amdgpu_amdkfd_bo_mapped_to_dev+0x35/0x160 [amdgpu]
   kfd_ioctl_criu+0x30d1/0x4aa0 [amdgpu]
   kfd_ioctl+0x767/0xb10 [amdgpu]

Nothing can be mapped on such a device, skip it.

Fixes: f9e292cbba21 ("drm/amdkfd: kfd_bo_mapped_dev support partition")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 794381c358d344d8fcf8b9e6426aa2bac0a7d1f7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -2175,7 +2175,9 @@ static int criu_checkpoint_bos(struct kf
 				bo_bucket->offset = amdgpu_bo_mmap_offset(dumper_bo);
 
 			for (i = 0; i < p->n_pdds; i++) {
-				if (amdgpu_amdkfd_bo_mapped_to_dev(p->pdds[i]->drm_priv, kgd_mem))
+				/* nothing is mapped on a GPU without a VM */
+				if (p->pdds[i]->drm_priv &&
+				    amdgpu_amdkfd_bo_mapped_to_dev(p->pdds[i]->drm_priv, kgd_mem))
 					bo_priv->mapped_gpuids[dev_idx++] = p->pdds[i]->user_gpu_id;
 			}
 


