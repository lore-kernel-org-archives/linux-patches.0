Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73224C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5E5C433C1;
	Mon, 14 Nov 2022 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430449;
	bh=1/paTGE8pkTYhJJeKRYG4J9dbBycu+fl9mrxZlfJ290=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e90xhlxXvXZEKZFTBdyTRRGc6rKjDjdOR8cNcJPEagqUKeAnZuv/CZCcxeVeeZKWx
	 RwOpe3o5q/jJ6GEJAYw6lwUbS233n+pu5hoiA0TwA3NeXH1+f5tDPh3d03S21ncox4
	 tSd2wbB06D5jffNn1tGKlJx/tK3PJEN+YHO0aheM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/131] drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()
Date: Mon, 14 Nov 2022 13:44:35 +0100
Message-Id: <20221114124449.023178874@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 5b994354af3cab770bf13386469c5725713679af ]

./drivers/gpu/drm/amd/amdkfd/kfd_migrate.c:985:58-62: ERROR: p is NULL but dereferenced.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2549
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 0cc425f198b4..93307be8f7a9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -865,12 +865,10 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 out_unlock_svms:
 	mutex_unlock(&p->svms.lock);
 out_unref_process:
+	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
 	kfd_unref_process(p);
 out_mmput:
 	mmput(mm);
-
-	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
-
 	return r ? VM_FAULT_SIGBUS : 0;
 }
 
-- 
2.35.1



