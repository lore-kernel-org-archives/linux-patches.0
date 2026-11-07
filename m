Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062973;
	b=rrDSsW2wzz/Zv+wClvUDm4zLbgXdS+OfFVv28X2WYcDUQRliGOqlwd1tks9PsUCSvRxe
	 ZxnNiZd4pJxjrxCeBb0vVw033MdruzDjropoiLerzjO6IHIaaaMwEUXtenuUjm3qNhB2z
	 P29vijiQ4eFwQLg47XkAnRObnIUOnc9gMkDyPFi80bSa3URk5vsEs9pjfHVXpbmVnkjbg
	 rVKVE6TNtLbSk0J5kuucjMcrZZP3QZWpONb8P7LNhMTQZ3rpMaTsOeeGFcneKeTF4j8wi
	 gWQaLH84op1/7BY6FpowsB7hcpcK47PbtCMAfZGOcG/2NMcUhNh9wUUmCcLVZ4eXHpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ERwuJG8I7Nz0JDf8ccpN4PkhOINndXvP5sXWMBgmSMI=;
	b=D6w9sigFNl8A5pQztaqecaxsbQptnY3ZHwurrYuUbOEHkp+cab7oSvC2g5oQwYcgsTEj
	 EtaV/EXkQ2BaYBObH6qqIw18yUpWuX8D826EnpZ9c/QfjRKmZ5sFpRE2vbZILfN8BEyOt
	 TVhQ45QqqqT5uqo8DiUrzznhnepm17ZeufX8VVl9Y3Dje3JL3G0vIQaNf1tyeJTqaftU3
	 wN3Dgc2fln/fTvmiWNI4NB2AtfbOlwWnj9fc2ybG4gvKU8JAeya7hHBV+s0pdBlqNLDmr
	 6Yi3YjKBJR0d7lmM+usEkI4QP8mIGf+9v4qzO6pY4ipgYDId+/nkENx3cIFLZHnEyXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxRHGkZo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB23606A32C;
	Sat,  7 Nov 2026 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxRHGkZo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8541F0089F;
	Sat,  7 Nov 2026 14:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062973;
	bh=ERwuJG8I7Nz0JDf8ccpN4PkhOINndXvP5sXWMBgmSMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxRHGkZoQInH5OXuOYXqMfbPSHn/Zfc8ELr9Sv5YpGb1d9kgoT+ISToLPNvOzGE/F
	 l2bQWIzjxGe/dJZ/DnofPjT/9c0xP7Oe2zc6nVNJGbIklyxg9oiF7/lGJaJI7Z6wBA
	 czJcC6UsE/giNoK1JgrbmvGHC0HkW2hZJ/3+ZrtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/869] leds: ktd2692: Pass context to regulator cleanup
Date: Sat,  7 Nov 2026 08:47:41 -0500
Message-ID: <20261107134858.224374802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit c73e9f04445f361d5f19ca2edfde742ce18348ef ]

regulator_disable_action() retrieves the driver context from device
driver data.  However, ktd2692_parse_dt() registers the action before
ktd2692_probe() stores the context with platform_set_drvdata().

If devm_add_action_or_reset() cannot allocate the action, it invokes the
callback immediately.  A later probe failure also invokes it during
managed-resource unwinding.  Both paths dereference a NULL context.

Pass the already allocated context directly to the action and retain the
device pointer in it for error reporting.  The context is allocated before
the action is registered, so reverse-order devres unwinding keeps it alive
through the callback.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: ee78b9360e14 ("leds: ktd2692: Fix an error handling path")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260910194525.99654-1-mhun512@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-ktd2692.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/flash/leds-ktd2692.c b/drivers/leds/flash/leds-ktd2692.c
index 0f16eefcfe4cd..04e2efdac3e6f 100644
--- a/drivers/leds/flash/leds-ktd2692.c
+++ b/drivers/leds/flash/leds-ktd2692.c
@@ -69,6 +69,8 @@ const struct expresswire_timing ktd2692_timing = {
 };
 
 struct ktd2692_context {
+	struct device *dev;
+
 	/* Common ExpressWire properties (ctrl GPIO and timing) */
 	struct expresswire_common_props props;
 
@@ -196,13 +198,12 @@ static void ktd2692_setup(struct ktd2692_context *led)
 
 static void regulator_disable_action(void *_data)
 {
-	struct device *dev = _data;
-	struct ktd2692_context *led = dev_get_drvdata(dev);
+	struct ktd2692_context *led = _data;
 	int ret;
 
 	ret = regulator_disable(led->regulator);
 	if (ret)
-		dev_err(dev, "Failed to disable supply: %d\n", ret);
+		dev_err(led->dev, "Failed to disable supply: %d\n", ret);
 }
 
 static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
@@ -233,7 +234,7 @@ static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 			dev_err(dev, "Failed to enable supply: %d\n", ret);
 		} else {
 			ret = devm_add_action_or_reset(dev,
-						regulator_disable_action, dev);
+						regulator_disable_action, led);
 			if (ret)
 				return ret;
 		}
@@ -290,6 +291,7 @@ static int ktd2692_probe(struct platform_device *pdev)
 	if (!led)
 		return -ENOMEM;
 
+	led->dev = &pdev->dev;
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
 	led->props.timing = ktd2692_timing;
-- 
2.53.0



