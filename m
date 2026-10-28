Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215948;
	b=ZsoCu30vE3cpxUdI5D+MeLyR3w+cFquWhj3hcmtUNA5r3LCq7aCEYJGKf14wrfUW6iX3
	 3wGhmri6kDnhzqGnkjL7lUzBJs+RLFoq2sThQON/gKMg6akJ91Vr6PbJev7k7thxOv4hu
	 Ca1ZhMBuzxT2QNTuFu6mc4MpLXdmJ3QGmBcD6Bozm4wCxaKId9GW0Qkg35gbjyOYCOjyS
	 cVF9lcNF16pxtXJC5k+56ugEF8rBmU+H3u5KFJ2WwtLyeX/XDfI22VKkNAKq225hC/25m
	 4NHIoadCOliYdvU7eAyJcevIomUEXK4qZtVDm4w1yfzgkyWxTq7MkBue6LdxfycxuLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VqPrqLasl80d7sWI/r/cwIVBeas1uHx9b1a9uuAUFeQ=;
	b=1DhB4eLttgqIjmdgja0BuTkfG8wc34GLK6ZIKFbeLio+VF09G8HRbx/V3VKRrezUIyqD
	 9mY5YtN9Mhvc/tHMnnvt1by8SC4V/f9kYFwihzzHSrGQSoV7XJ5bbyNZC5gDEw4+d96k0
	 zgyeZGD2WXDjBhAhFiotTCFfkr+OprmxtCKdbI/EVFHLTJf45AyXuaN8mNpG/MtixoWbJ
	 VtvfEmi+kpYXVdJsrXz31K8wg4XpAnySwhnfrLdKdQ/mmnxAwe1t/sHFfN7rifDffpvWn
	 fhA5eW3/C/tqdqT27rrEOKf7+XlI+DAPsfi3Xo4LFm7oVVzFxiG9lm6xjclOvUyDPMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKaCwgpo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0696D606A31A;
	Wed, 28 Oct 2026 19:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKaCwgpo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131591F01825;
	Wed, 28 Oct 2026 19:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215947;
	bh=VqPrqLasl80d7sWI/r/cwIVBeas1uHx9b1a9uuAUFeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKaCwgpox8BaRlFgE2QIzUBFySbaZZT+EDrVSY7CMlKhoVMhfFlGArNa5HusaqghJ
	 NU2Jnq6fV/Prff4bxOzqhLo2Js8hss3KdwJpfJSFgA0T5u0sZP6mqkAXtvc0woQ3i1
	 UvaQ5aQ8GzchvQDICQC1LXgXkQvv94dDKNchZ0W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1388/1887] power: supply: charger-manager: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:58:04 +0100
Message-ID: <20261028170531.036456582@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 403eebf95c38302cacc48c127e575461f0e798be ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() is renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230918133700.1254499-8-u.kleine-koenig@pengutronix.de
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: c57cb36f76eb ("power: supply: charger-manager: register regulators before exposing sysfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/charger-manager.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index 75df8c15df05a..a20e7aaffbaa8 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -1630,7 +1630,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int charger_manager_remove(struct platform_device *pdev)
+static void charger_manager_remove(struct platform_device *pdev)
 {
 	struct charger_manager *cm = platform_get_drvdata(pdev);
 	struct charger_desc *desc = cm->desc;
@@ -1650,8 +1650,6 @@ static int charger_manager_remove(struct platform_device *pdev)
 	power_supply_unregister(cm->charger_psy);
 
 	try_charger_enable(cm, false);
-
-	return 0;
 }
 
 static const struct platform_device_id charger_manager_id[] = {
@@ -1742,7 +1740,7 @@ static struct platform_driver charger_manager_driver = {
 		.of_match_table = charger_manager_match,
 	},
 	.probe = charger_manager_probe,
-	.remove = charger_manager_remove,
+	.remove_new = charger_manager_remove,
 	.id_table = charger_manager_id,
 };
 
-- 
2.53.0



