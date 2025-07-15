Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422A51B0F23;
	Tue, 15 Jul 2025 13:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586343; cv=none; b=MgBhiX56ASySZTfW5fmnFpJPqppHTAJPQpo22+uYMKyn4tPE3g1zKl2hOQWozwa0LzznHbnV/xlzh3SGI/z+EiTS6wXS9GvYNITxNJAdRZtQe6PA8kvf64VaOxauv9ILlwDQ+faN4Frsh+YW22yGuE+JhJt1v8xt852V0I4f/LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586343; c=relaxed/simple;
	bh=v5oZoj2tgs8D4tiRY75Pifxkt5sI6nTSNuHbN6Tew9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdYuVf45L1Z+PyFWlPGaZSgDHsTJLE/gkcJAEedBdDNkBqZne0vtP4n7XhqJ47vfFcpVLfur7pIazlSUvzW8S+t7kR67bJu7KK+di555RnkF78D7satLmdLQ9WUxMh8RKICnUyB0AVBDtDXVr6+Rup0Zhn6C7nxMy0HwFv4XKgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDh3UAqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDh3UAqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3855C4CEF6;
	Tue, 15 Jul 2025 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586343;
	bh=v5oZoj2tgs8D4tiRY75Pifxkt5sI6nTSNuHbN6Tew9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDh3UAqkCL9XvVSRuuA0/CKBj/9L4ESiMMDqbMBunEtIJvtuwe11tL1Y8+qIe4wsW
	 FSuib+h2bG+PfxgYkq8tyPkJV0AV756Y1PYhNM4yp8Qd5Jd8+iZNuuHdlLjMlTi5AI
	 ildJFEze/cjC11pWOfcQg4DTXa3rMlKr+1wDp+SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/148] media: cxusb: use dev_dbg() rather than hand-rolled debug
Date: Tue, 15 Jul 2025 15:12:31 +0200
Message-ID: <20250715130801.482635087@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit c376d66515f89dd833b344c419e313db9ad169b5 ]

This solves the following compiler warnings:

drivers/media/usb/dvb-usb/cxusb.c: In function ‘cxusb_gpio_tuner’:
drivers/media/usb/dvb-usb/cxusb.c:128:35: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
  128 |   deb_info("gpio_write failed.\n");
      |                                   ^
drivers/media/usb/dvb-usb/cxusb.c: In function ‘cxusb_bluebird_gpio_rw’:
drivers/media/usb/dvb-usb/cxusb.c:145:44: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
  145 |   deb_info("bluebird_gpio_write failed.\n");
      |                                            ^
drivers/media/usb/dvb-usb/cxusb.c: In function ‘cxusb_i2c_xfer’:
drivers/media/usb/dvb-usb/cxusb.c:251:42: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
  251 |     deb_i2c("i2c read may have failed\n");
      |                                          ^
drivers/media/usb/dvb-usb/cxusb.c:274:43: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
  274 |     deb_i2c("i2c write may have failed\n");
      |                                           ^

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 73fb3b92da84 ("media: cxusb: no longer judge rbuf when the write fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/cxusb.c | 33 ++++++++++++++-----------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 06bd827ef4619..5a15a6ec204f3 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -54,9 +54,6 @@ MODULE_PARM_DESC(debug, "set debugging level (see cxusb.h)."
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define deb_info(args...)   dprintk(dvb_usb_cxusb_debug, CXUSB_DBG_MISC, args)
-#define deb_i2c(args...)    dprintk(dvb_usb_cxusb_debug, CXUSB_DBG_I2C, args)
-
 enum cxusb_table_index {
 	MEDION_MD95700,
 	DVICO_BLUEBIRD_LG064F_COLD,
@@ -125,7 +122,7 @@ static void cxusb_gpio_tuner(struct dvb_usb_device *d, int onoff)
 	cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
 
 	if (i != 0x01)
-		deb_info("gpio_write failed.\n");
+		dev_info(&d->udev->dev, "gpio_write failed.\n");
 
 	st->gpio_write_state[GPIO_TUNER] = onoff;
 	st->gpio_write_refresh[GPIO_TUNER] = false;
@@ -142,7 +139,7 @@ static int cxusb_bluebird_gpio_rw(struct dvb_usb_device *d, u8 changemask,
 
 	rc = cxusb_ctrl_msg(d, CMD_BLUEBIRD_GPIO_RW, o, 2, &gpio_state, 1);
 	if (rc < 0 || (gpio_state & changemask) != (newval & changemask))
-		deb_info("bluebird_gpio_write failed.\n");
+		dev_info(&d->udev->dev, "bluebird_gpio_write failed.\n");
 
 	return rc < 0 ? rc : gpio_state;
 }
@@ -174,7 +171,7 @@ static int cxusb_d680_dmb_gpio_tuner(struct dvb_usb_device *d,
 	if (i == 0x01)
 		return 0;
 
-	deb_info("gpio_write failed.\n");
+	dev_info(&d->udev->dev, "gpio_write failed.\n");
 	return -EIO;
 }
 
@@ -248,7 +245,7 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				break;
 
 			if (ibuf[0] != 0x08)
-				deb_i2c("i2c read may have failed\n");
+				dev_info(&d->udev->dev, "i2c read may have failed\n");
 
 			memcpy(msg[i + 1].buf, &ibuf[1], msg[i + 1].len);
 
@@ -271,7 +268,7 @@ static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 					   2 + msg[i].len, &ibuf, 1) < 0)
 				break;
 			if (ibuf != 0x08)
-				deb_i2c("i2c write may have failed\n");
+				dev_info(&d->udev->dev, "i2c write may have failed\n");
 		}
 	}
 
@@ -299,7 +296,7 @@ static int _cxusb_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	u8 b = 0;
 
-	deb_info("setting power %s\n", onoff ? "ON" : "OFF");
+	dev_info(&d->udev->dev, "setting power %s\n", onoff ? "ON" : "OFF");
 
 	if (onoff)
 		return cxusb_ctrl_msg(d, CMD_POWER_ON, &b, 1, NULL, 0);
@@ -318,7 +315,7 @@ static int cxusb_power_ctrl(struct dvb_usb_device *d, int onoff)
 		mutex_lock(&cxdev->open_lock);
 
 		if (cxdev->open_type == CXUSB_OPEN_ANALOG) {
-			deb_info("preventing DVB core from setting power OFF while we are in analog mode\n");
+			dev_info(&d->udev->dev, "preventing DVB core from setting power OFF while we are in analog mode\n");
 			ret = -EBUSY;
 			goto ret_unlock;
 		}
@@ -754,16 +751,16 @@ static int dvico_bluebird_xc2028_callback(void *ptr, int component,
 
 	switch (command) {
 	case XC2028_TUNER_RESET:
-		deb_info("%s: XC2028_TUNER_RESET %d\n", __func__, arg);
+		dev_info(&d->udev->dev, "XC2028_TUNER_RESET %d\n", arg);
 		cxusb_bluebird_gpio_pulse(d, 0x01, 1);
 		break;
 	case XC2028_RESET_CLK:
-		deb_info("%s: XC2028_RESET_CLK %d\n", __func__, arg);
+		dev_info(&d->udev->dev, "XC2028_RESET_CLK %d\n", arg);
 		break;
 	case XC2028_I2C_FLUSH:
 		break;
 	default:
-		deb_info("%s: unknown command %d, arg %d\n", __func__,
+		dev_info(&d->udev->dev, "unknown command %d, arg %d\n",
 			 command, arg);
 		return -EINVAL;
 	}
@@ -1444,7 +1441,7 @@ int cxusb_medion_get(struct dvb_usb_device *dvbdev,
 
 	if (cxdev->open_ctr == 0) {
 		if (cxdev->open_type != open_type) {
-			deb_info("will acquire and switch to %s\n",
+			dev_info(&dvbdev->udev->dev, "will acquire and switch to %s\n",
 				 open_type == CXUSB_OPEN_ANALOG ?
 				 "analog" : "digital");
 
@@ -1476,7 +1473,7 @@ int cxusb_medion_get(struct dvb_usb_device *dvbdev,
 
 			cxdev->open_type = open_type;
 		} else {
-			deb_info("reacquired idle %s\n",
+			dev_info(&dvbdev->udev->dev, "reacquired idle %s\n",
 				 open_type == CXUSB_OPEN_ANALOG ?
 				 "analog" : "digital");
 		}
@@ -1484,8 +1481,8 @@ int cxusb_medion_get(struct dvb_usb_device *dvbdev,
 		cxdev->open_ctr = 1;
 	} else if (cxdev->open_type == open_type) {
 		cxdev->open_ctr++;
-		deb_info("acquired %s\n", open_type == CXUSB_OPEN_ANALOG ?
-			 "analog" : "digital");
+		dev_info(&dvbdev->udev->dev, "acquired %s\n",
+			 open_type == CXUSB_OPEN_ANALOG ? "analog" : "digital");
 	} else {
 		ret = -EBUSY;
 	}
@@ -1511,7 +1508,7 @@ void cxusb_medion_put(struct dvb_usb_device *dvbdev)
 	if (!WARN_ON(cxdev->open_ctr < 1)) {
 		cxdev->open_ctr--;
 
-		deb_info("release %s\n",
+		dev_info(&dvbdev->udev->dev, "release %s\n",
 			 cxdev->open_type == CXUSB_OPEN_ANALOG ?
 			 "analog" : "digital");
 	}
-- 
2.39.5



