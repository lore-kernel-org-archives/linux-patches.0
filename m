Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950563370FB;
	Fri, 17 Oct 2025 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713105; cv=none; b=rZofZfi8BX0FKJyBcN42A5uCtn2jhSQXM3UISIn3tz4RPrKtJX9lt83RABeTo30d+rQtr5pJd/Mx+eMrYgVcxsPoVhX9gq/BzhS8KZnAV9kW3VzXv7pHSJzpwvjirgv2iEl1SKBI1qATQW+YrXafmwVjiewEIMEHqzkifWiE0Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713105; c=relaxed/simple;
	bh=/tAV1V3vhwkYZhMYnKkpggYAX0hlaqtjvw1tnNU1eQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrMAhNeArX4tpLWbWleLmraCNfZTqQxKQKKXFf6+P22fkfncdx6ptLjnRl3Jf6I+5tdehIN8qJQoJhAFq5Wyji/OzpD5j4ixuPx4Z+PW2es9avB+XXnJ4GuSOzQr5LHE+sSM+wllPWkoxVg605Cfxio1SBw757uEjBnLfvXpgto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxqL+FHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxqL+FHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B2FC4CEE7;
	Fri, 17 Oct 2025 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713105;
	bh=/tAV1V3vhwkYZhMYnKkpggYAX0hlaqtjvw1tnNU1eQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxqL+FHPnQLzRPQP0SkE62H+ds/KKSPQ9rd81CJ20vM6kSvxSgiLdQraT5KPXkCHC
	 fRWTV0oe90flp+SFIyYeCFOme0aGNLN4Zv4bwTa38rZs36G6YgTsoQ25gsB158vsv1
	 9AMUZuINmtbHRf6SyqP9sC2SPpfsjRhEh30SqRKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/168] gpio: wcd934x: Remove duplicate assignment of of_gpio_n_cells
Date: Fri, 17 Oct 2025 16:52:07 +0200
Message-ID: <20251017145130.787893091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



