Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211269;
	b=uzbCugyn7hSVfg3iYkhyFgioKp9zQehVlTRS/Ddl0CJYV0xZLSzCwDXlZE8sSnpZKr62
	 oHr0y4SDgH1QByh9UgkdUP00CY0oMDjjiq/a4QsFCclxuaDvh6GU0KeGKo13b+iRP9IeM
	 3oleLk1b87cT8TE044In4KFc3764hKATciwjZABtKlM/H6GNFa3cp3M2aS15W8o4IJlYp
	 UBlUnZMh8DWBYCtrtJowOssQbSmJhQAhr/WQzPd7al5kME5lKyhg6PDpjqshgh9MtaDoN
	 CNHqUguDKiNEQfeFjZ6LggXP/N7BFhkN6mflYrZvvNaN4JCZy4sWCUo4uc8yWpssdDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d7GZHZn6J8kPzl+vrLae30F9D8TR1K8GUYPILp907K0=;
	b=huAZushtAgXxe9poR6quPqigNXKasZyhuRkRVy04yuKcMCeytGcJ0UnFe5T1kjtFa+Vk
	 bg001JCAk3P9Snk9lg290ROFiZHTYUt0Z/iln5qNKztXuCpNCHiGfukXIZfDM/kvuDr91
	 uBdlfv6fuZpZ/mGaQ1xxCiUW2pb2fxmKHYs9Rczm3Jukx90H0aZCZQ0Crw+PggObjBh1q
	 SISFQK+L4Y58eLaXGeIp/z5VJknFMznxaknAs9ZqwjHWwHhepA8hpSwuaQXy6DdHm5Ik9
	 CgOxwjuH4FyU6UKo0IvyO2akVTFx0tZwjJnyahRCQ+QqtxvGXjTAPBD/SFSEClBFXNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ejPT288j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA9606A31A;
	Wed, 28 Oct 2026 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ejPT288j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3408A1F01829;
	Wed, 28 Oct 2026 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211268;
	bh=d7GZHZn6J8kPzl+vrLae30F9D8TR1K8GUYPILp907K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejPT288jQkBo4MEnDPBvCr0KvjrIBv35PtBrnaAVO1P9T65Fs2lTJxsw5qu/6BfCL
	 MSRIbNqFM38s4R4uaXxPJq+J8D+LNHVphvxIkkt0ksj8CJkB8d/6JLurCUFxiwtW/N
	 FzU8gLkIuIxRjzQx9m6a8TT9IsDnrqj81JyDcHXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/571] wifi: wlcore: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:57:01 +0100
Message-ID: <20261028170014.504837527@linuxfoundation.org>
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

[ Upstream commit f00928012886a07ca6817ea70eb4856ce280ce05 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code.  However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

wlcore_remove() returned zero unconditionally. With that converted to
return void instead, the wl12xx and wl18xx driver can be converted to
.remove_new trivially.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230912171249.755901-1-u.kleine-koenig@pengutronix.de
Stable-dep-of: a8b8881d0c1a ("wifi: wlcore: Fix runtime PM leak in wlcore_remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wl12xx/main.c   | 6 +++---
 drivers/net/wireless/ti/wl18xx/main.c   | 2 +-
 drivers/net/wireless/ti/wlcore/main.c   | 6 ++----
 drivers/net/wireless/ti/wlcore/wlcore.h | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d06a2c4194479..de045fe4ca1eb 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1919,7 +1919,7 @@ static int wl12xx_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int wl12xx_remove(struct platform_device *pdev)
+static void wl12xx_remove(struct platform_device *pdev)
 {
 	struct wl1271 *wl = platform_get_drvdata(pdev);
 	struct wl12xx_priv *priv;
@@ -1928,7 +1928,7 @@ static int wl12xx_remove(struct platform_device *pdev)
 
 	kfree(priv->rx_mem_addr);
 
-	return wlcore_remove(pdev);
+	wlcore_remove(pdev);
 }
 
 static const struct platform_device_id wl12xx_id_table[] = {
@@ -1939,7 +1939,7 @@ MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
 
 static struct platform_driver wl12xx_driver = {
 	.probe		= wl12xx_probe,
-	.remove		= wl12xx_remove,
+	.remove_new	= wl12xx_remove,
 	.id_table	= wl12xx_id_table,
 	.driver = {
 		.name	= "wl12xx_driver",
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0b3cf8477c6cd..d4a89401f2c47 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -2033,7 +2033,7 @@ MODULE_DEVICE_TABLE(platform, wl18xx_id_table);
 
 static struct platform_driver wl18xx_driver = {
 	.probe		= wl18xx_probe,
-	.remove		= wlcore_remove,
+	.remove_new	= wlcore_remove,
 	.id_table	= wl18xx_id_table,
 	.driver = {
 		.name	= "wl18xx_driver",
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9856d92f84a47..28022749f5d6b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6803,7 +6803,7 @@ int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 }
 EXPORT_SYMBOL_GPL(wlcore_probe);
 
-int wlcore_remove(struct platform_device *pdev)
+void wlcore_remove(struct platform_device *pdev)
 {
 	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
 	struct wl1271 *wl = platform_get_drvdata(pdev);
@@ -6818,7 +6818,7 @@ int wlcore_remove(struct platform_device *pdev)
 	if (pdev_data->family && pdev_data->family->nvs_name)
 		wait_for_completion(&wl->nvs_loading_complete);
 	if (!wl->initialized)
-		return 0;
+		return;
 
 	if (wl->wakeirq >= 0) {
 		dev_pm_clear_wake_irq(wl->dev);
@@ -6838,8 +6838,6 @@ int wlcore_remove(struct platform_device *pdev)
 
 	free_irq(wl->irq, wl);
 	wlcore_free_hw(wl);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(wlcore_remove);
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 81c94d390623b..1f8511bf9bb35 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -497,7 +497,7 @@ struct wl1271 {
 };
 
 int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-int wlcore_remove(struct platform_device *pdev);
+void wlcore_remove(struct platform_device *pdev);
 struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 				     u32 mbox_size);
 int wlcore_free_hw(struct wl1271 *wl);
-- 
2.53.0



