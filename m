Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059389;
	b=GpTxAqhBFhlj60eZ0R2unf6Zt3NfLqRWILjYGbfB4g/xfbo7h5yhv/y1mCj/w76lwGhF
	 5wxyaDNRdd1bJ4JpBBdE/4TRr++BXpBbKqhTwazPHzLrSxzazPkevQf42a0oYlFUg2j12
	 eEs+aAh2f3tt0XVc5Atfoer2i34m4v/RMbrXibSjGiwlXYXwIUUka5GzVe/RlPJyvkyme
	 bW7BYtcnXcGsx/74ZL29BYZlHukZxTbgY54aUsHOzw1EaRKICoVGHGrHH4lsm4sV0vfzC
	 jrUEyNXBP7AZMRFu4CL1a8LQc5gAoChwCmJA7o00oZhk43wcodnp7z60ikwm5q4oJQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yvFsNuwhNHMlJ8A0rvCseN+JTKNrfxirlRlMs50jst8=;
	b=tNXU7o2zhjuilivq1xuFl5n5wn08QOVsOWCag1f1A2fARBxFqsrxea0/EpCTJuIMHsWY
	 4M0p83fgh5s5n0MymrDZI9oQkynDu0I8mnNeYAMi7kIkDTSBJiXuvjODHhb/SNx6bmvF1
	 4CyT1MOdScp1mZ6tzD/VmpXX9q5kMcfjjYE4K0Cjq+fkbEb3YIztGZ4vz/rPSn//uWg1y
	 T68G2qq6ajIeumbMF9mREOnYTiP3nYUGZwUlCOCcmuf4D4TuiixR/jS+rLplI0fpS0rIe
	 UghKEvuwfAZBnKq/hIxb/US+rrlUbQ0olbVHQp+jAn0gxe1kCuEiMeBKHP1YljK2NEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcOJY6ko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D29C606A31C;
	Thu, 19 Nov 2026 03:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcOJY6ko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4D31F000C4;
	Thu, 19 Nov 2026 03:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059389;
	bh=yvFsNuwhNHMlJ8A0rvCseN+JTKNrfxirlRlMs50jst8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcOJY6koRFi/vdwuCLDqG0Nu07F26++ufR7Z6RkEh3+OugFiAkxf5Xa7T12UI+JvB
	 2oodjq72OoZkLKxRH69ZeEvptrSOatnfc0179660pksuaYXuQRfyq9altdkdBIY9ga
	 NbIvKdrc/SHjHz1vk7czbSN7udBpFAw1YRCsBMn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0824/1848] iio: light: ltr501: Power down chip if request irq fails
Date: Wed, 18 Nov 2026 15:47:42 +0100
Message-ID: <20261118145951.239183584@linuxfoundation.org>
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

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 8a9bcd587d7d768e6c8e9fff88bb89645e412731 ]

In case devm_request_threaded_irq() failed, we were leaving the chip
powered instead of powering it down again. Power down the chip switching
ALS and PS modes to standby.

Fixes: 7ac702b3144b ("iio: ltr501: Add interrupt support")
Cc: stable@vger.kernel.org
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: adjusted context for existing dev_err() logging in the IRQ failure path ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 379236a806fac..77cb094d5753c 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1510,7 +1510,7 @@ static int ltr501_probe(struct i2c_client *client,
 		if (ret) {
 			dev_err(&client->dev, "request irq (%d) failed\n",
 				client->irq);
-			return ret;
+			goto powerdown_on_error;
 		}
 	} else {
 		indio_dev->info = data->chip_info->info_no_irq;
-- 
2.53.0



