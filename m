Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774787;
	b=OMPq7TC//NhZ0I91qdvLqf9yAlBr1bojdPhAxjJGn6lLVpvyRlrH3vprPU7fMSwOhHtf
	 2xg/q6Xx7zuNAQYzJOPkBOYyaHTH+dhpmcg10wKVmbat/+P9f/hfZ4SiBYdZ+VB+ud4n+
	 IlCLBK539AIyqrZp1CZ+LmQQ7UUpm5bHh5urxRTzvjJku/95bV2YC39fvPQj/1/QGY4S4
	 lBCrVURBnRz27v2MC2CF11/s2nxISCTb47ETfJqz2GwtHEWLSprh5Vuc8aUoeBpa4kfOz
	 bf6qw12tvuBOM2G1tym+6FbkQU6QKr6EJpzBfiEWZZdBX+59LRXub5BlUuRMD7GCQJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hoVnS/LfoCcl4DYxM+STDAFkbn5mFKRMYsVXY0aiR2M=;
	b=pEEDysKDboecqqdw6BD8lbWeoV/lZ3IhfGCq8GZcrStDE48IgbMZAp8gMdFSDiCnuDKZ
	 MBc6tTbf5lrnZPNZxXoaR2siS6B8HtAJRavIVfJAUEkKLWvtIXHBy7RMP3QlG3966YrQp
	 rEMgURYsfwf2nC3X6Mr5XmlbpYcwbVWy876gXFqnwZYbYwSOtMt43101M3fqzbakmJTMG
	 F7ttT2GeibP6YaHCVGp2DLh8E9o9VppoM2shZItha0HLTZjzE7ezzl3074abejf/0ejnn
	 xMrw0Im0pvQqtytIeqGTDqBplsp/s8vFh3PxY6w58Z8fcyWiMyO1YDh25D8+Yu/lQWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3mRFyP1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A06606A31A;
	Fri, 23 Oct 2026 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T3mRFyP1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13DA91F01825;
	Fri, 23 Oct 2026 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774786;
	bh=hoVnS/LfoCcl4DYxM+STDAFkbn5mFKRMYsVXY0aiR2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3mRFyP1Dg1fEehIKlnuXWfUVdcawvGfrvVBazFMW1NRq83RsEquq++JWjYYl4gKT
	 iujgwMMa8ir3gPjc6nSeRfFl2iiXDm8jSj+YC3qkzaLP2/3ih0JIyGSonUN5kCgOtF
	 WgEPPVJsg7x7yOKVkJCmucUA1WQmwsigvlcOE2mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 157/242] drm/amdgpu: fix sched entity leak in ttm buffer entity init
Date: Fri, 23 Oct 2026 18:39:59 +0200
Message-ID: <20261023163717.495607827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

commit b5629f4a0869f4b01cfbfdf27f2c349d68c5d9d4 upstream.

amdgpu_ttm_buffer_entity_init() checks num_gart_windows after
drm_sched_entity_init() has already attached the entity to a
scheduler run-queue. Returning -EINVAL from that check leaks the
entity.

Move the ARRAY_SIZE() check before any resources are acquired.

Fixes: 2c3725572561 ("drm/amdgpu: statically assign gart windows to ttm entities")
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4000d1cdd1eacd3422267d6c8b4f1c9333b0317e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2043,14 +2043,15 @@ static int amdgpu_ttm_buffer_entity_init
 	int i, r, num_pages;
 	const u64 GTT_MAX_PAGES = (AMDGPU_GTT_MAX_TRANSFER_SIZE >> PAGE_SHIFT);
 
+	if (ARRAY_SIZE(entity->gart_window_offs) < num_gart_windows)
+		return -EINVAL;
+
 	r = drm_sched_entity_init(&entity->base, prio, scheds, num_schedulers, NULL);
 	if (r)
 		return r;
 
 	mutex_init(&entity->lock);
 
-	if (ARRAY_SIZE(entity->gart_window_offs) < num_gart_windows)
-		return -EINVAL;
 	if (num_gart_windows == 0)
 		return 0;
 


