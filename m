Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061030;
	b=DQANW8/CnXV93DStvrYeYDLOHzQ32PPn9M62Z+Ck0ekAk4ywPugoBr1q6EufaN8zoHn0
	 WJruWn1GZ0Vfjy+h5eHKZguzlHRstQtJYDF5G6Q7nGb1kypQqwz5zPpYOGGxzv14E2Q7F
	 Ir3lHqieuEL+9hk5dthxyNPM03xAXwlDqm4MQFRxkvMXpUA7MOMQFU7+/e3x6tBJ7VCOH
	 C9WohV7GPIr9mgIFJM5ZHi5xOBw5hAk7UQUxKkmTI8ppACmFkIL3dRepIeBKyBz9uSXsU
	 vWcNk+AsLsCwKIeMXlmDsqTLThm9zJhrXesS5RRbG5/PJOjD1UN4EkyLrwpkquAvEyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMQglBxnBvoMWeDz8FnfMLgMJcnCsBghzvzJU0FW8OQ=;
	b=Ods5T6OibpsullqGO3H9UGs0R6r3Ey1r/oUr5YiGZzdsoVlRVVmX/InfWkU4qY3T22D9
	 9m68/h8aXrClrxg3JKSim6wdpDQhHvtXp/9RfUp5YNMNin0cr/pQ74OQIUc5u0CP3GRZE
	 g9++eilvvugvLcLJfu9LC5IUehcW8kWQQbTCfTIYzZKFxNVk9hbs8i6X+xHo3G5FH0Hh6
	 B3s/0DW0Zs0aDipyTtYOnVifvWGE0BAm2xrrVDu2sWvuqpXalLrulWDhIvnGhNvBgh6Qy
	 AbqDru9uhyc9sn+3DHRaPx0kJ8uoOsI+GQ6YeodhA0S75o1z1HKre9UDPRUI3l7XyVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmLJST2U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD9D606A33D;
	Sat,  7 Nov 2026 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmLJST2U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774761F0089F;
	Sat,  7 Nov 2026 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061029;
	bh=KMQglBxnBvoMWeDz8FnfMLgMJcnCsBghzvzJU0FW8OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmLJST2UILCBWYOo6eNTFTLp7r/VPKTPGrLsvGXYYsai38l3t8e84Fre9KWSu521S
	 0dclKRfWfFQNo4CkcqshmDXkVeYFTtEhtaWN2Rs3nn/D/5YI3dMgdHYcvqwSH7kJrq
	 39pJZEbay47Wg1RW+EhiKq7BdFNsKeSIDYXxkw2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0365/1536] vdpa_sim: hold iommu_lock across dma_unmap passthrough transition
Date: Sat,  7 Nov 2026 08:39:41 -0500
Message-ID: <20261107135007.907427035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiong Weimin <xiongweimin@kylinos.cn>

[ Upstream commit 7b411448c668bfab0d0e572cee5a592cea396ce7 ]

vdpasim_dma_map() updates the IOTLB and the passthrough (iommu_pt)
state under iommu_lock.  vdpasim_dma_unmap() clears iommu_pt and
resets the IOTLB before taking iommu_lock, then deletes the mapping
while holding the lock.

A concurrent dma_map(), dma_unmap(), or reset path that also touches
the same address space can therefore observe or modify the IOTLB and
iommu_pt state without consistent locking.

Perform the passthrough transition and range deletion under the same
iommu_lock scope, matching dma_map().

Tested-on: openEuler VM (6.16.8, /usr/src/linux-6.16.8)
Tested-by: Xiong Weimin <xiongweimin@kylinos.cn>

Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260626020545.607600-3-15927021679@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 3bcec8c1e2ab3..f7d346809e749 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -734,12 +734,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
 	if (asid >= vdpasim->dev_attr.nas)
 		return -EINVAL;
 
+	spin_lock(&vdpasim->iommu_lock);
 	if (vdpasim->iommu_pt[asid]) {
 		vhost_iotlb_reset(&vdpasim->iommu[asid]);
 		vdpasim->iommu_pt[asid] = false;
 	}
-
-	spin_lock(&vdpasim->iommu_lock);
 	vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
 	spin_unlock(&vdpasim->iommu_lock);
 
-- 
2.53.0



