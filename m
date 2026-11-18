Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048972;
	b=aeoD1+DizO4a/f86JDvZRvPRh2hrgidbexKTAK/UWCGSnpBYFHtQ110rd36d5QEoZYDr
	 6JtB2eI2B+kBVIpC/fvcQ5dWk7ph4MbiZrKfnSFBrj5IwrmOudzo97tpNPOhi0aljP1Dm
	 CqLhF67kpC4G8v/xPKDyperjEhiAmXkX1+SY1n5YQqcsqdh42oiwYmUGeyterzsfw9hOd
	 ANhZ6yUWb6mlCN9HicOPSkHrYMhLEuCr97CRMa7qSZnhfVxE2UwHVBPwFNnbZIBiARTun
	 C0dSXnaMjCfdd+URt7888iKnHus1NH9kPPmnefHuKg2doQ51zEKquS+sIw+3ds/OIYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W6rKeN/GnKk88um1KxfDekS5Th7M6wXTg1bq5UYWxAM=;
	b=TJhpFFnTsDVxmUCBGUmgThZmiQHWqgB7BCqgA805XFecCjW5DF150yQNjT5sTTC3YuHr
	 d4yERq2tgr02VS+Z1eMqquAIJxhCGjOrPOCHCjIy5XHdai1CnmP1YA9IYAqJMJ82dJ8U+
	 moJ+8XmHktiIKsMTMZMTaXRb8vWHVcC5u7eLMC3wSImugB9J7ndEtvClG8CSuCN4pHnDT
	 eC+Gnme1cslKUt46SjKFAWPA5N3DISYlarQD9Kx1Ef2UOgelsVkAEAbh67/JOZpWolqZD
	 9fBFH1HxRrNgOoWAH4NfU9mtzjrL5gWGz0L6Tqbj51tUFwgzbI5RBEdc0+cJIeFbdDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT2owDWw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EDC606A320;
	Thu, 19 Nov 2026 00:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT2owDWw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA66A1F000C4;
	Thu, 19 Nov 2026 00:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048972;
	bh=W6rKeN/GnKk88um1KxfDekS5Th7M6wXTg1bq5UYWxAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qT2owDWwcnm06VqIeFsCmw6YYBVB0qPrZvb7JNHBd1IzT86z43HtFxWV3XuMySMNo
	 /WzaoMdX4Uzha/6B3+J14gIZWxpYVaQCKB8v3x+EhKC+kKR2xDgj1ajCG1pU/1vXfn
	 cNkJajCHtZ5ooiFW2l9TbGyukjoWPk7rRMQaYewo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2168/2857] drm/tegra: Drop reference on postfence
Date: Wed, 18 Nov 2026 15:53:22 +0100
Message-ID: <20261118150319.463000474@linuxfoundation.org>
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
index 3f2253236a606..af0c5632a7bf0 100644
--- a/drivers/gpu/drm/tegra/submit.c
+++ b/drivers/gpu/drm/tegra/submit.c
@@ -672,6 +672,7 @@ int tegra_drm_ioctl_channel_submit(struct drm_device *drm, void *data,
 		}
 
 		drm_syncobj_replace_fence(syncobj, fence);
+		dma_fence_put(fence);
 	}
 
 	goto put_job;
-- 
2.53.0



