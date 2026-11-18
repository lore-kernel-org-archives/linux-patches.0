Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055631;
	b=jHHlrfBCEndNU8yQRCKTPRkeSq0k9X2/AzlMRBelj1IFZv/jBXdKBeljJCl8Pn8+0OYJ
	 aRQxH0gGhEcfXT/KVx48TddZLVQ7TOTLOF4/1AvIPk2fEIhHGEhCt96TdzXyiFCsJmfH5
	 ehvdZtgBUqjoqVfZoYwvqWa4C3+VnfC7Ouf0BaNIqraju6jLRxY4kH1Qv3UDRYgroog3R
	 1SQCTTr/kuDLtLFkm0fgMBs6R4qDldABrwWnYvINKIkuRQy3SUl8XAxIk73Y3mnCI80zi
	 45qK7YevDlGwRwfcMck44iKvkyqk67mlCJXAF9biOtLfOsf1Ow5IAJcw/9Y/loPvvxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ECwagqoFMBOTegvjh56ui43B8FO2mcP8JPqi8T7krfw=;
	b=XO2MTcbGGJlVfkDtVNHRDjiJ8qQhQz+6fAY7xYNEhr2IR5IontEpVaRwh7f8csDnRn6l
	 2VYQfoiOP79cDmKa4VrJ2NDZHM8qyCvW0VjbfeYaapgnsyxg7zgyAuANCNf1G6+qFGc8V
	 tM4Zn4Y/ELWM+ykOM5O278PRvwFU14vzgBd3VZ+49Fgpelkzh7D6bYCWoY+Mtwc3pC8X9
	 y+t1AI9CTRFur7914xa4S6H+TDX7870hvhwkUjuQNIyCcgOXfob4kNd0siuVQWs0EWwZl
	 fdM3k0NM5ApVNUvwN0YAsOnLW7Vg60BNfX5OBHf0CSfm4OmHXUfm829mNQ9V1c2cQtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7unRVrJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20D60A2602;
	Thu, 19 Nov 2026 02:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X7unRVrJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623AF1F000C4;
	Thu, 19 Nov 2026 02:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055630;
	bh=ECwagqoFMBOTegvjh56ui43B8FO2mcP8JPqi8T7krfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7unRVrJmuvmSl6BlhLoSefJgYd6WtXl8ATa+fBhwLQnxSMdO1rH144txRArQl9zp
	 /0lBODWjcDH2oBtPj6B95YmCYrCVXFLjZY0vDLsAzt4jnEEFO/j76kqmqQ5eT2b+hK
	 UAAdu7RUf8YE0NfcA1knI6chv25/upHLTyt0X4q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1700/2214] drm/tegra: Dont pass an ERR_PTR to drm_syncobj_replace_fence()
Date: Wed, 18 Nov 2026 15:56:16 +0100
Message-ID: <20261118150119.808095233@linuxfoundation.org>
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
index 45f0baeefd555..d5f274018cce5 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -601,6 +601,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 		if (IS_ERR(fence)) {
 			err = PTR_ERR(fence);
 			SUBMIT_ERR(context, "failed to create postfence: %d", err);
+			goto put_job;
 		}
 
 		drm_syncobj_replace_fence(syncobj, fence);
-- 
2.53.0



