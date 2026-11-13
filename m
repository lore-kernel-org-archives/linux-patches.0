Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590587;
	b=4iYl2mt1VY9I/461zZbm2sDAKeKRB0E6Dbff9lsuafF4jIr3LVisWxGiouaCHVPsO/AM
	 h8GqtV/fxVby6JgjghAxDibcspr20h/cBxdf5xGEMQ9jvYo0xA+HnlDbrN6v5NfR7vUf+
	 eq6ZxlDdhL7I0UgI5FjqjAcM4/52eb4RpCtWMejD7zVdrROzD1HBCSNJN/26nPMfJZZkf
	 b7uHQPF4d/XeVr4a7FeELTH5fqv+QFhTcOx6hHLMuQ1JQrCXq5lL3JL1AI+eJwBhHIlnH
	 QysuumOryVTne+fNiD40Z4xn8khMZIOxsjiAPKcACsxo7di5L1C5rjgWT+p6oRYVxOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CggKi0fxydWeyvZAC/X7zt3UyzVrs7zakoD5e6rkp3s=;
	b=WP/sjRuJ+GROXA61NBsadcGFZGaeBJRZzG4XSJUZrKXRq2CT9rij2yl0n1ecywC/weyj
	 /QTBz73MwBRO/dU9OZJ399F4lB1fh1ZtHfX9AQETwKNmKF8bhPKq8Hn9tSHfE97JdjYMA
	 DIiUcvUX3L1jN0KflYOJtE/Srr6FrUfnSe6L8Un7DmOYSCPtPqAi16GoIBAb08vhe69Ak
	 xrzfm2PKFMLgWGlhVhruuee9HrH6TPI3fwMFyLaIwrPehtU3saWFb2+Gr8hrMzVcPHBLY
	 9rIe12DGd39JOwAHlDsFBXWSi7x3rv0BYgOlp2ivtZc00frRvPRQAEO0tczn4OTJKYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C09uomTO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E306F606C081;
	Fri, 13 Nov 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C09uomTO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB251F000C4;
	Fri, 13 Nov 2026 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590586;
	bh=CggKi0fxydWeyvZAC/X7zt3UyzVrs7zakoD5e6rkp3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C09uomTOD5aGQWkt5dBCiUeWcJf9vjpqXtFS9UnYRVwL+twv8tAVyrp8BVgANtrcD
	 QWNnS3outWK9zEfxKxcplOE8ho4tZRQhr9NEVY3OL7qmKVwteqqLcagqfvQIUZjQVy
	 uIZEIyNSHt+W2oXFkiYktSXyLCmOWy2rV48zK7uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 519/686] iio: light: ltr501: Power down chip if request irq fails
Date: Fri, 13 Nov 2026 10:50:52 -0500
Message-ID: <20261113153838.739146175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 36fe40fec2329..a38cf1490e13b 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1539,7 +1539,7 @@ static int ltr501_probe(struct i2c_client *client)
 						"ltr501_thresh_event",
 						indio_dev);
 		if (ret)
-			return ret;
+			goto powerdown_on_error;
 	} else {
 		indio_dev->info = data->chip_info->info_no_irq;
 	}
-- 
2.53.0



