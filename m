Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774774;
	b=z58JGvBQTb7f2TCxTiL5v6tjQ0HJCIOCyHlRwkfKWo+aWYpqCb88uL64E5PH/h9RpEvP
	 K01LGZWW/9p2PFqdjK6w6E3h9z2ktFEgtvMD/rdPZaq6lRbVB5JHDtdIlqQVUHaFD+uGG
	 +99Qj3W7YrHsrddoB2U7ReXiQy2ACYa/58HaT6CW14HNuiulSRKSrZDVHjrVW5rMh+UPr
	 ZGYYhNXuJXsxydVB9QVuhNGYyYh5kjWV2CjABJoO/RXFKoP/S0ULhW37YZgstO8jJFHRT
	 5xzxkIS//tVkNrSHBFgH0qgxfMKS6MQPfuGhxS35JGGss5ZhSvUE6nWFkeYeFkL30Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kVdqc3F9LHgHR9Pp8VSBl4w/jhSG6+7yWS8YUL/nlJE=;
	b=nvCxL71uA7IPm73wKzvFGUNoE87ais1xGXDwZGsYlu2Et+hd+Mk1bryHrlYSuUzmQa47
	 TYuJydPmySy8tC2N//Xnfnae/C8YTx/gDal0RAvTUsWv6NBzTWIuxGbTEGuXiWev6ZIjB
	 VvklzTL0II/QpG57+3eoKhsx/oYvBqUcYkOO4dZSjBihfnZpxPrFz6g65ePBj8QMxPxcO
	 UodhumbPJZnhjD6+WWlT9nwio3f0bRGWuJ4JnltL1kkFYrUD8+jky7I9ST+wJeoL8Hn4a
	 AdrPwKpR2vtlcDpspVhoTp2NlHE1fGq6uJzdZFR7++i0e4o/Xiq0VHX6coI6e4YaBsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dY7sK81m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94826606A31B;
	Fri, 23 Oct 2026 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dY7sK81m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6181F01825;
	Fri, 23 Oct 2026 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774774;
	bh=kVdqc3F9LHgHR9Pp8VSBl4w/jhSG6+7yWS8YUL/nlJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dY7sK81mVu/AxaM8rIi/g14axHH++piH0u4WqQZGnW6v2ZQSsOmVk2KO9mIt8r2QQ
	 nEMmzzkchT9spnrXCcyZKF+A5yMDwKaVhQvHAAaNd6qlHXTMKw0hZ/Pl6PScnrJw48
	 aRGhJxirTL+heavoefLPNK6isdagWhWOFHGgfYEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 154/242] drm/amdgpu: destroy mutex when tearing down ttm buffer entity
Date: Fri, 23 Oct 2026 18:39:56 +0200
Message-ID: <20261023163717.425747015@linuxfoundation.org>
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

commit 5b0a459f990be2faba33229fd93f10f23745fab2 upstream.

Pair mutex_init() with mutex_destroy() on the GART window allocation
failure path and in amdgpu_ttm_buffer_entity_fini(). This is a no-op
without CONFIG_DEBUG_MUTEXES, but it keeps lockdep from seeing a live
mutex after the entity is freed or re-initialized.

Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 03ac40aeed034a0a0d5824ad26f8fbe1f6463698)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2058,6 +2058,7 @@ static int amdgpu_ttm_buffer_entity_init
 	r = amdgpu_gtt_mgr_alloc_entries(mgr, &entity->gart_node, num_pages,
 					 DRM_MM_INSERT_BEST);
 	if (r) {
+		mutex_destroy(&entity->lock);
 		drm_sched_entity_destroy(&entity->base);
 		return r;
 	}
@@ -2075,6 +2076,7 @@ static void amdgpu_ttm_buffer_entity_fin
 					  struct amdgpu_ttm_buffer_entity *entity)
 {
 	amdgpu_gtt_mgr_free_entries(mgr, &entity->gart_node);
+	mutex_destroy(&entity->lock);
 	drm_sched_entity_destroy(&entity->base);
 }
 


