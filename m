Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8244E136658;
	Tue, 23 Jan 2024 00:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969682; cv=none; b=E8VMHv6ChQIJi19tk6DjcA/Yk4h+pRODlAE2MPZ9ElP3ZyOmPgsVBttD0o3LiVAmlnMnko69uAkzYm5o9LAWSZvJfzzrTewUj54iwiXql3cclSmHTaWGeZNW77a63P7H3DuH8IuvNCuK436mJHFAobbYaEa+JmPSMPhqvRqy2sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969682; c=relaxed/simple;
	bh=gHJQp4oGShQdNnuPGMYK6zjXq3yFGI+kXzRWyVpzgtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MlbfoXQ6RG3zdTJ8K3+OMEgb7KeDDQVVVR1yVF8Xqvg4nHWiXM3wO4jrOAKyXBCokfE9HqSb1MzuRVVO7Osj4TnmyQAJKx6y4epzN9IdY793D1N/qnxtmfqvrT71JLp/HIrf8FBLHnrOszqcWMqWVuHdGsUr0bya+jP0Gayxxwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbraETlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbraETlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EA3C43390;
	Tue, 23 Jan 2024 00:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969682;
	bh=gHJQp4oGShQdNnuPGMYK6zjXq3yFGI+kXzRWyVpzgtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbraETljlF8LRCFAVXHQcodo2uY81zrVLC8sXOSxNzUKB7Cet3TxfcIMNX6jIAyM/
	 Hq4/AXTBaJrVDaD62/PsGw2dt74AjE5ZATKiv0V9Ssj8FOkU2szHM4DL0rLPE1kXj1
	 PhqD5mq9DYmtn87ecTThysqLfsFBmuQ//loP5mTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 367/641] drm/amdkfd: Confirm list is non-empty before utilizing list_first_entry in kfd_topology.c
Date: Mon, 22 Jan 2024 15:54:31 -0800
Message-ID: <20240122235829.436187542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 499839eca34ad62d43025ec0b46b80e77065f6d8 ]

Before using list_first_entry, make sure to check that list is not
empty, if list is empty return -ENODATA.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1347 kfd_create_indirect_link_prop() warn: can 'gpu_link' even be NULL?
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1428 kfd_add_peer_prop() warn: can 'iolink1' even be NULL?
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1433 kfd_add_peer_prop() warn: can 'iolink2' even be NULL?

Fixes: 0f28cca87e9a ("drm/amdkfd: Extend KFD device topology to surface peer-to-peer links")
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Felix Kuehling <Felix.Kuehling@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 057284bf50bb..58d775a0668d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -1342,10 +1342,11 @@ static int kfd_create_indirect_link_prop(struct kfd_topology_device *kdev, int g
 		num_cpu++;
 	}
 
+	if (list_empty(&kdev->io_link_props))
+		return -ENODATA;
+
 	gpu_link = list_first_entry(&kdev->io_link_props,
-					struct kfd_iolink_properties, list);
-	if (!gpu_link)
-		return -ENOMEM;
+				    struct kfd_iolink_properties, list);
 
 	for (i = 0; i < num_cpu; i++) {
 		/* CPU <--> GPU */
@@ -1423,15 +1424,17 @@ static int kfd_add_peer_prop(struct kfd_topology_device *kdev,
 				peer->gpu->adev))
 		return ret;
 
+	if (list_empty(&kdev->io_link_props))
+		return -ENODATA;
+
 	iolink1 = list_first_entry(&kdev->io_link_props,
-							struct kfd_iolink_properties, list);
-	if (!iolink1)
-		return -ENOMEM;
+				   struct kfd_iolink_properties, list);
+
+	if (list_empty(&peer->io_link_props))
+		return -ENODATA;
 
 	iolink2 = list_first_entry(&peer->io_link_props,
-							struct kfd_iolink_properties, list);
-	if (!iolink2)
-		return -ENOMEM;
+				   struct kfd_iolink_properties, list);
 
 	props = kfd_alloc_struct(props);
 	if (!props)
-- 
2.43.0



