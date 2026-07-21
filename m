Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296043B8120;
	Tue, 21 Jul 2026 22:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673038; cv=none; b=cyV9ee5IUg+uRg9T65qp9qx3erOc6s3er1GK0SqQzAFRM4aD2xqOFd40hUan9lZg+topqF1F6fPCCP6KOmlTb9uXDUO649mk4JB5ViZlH05clU2R5uE6wkFNI2DvCWZdWNJTYwFtIMkkEQD4wVXhL06YiSFfPjoB4pOeKRumZr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673038; c=relaxed/simple;
	bh=hUabS3wtGyp04jIAzyBtc7qNjEG9Z/xuYzhJbwOZT9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nHz+JfDk3DNRPRoPoubPVnqLrW3u9VPSeS2In1ClZU2F4nPrNrltt3upRkTaS/nBaW8h0Ge0OjQXx/PDpdwAUNQS1MfytHI5bapvIdM1uu3TnZ6PusQIjjMaIxDX9oVbdLIPk2rDc3VDDD1VTnzu5o027pnPKn0u6E2VKV/1bJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Gxb4hi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Gxb4hi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8B81F000E9;
	Tue, 21 Jul 2026 22:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673036;
	bh=JFnKpsMUra5KM6JkiPU0lWzgYCJ/Tw3rUUTQ3Yt2k8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Gxb4hi78vvPKlC1/RcC3T8rciTuIv2QGUdMhKuN23VXKI492A2kKM3a5Aa04HdMX
	 LA/gITMACP87PnTRbFWdER6Z62AitHn/2wbfNIq6ItqdW5flnBFkWKP5o0ciVqHixV
	 RcFmAYdmvQhXwKB8zaCwW6BDcOOLzOpMy8HojUuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 815/843] leds: lm3697: Remove duplicated error reporting in .remove()
Date: Tue, 21 Jul 2026 17:27:30 +0200
Message-ID: <20260721152424.410017063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -345,10 +345,8 @@ static int lm3697_remove(struct i2c_clie
 
 	ret = regmap_update_bits(led->regmap, LM3697_CTRL_ENABLE,
 				 LM3697_CTRL_A_B_EN, 0);
-	if (ret) {
+	if (ret)
 		dev_err(dev, "Failed to disable the device\n");
-		return ret;
-	}
 
 	if (led->enable_gpio)
 		gpiod_direction_output(led->enable_gpio, 0);


