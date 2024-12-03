Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FE91DAC9F;
	Tue,  3 Dec 2024 15:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241088; cv=none; b=IOIr10E8j2E2PnQEPjT4Wh8fuuCimALVkEtliwV/KfKLUU6YxOJOIeqJa81539PsuMpEXWUZsYPeWSWZncjQFL78LVu5YzScG2RNNtudGRJt0DqpCQOXNDc1JeWNBQv1DjA3O1uzA8BgM31ym4CiS/NdB+xcpK+ynQZRF2yAyls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241088; c=relaxed/simple;
	bh=QHIAxF2TproiPMc5J5qA6NxEaJMDDpKY6w3zuD4GCno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qhxu7AHto1xHgk8Gw9NM69wIiSq7ujwZrAIqH+7bzncGHRkYXY95O+7fOKQCQN/d16GRsp9At5rRcvw1wK8npHEA2kZzLfCJUW7TEoXbiH00XO99amWL93lDddfxUOCVQx98aE+nRgf0FlefqtaBuOJzX9eso35GGzhwS1Rg+aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIlKkKbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIlKkKbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC77C4CECF;
	Tue,  3 Dec 2024 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241088;
	bh=QHIAxF2TproiPMc5J5qA6NxEaJMDDpKY6w3zuD4GCno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIlKkKbla8ZJXFXiW5mAqHUUDs8kBTp2AGVzbZxKBQE5AyV/2EELghejYS5KB9O/n
	 PWo9T8ZbLgydi8/lXSv/dwVIoMH/y44tTGYpFMI61bAaKHmqwRJ3sIRNT6WiJoPyaw
	 q1rxkFPrlLTrckvVb3I7wNd8oK7hM2cEwAXnPmDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/826] drm/amdkfd: Fix wrong usage of INIT_WORK()
Date: Tue,  3 Dec 2024 15:40:49 +0100
Message-ID: <20241203144756.322856913@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 21cae8debc6a1d243f64fa82cd1b41cb612b5c61 ]

In kfd_procfs_show(), the sdma_activity_work_handler is a local variable
and the sdma_activity_work_handler.sdma_activity_work should initialize
with INIT_WORK_ONSTACK() instead of INIT_WORK().

Fixes: 32cb59f31362 ("drm/amdkfd: Track SDMA utilization per process")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 6bab6fc6a35d6..ff34bb1ac9db7 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -341,8 +341,8 @@ static ssize_t kfd_procfs_show(struct kobject *kobj, struct attribute *attr,
 							      attr_sdma);
 		struct kfd_sdma_activity_handler_workarea sdma_activity_work_handler;
 
-		INIT_WORK(&sdma_activity_work_handler.sdma_activity_work,
-					kfd_sdma_activity_worker);
+		INIT_WORK_ONSTACK(&sdma_activity_work_handler.sdma_activity_work,
+				  kfd_sdma_activity_worker);
 
 		sdma_activity_work_handler.pdd = pdd;
 		sdma_activity_work_handler.sdma_activity_counter = 0;
@@ -350,6 +350,7 @@ static ssize_t kfd_procfs_show(struct kobject *kobj, struct attribute *attr,
 		schedule_work(&sdma_activity_work_handler.sdma_activity_work);
 
 		flush_work(&sdma_activity_work_handler.sdma_activity_work);
+		destroy_work_on_stack(&sdma_activity_work_handler.sdma_activity_work);
 
 		return snprintf(buffer, PAGE_SIZE, "%llu\n",
 				(sdma_activity_work_handler.sdma_activity_counter)/
-- 
2.43.0



