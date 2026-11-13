Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585791;
	b=x6CaxRO3R+10LTQSX9eLhP0b37lKbsbyeP1u4bFAj7yTT1gvQJYRCWjSAO59HxNzXT1O
	 f4u45nJ5B5f9amj1/xqNZBueQr27e4vC9Y6fyuzHbg8oDmlmxeeFJGm7d6Lh/mSoo3F4R
	 q+amfUuXSnXUiKbxh4MqYAQBs+H4VgFk9do8FW8+cy5jt6zVqynHsZzsEPy5C6/WRQByW
	 dvgB1WoyTNkf/3Me0Tpk0KpE2tjEC6gR5wKHdzxv4FLhgLMfH4KfgoFXDmj/h7SH+U5Nm
	 ienAb4/Fv11tU+p3tzV/9S2Cl5qhx8QbXfeLTM/lxkKuVS4MXcuPxJUeePogk1YaFOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=S54paOWi74enEzfwp6yVEaLnf2x+aC1ut/CeVqWLPU4=;
	b=y2IL/V+4+v9uwfSWGJzBMyJ5qAvyfB/aHO8bVz+83fqgfyS8RhfbrPhdVrSV7U6+kFq2
	 b425frMPSlh48hmrlyhvZNmnNP3TCsD3lmgUArTN6WDyLshUJSZYV/UDBcKVh2EiMcrcl
	 guJRfH0FIYgILjRbEO7nbCEJVBUL6NUo8Aab50JFT2ZWToA7huVwQnzlda8HpMqyLWk9/
	 zaTbiDg7sbnntyKe+VEyxD5SibrKVOe26neSL6SE04LHe3YHvCezM8VZfiFyzvNSNcxin
	 1rruiGRCvE5g/w4agpBeuGlaQnEFQ+Dhuy/72OXYYyQTofLpDTDPY87nT8/lKP/uH/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9ZubPGX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE390606EBB6;
	Fri, 13 Nov 2026 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d9ZubPGX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E581F000C8;
	Fri, 13 Nov 2026 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585791;
	bh=S54paOWi74enEzfwp6yVEaLnf2x+aC1ut/CeVqWLPU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9ZubPGXSlIFtTVoIRXLceEhgZefLasyypEyxWPvPCBjm5yYj/7rMjKgp41geZxxL
	 NUlnKMC7CGVkEnfrOsP47aZ/dgsfldUZvVKBLgF5zqurqjX6mk9B1D9+XYxnVcX9f0
	 cLWC0gKhyZDzRsigYvbM02B0hIE161Yr940MuOSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 380/507] drm/amdgpu: dont drop the gang dependency fence twice
Date: Fri, 13 Nov 2026 10:51:24 -0500
Message-ID: <20261113153809.193439005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 6d1f901a83603a7d314e4a756b416b11d8dc7e35 ]

drm_sched_job_add_dependency() drops the fence reference when it fails,
but amdgpu_cs_submit() drops it again, so the scheduled fence of a gang
member loses a reference it still needs.

A GFX+COMPUTE gang waiting for another context, with the
xarray node allocation for the leader's dependency failed through
failslab:

  WARNING: drivers/dma-buf/dma-fence.c:589 at dma_fence_release+0x34d/0x730, CPU#1: amd_uapi_regres/2993
   drm_sched_job_cleanup+0x2c2/0x340 [gpu_sched]
   amdgpu_job_free+0xcb/0x3e0 [amdgpu]
   amdgpu_cs_parser_fini+0x435/0x710 [amdgpu]
   amdgpu_cs_ioctl+0xcd2/0x7a60 [amdgpu]
  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:dma_fence_signal_timestamp_locked+0x1b8/0x610

Fixes: ed21f6c3fe42 ("drm/amdgpu: fix another missing fence reference in the CS code")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5aa070a83c8378810b906cc8bfc650ce69822a7c)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 2739eab3e57ca..a03a15cfca961 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1318,10 +1318,8 @@ static int amdgpu_cs_submit(struct amdgpu_cs_parser *p,
 		fence = &p->jobs[i]->base.s_fence->scheduled;
 		dma_fence_get(fence);
 		r = drm_sched_job_add_dependency(&leader->base, fence);
-		if (r) {
-			dma_fence_put(fence);
+		if (r)
 			return r;
-		}
 	}
 
 	if (p->gang_size > 1) {
-- 
2.53.0



