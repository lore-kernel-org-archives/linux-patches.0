Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1426B1A9FB7;
	Fri, 17 Oct 2025 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716360; cv=none; b=S4Z+RrAkn+eS6cU2yB4lUXMlJAjhNRERpjiLPwWMS+NAlpVdS/VEwtmqHo0lIXaTYwFSSRPM/Jv5R4uVIiJX3+K1vI3iQMmz0JrG4jbwq7TciamnB8dMOQh5gko1EQVZDUkF7wmMYMw3nXv8filXN0RBoDfMklqI70/MM0DkVlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716360; c=relaxed/simple;
	bh=cXRDwRrybquujEs9aH4bjpePoRlrCO31jlQClZctejM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhONdJMNTQn5JYSvewswIw5XoiCvBi2Yfz2KF6pEkFA9SjxQsGgck+QckEUKwHOe0Rx24FdnXJwYAzF99ipuFjhAOCohIeQJO8b5+wAa0G3QwVaR43Fi1zre+U2A8kTiTJzToZXKDrPFelEj84GBcjoY4W6w4V7lVsMEB6cMXZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh+HEPcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh+HEPcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBCFC4CEE7;
	Fri, 17 Oct 2025 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716359;
	bh=cXRDwRrybquujEs9aH4bjpePoRlrCO31jlQClZctejM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh+HEPcfsJRRv8dlh28KUimyibkw4fCxsmqoSrPq/Pb98/WUTEyvTQF0xSDGOoLR9
	 EvC/3epix323ouR12z1JLI6y7CyLh8kp2J/stc5nf8c1QnxMwZV6rmm2EC6zvD04dw
	 sZVUW492aoxw7hkc6/FD5iR/hy9eYyuGW7jGMQAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/276] gpio: wcd934x: Remove duplicate assignment of of_gpio_n_cells
Date: Fri, 17 Oct 2025 16:54:16 +0200
Message-ID: <20251017145148.422374356@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



