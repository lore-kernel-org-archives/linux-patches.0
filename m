Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E33C53A7;
	Fri,  6 Dec 2024 15:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497338; cv=none; b=TX52HJ386aVcjZ49PMyDNOWO/OB9VkWw3JNfOFSqLfZ8K6ouYdU7HJN6OEQExUR9zVgf86oGV2jUghAC1Eqssh9ddILTEqe+Fz0Msbp98saOyhJZESpRy3pApT1Vr06QLj0wZQGmtQsLJoJgcPecq8pzDkV/17+fy3VMsXqBRqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497338; c=relaxed/simple;
	bh=8hVsiz4KEaoXvqQKbYK1b8KvuXFfeuVcZaVR2vemO8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQccSSjjVUSZDE3Fi/j1/unVQfIbHO8eZZ+lp5tjiZDnTlN7U/R0cLC7E/YRFt8NfxZ9rkpcfxTP8A2V8pM8Forqge5DbmkUH4TvYCvOz0rqOLR2khHdKEQDg0tX3t9M3XmK1QQE76LgFpHkWJdd2XddHhnjismffrNtHW2pYEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vi5FE6hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vi5FE6hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05D5C4CED1;
	Fri,  6 Dec 2024 15:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497338;
	bh=8hVsiz4KEaoXvqQKbYK1b8KvuXFfeuVcZaVR2vemO8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vi5FE6hdKkMMp6cJOpX6SDfRFJzXAWfKQ8exHWG9c27Onwd7rPxGHW8FBQjcPwgpT
	 kx5KBzE6rpKiOABMbjoHOkfy1hpINXwwteFBlfeFPrpNXn3dACe7UBrS+9SBXVRy8l
	 jandz5zUW6ZOBy7SJDcmRUQmuOyGuOZmlZ1yGG1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/676] drm/amdkfd: Fix wrong usage of INIT_WORK()
Date: Fri,  6 Dec 2024 15:31:05 +0100
Message-ID: <20241206143702.941054678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c90231e0aec2..fd640a061c96a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -312,8 +312,8 @@ static ssize_t kfd_procfs_show(struct kobject *kobj, struct attribute *attr,
 							      attr_sdma);
 		struct kfd_sdma_activity_handler_workarea sdma_activity_work_handler;
 
-		INIT_WORK(&sdma_activity_work_handler.sdma_activity_work,
-					kfd_sdma_activity_worker);
+		INIT_WORK_ONSTACK(&sdma_activity_work_handler.sdma_activity_work,
+				  kfd_sdma_activity_worker);
 
 		sdma_activity_work_handler.pdd = pdd;
 		sdma_activity_work_handler.sdma_activity_counter = 0;
@@ -321,6 +321,7 @@ static ssize_t kfd_procfs_show(struct kobject *kobj, struct attribute *attr,
 		schedule_work(&sdma_activity_work_handler.sdma_activity_work);
 
 		flush_work(&sdma_activity_work_handler.sdma_activity_work);
+		destroy_work_on_stack(&sdma_activity_work_handler.sdma_activity_work);
 
 		return snprintf(buffer, PAGE_SIZE, "%llu\n",
 				(sdma_activity_work_handler.sdma_activity_counter)/
-- 
2.43.0



