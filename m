Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025061;
	b=puaPq42lwJgWfKycoEcfFLIS2bLn4yQz1DeXk1yMmAx9V5lkxaarhc/yidPQIAQbX3h7
	 M39uA3HP9WnyW9FABuNgRjdfAi9q3Wa8a31WC87qLge9+I9fcE6XqGb12PWGZ9NjCyRhw
	 VMfYbdUFj9dVBGa7VTLn7sMfaEgKWGpTsQ1CWVtDFEmCqxt7QsyCKSEJoXQBNhNhaOjiL
	 Sw1aQMRC4Wz0ZqDeukxdoeDBUJ0l+m28GSJcN28N+pVmI6EMOq1/U/UnoHa1UwR9gKfo2
	 /Fa1/z9agngBnG8z/uMF5sM6QK735Wz7ifFjS6aV1Z39B333xStu21RtA8FuMkHfkIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RCU8MA18xX34bNC3OSAdSDkFaBRPlQiU5zfxkXJI6Ic=;
	b=mIh0rMUkkseEzeiol/8GvRmfS+6IXMpjgvYybRudps6rcN6MpnurXeQR/tLvTtKeCxEk
	 acLcNdFYxu0OXzUqxdF+RxurhAIKC1dkLqkMWFZN/pcB+Xh1xLEj6+CvVtQioGPOwtbfs
	 4aXsWqZi4qL5MxyevZcU5f02/uPEnVHND/i+Cz/9c7ahFsFzOtHL4n6UfH+/QlCUX5yVQ
	 exvhQsg8i9F1jOoZ8OJH1EKuX0xdzCIWKB2qGj8E1UBbr5I3+y3KSeY35JXTrLvP6QdeQ
	 JcWG2LaQVgng6o95hgOGrrDXhEvR0Hw9WaoFWAn+7eXDdWJqVYdjjqsh4IiQeTfUWUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0eZa89w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41580606A31C;
	Wed, 18 Nov 2026 18:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0eZa89w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0421F000C4;
	Wed, 18 Nov 2026 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025061;
	bh=RCU8MA18xX34bNC3OSAdSDkFaBRPlQiU5zfxkXJI6Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0eZa89wZFY4/ne22aV9QSHa+qD//uOfwaHPOJaX66bQI/XqxOiZJXC50SVLo3ZbQ
	 1Hm3Ka7xp9Aks5b6fxX2GQALyEP7sWT9mQvGTYyZAWsrLNMzpcyioT+iX1tu8/dM6M
	 +j+yVYND22cd/Lsxg6J63cArGnJ5wMEbSInSdq44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0947/2151] drm/tegra: Drop reference on postfence
Date: Wed, 18 Nov 2026 15:44:42 +0100
Message-ID: <20261118150156.967244310@linuxfoundation.org>
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



