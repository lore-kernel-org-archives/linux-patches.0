Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB946FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2132AC433CA;
	Sun, 17 Sep 2023 20:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982851;
	bh=b6OVyUOzp6LINKKHdGbB8GFONID7IIWUipGw0YqbU0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHPQtY1GWqlktnLEh9JraPwv2EyT/WcIJK9NGBa77hzBF1Htk9EyEa+eJXOVVx1H6
	 8AL8xz1HS1rAsfFCrgarZW2Md0HcUbq0JdSTWgNSUVRA4sL4c4CzmsQSDwX8kSAkL2
	 SeE2RrhB5UGqTDv9PFBF6lcPEYLsqvZaLY45YlQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Jennings <bryjen423@gmail.com>,
	Alexander Deucher <Alexander.Deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lang Yu <Lang.Yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 370/511] Revert "drm/amdgpu: install stub fence into potential unused fence pointers"
Date: Sun, 17 Sep 2023 21:13:17 +0200
Message-ID: <20230917191122.741628538@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 4921792e04f2125b5eadef9dbe9417a8354c7eff which is
commit 187916e6ed9d0c3b3abc27429f7a5f8c936bd1f0 upstream.

It is reported to cause a lot of log spam, so should be reverted.

Link: https://lore.kernel.org/r/d32d6919-47cf-4ddc-955a-0759088220ae@gmail.com
Link: https://lore.kernel.org/r/BL1PR12MB5144A0E84378A2666A26AE18F7F2A@BL1PR12MB5144.namprd12.prod.outlook.com
Reported-by: Bryan Jennings <bryjen423@gmail.com>
Reported-by: Alexander Deucher <Alexander.Deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Lang Yu <Lang.Yu@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2260,7 +2260,6 @@ struct amdgpu_bo_va *amdgpu_vm_bo_add(st
 	amdgpu_vm_bo_base_init(&bo_va->base, vm, bo);
 
 	bo_va->ref_count = 1;
-	bo_va->last_pt_update = dma_fence_get_stub();
 	INIT_LIST_HEAD(&bo_va->valids);
 	INIT_LIST_HEAD(&bo_va->invalids);
 
@@ -2975,8 +2974,7 @@ int amdgpu_vm_init(struct amdgpu_device
 		vm->update_funcs = &amdgpu_vm_cpu_funcs;
 	else
 		vm->update_funcs = &amdgpu_vm_sdma_funcs;
-
-	vm->last_update = dma_fence_get_stub();
+	vm->last_update = NULL;
 	vm->last_unlocked = dma_fence_get_stub();
 
 	mutex_init(&vm->eviction_lock);
@@ -3119,7 +3117,7 @@ int amdgpu_vm_make_compute(struct amdgpu
 		vm->update_funcs = &amdgpu_vm_sdma_funcs;
 	}
 	dma_fence_put(vm->last_update);
-	vm->last_update = dma_fence_get_stub();
+	vm->last_update = NULL;
 	vm->is_compute_context = true;
 
 	/* Free the shadow bo for compute VM */


