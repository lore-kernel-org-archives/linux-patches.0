Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D944E3D0D1;
	Tue, 14 May 2024 11:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687644; cv=none; b=cOED+PKrk76WbfUbP/vNF8mYWx0bAQRnrw4m5JmyiZHFmWz3ywwXCfRh4JwWq3ywZpQXf/Pv0ahI8Q3JXArViN0gDPWfV9+IQAX/ujNzEJbVxFwvCVQnFC3o8yb1lw+ISxGGT39rZISr1XvN0a12mys2rJPNOYxoX1XdwXWA8+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687644; c=relaxed/simple;
	bh=keyttUwgn3oWMVEZOMcOnLds7Kw9WPxNOEP3LQimvtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiBviJlS3pER+TxAHftofDfh3mcRiSmizoPjgrX3JCUMnp3fDRiQC3xjDAJpaXao6eh3Ucoj7DjUHmKhmrcVrYzjK2AHE8lcPBaHx0filMKFK1exovk4vxfB4CNaeX5LxcHi1wR0SW+UZ+84dpYtgwmRRS87EzhhNfIRIW4+hbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R32GUkih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R32GUkih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6D0C2BD10;
	Tue, 14 May 2024 11:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687644;
	bh=keyttUwgn3oWMVEZOMcOnLds7Kw9WPxNOEP3LQimvtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R32GUkihDNNwzCXFX9wnU26G1mk5g3MFIica3OKUgw2fXE70bGHs3z4ttetxPlqhe
	 MILC9gPKxsc6B6zEftZHkBIZl7KWrY9Tfg3+Gi/IRWv2DwyAHN2c6PYJKEandaKKqy
	 lPo+puxq4yURZuIOc9YKeKkh1+JKQ+if1nbCgWek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/168] drm/panel: ili9341: Respect deferred probe
Date: Tue, 14 May 2024 12:19:14 +0200
Message-ID: <20240514101008.807535007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 740fc1e0509be3f7e2207e89125b06119ed62943 ]

GPIO controller might not be available when driver is being probed.
There are plenty of reasons why, one of which is deferred probe.

Since GPIOs are optional, return any error code we got to the upper
layer, including deferred probe. With that in mind, use dev_err_probe()
in order to avoid spamming the logs.

Fixes: 5a04227326b0 ("drm/panel: Add ilitek ili9341 panel driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Link: https://lore.kernel.org/r/20240425142706.2440113-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425142706.2440113-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
index e1542451ef9d0..f8afa922fe9ca 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
@@ -716,11 +716,11 @@ static int ili9341_probe(struct spi_device *spi)
 
 	reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(reset))
-		dev_err(dev, "Failed to get gpio 'reset'\n");
+		return dev_err_probe(dev, PTR_ERR(reset), "Failed to get gpio 'reset'\n");
 
 	dc = devm_gpiod_get_optional(dev, "dc", GPIOD_OUT_LOW);
 	if (IS_ERR(dc))
-		dev_err(dev, "Failed to get gpio 'dc'\n");
+		return dev_err_probe(dev, PTR_ERR(dc), "Failed to get gpio 'dc'\n");
 
 	if (!strcmp(id->name, "sf-tc240t-9370-t"))
 		return ili9341_dpi_probe(spi, dc, reset);
-- 
2.43.0



