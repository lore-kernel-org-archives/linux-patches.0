Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD27E110;
	Tue, 11 Mar 2025 15:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706295; cv=none; b=TZPgfk0i0Iar3p/JVkcoTw7nOHvOh2Sw73iZgLpZSmg/S57A8rjLNRrd6ek5BqyvPlDNuokSgnTV6+/g996nAgMAttsunHVPHEQWvsCLCYS7UpA50A+ixhw/xIgBsTKvcCa6AgLbiCsYx1WZZyLKdrU+oMozBcBZskyNF3/tH3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706295; c=relaxed/simple;
	bh=TGpPjInJ29f+hPylNgihQzk6lcDzsi5u0hUdWg0SRxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgD3DVgBNfMEAtidns+keb6cgd9Dy0ahYZhL7g/tM9q0HttzOvKiuAUCBzvAx+uuhu51ypTAhyP6wApH/KUzJkqjNk8fY3dJxxefIzyv1rJtNYpADz1PWgdqthhYhHBDzwQ7Ccwg5qR3I+c7g9nT64SI4siQIrYCSYWsD8EDUsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mO+r5lon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mO+r5lon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A11C4CEE9;
	Tue, 11 Mar 2025 15:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706295;
	bh=TGpPjInJ29f+hPylNgihQzk6lcDzsi5u0hUdWg0SRxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mO+r5lon2336Iz7UJ+t1o5N0PJe/Q04SECzrzCZ+mA71fvaK+OOrWtyHbTpUh3DIn
	 Fmu79MYwrYMrCHZp/ec5mGRvm0PfYXU53RrnZuQS1/GwHLyieIvNlbysaP7a9AJeJ6
	 dUiwepeYhMNOnVkmpOO4AKGOrP8JjrtNJli8Yk98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 328/328] eeprom: digsy_mtc: Make GPIO lookup table match the device
Date: Tue, 11 Mar 2025 16:01:38 +0100
Message-ID: <20250311145727.930970870@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


