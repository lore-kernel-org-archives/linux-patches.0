Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055633;
	b=UpHycsoPfOr0guAkwg6lZUC727UmbhZbylrtU2iQ6t5TwKmuau0hxDAa8hkkIbDOZpX5
	 JXx8+w9IikwKCYv0q7QWySkypp3dLvnCakqA4OBvyapr3eEpOsePI2C+AfUFg6ahuotsl
	 +NC7yYxcPR19SZVrpJ0MiVjSVFJPoTWm1XMzXeUriZQqDHGeyiLSRhYpVGAMQk2IAF7i2
	 36mxqy/jFc94SGv8wKUjR/yxAshk8JP03gOEsmThN6LdvjWiEJKE2NZoVGIdXrUmZl3AT
	 FK7QXRC19RDJPgedU4M9Wm5lZA0OYX4XSG5EbCqrtVZkg0qcTOqQ65LvPVpzWjHWuQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V+To1VUgyQJf5IRqyT1lcVOeyw7QkeIa/eDv9dzF2jI=;
	b=gm3Cx1FE8zTzDOVK8OWvGCBOyRwpr+T8233etn0+xnGLUYQOiwaeUuWeJHINwrAd9apP
	 baAl1FGVB8oIvmvjNUddP4OFq58D4OuoSS8ZpZeU9n4JAXEcW+0xzmwa5eiZpOGhVW0vz
	 +BcIBUFl8pDC/J7vNAVK91ahB0+BBSU8X2T6OWDaj0FAVHO8Vjo3l5vTNUb4v6Urvx8Uz
	 bgVNiSKdKoYOcxmmBn1GX7oCaAropgXBqppZhOUWczggK2aj7KalRFjCQwX8HRgw2OoPX
	 U11W1o3B0mX05J50Q3HTV7ND/z7qMADdSZKt3CJr5teVL8UdmotuJ3TysdGzTQzLnZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xg2aHgWl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C3606A32A;
	Thu, 19 Nov 2026 02:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xg2aHgWl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284421F000C4;
	Thu, 19 Nov 2026 02:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055633;
	bh=V+To1VUgyQJf5IRqyT1lcVOeyw7QkeIa/eDv9dzF2jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xg2aHgWleZcSsn/A2mphBQfA2sTRmLBP6WvDiwtPtTKcyRP0royQnAukDYRWcKeEW
	 Ix+/DU9oXy5xaziShfE8lE1R12fTUTQ+5HiJWL2QwtQrwJ3sT1ORDPqtOHbVgIp6ub
	 sJdAj1JiC9eYNWoU5+78fdfeGbih/RWdMg7Z2q6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1701/2214] drm/tegra: Drop reference on postfence
Date: Wed, 18 Nov 2026 15:56:17 +0100
Message-ID: <20261118150119.842137965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 5ba3dfe724448f308ad7b28ef8d4f41bca4896ae ]

drm_syncobj_replace_fence() calls dma_fence_get() on the parameter
fence, so we need to drop ours. Add a call to dma_fence_put() to do
that.

Fixes: 13abe0bb15ce ("drm/tegra: Implement job submission part of new UAPI")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260730-b4-host1x-syncobj-wait-v1-3-afa730410392@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/submit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/submit.c
index d5f274018cce5..c63f48d41ee81 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -605,6 +605,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 		}
 
 		drm_syncobj_replace_fence(syncobj, fence);
+		dma_fence_put(fence);
 	}
 
 	goto put_job;
-- 
2.53.0



