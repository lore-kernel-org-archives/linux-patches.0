Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591355;
	b=yoLQ6yGQM1tCCHRSuBcgnNjsb4JxR6+UuPb4HJ8ASTV+7Q9HkGfneG8RF2Lclt0MXCc9
	 5Uh3kd3bvv/UKKokPNclKK31cTMPVadQUgIyWro4Pr0jhrMUqdJWn9sfv3UyKKHLK1a5l
	 Kiy6njBHzM3VhQLX4z0d73e/Xdkye3Ty/f06KL867MOBph/bN1wkkT20RbLt4c0MRjDZI
	 AyAqiQ7WCeVqDg1pR3RIDXtn02HB528bn40T8J3XyPJLePez50GjUbtpqvPXkpx5pN5gE
	 uPYqFw3zFbkvbJAEG1ji+L8nJnsn0LSm2oSWm2CGitwDv4jD7yNfo7CwQ5YxT996/gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RXuj74KHUFASP4NZelSp51BOyAZiKSvZDDbtXnsnXLc=;
	b=c+EfcIXWAlGq7uvBOlBAfi5d3KtxLnHAgjqQBgcDesPrmQ2gRp7c6uRljZdgHjHRJ5Yw
	 eZNg0syWuXJGFaOzZXjUksKiJJr29gUuLEgy+coD8jGGnC2xSK/+9Nm7PLJAUddKFicje
	 fID7xTj6xjApy88E7d5Uc7U2zd9vvtF38Fl9HA6Z7wrdFeKCuN3zxdUtoTSa1rcKS3N73
	 Grf2V/L+sgQl6qK489DoOdE1KE08SfIvxzHv08SwRzuTyS24cOAHGs+GTv7PFAGtG9iKM
	 Y4pN1gEJr+XM7WGVmGp7vanvr4SVdhRiMhJiSWY9y99tetviUXz8Q7+rDHtB12+DSEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPjOACMq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2948A606CEFC;
	Fri, 13 Nov 2026 17:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jPjOACMq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95041F000C6;
	Fri, 13 Nov 2026 17:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591355;
	bh=RXuj74KHUFASP4NZelSp51BOyAZiKSvZDDbtXnsnXLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jPjOACMqT0VwXE1kJZSonDuCcn4JkmB0gwdWASbxjlOzFKi+Z3bHiD6jM91qc5+aq
	 XDMaZypxPpW4/WErrMFmwXsSC+Xw/r1ZdntoiyCDKTyBcUpLmWZwUP+wgEMwiXvMav
	 yih5ScBLXvMsqUAqXBIPYIHVgn44SVmYbxs3e97I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 460/670] iio: light: ltr501: Power down chip if request irq fails
Date: Fri, 13 Nov 2026 10:50:24 -0500
Message-ID: <20261113153827.555952276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Preserved the existing IRQ failure diagnostic and surrounding braces that were removed upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltr501.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/ltr501.c b/drivers/iio/light/ltr501.c
index 8c0b616815b22..3c9e1dc019514 100644
--- a/drivers/iio/light/ltr501.c
+++ b/drivers/iio/light/ltr501.c
@@ -1558,7 +1558,7 @@ static int ltr501_probe(struct i2c_client *client)
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



