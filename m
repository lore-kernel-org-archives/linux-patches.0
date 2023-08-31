Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E1F8F6B
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4BDC433C9;
	Thu, 31 Aug 2023 11:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480250;
	bh=L/2edS5FFQtxPrnMyGnR7hKwJt5TpGdGCZjsmcQG8dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeYueEyaWEkPNRKwJIXMnjIkcBuSeOfiBjzDu9gY9Gt6koEnek+kEKbVg1blKU2X9
	 AqAC5TG+drWpAXICySAhd4pwE5cN/Cu1Ye4vTgn6UFBeGCatfTT96JFjUlSwq113k2
	 yKwGqYcKT8ZoFQd9lfz+tufpGyjWfdA+ScNWFUqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"From: Chia-I Wu" <olvaffe@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lang Yu <Lang.Yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/11] Revert "drm/amdgpu: install stub fence into potential unused fence pointers"
Date: Thu, 31 Aug 2023 13:09:58 +0200
Message-ID: <20230831110830.709974865@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
References: <20230831110830.455765526@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 04bd3a362d2f1788272776bd8b10e5a012e69b77 which is
commit 187916e6ed9d0c3b3abc27429f7a5f8c936bd1f0 upstream.

It is reported to cause lots of log spam, so it should be dropped for
now.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/27d08b24-3581-4451-b8db-5df144784d6a@roeck-us.net
Reported-by: From: Chia-I Wu <olvaffe@gmail.com>
Link: https://lore.kernel.org/r/CAPaKu7RTgAMBLHbwtp4zgiBSDrTFtAj07k5qMzkuLQy2Zr+sZA@mail.gmail.com
Cc: Christian König <christian.koenig@amd.com>
Cc: Lang Yu <Lang.Yu@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2155,7 +2155,6 @@ struct amdgpu_bo_va *amdgpu_vm_bo_add(st
 	amdgpu_vm_bo_base_init(&bo_va->base, vm, bo);
 
 	bo_va->ref_count = 1;
-	bo_va->last_pt_update = dma_fence_get_stub();
 	INIT_LIST_HEAD(&bo_va->valids);
 	INIT_LIST_HEAD(&bo_va->invalids);
 
@@ -2868,8 +2867,7 @@ int amdgpu_vm_init(struct amdgpu_device
 		vm->update_funcs = &amdgpu_vm_cpu_funcs;
 	else
 		vm->update_funcs = &amdgpu_vm_sdma_funcs;
-
-	vm->last_update = dma_fence_get_stub();
+	vm->last_update = NULL;
 	vm->last_unlocked = dma_fence_get_stub();
 
 	mutex_init(&vm->eviction_lock);
@@ -3044,7 +3042,7 @@ int amdgpu_vm_make_compute(struct amdgpu
 		vm->update_funcs = &amdgpu_vm_sdma_funcs;
 	}
 	dma_fence_put(vm->last_update);
-	vm->last_update = dma_fence_get_stub();
+	vm->last_update = NULL;
 	vm->is_compute_context = true;
 
 	if (vm->pasid) {


