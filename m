Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064013;
	b=c3ja0MRTRe6i93dcFXxp17NCaulRP3LUHnBuCB4Lv3qHJTXRZh6Px3JyK4ovmcRV++0D
	 c+kXwm5pB0ByvijywanFl5XNioehjVAANDobZrxwm32p8XLW/OJWNmoVCU21RGJuyKZ9J
	 E5AwZZoV9dp/+zZrineC43Gy+NZZAgqv6ANjOvWGH8AgwyZz+kD9yx6Ecdl5hcy0P5YsI
	 CSDkGpkh96V41C2Nzv5DhgYk4KGpx13AWMPK17fw6YWK2EU1wPb+W4q6cltXhRSbmWes3
	 ptQxhchWOTdHTLCG53T7Cr7j4uA0OgHHU8kBd8bwYXixzmArljDyFceSxGkzqnod+lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6WOceJEJFs6lyHgJ50XHRtAGNJsPue1CndtoUAz+Qbw=;
	b=zK7RidlCJ2/nmImoshV+8QLD7yVgUhWBBZapONZWcU2mSmXesTwgBncvwmwS9tTGIIy2
	 dOu925J2jfnUFMHPwiEu5HHPsRwsBedfTIQGD6ZLsjRHGe78WrtAJDDq7xWAo2Xvf1pGd
	 iw6tUVfL/Y8LNUIIwC9oA5HCMgIu11Mi85US0hAhsKgFs6f2QQOKpO3gsYyl4h6SP3nr1
	 GqLYU1h6v00ZllN33rfDP5ojtJ+WBaqDMsvmtSJTmvnfbBIqjG810LL6lgpRK2yH0FtPH
	 0iZcSrgvFjS0rEUStUtjWCT3W80Zt7JMLDWYkjtGTTobtR72l9cLYLABpptn6+CO4xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2acplEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE014606A9C0;
	Sat,  7 Nov 2026 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2acplEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC261F008A1;
	Sat,  7 Nov 2026 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064012;
	bh=6WOceJEJFs6lyHgJ50XHRtAGNJsPue1CndtoUAz+Qbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2acplEbWsQ8CO9BFbXN67aXHnsAu81Z53Vd1Qd9xf6x1DfBJkRzLmXYsNAWtGEIp
	 c0gFjD7A37z8XQ+2QYqiZKmLLX2oQWKPXKxQvIIM62UVD+6n1DNoMMqfu4NQHCfhWw
	 t31okDHfPSzZanL69/daPO2Rh38WbhBlebPJTnTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"jan p. springer" <regnirpsj@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Manuel Knitza <manuel.knitza@googlemail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0191/1257] media: i2c: cvs: Get the wake IRQ without claiming the GPIO
Date: Sat,  7 Nov 2026 08:41:27 -0500
Message-ID: <20261107134944.732909208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@intel.com>

[ Upstream commit ed447e2b1da9bfe7d076e12cde496f3f689f7fdd ]

The wake line is only used as an IRQ source, yet the driver requests
it with devm_gpiod_get(). On the Dell XPS 14 DA14260 (Panther Lake)
that request lands on the pin the four CS35L57 amplifiers read their
speaker ID from. Each amplifier's _CRS carries

  GpioIo (Shared, PullNone, 0, 0, IoRestrictionInputOnly,
          "\_SB.GPI1", 0, ResourceConsumer,,) {20}

and INTC10E1 builds its _CRS at runtime from pad numbers kept in NVS:
a GpioInt (Edge, ActiveLow, Shared) first, then an Exclusive
output-only GpioIo for reset and two lines on the USB GPIO expander.
The driver maps index 0 to "wake". While it holds the line, cs35l56
fails and does not retry:

  cs35l56 sdw:0:2:01fa:3557:01:2: error -EBUSY: Failed to get spk-id-gpios

All four fail and no card is registered. Fedora 7.1.13 is the first
Fedora kernel with the driver enabled; 7.1.12 on the same board
creates the card, and 7.2.4 creates it again with intel_cvs
blacklisted. Where ipu-bridge does not expose the CSI endpoints, CSI
init returns -EPROBE_DEFER and every retry claims the line again for
the length of the handshake, which is how 7.1 fails as well.

Take the IRQ from the GpioInt entry with acpi_dev_gpio_irq_get_by(),
as the I2C core does for client->irq; this also applies the trigger
type from _CRS. The vendor driver in intel/vision-drivers does the
same. The driver binds as a platform device too, hence the explicit
lookup. A DKMS build of the patched driver on a DA14260 running
7.2.4 binds with all four amplifiers probing and the camera working
(third link).

Fixes: 8e2b43d2c10b ("media: i2c: cvs: Add driver of Intel Computer Vision Sensing Controller(CVS)")
Cc: stable@vger.kernel.org
Reported-by: jan p. springer <regnirpsj@gmail.com>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2529031
Link: https://github.com/thesofproject/sof/issues/11152
Link: https://github.com/omacom/omarchy-pkgs/pull/419
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Tested-by: Manuel Knitza <manuel.knitza@googlemail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/cvs/core.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/cvs/core.c b/drivers/media/i2c/cvs/core.c
index d4a3b9c3bab1e..8d857bbd8ab51 100644
--- a/drivers/media/i2c/cvs/core.c
+++ b/drivers/media/i2c/cvs/core.c
@@ -725,8 +725,6 @@ static int cvs_core_probe(struct device *dev, struct i2c_client *i2c)
 	}
 
 	if (ctx->res == ICVS_FULLCAP) {
-		struct gpio_desc *wake;
-
 		ctx->rst = devm_gpiod_get(dev, "rst", GPIOD_OUT_HIGH);
 		if (IS_ERR(ctx->rst)) {
 			ret = dev_err_probe(dev, PTR_ERR(ctx->rst),
@@ -734,14 +732,12 @@ static int cvs_core_probe(struct device *dev, struct i2c_client *i2c)
 			goto err_put_ipu;
 		}
 
-		wake = devm_gpiod_get(dev, "wake", GPIOD_IN);
-		if (IS_ERR(wake)) {
-			ret = dev_err_probe(dev, PTR_ERR(wake),
-					    "failed to get wake GPIO\n");
-			goto err_put_ipu;
-		}
-
-		ctx->irq = gpiod_to_irq(wake);
+		/*
+		 * Do not request the line: another device's _CRS may list
+		 * the same pin, and its driver would then fail with -EBUSY.
+		 */
+		ctx->irq = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(dev),
+						    "wake", 0);
 		if (ctx->irq < 0) {
 			ret = dev_err_probe(dev, ctx->irq,
 					    "failed to get wake IRQ\n");
-- 
2.53.0



