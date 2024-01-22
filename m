Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA54564CF5;
	Tue, 23 Jan 2024 00:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971529; cv=none; b=VCJIqgzbawS7yXM3RROWyj65K7mBdVGtkcHysKWVCxISqAiHUM9NGiBq4gKiHwrJAiJJS008QWGV6ZpGP8MdEz6Rxr64wxBJq4dPN3EB+MzRLGImzsGivhBSPXQfuHWpuC00Hmwce52sBXdKy9T3OB1tFnP/XgeRoZigGXWxpuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971529; c=relaxed/simple;
	bh=6i+3HgelJanc/SloyjVPiesdUHwmdp33jt7lgq6PKNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwSTfPKyVdFWaygv6MOzf4stPoZm+uZBRZbUm3jbhndzR7yKv6whDdpmNJlEdnKmBLGfsaP3HZvMKexd7y33W3MKqESDVEUkDFmxgzoKlZK+wXEbqlqgbJePTjV7GNgSAG5WVqjk8+Q6C1INsNk6EZUrLOoaJME4IlNr0UG0kQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD5io+MQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD5io+MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6461FC433C7;
	Tue, 23 Jan 2024 00:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971528;
	bh=6i+3HgelJanc/SloyjVPiesdUHwmdp33jt7lgq6PKNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD5io+MQ5FSm847mjLRwbDKUq58yAz2V/9hCMRlNEUz0Q/vE/tLE0ky05chRZwSa8
	 XMtPe4SxMoVOOtaMqlbbBAqgVWwVKmUf9jPh65BXSqXgQrVOjPdKUfPXar7smC7l80
	 ktsnV9LXNMbI/Hup8AkWwNo6nTtw0Mney1KMrLkg=
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
Subject: [PATCH 6.1 240/417] drm/amdkfd: Confirm list is non-empty before utilizing list_first_entry in kfd_topology.c
Date: Mon, 22 Jan 2024 15:56:48 -0800
Message-ID: <20240122235800.199217770@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 713f893d2530..705d9e91b5aa 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -1403,10 +1403,11 @@ static int kfd_create_indirect_link_prop(struct kfd_topology_device *kdev, int g
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
@@ -1484,15 +1485,17 @@ static int kfd_add_peer_prop(struct kfd_topology_device *kdev,
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



