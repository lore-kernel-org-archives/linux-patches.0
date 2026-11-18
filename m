Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051191;
	b=ogbMQzo0xjt9fkrbfiTkRiGAn85Zxr43Tap54QiHZdCQZyCCti7z3R4aG7Gn+VnaQYBw
	 jAnGAdq9QzO46UXJuXnMEraHd1ImzKANRe47nzZKDIBshFmAblVhzL/bCuYKRDwM5izV8
	 n1841iss89B0iZZmjRogOAzSRpKBd5AF/JN8zHRYD9OfHnxbG/3yW0btjmV96J9hk789n
	 9Nwcjs1QF9uPF5wyqfmcsedhzVRwREqzf4kYET7LUSYm4CshqTfLMRCvRn5s3ZG6gEUwc
	 v/fBJ/sRvc+AFq6bVwMWhv5Kos0/pBAysd0q47Gh8Po4r9rAcJkzFa1sVEh6sGsRy6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZ0WKRks5QWkDMInYkdWZYGnW8J8oKfztdndjemM/eI=;
	b=DJ5nurEY70s3T63WWcIEAtkkIOQ5FS3ewtrB8l5GVdmLl5ZgStDmG3LenRPlsm13Tzj6
	 NXnFBNykA6bJpaOEXQQzn0h5uv5kV8u9+8mQcQnrMH5Xj62e3i1hbRSaAQp2ddPjAkILs
	 mEV//zFCA1CDdy8JUgGDq+d0b9LAlk1jcasj4eLCB0vuVHu7icxZYilTctnpBF3fZ82Ap
	 OmZvI/evjcKYFlFIKdhQ1ZMDu9wSkC/h/pBz8bI73i3UcfhP1d/4M1i5cnKAf/eZybKYt
	 l8+GONF0LsHAZhXkXkNtxQFWTVSSQ+Hf+I/ZC5jdXll0rbdVfHGZ7ohJ0Ht/vwQtYKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AY08h98R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BAD606A320;
	Thu, 19 Nov 2026 01:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AY08h98R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697C71F000C5;
	Thu, 19 Nov 2026 01:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051191;
	bh=TZ0WKRks5QWkDMInYkdWZYGnW8J8oKfztdndjemM/eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AY08h98RZKBnSabqThIV4q2IDZnbgHs30XrzqqM5hKzG8iPxaibdPoDGbmHgpzOy2
	 qec176cyd/UzG9sHFwSFtE9qsmyAoF2jBsxhUrZNJ8vejU9ovPFuz19SYXzCXlmHsR
	 4f5wI0EKzW6ZlU1AnwO2ZCXigwajoxZLY1p+035o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0120/2214] power: supply: cros_pchg: unregister EC notifier
Date: Wed, 18 Nov 2026 15:29:56 +0100
Message-ID: <20261118150014.872550463@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 631adfa03595c63b2a621cdc62db60bb1ce5f91c ]

cros_pchg_probe() registers an EC event notifier whose callback uses the
devm-allocated charger_data via container_of().  The driver has no
remove callback and does not unregister the notifier, so the notifier
chain can retain a pointer to freed driver state after unbind or probe
cleanup.

Register a devm cleanup action immediately after the notifier is
installed so the notifier is unregistered before the driver state is
released.  Also fail probe if the notifier cannot be registered, instead
of leaving a charger device that cannot receive EC events.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260615063105.39152-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cros_peripheral_charger.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/cros_peripheral_charger.c b/drivers/power/supply/cros_peripheral_charger.c
index 305f10dfc06d1..b3f6a956ca398 100644
--- a/drivers/power/supply/cros_peripheral_charger.c
+++ b/drivers/power/supply/cros_peripheral_charger.c
@@ -282,6 +282,14 @@ static int cros_ec_notify(struct notifier_block *nb,
 	return cros_pchg_event(charger, host_event);
 }
 
+static void cros_pchg_unregister_notifier(void *data)
+{
+	struct charger_data *charger = data;
+
+	blocking_notifier_chain_unregister(&charger->ec_device->event_notifier,
+					   &charger->notifier);
+}
+
 static int cros_pchg_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -367,9 +375,10 @@ static int cros_pchg_probe(struct platform_device *pdev)
 	ret = blocking_notifier_chain_register(&ec_dev->ec_dev->event_notifier,
 					       nb);
 	if (ret < 0)
-		dev_err(dev, "Failed to register notifier (err:%d)\n", ret);
+		return dev_err_probe(dev, ret, "Failed to register notifier\n");
 
-	return 0;
+	return devm_add_action_or_reset(dev, cros_pchg_unregister_notifier,
+					charger);
 }
 
 static struct platform_driver cros_pchg_driver = {
-- 
2.53.0



