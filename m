Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E588F22FACA;
	Mon, 10 Mar 2025 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627010; cv=none; b=IdUggymnEg0PSLKXa1txgZB14cTYh+J/twJyKFBnf45/4Zi/dAeiQjIKuaf375IbX4FjG6dqh4qSxdTUDl8Re76+HoTIqXxXiPsC4dumhdGCBR9GBBAcF4Vvdd6E1cps92On4yfprnmaEDNMOjfj0bhqRjcjJm6EIcJOWg/YQGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627010; c=relaxed/simple;
	bh=CQEIVUrXqxrIp5XpP7OM1RkFrlpfo7UYSbird1Lc378=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTrdKbsycYEvVGvMKvKWNkH5J79qtD8ikdaWSqFTdBh7VDpqtuP1NLOva/3ClCc3W8Wa80aaMWFJiDR4iwFuogWOHlJnOqD+O6bawzaxoWZF1k4JMx/sZUJACRrQ1vuIQGjivf8NjlpcrkGLeQ/XQjN2ul08HLDPZr4a+vKUjaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLuv1JBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLuv1JBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A88C4CEEB;
	Mon, 10 Mar 2025 17:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627009;
	bh=CQEIVUrXqxrIp5XpP7OM1RkFrlpfo7UYSbird1Lc378=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLuv1JBITO24/SYbQT6fJqfOuuWIGDWvHBcOSpxcfOIzd7PFJ0VoBiPbvbZmrmn2C
	 6d74UfAbRIJALEUHrk/x+ZjVc8OH168Rw5JBJXIPnDeatFRdisG4KqpmcBz+K8eYP5
	 8tJX3YkLyK4dbJ9y2yjizNcMmCvAJnKkF3RNB8j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.13 190/207] eeprom: digsy_mtc: Make GPIO lookup table match the device
Date: Mon, 10 Mar 2025 18:06:23 +0100
Message-ID: <20250310170455.335821113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 038ef0754aae76f79b147b8867f9250e6a976872 upstream.

The dev_id value in the GPIO lookup table must match to
the device instance name, which in this case is combined
of name and platform device ID, i.e. "spi_gpio.1". But
the table assumed that there was no platform device ID
defined, which is wrong. Fix the dev_id value accordingly.

Fixes: 9b00bc7b901f ("spi: spi-gpio: Rewrite to use GPIO descriptors")
Cc: stable <stable@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20250206220311.1554075-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/eeprom/digsy_mtc_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/eeprom/digsy_mtc_eeprom.c
+++ b/drivers/misc/eeprom/digsy_mtc_eeprom.c
@@ -50,7 +50,7 @@ static struct platform_device digsy_mtc_
 };
 
 static struct gpiod_lookup_table eeprom_spi_gpiod_table = {
-	.dev_id         = "spi_gpio",
+	.dev_id         = "spi_gpio.1",
 	.table          = {
 		GPIO_LOOKUP("gpio@b00", GPIO_EEPROM_CLK,
 			    "sck", GPIO_ACTIVE_HIGH),


