Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030686;
	b=JOiyIqXMbNeJBwKI+gZmp6+LCoFdudEn28xP85np8BBntcWJaE34M543fqAfJYDs8JUu
	 ZWw6qKif62cc4r5+ZA8yV4xXb0Pak1SmuMIrOSnzpeHEqwQo0tCBAgK7H/71ScG1I8FKX
	 mysSB9OEIFKaI1pIIqT4rG9mRU/U9e9pqySg497CgYgrkVl0nU4iRLTgE96Yj3IMjOi57
	 zKFrhXJdbZ2Glve8H2bcGdKXBMkSWJQl4n9EKuYvN9I7v0cTEvfkfNzFlZHygwxn3xhVX
	 wVSe+d8beKX8sgA0aakbOAl2xyUNMhR6p/PTfdxc/j01MX025REWl1xOU/GpJs+M9/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rqUoF4UpZlq2uCRXS8EHCEBVXV9zyYEm0pnrBTVgO3g=;
	b=jnlSqZqhWdMwo4t1x049avxFiRAVuzHyxhSZjxyTdBpyPfb38MpneOai34WIYBfERwrp
	 USRgLHW+4esJMt8HHuqiAaZb492gAQSFTsv4gbCaIBRs+8v9UJvXMddG++LU7I08wDT1M
	 cvicKlKT1LkXG7G62QuLojeuLWOfaaHTBXd4anndbn8YqBL7V3ShZGi6y4D2rghfCrZd5
	 cgwYrIXYYRjMb/k3d01EYdj4TNqFa6E9pTc/oY65lb7Orun54xkAiBzF2L6Bwem31yK+X
	 5c1z7eMI9kjd5xv/MqSTDbwy6gpTuNJ3Fu9SQbucMfxjfQAZ39AXKuwj8eORawcA0qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSrltf6h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010A606A320;
	Wed, 18 Nov 2026 19:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oSrltf6h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAE91F000C4;
	Wed, 18 Nov 2026 19:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030685;
	bh=rqUoF4UpZlq2uCRXS8EHCEBVXV9zyYEm0pnrBTVgO3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSrltf6hECUj8YVbKPX5r4cQD3TgP7JNQhmm6CeDlNvRaIgfrzFDRLtx3+rqH+jl/
	 m1d9l3OEEg2h0pteo7cJHDeWiueQlpUjmMDzw03JnRMX/SkQr7VyGxtlhGI6UT8jA3
	 3sq6+UPmWNKma++TIDfad48tkHVRHu9vX1SETY6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0750/1756] drm/tegra: Dont pass an ERR_PTR to drm_syncobj_replace_fence()
Date: Wed, 18 Nov 2026 15:47:57 +0100
Message-ID: <20261118150039.435354952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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



