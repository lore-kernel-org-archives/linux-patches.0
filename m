Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003CC190072;
	Mon, 10 Mar 2025 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628573; cv=none; b=c3Wf1hnHmfMhFaGILLxL44U8fhCjR6lkfL2OadRnU4wf69JTZp1ycZGw+dGffMRROW99FY0UdLSTSLAOoZP02ByweXTlObsvZzEddSaaFsRPXQ4yEOj1wg5V1Bvu5udr8VEJqnCIFpCCnv3QcBUxgEEfK61u3iiKxUpQb8eBgJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628573; c=relaxed/simple;
	bh=X0YF/2pj1s9zkKKnN0OO7U1SwhAH4BQkVffH9GNuFwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oid5GXJ6QpdAIAHDyg9fEVsoNfaP5UnMWNjbj6rGaYM340F23xsM1ZkJkrDeKH9E2WlwubOdpieSqk4paMBNjkfGU9XlJ6VQyjcDJ2E/0/tuVq5Gcd2s+tZpgaLgJFM+IBGKJ3m3Kyxriw89f34aHPZpCw5QMQcD65rH1x7/B5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQMqs6/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQMqs6/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EC3C4CEE5;
	Mon, 10 Mar 2025 17:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628572;
	bh=X0YF/2pj1s9zkKKnN0OO7U1SwhAH4BQkVffH9GNuFwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQMqs6/X5507FUWiO05qqz6YC78zl/W+IktMvFcl4iLHqkLX7PM1BEsJZskLIqd9D
	 dOZd0AQsyf6YJtnCUbzN5PvZWA7EKYkIaPn9BxDXs7wfgS/v94L0DzMPJh5sMqZ6ke
	 wl0Qp7Jw8r9CF4cbKw1kX8LlwaO+2n8ew3+gc8Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.1 087/109] eeprom: digsy_mtc: Make GPIO lookup table match the device
Date: Mon, 10 Mar 2025 18:07:11 +0100
Message-ID: <20250310170431.023565968@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


