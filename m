Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208822;
	b=UvdDLKq2FKkCUbgRJK6H499zgs8TBfWp5NFVGS06oW4glWJuy/LWfJTUIZDnt2DK5ilv
	 RL3Jv+p8wKYSSJ7/4h+guq8ho+RacXv5QvROuk9oyd+nBZ/qx74zdQNYjUGsaAtRM+v/Y
	 F0gT54VRyFvIr9ZWaqD5ordTywOYHNj6Hrm1raLXSdZK4fuoLWQeDKr8VKuPrVsfFfw0V
	 6xvPsO2mF8ZuNwGzYov+Ifl2I3tRW5PY03axAjhnIMGLfSyoCWHo70BLit717haFyknqC
	 Mqnmz0lICOzMGtH+RodvzInVNQdDQNg0Tn7QPxH6p7s+Ei2WHE6wxBO7qbZ1dqJLbWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=B7EuYuIO5y8p6eoObM7FKt5YbSYhlAchsunuyfMQ5jo=;
	b=pNdzB5MqwhE5jdQOYAMEwDSVHYOt1Gq0LOsoyEs4rboctFznwd5oIpl5bku9wbbzQKFk
	 TTIvqJfzABiVJ1BMW4OggIiWn4dntymYj609oEqwxo/slSVOgmrr8ooFK0SAWZtNSJq2x
	 ZkYqOuHWobf4AepFrQjyQMYpES5tAvuyCh8OPaDkn2O4WvAw+HafiAt3w2j39CpPCEuvz
	 I9wAnZEGDiDw6ECImEBH3ClriczbyuGzppw9KH/zfkVAirvH4blZUvdTtTpnDgRH8heZb
	 g3oTNbh25XiyE3XTfCUy/XmHIJoSCbhAHq6sdwpX+S0vIJEpBjm5i+tke6Hg+Jf3Xmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkUNVk7S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC86C60A2600;
	Wed, 28 Oct 2026 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QkUNVk7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F8D1F01828;
	Wed, 28 Oct 2026 17:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208821;
	bh=B7EuYuIO5y8p6eoObM7FKt5YbSYhlAchsunuyfMQ5jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QkUNVk7SuWfzdonP4FjSsKhPhGXMjtVquS/H9c/qM3PUxef0XY+4amCKAhN7Ump9I
	 X5+c0yPA8LC+s/pn+mNbzvYk6mVJGjoAYuqIQS/2hC72NBwTrBS/fI941Fw2snC3dA
	 KQ0BHonskxfIyBIemh2DyHBYKISCFEqbdNmwQRfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/516] wifi: wl12xx: Drop if with an always false condition
Date: Wed, 28 Oct 2026 17:56:46 +0100
Message-ID: <20261028170009.511974869@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



