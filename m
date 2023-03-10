Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF9846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAEAC4339B;
	Fri, 10 Mar 2023 14:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458684;
	bh=ILhp9S1UVvgreZ8RR1lU25VNZdOmPTZWl8fs9Pw82ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WyOfLbr01DDjAmA51YDvDZuaTEdd2nsGDXXgKU6hU/2J3r3lItA5RWkbbKuKtXKo9
	 0yoH1Slk1n3FJpntEA2Mmv9l3Pfg+vEG2HNUa5iyCcFhhh5hcTzSC5kv39YBf6sGbi
	 JgZO+fFC8r5Bh26ktDJQAclQo7kjylHkKcqUahNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/357] drm/exynos: Dont reset bridge->next
Date: Fri, 10 Mar 2023 14:36:39 +0100
Message-Id: <20230310133739.506125222@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit bd19c4527056b3e42e8c286136660aa14d0b6c90 ]

bridge->next is only points to the new bridge if drm_bridge_attach()
succeeds. No need to reset it manually here.

Note that this change is part of the attempt to make the bridge chain
a double-linked list. In order to do that we must patch all drivers
manipulating the bridge->next field.

Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191023154512.9762-3-boris.brezillon@collabora.com
Stable-dep-of: 13fcfcb2a9a4 ("drm/msm/mdp5: Add check for kzalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_dp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_dp.c b/drivers/gpu/drm/exynos/exynos_dp.c
index e0cfae744afc9..01c5fbf9083a0 100644
--- a/drivers/gpu/drm/exynos/exynos_dp.c
+++ b/drivers/gpu/drm/exynos/exynos_dp.c
@@ -109,7 +109,6 @@ static int exynos_dp_bridge_attach(struct analogix_dp_plat_data *plat_data,
 		if (ret) {
 			DRM_DEV_ERROR(dp->dev,
 				      "Failed to attach bridge to drm\n");
-			bridge->next = NULL;
 			return ret;
 		}
 	}
-- 
2.39.2



