Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211246;
	b=DAwZhY6OrkwXmvrxeAbcmX9swH9uVBrQvo+4Xb2q5XKA3fRhl/QytgvucoMNh2LzJEWU
	 Z8aqYtNRzLg9OMKxOWuGOeUvyH6arA9zW/6k36gRHn7HRC8CF9Wp7Tn0MGLhqmfjP5YtX
	 Byf+Ls12MnpqUbbO41iQoEbz4evyq+p9563Hh78CJH9/VRGUl9U4v1oFnEMkbQaN4qkwF
	 ntNr8sdtc15oe2hUDpMqBDsQPb6gjlf6TgdZp1ZgpiSRv+7pnsejFK+pz02D5d3Jg4JHY
	 6zWyB2Cq40Rt6/Mb3ifduJ6pCveJEHbdzh1J/0gGBu7hs/nQGqBzfyVQLRoTO2T6x7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=z+lJQvf9wNiQVLMi1sSa+Uj/xUaCHLm+RtZ5Tkcz6fk=;
	b=pcX4GLar3NZkjOTctZf+MgM+icSWnD5TfvcHuN6BIllWUgzLF8BsZ+N5LwkdJXBWMJMz
	 DEatOg6fE5L0882M4F+nFxERhZRd9lucRAEIhc5hz3diF+QFkf3Ab6Nj4bVGqXBjoq1SY
	 7ODtXiAXJ+Sa2UTS71ABt2XZZ3rm18qtbMxgByumw0pY6Kd7ttX8iAbM3ZcZL6U6xB6Vy
	 jpjAaOHN25lxMcIFwV8kq61zUT7oQZLRQa36cjAN3yT51Ms4CNiag8ycLcy5JKrQJ/pqd
	 Y/1MkPRQGSORRv2XzAcXooVel3IDLkw+Qyo0UJahoRaM2rBFqhIONIQIvTl+Cj+XPCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EZL/RkPx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC96260A2639;
	Wed, 28 Oct 2026 18:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZL/RkPx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E641F01825;
	Wed, 28 Oct 2026 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211245;
	bh=z+lJQvf9wNiQVLMi1sSa+Uj/xUaCHLm+RtZ5Tkcz6fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZL/RkPx1XOg/MEs4D14TjXhApAGgrEU7PBKiSqgmIFjR/4JgfK1jtza+5jygtS1q
	 T8kINBu3nSQ7vDIp8cJ45U6SyqYciTc2iHLNid6B6rm6rACTgIUi9HaXWmKK11YuYQ
	 GcafCTgDbxeNtlH0D0HXDDHqX4MJerlmOcfOGwZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/571] wifi: wl12xx: Drop if with an always false condition
Date: Wed, 28 Oct 2026 17:57:00 +0100
Message-ID: <20261028170014.479610877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 69ddcea564437ce4b0d5143f37a9154fcef8d3d2 ]

The remove callback is only called after probe completed successfully.
In this case platform_set_drvdata() was called with a non-NULL argument
(in wlcore_probe()) and so wl is never NULL.

This is a preparation for making platform remove callbacks return void.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220715224619.ht7bbzzrmysielm7@pengutronix.de
Stable-dep-of: a8b8881d0c1a ("wifi: wlcore: Fix runtime PM leak in wlcore_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl12xx/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index c6da0cfb4afbe..d06a2c4194479 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1924,13 +1924,10 @@ static int wl12xx_remove(struct platform_device *pdev)
 	struct wl1271 *wl = platform_get_drvdata(pdev);
 	struct wl12xx_priv *priv;
 
-	if (!wl)
-		goto out;
 	priv = wl->priv;
 
 	kfree(priv->rx_mem_addr);
 
-out:
 	return wlcore_remove(pdev);
 }
 
-- 
2.53.0



