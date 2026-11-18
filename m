Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040576;
	b=rAwaAq1t8uan2pTR7TrHJJgPRFzwFAoRfu97m2cTx828w0OYUoxII+YctuVNDunDGf+u
	 CoZmzCvORJKwLyJcGg6zxcg8DOBn2iWm9XqNnEUf4nIB3tZzbQVDaoJLtGbNlAdJM/h8L
	 P8amLfSd4XyqdX0dTAQd2MqUhifLXA4VqNfrJH8LeDLW0XBDRGbCJixUTXjb+V0GLwznO
	 ypEx8teE7bwUgWBjt1SzgaObdXv1r8IEQCB5Bph5vrtXAWzdvtg4tqFE5xe2TBCaEhDf5
	 1/5hI8sm2bm1IlVYcvgxJ7e+gWSnEL+xjBt4XANBXTkwwMt6EL6Y7FzxZ1oSsHk0cnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VT5Fdhhxxh4/hFfERpeKYJfepW3EeoB+PmXhKALB2A4=;
	b=cl1beYdsemOLzAelprMeZUDkMKfNBbq/FonZ6rUn9qU71x8ZhCYBjMPCJXmBu7XjCdE4
	 EukHjOTwN4EGvpqZaEHa0Ml1apA7Bo6+FwOl6+aZwkqZhfXuv5zpDfhZGyx6kWMnR2/QV
	 0/nEaHXtjx639X4QNqitNpOjgvWyOh40g/VHSdfBdpn5sIZDxLlxO/+hxxSEnJ6XUDldi
	 R/y3P0Q0ZqaPWQ0NzH/O1zzb7wC5Oa2p4JP3AWM8h40W4k7K358Lf6l/8w+PUhanpc5MO
	 wmOhZ2iJn7c4ko01WN3I37X2wTxnqNUTcFB5QvcgQPX8OFbt2Va3GYN261nA2Gb8aBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtm2WFKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672E4606A320;
	Wed, 18 Nov 2026 22:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mtm2WFKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944E61F000C4;
	Wed, 18 Nov 2026 22:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040576;
	bh=VT5Fdhhxxh4/hFfERpeKYJfepW3EeoB+PmXhKALB2A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtm2WFKThYg/FK6a3MYm/tTrbYQEmaGLtXSgCCYQIjF9f7+kbREG2jFjaRa+VkaeX
	 DtGUkGjt33NZYk5OEAuuHGPBXjcqZcJARVkPPy0DgtvACADF0MVx1EQO3bbLhzekUF
	 980hAby5vSgILl9vm4KjGHB85Tqiyblo2AE/t2T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2507/3318] drm/tegra: Dont pass an ERR_PTR to drm_syncobj_replace_fence()
Date: Wed, 18 Nov 2026 15:52:09 +0100
Message-ID: <20261118150436.583580377@linuxfoundation.org>
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



