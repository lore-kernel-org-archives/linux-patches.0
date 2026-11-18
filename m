Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030688;
	b=Ou4Z69uf+Vr6jA16hPdIBDo3vacKzWVRpuWpyze4162b2gkdGCb2tBo98XXQWuJDWDJw
	 iIcmbWY6NYELiqMXwmidGsPyTzFs/Fg8k22+ysbDP6XW7kgpqqY0p1jbiT/M9dA28nMkV
	 MBl/ylnxoDkVi9uFUab0XbOCMakBfCNqrfG5SMarXFf/m0r/ddfiqJuQf2nwAg6pRxE1u
	 QgphrGHLTZcpok0ScuSSu7MrqtC58y+SuXEL9/qjsoOQqVugJpjlu3+NGV7DRq1LqHN2E
	 vXhmd+k9gveC8G/XMZzpMo5GLvMV4yN34utbYwlLcET05r2rHdwkQN9rSD0hIv6QmsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eoXwbSC5WpsK+yNCLpiPbPcN9XQLzPUIupUBcX59HeE=;
	b=o71OZ6SLvG0o01A5LY3N12iJghwGRIwMFjiLek3OmVaSXUhwQewkOYj64YbWQ/XuwAbw
	 sYAiv6nOsAr2R48FAWDjk/92/zSPhsWJ8E5O1mioNibNxPpOGicKDvsLSeAg2gutIdkWP
	 oAXb0KxmYIBIDU8jHME9JX67krZVUjOZn3b6QocORcCwwlxFxoZXAs94bQP2E/nssv1ge
	 hadljMTI/2A+tkMHNJQB66MSbr70haD4kDQn839sMPltuVl5wFvsH0vuIEtvZSqBAbhtL
	 Z/oNL9gFEzOgWSgFtzIQrJUbmmwo+K6ctNFmCF++L2nkL+3RsoYpacDgMu9EcloRFVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qsv7ek8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D041C606A901;
	Wed, 18 Nov 2026 19:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qsv7ek8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2901F000C4;
	Wed, 18 Nov 2026 19:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030688;
	bh=eoXwbSC5WpsK+yNCLpiPbPcN9XQLzPUIupUBcX59HeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qsv7ek8rH4YNK9dz6nICi8I77CvrAudZtjTobdfNu6YMMb/ILCfLoxNLusjQt+bQQ
	 bAXUkPk9gXi2N9WUffsoWabkMkq2SOWE9qhYn4ivle+foNuciUyMQcIaUGTqn5JH+4
	 o7zzOSJT0ynQGAcQ5UExZNTsHzsTgY8pxkXm0xS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0751/1756] drm/tegra: Drop reference on postfence
Date: Wed, 18 Nov 2026 15:47:58 +0100
Message-ID: <20261118150039.488057117@linuxfoundation.org>
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



