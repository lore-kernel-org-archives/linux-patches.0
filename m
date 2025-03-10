Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA3B22758F;
	Mon, 10 Mar 2025 18:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630985; cv=none; b=FW6404zk9gQelDdPXUKckY/cQP1jIXEhSfzF5Uk6Pg3suxa2VzsrZ0glCFBtmfz+JgpBLe8lAWiR2FrpWNJ6pQ4KoHHzCGNrvGCbyVu+QQbSRHBXu5mVfqsMdQpQeeek7I/+oZG/ZsftX1VesZ+9FdFxFMsAP/5wcbMsRpv0xtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630985; c=relaxed/simple;
	bh=RKfirVrlDNn7kl/gN3mSSkybuC+WrbHIarOed64lSVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acGrVF+Waq98ZvTxO0R8wEGskXfjIEMJLlaPm+3LyKg0olil2ARhiuZHWwPgm204kHGLXzaeaf4L/TG3jpZvk0Aa/OONU4PJnDde7DPneM+M6nbkez8tULJ1MmoC8fNBd84vBYpeq6RRDIBM5MzsZQtTX/rWccjXKRsoj1/8sJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m99xPCvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m99xPCvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9E2C4CEE5;
	Mon, 10 Mar 2025 18:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630985;
	bh=RKfirVrlDNn7kl/gN3mSSkybuC+WrbHIarOed64lSVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m99xPCvqQRiWbrIjVpgqWcUucUfTD9onTljzLEB2UkT4E89TfPWnxHW5lsCIzdqU4
	 7NGki043SufQHtcBpqMh9RQQEm/BEV7Tu9LzycA21EdB36Aw8/PafnDdnejr/UMeN5
	 5ClhJy6LAxTNSjTM9znaG60v9+RuA+xZY3yMOQuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.15 603/620] eeprom: digsy_mtc: Make GPIO lookup table match the device
Date: Mon, 10 Mar 2025 18:07:29 +0100
Message-ID: <20250310170609.334837789@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -60,7 +60,7 @@ static struct platform_device digsy_mtc_
 };
 
 static struct gpiod_lookup_table eeprom_spi_gpiod_table = {
-	.dev_id         = "spi_gpio",
+	.dev_id         = "spi_gpio.1",
 	.table          = {
 		GPIO_LOOKUP("gpio@b00", GPIO_EEPROM_CLK,
 			    "sck", GPIO_ACTIVE_HIGH),


