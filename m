Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620111;
	b=CRd6Pb9LvfvHV4utMtCbvuCG22GWwcFd1pr5B7AccU+1caJdkMSzFRFMJ+giQoo7zWNg
	 Pz4nonEmZo0VSbmylxdPtK6ZcLOMd2DPrDBC8Oge1XvI1ateoKsTmdvcg9Pn3TbOsbk9K
	 1dcc99YlGDkJMbfoXeydQFrOKCdd+AN6HQAcYP8CHOwa05jHrs1EBLE6xwRjHuVwamCjI
	 qX+xoXcAcJqh2phcShYvCopX0eJp/XKmcypR5oWOjmJWQ/v1PzhsccXVsf6OPq93VEqC0
	 XIrJI3SGAFW2a2kVO2QWN4+F9lu7WXZQyFohSo1w5nEZjn9nfyT0CBSPjT2N6a0aQyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620111;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x1/zk6XYe4aRbW4VWCp92Y7L1cXru/lP12QMD8Bnnyw=;
	b=lXSQmrQZgA1MWjYUNL2tg3QbqSnX/xEixPU15ZRcVFZznbSFeDOv2c00YgFRGAgfYOHy
	 TtFneSlfRJVWi2bJmM3YvpuosRgbeTsahqTFBRj/qY5i0vaqZY/vUCXdREX9EfJqJ5yrD
	 8aXWzipn2jJZ6hzRRcZf6S7tLob+Z1O6V8dLBJOf/5FO50k7eXDDKhCqiTEnEPvX0Dvbx
	 64LS0kdPhdMu38iYX08Y64qL1DHgYq66bvsYY51f/cRva4NGfKhNasuugwSB9xDJiDWse
	 2FG2AOOhqIVb1g0yl2eRvwbWS+DP44RdzIBgYho2s7XRSsHMTxNcMKXRIQzRrS1J/1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WR2/n0D9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A793D606A31E;
	Wed, 25 Nov 2026 15:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WR2/n0D9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D471F000C0;
	Wed, 25 Nov 2026 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620111;
	bh=x1/zk6XYe4aRbW4VWCp92Y7L1cXru/lP12QMD8Bnnyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WR2/n0D9twjuTM2X6HF7sLtzY9bhraOT3ay54r9DOmJ4h/UERcpOpAc/aRJ663196
	 fog9V7+mw5QilkalK0CfULxmHUckGSaRDLR+92q4JiJVASNo6gKu8MuTot90L9bhFB
	 t2qFvEK0MvnR+fVKcBBT5HJelz727uHKmbvsJPEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0812/1005] gpio: keep the chip reference when deferred setup fails
Date: Wed, 25 Nov 2026 15:35:50 +0100
Message-ID: <20261125143840.749202255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 7e899fe007d2ffc753e6aa5bc8f2ae0a802b9e07 upstream.

gpiochip_setup_devs() runs once gpiolib has been initialized and
finishes the registration of the chips that were added before that.
When the registration of such a chip fails, the function drops the
reference taken in gpiochip_add_data_with_key() with
gpio_device_put(), and only then logs the error through &gdev->dev.

For these chips that reference is the last one, so gpiodev_release()
frees gdev: the dev_err() dereferences freed memory, and the chip is
still linked in gpio_devices, so the next lookup walks into the freed
object as well.  Here the registration cannot be undone the way
gpiochip_add_data_with_key() does it, as the driver already got success
from gpiochip_add_data() and will call gpiochip_remove(), which unlinks
the chip and drops the reference.

Keep the reference and only report the failure.

Fixes: 16fdabe143fc ("gpio: Fix resource leaks on errors in gpiochip_add_data_with_key()")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20261104025345.1527526-1-vulab@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -924,7 +924,8 @@ static const struct device_type gpio_dev
 
 /*
  * An initial reference count has been held in gpiochip_add_data_with_key().
- * The caller should drop the reference via gpio_device_put() on errors.
+ * A caller that tears the chip down on errors must drop the reference via
+ * gpio_device_put().
  */
 static int gpiochip_setup_dev(struct gpio_chip *gc)
 {
@@ -1100,12 +1101,16 @@ static void gpiochip_setup_devs(void)
 			continue;
 		}
 
+		/*
+		 * The reference taken in gpiochip_add_data_with_key() is
+		 * dropped by gpiochip_remove(): this chip is still registered
+		 * and its driver has not been told about the failure, so the
+		 * reference must be kept here.
+		 */
 		ret = gpiochip_setup_dev(gc);
-		if (ret) {
-			gpio_device_put(gdev);
+		if (ret)
 			dev_err(&gdev->dev,
 				"Failed to initialize gpio device (%d)\n", ret);
-		}
 	}
 }
 


