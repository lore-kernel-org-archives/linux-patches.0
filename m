Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048969;
	b=juqTZB8zAclm5bilXuwyyuhbhJveKk6l4kKSeIxrqTNENdPQ4IsmdCxVEYNpwiH7608k
	 G7LfI0OWPYSr8mvhwoxa1sm9GLb+kT4+dskvIpiY0W9HASQ2qo9YgAnBLsxT4jtslz9DI
	 UtIMd1BK5YdhlOBohtSN63xxQnGQVA3z8xFXqkYMjK0xywiIrelUHhrOk1Np1Fhk9RuR7
	 e1oM0MkqAJf8Je9lw8t67ticsJ/eeg38MjoT1YBaCsvJ94rJzDBqy8qFr1XVZNP3GSZoZ
	 rWgAWv+Hv7Lpt81qQCP1IgGNBCu+y9Zo3YZ00nv62tiOFQVxYB3jrJixrnpo1to8N8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zLhGjGDyqEJkpWrStAf7kslft5R6fI8irk1thAbmZaE=;
	b=y63Ua250vybTfjf2Y+3sxndUHcshESpQPgQfQ7f0i3+5ds2oZyGG6FOs6zKiCPSzD64U
	 o6w5ajv9e5aTuTAXjIrJ1tTYERAAmJ+arbRNzmMzDrj+MH/mNAlwBOinClWZ2oAPG17v9
	 /HlCP1O+Ye1AvNT287OAHl+PBCxrj4s/iQfgo54lWbMw+a4bPN+G9mQIAPjf+uxYP/bbU
	 DeHq2450TNm2Jj9Q4uMlXVF2lyFD+rj+jw3abyj9rQInbnT0TT7iLoFSuYvGm81y81u8M
	 1EYGU0vtnhG5xD9f16OP3221K2uzbQn2SkJ/fSvg70HqhmLTth+QuyNBXP5JlcTQm1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/dRzzQ2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338B606A325;
	Thu, 19 Nov 2026 00:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/dRzzQ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1408E1F000C4;
	Thu, 19 Nov 2026 00:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048969;
	bh=zLhGjGDyqEJkpWrStAf7kslft5R6fI8irk1thAbmZaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/dRzzQ2CheDKbrOF+1tdbKiybmVnphE06SR/PvySjKtdbr7lMJswJsYuHrlVbPuQ
	 jpt+tnotjaDI8nRQnFzIj+ppACRYNYhWKiaDL9Jm1C+WImuTlEIUCGv4EnGwq2i9pQ
	 sqJ8M6+Gz7sKam7Ff4/ExQPD3brUV3MK+8bsm4VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2167/2857] drm/tegra: Dont pass an ERR_PTR to drm_syncobj_replace_fence()
Date: Wed, 18 Nov 2026 15:53:21 +0100
Message-ID: <20261118150319.426681893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 31b54bfb5c9cc..3f2253236a606 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -668,6 +668,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 		if (IS_ERR(fence)) {
 			err = PTR_ERR(fence);
 			SUBMIT_ERR(context, "failed to create postfence: %d", err);
+			goto put_job;
 		}
 
 		drm_syncobj_replace_fence(syncobj, fence);
-- 
2.53.0



