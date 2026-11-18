Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025058;
	b=bpAhfdechIzNXrVZ8R1/+7+MLZ3qz95RqghXzHntrA5jbDvvA/t7I/8elsFdZoqTPXN1
	 kgrtIJxkHbYcQJ4Lq95KNtygjt5bX0wTjOgGJF6Uq3pO7N8XF6Opv77lKtr8Q3/vE1QmN
	 NTh/BX6kcugWIZcK+XqmTTXAxv6h6BwVVn8FwPxLQ5gds1YnW6al++picNXmzrGiGCAo4
	 +lzRGnDKkmievBkqaLE0LtwMU6SLyPP8cXujAJ++4MRE18aCjpGUK68NGtpI484o38mTQ
	 mqGcUloGjezTHo11r9OHJAIpJ7kzj9XSsXgVvHDmJbhPnhN91G2OzoCY9OFxdH0OkXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SMtbx1CcLPhDY/5cDVG3krQJ8kiiLCigfrfT7I/6aME=;
	b=zKtCFVosCGGWzLweQGWnOKKnVVKPggelo1YGydw3ZY7tLLDOfVESKorNKddddIRT2XqL
	 s258MO0x0L+qJRf5g2ZdJ+LVjyk4bODKeVq7UCmzrRBAjnhFjlax9BGgsOQcteWkiQFf0
	 emqfGIrts9tcbmPEqq/rf8769PfHnT7GrUTUHa+Hk0kwnmhmkctwKECex6l2huE/FhGvl
	 W8ib+IHpB5QyaDCx43RT1claph8xP5SDkqp6p7tzbtQifS6j7SQYuUD4NVvo379Xlqvo2
	 JAeB3tR5quTdd+vbBAU6cxen6K6EfkClby7lWfz5UK8erxMw2ySzSvrZrCrUsVETczw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDzoDbZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA34D606A31C;
	Wed, 18 Nov 2026 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WDzoDbZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60121F000C4;
	Wed, 18 Nov 2026 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025058;
	bh=SMtbx1CcLPhDY/5cDVG3krQJ8kiiLCigfrfT7I/6aME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDzoDbZErplcZtAAgsS03EOEb+0kT0zPqUBBOW9he72tPS0jey5/IjuYfs9a1/fT7
	 NvMgQpK41ZgJBDFRW1p0lIw1J1JeXXb9dfgEnmR8L04CBIdJ5AKmulrKceAlqQgDbV
	 7FdtDbI8Ut7H8i8cFO6I3AwIo4EUiej+K99JwZoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0946/2151] drm/tegra: Dont pass an ERR_PTR to drm_syncobj_replace_fence()
Date: Wed, 18 Nov 2026 15:44:41 +0100
Message-ID: <20261118150156.932941899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 7fce3d34eddfff6361cb4de2c5b8789b88a552b6 ]

When host1x_fence_create() fails, avoid trying to attach the error
pointer to the out syncobj.

Fixes: 13abe0bb15ce ("drm/tegra: Implement job submission part of new UAPI")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260730-b4-host1x-syncobj-wait-v1-2-afa730410392@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/submit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/submit.c
index f35e5c3ff37cd..43720a69d0f0d 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -655,6 +655,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 		if (IS_ERR(fence)) {
 			err = PTR_ERR(fence);
 			SUBMIT_ERR(context, "failed to create postfence: %d", err);
+			goto put_job;
 		}
 
 		drm_syncobj_replace_fence(syncobj, fence);
-- 
2.53.0



