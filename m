Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034256;
	b=1YZhz47uF2E6vpsR5SC7pGu/QuhRWDZKwmji6AHFcAR2uJ9bQouy5suDW/t9cMD0/c6W
	 WZUCGoHr9wndfHD2Ny1pQ+nLEaTMTUqxnz88Vw9mHcpmMrYq8i+c2lMTxgt3J/aenm/Pd
	 08/V9jegR8RBUKOgJjmi0iKA7/TOgxshJnWerBES3WhbrDZ/QF2UMisiYYvS7dQv1cf0Y
	 1JdpjgURt0I/ZCDUvN5idZMwV5/+SPCRgCYoaeSM8SIAUD9Lt6beV1cQ/NQWYDyn51P9f
	 KTCX/he6cIPeokWopAM10YwftsCrRfoFb7lKgz8BpbcXd05sHnlEby7v2DYvziGVuGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLMya6iwwt73V3PfiMG4W3MLKgn3/jNnejQdNxaYauY=;
	b=S+18YLyVmTSdReunq6+UP1flQ5L4GEZ2nXM2z03+IWlCVU7pPYwBu0mvnf5HHNxqYn2B
	 lNjg1iybMuvBhh1CH8TpS9QkBKwakZb7SoNWIBOOIYzCV279wSZK1OaqMOPZoLV411gSg
	 6JaTbrGPB9Yr2IOefgc3nsKne8ObR+UIdfClYgzYyOzm2H6Yb52mr+kIg4kyt+fQQXuq1
	 bz8lkh30VhsIIzzFBkyIWpQkq+ZzoC3NVj4oHLs/EkjwS5H2zO2G9uu7trvXtaV5al7Hl
	 wwfSwMbX2tyWD3LNfrEzuHrTFiRjpN7FGFUBptu7Qr2Smq6nt0PLlfOeGFUv5QpB0hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5bFZdK0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362B2606A320;
	Wed, 18 Nov 2026 20:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C5bFZdK0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 880A41F000C5;
	Wed, 18 Nov 2026 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034256;
	bh=uLMya6iwwt73V3PfiMG4W3MLKgn3/jNnejQdNxaYauY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5bFZdK0twF8dh27fypMqlECyY+HUKGvjtTwdWavJQkpfCREMPPrpN2KHFd2nvVAT
	 BBreqP988FU+SL+M7MU1ylOdlEjVpuQ/ZvAjQV1NRt3a5MqYYJmiHI1SqLmrRt5Mff
	 HMGoISHvmlwLbK4Idt/txypqwAv8KwZFP8DV2Yxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0305/3318] vdpa_sim: hold iommu_lock across dma_unmap passthrough transition
Date: Wed, 18 Nov 2026 15:15:27 +0100
Message-ID: <20261118150324.911728520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20edde71280e9..b7d24faa8af3e 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -691,12 +691,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
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



