Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033840;
	b=zIAM1Yf7hImUWED0F33shOcW4ae5Dl0k+OC7iZMK/uEkP2Yc+lXp+ZKQIqxQpNCsGQSb
	 LINriUb1un6R+9A3Ax1urNu7vly7W1r6Zm8JNs2FAAjyICRson7V129exOZNogIoSMDdz
	 3RbGOktCteywFHE+sFPFf8pxWgyCsxFDEEriThK7mUi5d0AsITU2mU41IOT86MXWiLtBE
	 +XjLqhnatHVo49zRaZk1Lz278lo4dWsITsxICqNs+aZKGGwcqi/8SetgaPTyPck44waMz
	 6Br5CyP1bcJVfgSYbWw7Dv2ASfjOq1yhN1GG9Wf76xDI5TOasYNFwfD/s3rNxBesS8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+J9V+E3Dw3XLpUqR5m88hgq9Uww/KR1la6ONRUFbPDU=;
	b=pEy5Ug/zu86uzbnuXiE1vLSApUEDGY2QJ7MLRl3Khs551fn6R3PuhBYagLeHOPk1huiD
	 WTC6hqwDVdOtFhE20bMEit/+B2GOkXjk5nkhScfjvFRMSm8huzEtcaTsT+FVIPcCBZe59
	 v/5QPvNN6KbH4iKLlzq7/SN0BmbvCbWhWpG/FlWJqSAAzwOLQGEnz3hJUNLSnM0s5w1Ts
	 aw2X26dtkRkWl0oZkYxbHPD0H8qpoNTLs/sV1aNg7Gb17jZa0MAEpGre2+rEdJBYIxQvu
	 Qtcs9FJKtbWJ+qwndsGghnqL1/1uYBjGik8BPr8C+zYXuHGqa25JeLOpOd0w1hg3FsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWx3o4VX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616D4606A336;
	Wed, 18 Nov 2026 20:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vWx3o4VX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8BF1F000C5;
	Wed, 18 Nov 2026 20:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033840;
	bh=+J9V+E3Dw3XLpUqR5m88hgq9Uww/KR1la6ONRUFbPDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWx3o4VXXLSzy03QPzPq5T0AHzSOoW/kqBecWMMZ5FRjXriG0bbQIBLVA0Fkg76D+
	 RoPeM/LJZPT2DLEtQzWvPnVaO+bcqnf4/bErrLx4AwEK+0cwuH5QUcaOPH15Bb3Lz2
	 p4G7eYiWGY2+AgUY5AvVdUa4kReI3s/MsRFaPJBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0155/3318] power: supply: cros_pchg: unregister EC notifier
Date: Wed, 18 Nov 2026 15:12:57 +0100
Message-ID: <20261118150319.193033741@linuxfoundation.org>
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
index a204f2355be48..6687d40c551c1 100644
--- a/drivers/power/supply/cros_peripheral_charger.c
+++ b/drivers/power/supply/cros_peripheral_charger.c
@@ -258,6 +258,14 @@ static int cros_ec_notify(struct notifier_block *nb,
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
@@ -345,9 +353,10 @@ static int cros_pchg_probe(struct platform_device *pdev)
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



