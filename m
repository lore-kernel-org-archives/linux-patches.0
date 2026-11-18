Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040579;
	b=kDpT+k2VUPk2T+OqufQB9AomqPUn0473DiqjzQG5JvNcpJ/aJo9AEf/KPG8Ffe+e5Vdk
	 EXRXQgyJLmf1ZgQFjTDLo57IS2DyOQ2/bom8Xa6PIhVjijbQbKRpl8ae7GSSMK5XarCIt
	 VyWlY9AnNCI+uUKDewlue3MWcZHgHhKOeSDVlAOGimaA+gRtHydFt4OIOTDRNje2Ouf8R
	 MgdnY18ND4y4stDhOOwnrNPkcuMdV0xhyj27uop50qBcFxFBzlY5ZAcAM6b8YUml/pRmm
	 xzhNk8ft65ie0Mkj9lxhDJ2IQbTPivZ808ikTHLV8SkNdr0uNlNNNt61zYmcG0wUAbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9xPsqAI8x/Ks6wo79X3+SiUDM7mxj5wxC20V3orSR1c=;
	b=dqBAWH96opGexZruXv90wZk4jf9J0lCWlqVnWJZ6+QdPY1SjMQpkeavEo9bHxuCSa+yW
	 pV2AuPJ4NvYGTYbL7HEFmrBg6gwqVLY+c/jlyUivGaVPJk+fXyZg8mZngKmfCD/9EARZO
	 zfjEFPKOBVo3CMiCWWZjadZ2oRalBDx8P/Wyv2ka946QbFq8LczMX/3h+EAIggFGQhFG+
	 Cfrf+BIzjWTVZ+GSlhpbNIy6ORLfP4b4lP/JdeJrFAhiurXSA6wAeHVhkJ1I39alVg6M1
	 5Tbp95XpP7PDe1dIxlkmKzF+JsaHH8KnDROskC+0pjDYsT48WXbZCE2PchwW9YIPTwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6R2RRdt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4E1606A31C;
	Wed, 18 Nov 2026 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6R2RRdt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E19B1F000C4;
	Wed, 18 Nov 2026 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040578;
	bh=9xPsqAI8x/Ks6wo79X3+SiUDM7mxj5wxC20V3orSR1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6R2RRdtP5dQVp1QKc5NOW1IgsN1QLFOQr4FMdE+C874E0jZXVrjKZ+lOZU+Cq3VJ
	 eTwueCcyp+IaEUQ/Aqy1UyuDl+BHYXdzbgXhMBTx6WhTkqYL2nybUgDOZM/NuJXF9J
	 APROypU4ivKA8ojhQpJFx/YlgPY4zN7KOekV9w9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2508/3318] drm/tegra: Drop reference on postfence
Date: Wed, 18 Nov 2026 15:52:10 +0100
Message-ID: <20261118150436.612001725@linuxfoundation.org>
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
index 43720a69d0f0d..fd88e28124f6f 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -659,6 +659,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 		}
 
 		drm_syncobj_replace_fence(syncobj, fence);
+		dma_fence_put(fence);
 	}
 
 	goto put_job;
-- 
2.53.0



