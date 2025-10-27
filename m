Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1728F32549E;
	Mon, 27 Oct 2025 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591250; cv=none; b=OJUn37chJhOoWnO14W50BdPr1fw3wpIFAzId15W/7+hMP/K8MnCw3fqeM4pRKreuOOUc1d0Pxp8jKrQnFD38hCtEoXUoZuZoVI9nShdFxcbuPtyj2pUzRAL/Fq7Ui6NBk2P0Wr7tD7MAGeF1ThHPxL/awIp10vBqxJxKE+iV0CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591250; c=relaxed/simple;
	bh=lc7rr2b++eJGRW+S0Nn1K6fdDOYQwETtbLVb63nT7ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhDxtA16cxuYuwo4uARm6rQueHJCsQPYqA9VpND3V6gK0A4+PY7+g7hr3Il6DS9AE6SyDfxauUoPL3braFgvcK7dTUt3mKLUNVYlVw4M+Q0dvNiPbJwZfExtwS94XLGc7kZig+mbZ7ZjMnA/Sejy/47Lw9SSqdiVM+y9eUO2oLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDgJD9W5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDgJD9W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D5C4CEF1;
	Mon, 27 Oct 2025 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591250;
	bh=lc7rr2b++eJGRW+S0Nn1K6fdDOYQwETtbLVb63nT7ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDgJD9W5yJjEhkhHbuwfQz1z7IGeakufxBsNsZJ8JY9dui7pW7bUOADHzOaSOvJSL
	 MyTL1ZukV+rqOzSyQoGdG9eEFjDIClMJxISw8UHGDp1Qa5b8hxAcdObg5MzQ8mVW70
	 fbsuTZ5WDIzZ3Zdoz2U9Km01yLnFfNWxu3b54AGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/332] gpio: wcd934x: Remove duplicate assignment of of_gpio_n_cells
Date: Mon, 27 Oct 2025 19:32:58 +0100
Message-ID: <20251027183527.913577571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a060dc6620c13435b78e92cd2ebdbb6d11af237a ]

The of_gpio_n_cells default is 2 when ->of_xlate() callback is
not defined. No need to assign it explicitly in the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: b5f8aa8d4bde ("gpio: wcd934x: mark the GPIO controller as sleeping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index c00968ce7a569..cbbbd105a5a7b 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -101,7 +101,6 @@ static int wcd_gpio_probe(struct platform_device *pdev)
 	chip->base = -1;
 	chip->ngpio = WCD934X_NPINS;
 	chip->label = dev_name(dev);
-	chip->of_gpio_n_cells = 2;
 	chip->can_sleep = false;
 
 	return devm_gpiochip_add_data(dev, chip, data);
-- 
2.51.0



