Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA081F76A4;
	Tue,  3 Dec 2024 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238713; cv=none; b=Rp8cEXm0wsInMf4UwSRncsYOXJrjC2C4KkOdpzT2y/IN6VwU5IYqhR/awMURiPbXj9MoLTiJQG7LIIEbpyFO18pqUZEHU31OLzOJR0pOhgjLDrVoV1mrLHpokDUH2muG39ALczqUGrJg/oLdlGKOvYErNkmMJXIcIopFrNlxJoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238713; c=relaxed/simple;
	bh=9V10d8hD9tpnGVJjnkeRIGMbXc+CXWM8UVtK5GeUnhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuKYzyP+83OnNp2pMrWFfQg8mGU0W8RmKtZXUzqpldQPq0pG2+66mhOV0dMhjmR2uR50u4z6kB0hYVPFBMAGZ3s+4Qs9xGBBvMT7NN130MI4KJtlgDmu4lkNE+g3nU47EL/a7WyJLYd2HhbZ2aggZw8LTrflBkWqe0s3iSxyqzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMtpxq2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMtpxq2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B251C4CECF;
	Tue,  3 Dec 2024 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238713;
	bh=9V10d8hD9tpnGVJjnkeRIGMbXc+CXWM8UVtK5GeUnhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMtpxq2QErIRbYMc89vZSwKZxMDslTrzruq3oOfFk/ebhknas86tmYpitLTVf/SF/
	 kRdo8QjAdnQYyIsJDyGdP7F2brCdlgv4PIbwfXYDMxT8dWUhbmYJlDEmSmik2Kqwkl
	 4TV8VA498Grn2VCuwQTK+wbdmPqGismgcHlvEuLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 341/817] drm/amdkfd: Fix wrong usage of INIT_WORK()
Date: Tue,  3 Dec 2024 15:38:33 +0100
Message-ID: <20241203144009.133049560@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 8343b3e4de7b5..378ce360b861b 100644
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



