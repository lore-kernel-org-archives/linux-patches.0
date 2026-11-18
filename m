Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059658;
	b=wEtcKgl09XxZGF2wDjEgFuosbtzYmpX0v5NuAPZuD3IzDLV0ZDDOhRAIpm7tuuGGSy9Z
	 LCZzBCHV5gK+9itr9o/h4QH012ih+pmJBsIjZDpv/nLkfrowPs6FAB3RmGpwM0U8BGjuN
	 wyU3pd64OuplQPPy5qYzkt/l4IVArateShhCO78uxdKJhaGZVIsvPc5xIouvhNCfEVoXM
	 gizo8tNF9claEZ/WgHuRbPBx1P+jXh9dwLyHkQJhbuyQ4x2XEHKKr9qjSII96nf/6OH15
	 fb/wholicIWbgNowvMugshX18fkZ1pqMbrPtRXc+xcOsOzf74LWRhrn+/VgKRLHJhiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Torau/28ndhWrWoQ9+ba8tPKeTPHu3bP6TiRmu0wPIk=;
	b=Zj5gfFUnPQL0l6TcI/KIUeDbyQZajCnCUfS4GRBbyYW/t4aKz4lBPRdUC6cZB4Ef66Vq
	 iwcyhvAvabNGxj/XuUYhRrvXcyOFTBJTh6tQqitSYTMWp72SmARyLv3+Ti8fT+nUc1zrX
	 wDLQHv5Y4FPagh2iG/Gr47xYMGRJEtBfoFM1JQgaRCGKRh3OfjMm0Icl1hTuT14aejrKg
	 pVbSlV+2CEbW+mYywSo8TM1sPhvDX+gynIIV5hPkJuM9/QitV6q3jZ/SRUMf7oyKmITtY
	 65VIgae+fJWdbARFnVNNGGxLBpLBSiW1g8rIFAB8k3OOUQdJYi6eIimYB3ahR1mAUbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McUZo85H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0049606A332;
	Thu, 19 Nov 2026 03:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McUZo85H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF4A1F000C4;
	Thu, 19 Nov 2026 03:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059658;
	bh=Torau/28ndhWrWoQ9+ba8tPKeTPHu3bP6TiRmu0wPIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McUZo85HoJH+PFAUCqHirDciR72Dtuo0RVWUCfAzV+YcuNlvU/Mk5qXBSoiElCht3
	 XrjemHdWLS2mlP5ru51fDK5O7ecdHAaoUdce08+VqOC5tvNvpORqqQLotIWkvs4o3T
	 Cz2zlcGiO+AVHuWhL6mFaRIN3bNZb0knAV/uxEcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0919/1848] leds: ktd2692: Pass context to regulator cleanup
Date: Wed, 18 Nov 2026 15:49:17 +0100
Message-ID: <20261118145955.309661436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the older ktd2692_context layout without ExpressWire fields ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-ktd2692.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-ktd2692.c b/drivers/leds/leds-ktd2692.c
index f341da1503a49..5ef8b3c530084 100644
--- a/drivers/leds/leds-ktd2692.c
+++ b/drivers/leds/leds-ktd2692.c
@@ -72,6 +72,8 @@ struct ktd2692_led_config_data {
 };
 
 struct ktd2692_context {
+	struct device *dev;
+
 	/* Related LED Flash class device */
 	struct led_classdev_flash fled_cdev;
 
@@ -258,13 +260,12 @@ static void ktd2692_setup(struct ktd2692_context *led)
 
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
@@ -301,7 +302,7 @@ static int ktd2692_parse_dt(struct ktd2692_context *led, struct device *dev,
 			dev_err(dev, "Failed to enable supply: %d\n", ret);
 		} else {
 			ret = devm_add_action_or_reset(dev,
-						regulator_disable_action, dev);
+						regulator_disable_action, led);
 			if (ret)
 				return ret;
 		}
@@ -359,6 +360,7 @@ static int ktd2692_probe(struct platform_device *pdev)
 	if (!led)
 		return -ENOMEM;
 
+	led->dev = &pdev->dev;
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
 
-- 
2.53.0



