Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829665;
	b=p7+iE77rwVWM80kmNTiM5W/Yhtg9OdIGH7g3NN5oUsqyq8AlaytrOTcYt+dplVOtlYep
	 dKMB2SytuNEG2N/iVpzqGBq6ilVU84pkZmtYNc2v4v6or27T+jBwYVeuKB6DNvjS5GOTe
	 lrO0Xh1udgj53dFEkfzkFgQ71dhoUkjYPZHKGArBSqVMOr6aJgbm961t3rviCaZ+s3LKy
	 HTLEed+wXNOTLLgp6+iW6PhiV7tmjWVzqEJv64z7ceqcMdxg4L2UifnUUSgbptQQ3iUGd
	 Vx4ryKCxGdvSl5LtBnT09qIqsQyO9zCSPbdpODx4LBR2cJfl0hjE3PiSZfW5UrqyhKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TNNS9T4MICxjapTU3O3c9dhB7je93XEPWnaO1YcYEbQ=;
	b=Md0pZm8/EnoyoZ6He1MgXAOdZqEmT1N2lObPwexw62mDGkh5p8f+T7SFn8bFQAJ3ceWS
	 tYiDDYMiBw6CrvJiU3/mFllf8JSXM301OZ4vPKt9ZkFU6TcvJG6pgelNMBUyDy8FWcltK
	 BOpWOp4o/bClnnMCkUEiz8nuToMrX1MJbXTi15w98MmpEF6O2ziOdwqN+2SDVYrZ1iyj4
	 FplqYoclw5UALDRC4ftgBdeB7yy9q5GBjMImNH9q3kTYw5MrMRxPn29aau3duUYifEMS2
	 1g97ktHuIfDsqu+NkZz6sr4DeQUZCOhUvUJyz5S4H9a4ULM4SQZHhtcU38bAiGlAGDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0VIvRXN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C0B606BA1F;
	Wed,  4 Nov 2026 22:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0VIvRXN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F091F00A02;
	Wed,  4 Nov 2026 22:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829665;
	bh=TNNS9T4MICxjapTU3O3c9dhB7je93XEPWnaO1YcYEbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0VIvRXNEYEU4cBJP9t1T4802N+UYhiGVkVarhmavmRArDROmaeY5qSwGS6etOpCm
	 ZUzrrtILzT3w0rRNc1x98ttrHf76VRrzgwG/BKJc3ShheGCA7a9MK60RIvZ5Hr3MZI
	 i6HbvQhnfNl+0ZTv9RpYJs3dSukPO9NkZnlKvF4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0217/1005] power: supply: cros_pchg: unregister EC notifier
Date: Wed,  4 Nov 2026 15:59:10 -0500
Message-ID: <20261104211049.893270834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 962a6fd298323..48e10e872d1bd 100644
--- a/drivers/power/supply/cros_peripheral_charger.c
+++ b/drivers/power/supply/cros_peripheral_charger.c
@@ -259,6 +259,14 @@ static int cros_ec_notify(struct notifier_block *nb,
 	return cros_pchg_event(charger);
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
@@ -346,9 +354,10 @@ static int cros_pchg_probe(struct platform_device *pdev)
 	ret = blocking_notifier_chain_register(&ec_dev->ec_dev->event_notifier,
 					       nb);
 	if (ret < 0)
-		dev_err(dev, "Failed to register notifier (err:%d)\n", ret);
+		return dev_err_probe(dev, ret, "Failed to register notifier\n");
 
-	return 0;
+	return devm_add_action_or_reset(dev, cros_pchg_unregister_notifier,
+					charger);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.53.0



