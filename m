Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040573;
	b=vopHTse9PtUOemUF948bMHCrQnT6fqHvPcqGfRodFDkf8uoRmN7lAJx8Xc98UJitpfWF
	 9laeRLbxxZi6xIY6pxy+ep88S/0dxxkizPL17SekNC/DOO2tUD5mOG685UC4bnP92ecEv
	 TLBona1Nqzhce6Igg1cGuyhjNbQIHPbQ13BN+W2ziZQZSPzNHvGRrYxlsLarfdQ/4hA75
	 eeH/qD+VqS7O2iowctIe38cZMKOMSudpIGTAP3Cz3thqFZyAnAAPsu6GYEa8jLNMlHNgW
	 wngCYCZMgI8lLjmN5zuzZmcC9r0RJ9wXqSlL+6M20vl3LzCBO69f7H1xDIk7baX+eCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=69i9VTKd6+e8dxb++RxicS5vaxXJLbSagkXH5gEXa3g=;
	b=o5L4daXhSyQMQ+vCcdH3t0aqR5DMNI26J1YRpbPpm+OwWJqRPWjnZ0eOkGMQhBe/p7W6
	 95UFO9ly7L3gRzQTVehShns/MjTp0F1C9iA51r2hTwDSh2zNlp+Q4fSkkzNHDa1zymzfe
	 Bsw1u5ok+VCz3LstnvDYktfXxYzLnOGcA8umV4pSF9d2QXP16geXImTnxR3jBFEoJGd2m
	 6vxbznDdN115KPErC1r4RejUDHe/rX9RpWIJzydgdaNS6Bbu3ykxGp/OVJgETtqdNnltK
	 LGvosboy8csf/pjE+W3x1H6UJlUbJHj9cfZjNUpZPgODpV3oQrxA+CQqDBtRoPAmuHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oslOAevZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F0606A325;
	Wed, 18 Nov 2026 22:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oslOAevZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FFD1F000C4;
	Wed, 18 Nov 2026 22:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040573;
	bh=69i9VTKd6+e8dxb++RxicS5vaxXJLbSagkXH5gEXa3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oslOAevZwkiPRA/nNgfGx5UxX2Esxk8hmqQtuciCjR3/5iKfpmtp5BjgnLyclXR/E
	 o6MRZiagLG5gfg/RUD2MrCuK5f6562FWCAI15lp/HCzSjIpKyyn50008Ki5u1hSKW0
	 c8FnXhWmJ4eCrmpQNyBBxanINhHvPQX4N8vqhuEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2506/3318] drm/tegra: Fix syncobj_in wait return value check
Date: Wed, 18 Nov 2026 15:52:08 +0100
Message-ID: <20261118150436.554221144@linuxfoundation.org>
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

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 27836c46a3db5a7869a9f7e181136f0c4d8bc0d1 ]

dma_fence_wait_timeout() returns the remaining timeout in jiffies on
success, zero on timeout, and a negative error code if interrupted. The
return value was assigned to 'err' and checked as if it were an errno,
the opposite of the correct logic.

Fix the code to use a properly typed variable and check each condition
correctly.

Fixes: 13abe0bb15ce ("drm/tegra: Implement job submission part of new UAPI")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aJM_te551jUwnRv7@stanley.mountain/
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260730-b4-host1x-syncobj-wait-v1-1-afa730410392@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/submit.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tegra/submit.c b/drivers/gpu/drm/tegra/submit.c
index 705382035f5f6..f35e5c3ff37cd 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -530,6 +530,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 
 	if (args->syncobj_in) {
 		struct dma_fence *fence;
+		long wait_err;
 
 		err = drm_syncobj_find_fence(file, args->syncobj_in, 0, 0, &fence);
 		if (err) {
@@ -537,10 +538,15 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 			goto unlock;
 		}
 
-		err = dma_fence_wait_timeout(fence, true, msecs_to_jiffies(10000));
+		wait_err = dma_fence_wait_timeout(fence, true, msecs_to_jiffies(10000));
 		dma_fence_put(fence);
-		if (err) {
+		if (wait_err == 0) {
 			SUBMIT_ERR(context, "wait for syncobj_in timed out");
+			err = -ETIMEDOUT;
+			goto unlock;
+		} else if (wait_err < 0) {
+			/* In practice, -ERESTARTSYS */
+			err = wait_err;
 			goto unlock;
 		}
 	}
-- 
2.53.0



