Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039964;
	b=F9x6RxQIPSgVqqM6JjsuznwsaGtD1Yfv1CwrWLOq1pmWsKOr/NNgT3/IBQiO3IQxsFdj
	 yvvhRiRbt9dVq3utyL2bGyH1SPZn5ufhwCPdyOVcYMiB6PMagzyVMwZj4V7bXFn6Ul4MC
	 r8ksq/ZODBq7O2iYVLfDdc2gAXfz2ncYhFRWgNq0baR5LuSs0YBtmVltzwxE9BKPGT9Hv
	 lFVWASXJyR5WsHn9p1csdLb2XAw6qfqmhsFJk35hzm3GKp6puXiUKY1iuTrP6sA2uFJjH
	 OZLdYg1G+abjVrMfSnrnyHBy4b35TM+bFWOrp6N7XaUURRrO3iZJ+KDyZut4MFocJHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KgMA4DAQdqQBKh/pHOsdx+I7yVxfS0r960/gPjQ17ak=;
	b=c+4LpfY7FZB3wcv40+eXDzdjIPMtoMn3+t0Ek5vo3mc2STRAdpYEtQA2OzAeA7sX3nOZ
	 OsgI7qPg5ZRb52kdD4E5BQHbqoFiH2s2ohWujj0KDafMvJg4ocYwc1dm/1HjrRG1r4euf
	 ikyZmcydjKi/9JLouoxz6cUB9wHIRIaRKgwtXmi0w2poyRhoTo6U8X6J3V6p1b32+EvMQ
	 f5dSFuaMjkIfadPb6D7nzyd9tBKR671g9JKZfWdfSgfBVaRBckeU7wWSdCNb2zYtkohdo
	 Exb+Ti6kTl7bsInuu4No93Mumhbljilb/xabKJ3jZ31G2cOjZnFImJrCjIqFlSTywFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7GludBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE875606A31C;
	Wed, 18 Nov 2026 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z7GludBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208581F000C4;
	Wed, 18 Nov 2026 22:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039964;
	bh=KgMA4DAQdqQBKh/pHOsdx+I7yVxfS0r960/gPjQ17ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z7GludBIpk74/I9FjSlUrGovE8fxscbjZF8jF5Ia6Zu2DChwzyQ1SpgOT1h5JV3uL
	 fHN0lE4u8dZPbxxWok9lMZybBN85OcV7gevlh2hZXWOy4OcdHjvr9U/ElYdcjSKB7C
	 +TeOlIzdB+YDmA+trxbZwzauCSjnss/NmkqLr4eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2289/3318] leds: flash: Prevent using uninitialized variable in flash_fault_show()
Date: Wed, 18 Nov 2026 15:48:31 +0100
Message-ID: <20261118150430.419712916@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d229695f2162a41bfa614f175798fa56a5f1c969 ]

In flash_fault_show(), address of uninitialized 'fault' variable is
passed to device-specific .fault_get callbacks. This is not a problem
if such a callback directly assigns the value like rt4505_fault_get(),
but results in an undefined behavior if callback just performs bitwise
ORs like as3645a_get_fault(). So just initialize 'fault' with zero.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260904054437.461706-1-dmantipov@yandex.ru?part=1
Fixes: 7aea8389a77ab ("leds: Add LED Flash class extension to the LED subsystem")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://patch.msgid.link/20260916161607.90106-1-dmantipov@yandex.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class-flash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 6fe9d700dfef6..e10a9c796c04c 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -188,7 +188,7 @@ static ssize_t flash_fault_show(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
-	u32 fault, mask = 0x1;
+	u32 fault = 0, mask = 0x1;
 	char *pbuf = buf;
 	int i, ret, buf_len;
 
-- 
2.53.0



