Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018157;
	b=YCsfTitE+NA/soOMZpEiM9FZzw59GGkE9get3FZyb2IyJ0xhJSUrYTgxpSF22rVkh426
	 kPvrmv/jGzzVRY5fDRi7oWk/qQbUEz0AKvu6MgLRvP4FAeG6UyDMTtUnLRVHSQ1SnVxj9
	 zLb8+lDGaJEJvIkdxLEz1lyDGLilybR+JKqAAEEUEr2x1aS+WMF5wdPIc+KEzz73FKwDQ
	 ryXmpFWNHqMz5Vf4V7rKBfQWG64Gdobaq0lnif/yKvGt93NFTxrgOx6m/2JIVkZ8noZ4Q
	 zW6dA7qFNWW5fjJoeAzGUBdCudjzPrKLgxXZu/m4poFSPMmz27PhSvnugiaG5LCkFDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fyKQM7Rxaz9Bpl3zVN87fsC8XcbbgJOicqLqzyFB6C0=;
	b=dg1TffhBVRo4FgbFrsGamsIt45qGLHwho88McN5QVLxD1j5eT9BrtOmubVWccVL0EtN/
	 4ssJD05Gh3vvV/uP+ajzvV465Ml048HzUt2D2lXIOoez+95VRIrNCN73gqoq+6ldeLjXR
	 /DGou+AJ+PwfywqinYGjNgDHURZYPiCAXrPxz7LylCKt4qdd+fLzTwsb5vjXuhy/NST2F
	 6z22AwGu3XoTQNF/qOad5a1pm7SZZXIzyjgcPGUUvfHPosu5RNlLRJEwyYxLuefUlJ38v
	 iz5I2U7MJCgegpmZJYAfH4DMsXQ7ln3BTERP94eTytrUa7qy9Q2SNUaMAc9XxqO1Dng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8PGWbDz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626B7606A31C;
	Wed, 18 Nov 2026 16:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8PGWbDz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45F21F000C4;
	Wed, 18 Nov 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018157;
	bh=fyKQM7Rxaz9Bpl3zVN87fsC8XcbbgJOicqLqzyFB6C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8PGWbDzzt7hIXnlgDMsJi+ZzN6gvuiDYca38Y5VwwKJ0KkpCW1/oxj4dsJz9bAOo
	 j2YfY+YIZ2IWia/TTALg07QBxRKoMqfra1ZiSGKJFem+fP+2PKPHJ0pj+XXn/jRieg
	 qG1y9BQ9u972w4gs5iu0FrrIBquLsu1po3mPEcOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1141/2651] drm/tegra: Dont pass an ERR_PTR to drm_syncobj_replace_fence()
Date: Wed, 18 Nov 2026 15:39:41 +0100
Message-ID: <20261118150329.084735346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5dad6dc4eb8c3..3f20b5a244476 100644
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



