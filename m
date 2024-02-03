Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AB9F9FF;
	Sat,  3 Feb 2024 04:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933421; cv=none; b=Yg84BNO2JUO4+Y3uHFNy20dF9jZGmJM95Jv6E8OpyHQsa01M8NiIoh6YEB5o11UVBANB6Okmw89u8dX27SzoOsVvkAppi8XqxmuRps+SijnMyaxKpHbUEE25K5IPzym7DJSCw2hHQOPLNsnph1nkSM7wST7bKEQlQB1UpW/oz48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933421; c=relaxed/simple;
	bh=0dJ/+dB/bmSkj0YOi8AAVHVk4iLBI9ePPSa+nVDmOwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebEyFFkdxf6LL2PX+BHY48QS5IWWE8erv0+ehbvregX9nTe/y++22VMTPA9Rg7whb+xa3Ma4yMrcHS8N4RjPZR9D1uuyfJsQBhS+LnILNVYsx+zdLv1ojC9VuDtljseFQf+M9TyNR0+58ORBsE3BLQos105BpkFKwBDr417AvHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbGDqzIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbGDqzIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4B3C433C7;
	Sat,  3 Feb 2024 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933421;
	bh=0dJ/+dB/bmSkj0YOi8AAVHVk4iLBI9ePPSa+nVDmOwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbGDqzImsTPEh1vNdy/nJioQwxAfb7/5rbUlSqpOLWn9DxWygb7Cc4SCQxuwT5r8T
	 LAYUjgE1hVlJPFTkk/vLSa9g7cBAcB4/3f92l9AEcsiC+oavmpuTqgXv8OpNGcTTWd
	 xY2icmjnWDq3p8kcbwJ3E9OQbGKasfDaTnL2pDmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 145/219] drm/amdkfd: Fix iterator used outside loop in kfd_add_peer_prop()
Date: Fri,  2 Feb 2024 20:05:18 -0800
Message-ID: <20240203035337.696105104@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

[ Upstream commit b1a428b45dc7e47c7acc2ad0d08d8a6dda910c4c ]

Fix the following about iterator use:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_topology.c:1456 kfd_add_peer_prop() warn: iterator used outside loop: 'iolink3'

Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 24 ++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 705d9e91b5aa..029916971bf6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -1513,17 +1513,19 @@ static int kfd_add_peer_prop(struct kfd_topology_device *kdev,
 		/* CPU->CPU  link*/
 		cpu_dev = kfd_topology_device_by_proximity_domain(iolink1->node_to);
 		if (cpu_dev) {
-			list_for_each_entry(iolink3, &cpu_dev->io_link_props, list)
-				if (iolink3->node_to == iolink2->node_to)
-					break;
-
-			props->weight += iolink3->weight;
-			props->min_latency += iolink3->min_latency;
-			props->max_latency += iolink3->max_latency;
-			props->min_bandwidth = min(props->min_bandwidth,
-							iolink3->min_bandwidth);
-			props->max_bandwidth = min(props->max_bandwidth,
-							iolink3->max_bandwidth);
+			list_for_each_entry(iolink3, &cpu_dev->io_link_props, list) {
+				if (iolink3->node_to != iolink2->node_to)
+					continue;
+
+				props->weight += iolink3->weight;
+				props->min_latency += iolink3->min_latency;
+				props->max_latency += iolink3->max_latency;
+				props->min_bandwidth = min(props->min_bandwidth,
+							   iolink3->min_bandwidth);
+				props->max_bandwidth = min(props->max_bandwidth,
+							   iolink3->max_bandwidth);
+				break;
+			}
 		} else {
 			WARN(1, "CPU node not found");
 		}
-- 
2.43.0



