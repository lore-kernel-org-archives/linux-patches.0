Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830970;
	b=rF3Ol4SwX/B8FJ9AlC3lDc6jSaJojCjmA41t4XwFfyBI2ctmxsIWlOAssPOhi1q/V66A
	 QXi/+awuD2jOKshnl9BtRZr1p7WxLQwOzB326GXau/Dpliwtv/6uJQDQ0vO7hWMLYgz8v
	 FfDLG4QwdD7LbgAUKaJAsCSF0pbvTqhzoXS1JbmLX3vw/usS6Tl1cz9iGKpbsbHQkELWc
	 gCGMq7TjyVZrqvpSPaFPaoRJP9B0jrmZtyT0XAfSyR85Z5v/t+uZMYO57Vp4A6JQXHQO6
	 1gMUXokPbXMe1XH3lWtctOrhHIWnkpO1eOH97cj1vyoN+mnG8+9p8cT06xiEthPOLgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdYVbB/BnABXPYrHBuqfsWcCMYEz9cMCLGBGcFF0FGA=;
	b=r7kRgQBD+diIfcDDcEruIM1f9h6b/dCvLFNJK99cEgggCoRyY9RhqnFbFMDXbUJkIqjo
	 8kQ49kVTrVl3JcOP6N1ZbpzxWnf0jI6BD8kJqkzgV6hLhX8iDCdrMXvVHEv6dB9KW0QKb
	 wx3r7APWgLAopEy8vXss51f9FPxxQc9GKwnbeEgNu6LfO+LUgZXnm6xZRO4Ac6Mwx8C7u
	 vIrRjKx0lt/+tG2t7xuV4/U8kfJVVAvq6XSfQ+NrVd9Ps5yV7/JKuKLSf2c65OIPDvJwk
	 zDFmhj8TRDk95u3TGgaH/0O7ev37pQUmlBj9lrWdgKo1RRreFfBc6LgEaBct7KQIPfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssGLLj4C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81595606A876;
	Wed,  4 Nov 2026 22:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssGLLj4C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6DA1F000C1;
	Wed,  4 Nov 2026 22:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830970;
	bh=bdYVbB/BnABXPYrHBuqfsWcCMYEz9cMCLGBGcFF0FGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssGLLj4CplGNGEW+ODT/rc9y+JRDhyRRPmTKIEHaw601N3fvbfNMdDgnZdX0gHmhC
	 Xs4XNvkSzUUTi+Gn1veiJBoJ0lbR7i/su23OOVo5hNVvrmVRwHPY/16rHo6iuS02kF
	 NJekS9Qoc506a6LcSzNxGEmZFpFelxWVoedo9JM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0433/1005] vdpa_sim: hold iommu_lock across dma_unmap passthrough transition
Date: Wed,  4 Nov 2026 16:02:46 -0500
Message-ID: <20261104211056.219899226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9df300c467452..44055778b6940 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -736,12 +736,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
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



