Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D019539733E;
	Tue, 21 Jul 2026 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674780; cv=none; b=njIcC33xYPcbl2zJozlVVuPDGVWPdXeamvhPS1wGo7ZXvHdWkgb130xTEZdZzUjwm/OPbqHhJBJHv79e+kz+e4pgrQ1MgekCHSFFfREHVn3CF5Ra0pBFBE2p+C0tT3FQIJFRw0mf9Cwh7IZVGNT+8RKIPK5FoqRIBoBuViWzWBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674780; c=relaxed/simple;
	bh=foPxvene37htrOkqH3y1IpEiPvczOxDHYp/CGzXCuA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRWpc8IYltYfI6fGswn2AjVeChDIzBQx4h0bDvyxaI3dM3BmOdKMIHnDsgaFsSVQ/QYdd1cHWlqc4Ey0LRFPLZZAwtcFSL4rHxISDLS9gsUO7EYBDiLJCq3b1vRq0VF2/rWEp05Ty0oFHz9L5agMJWJumDZKlQKVRhy7mWvQdNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYvEdTlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYvEdTlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410201F000E9;
	Tue, 21 Jul 2026 22:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674779;
	bh=vRDug223fL6TVTpKWes5AR1wqFe9CjPP03ieMMUek9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYvEdTlS6WFcABy9H9wXkHoceEJ5BA2YOrJxT4WhNz5ZcCT/gMKI2Gfmush/kidg6
	 vBOR5yvHrYZ0o7AnK3A3LwyMUMrUjRhWIlKIGuLe6w1lPEb6CtbDc96RORM9nAzvc2
	 Cfvl9BtNeGrlcKtCLSigyOdTQ318RZzOdeUGTkMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 669/699] leds: lm3697: Remove duplicated error reporting in .remove()
Date: Tue, 21 Jul 2026 17:27:08 +0200
Message-ID: <20260721152410.855673614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit af89fa11fae1cee4e07453f780e6e5573ef0f477 ]

Returning an error value from an i2c remove callback results in an error
message being emitted by the i2c core, but otherwise it doesn't make a
difference. The device goes away anyhow and the devm cleanups are
called.

As lm3697_remove() already emits an error message on failure and the
additional error message by the i2c core doesn't add any useful
information, don't pass the error value up the stack. Instead continue
to clean up and return 0.

This patch is a preparation for making i2c remove callbacks return void.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1f0bdc2884b6 ("usb: typec: ucsi: ccg: Fix use-after-free of ucsi on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lm3697.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/leds/leds-lm3697.c
+++ b/drivers/leds/leds-lm3697.c
@@ -337,10 +337,8 @@ static int lm3697_remove(struct i2c_clie
 
 	ret = regmap_update_bits(led->regmap, LM3697_CTRL_ENABLE,
 				 LM3697_CTRL_A_B_EN, 0);
-	if (ret) {
+	if (ret)
 		dev_err(dev, "Failed to disable the device\n");
-		return ret;
-	}
 
 	if (led->enable_gpio)
 		gpiod_direction_output(led->enable_gpio, 0);


