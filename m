Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046788;
	b=g1A72NCsZTOj3O3Zax0eykpdjHz5EbZKp59U/A05Fc/bwbbn5GmhBiaq/QOEZFDe0qwT
	 WGIwWEUeIJ2xNWd4hXdxkNAO6bv7pCcNmokGoP0vK/dhb6UWlgenSDo9YP1Mdg58akn4G
	 g2RF0dK7A5LkyKvLY2AIr27lRFxLaruGd0TZ92cBCUHusdaMC7r0uVTw0keQgVh7Ms3Kq
	 +U20YTaNybnSkbYJzL5aw4sUB1Y3FTloEUcBWCIxDml/RU117m28Kb+cieNhmkrE/OdZM
	 KjbdZy2APTaQNZb5nNqeDGjq83Bh0uBmHTdGtAW7UM8EHtNFefitrjt+Ursff5vF0KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GUQsoZH4HzTQFNrby4CFnb1kegdIbe9/f029WlNebxA=;
	b=qu2QXgiWx6Uu+sZiQfglrCTnkHoZhmBn7hspKvToPdleraTjdR47s4AgU+rZBO7Mwfhz
	 9jt7UvbHcZna9cd+SK/5c4Rlmg5Zy6ZL2bR0TuTCx2mdFrgY5SsiSAKLB+7W4wjKiSynP
	 QpZplyQOpZ1E44bPkONBNzJXyqj0ruFKAhlF4I7WIXRacSXpHweZr3xqEUzfeGNGB0ljr
	 VAbwojiH6HV3eExS+R4JebFVdrGzD8MZRcH9wVCEu+2JRObuA1d2CTQCPdvxx2wiykFDr
	 11qZnLMLMTh7PDlaTnNVjxCwgM00IKrhuOuWCixraINxsUX6e1KB7sl5tkbDh/CUNgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2b1yHkw9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2124606A31C;
	Thu, 19 Nov 2026 00:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2b1yHkw9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB511F000C4;
	Thu, 19 Nov 2026 00:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046788;
	bh=GUQsoZH4HzTQFNrby4CFnb1kegdIbe9/f029WlNebxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2b1yHkw9VUk0kRX6PlfeVVyBakGhQHdoA5FQ9TP2ygGJvMUnmpHc6Ajwo3Pp6ioX0
	 PZWPWqUhk16bGbkM7xDOMTsFPAqLaQzp1nBWFWUnppuCL3F5WaPJ/0f2+IaEFke6R5
	 J6bVHxRKMd3VAuHyAmEIalxZRJTbS70J2BaS3nRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1379/2857] iio: light: ltr501: Power down chip if request irq fails
Date: Wed, 18 Nov 2026 15:40:13 +0100
Message-ID: <20261118150251.027182372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context to preserve the existing IRQ request failure logging ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 49f293232a709..e72bdbcf9540c 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1576,7 +1576,7 @@ static int ltr501_probe(struct i2c_client *client,
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



