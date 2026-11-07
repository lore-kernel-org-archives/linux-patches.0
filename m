Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060770;
	b=AEyDs4y1/i0qcjEJ3z5kXTakFpArw+ajkqSgiqaj6M7Zy4md6WM9+3EiIQrYH0SRyZi5
	 LCBr4NZNZDBFNZjBheUjxxnAOL3teMNrrYuQrjIz2PoRJj7bnZNWs6w5317vHeutaojKP
	 c51C0usBn93ealyZ1q7jjQzumILh3evLx1Yw1cyzmebspK0DvK7Zh/bp3HYDqO6w37Qic
	 SUgD1E7kTcNJwIxFaMATO7HTHtsfx71Y07LYKdTiJTZWv7Z7p8edz7M4+VbOaHrpo4LRf
	 hWXK1JtxRpDk6350OEcy/QbB92qRCdoVInKKT+SP2txwc6CbATST2Pd+jDQkvr4aDGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w8m5erW1DDSbLjJgmNgVrif3t+wIlyqEQU8rBFEN7+M=;
	b=Al5mkew31tujLuR/YtMNcBGPX1bLKC9U3aGwZ0aYqsyDqVzZ1hmqGb+O55dNqKOHJs9P
	 YWiq7BYpIOVXexQiSbYI/Mo/PX6y8/bKwGWo10Oot/dUqIDEHBx73aCcMcwVaCFkEybqm
	 Ynr72C/lKEaPHR9RYrX379JNcVs7KDPkwzJkKR2U/MGfB3+QHj4WI7p7WphmC4jAW6uXo
	 LVLMGDP7kgfFt33U3jtpqZ8jQ6/9msH9XTYOZhBs8MM4V1W4M3mz9jG5Cm2p0HXpf1zXm
	 pUEDKsFztYelTWTZcbR+OoVFNaa4FUn+6wRi31P/gUg4vuMrZgqURwD46qn2kETaXGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2t11dK7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C28606A32D;
	Sat,  7 Nov 2026 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2t11dK7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D931F0089F;
	Sat,  7 Nov 2026 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060769;
	bh=w8m5erW1DDSbLjJgmNgVrif3t+wIlyqEQU8rBFEN7+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2t11dK7tLzlAEt0uHEt0TBn25a7fU0VrBu5147mbHLL1ujop+BgK9Rf+Yv9cUa9xS
	 UgFtNyrZtan3IWh98seiQ9bzyqMmOzysZWkwy5zZw1FE/trAcPHfr22JF1ZxU67qdu
	 vhCGGNUxhiwYUZtlCvF22SvccPLSZcV30w/ZrGxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0180/1536] power: supply: cros_pchg: unregister EC notifier
Date: Sat,  7 Nov 2026 08:36:36 -0500
Message-ID: <20261107135002.718599292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



