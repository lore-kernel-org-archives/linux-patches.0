Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053935;
	b=NpybQTopEQmOu4udsny2IDwyI9dALHBSvBRh2iOb5nvauxaLcAGc84nTEGsmFz5Z1OdN
	 yJ+pTGjyjHeUqmNdQI5uyagrM693MTPIIH86VQ8ZRW5hNCwNXPeWTUwBl4oeHooyUr2oq
	 Nz1xTcdAAgWicwCgEEjzdJZABRphCmVL6bBqDfif59SO02N1NW2uSNpYTDJScpvLhFA/v
	 rj7wVIYjia5ck4jzIFyhnI9nHSufnLwRhcq7AWFzM6497BzxOF9ruycM2FyRfLTLjiKEZ
	 h0fBA34F6w18MgyJv8yHqfU0lm06aO98dlfj6+3o1ZvTvgZXxAVjpuOf0TOxYmdo4Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WLY/PJnH3/hN3RcC6KJ3YMP0nO94nhXKvtkxCT6+GpE=;
	b=UHhyl5dg+hZl95rLfDkRoIPgV+UixgAQhHYtumJKqCotxUOkDPLFS4Dbm3ZvVzhOhWD+
	 qyM7crvVilsz0eE1bTGD+BRrdW86J/BkpAOnH4yzhgAcamZ5XK0EW+Wr4h+7/99ACJArM
	 wGR53j9FsdQ03ScLue2OE4Vf/TWVNZ/MgS5SNeY63Oul4y4qbP/njzQNjqxKTLEEPPzJL
	 zY98dVOscawnJHDgoVbru/TYEgkyCgreRJC38klDrJrU1X+0KaAbYghD6KY6npmN+6ym3
	 pN8OdMLNGQcETX6mF79vARy4Z/buul6lI3/8XbWOonCsSwA3bGNQ2mfZ9Lnz6Azqkdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTXjh591;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A2A606A31C;
	Thu, 19 Nov 2026 02:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTXjh591
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F314E1F000C4;
	Thu, 19 Nov 2026 02:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053935;
	bh=WLY/PJnH3/hN3RcC6KJ3YMP0nO94nhXKvtkxCT6+GpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTXjh591iTdDqS9C72tKrsitBtHd9z7j2cS/T8immX2nZl3FbRBc/sqkJ2EOxHFq7
	 D1ApWMW/7FmQNJgdOM2FVZXFJz4TV1+W+gt14pDG17UpM0iCPwr2R5foGYAdIZT4SH
	 IFaqCaHS4CzDYpmFJ082oATY6c4PY0pNTSsEGjUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1095/2214] leds: ktd2692: Pass context to regulator cleanup
Date: Wed, 18 Nov 2026 15:46:11 +0100
Message-ID: <20261118150056.013752646@linuxfoundation.org>
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
[ sashal: adjusted context for the driver layout without common ExpressWire properties ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/flash/leds-ktd2692.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/flash/leds-ktd2692.c b/drivers/leds/flash/leds-ktd2692.c
index f341da1503a49..5ef8b3c530084 100644
--- a/drivers/leds/flash/leds-ktd2692.c
+++ b/drivers/leds/flash/leds-ktd2692.c
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



