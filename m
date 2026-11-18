Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018160;
	b=dtRk7Hm3mHfmAfDsnTBf0k6khqS2P0pV2G3YG33OCbKTB1ooDy4YsteKtfQck6pbkAyg
	 dx+tnQNaSnCHqqbhZ8li8NTvoIaLaWuzyolJKUXMqySpdbrN0vTH6WN+CcqG65TACTZ0I
	 yNuif2VGNThKUsYIitKeS8icAM5pCImqVjDhA6AYMTbyRqDHDG4lFBRGJ9LW7uGLeR5aB
	 UXXBm8X2UIqcZIqR5JRkUVvgbUCU1WD4F3HDmVkTXAaA1dIQYRnexlG+yTQnlAx70cE7Z
	 CKM7nvDjAseVv1PkQGsFUk7J2fTWT+hC6BG5yJg1RuwVvvFqlpbhNJVprVZ1wXcOQ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sQ/r8igawvLMwuUD+O/X3nZ2dHKMXHScXw3475j2JQM=;
	b=pKUcVxOtUq3zZNm7OwM8R8Ebr9wG9Wy9mOARIbfrZUzYayyC26fXaizSUlkmjpWzh+Ug
	 kEfY8+AkJ70VvFD8QFUky+llNU62BbtTVX0C4Ym1/c3FmLAmgo06CB8Q02J3hbltJCaIi
	 x3IJLwiEJruZFcuB3BOnYP+HZ17WgzRBE03/mTjH5LFBb1scUx8rtIIBXz8vE0KdUgGxV
	 TYBor4rzvdyYM42zTxJwQjn40cATTduaXh5EeCjWp7Hj3mwLDGm2O5wLS7K4l6da2SKht
	 EzsrcMiVTB179T5ArUOG5EDoQzlU/WvC6NJ9C9Q4rHhz4ouTZdrzbx8/xEH/nbuY3nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gusuTm6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2341060A2600;
	Wed, 18 Nov 2026 16:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gusuTm6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799F51F000C5;
	Wed, 18 Nov 2026 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018160;
	bh=sQ/r8igawvLMwuUD+O/X3nZ2dHKMXHScXw3475j2JQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gusuTm6yuPcdJE1wHt1bbchyoNMvgKEFc/pvSvy6dgflVSN2B+lFoyML6H2oH1u20
	 xr/tWcGD7Vr4E3+QVTq9ZuikFnHD6v8rPgoI7KOaUCKnXkTFH0Jdxegg6+FdFzIZTo
	 ghoAXzl/IXcnt5HN3WpmrHsgHbYCnORDr8Xc1Etg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1142/2651] drm/tegra: Drop reference on postfence
Date: Wed, 18 Nov 2026 15:39:42 +0100
Message-ID: <20261118150329.119316079@linuxfoundation.org>
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
index 3f20b5a244476..658396f2e9549 100644
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



