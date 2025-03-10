Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060182309B0;
	Mon, 10 Mar 2025 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628202; cv=none; b=p505PbFskAlcTvyrdUKrbvTuT6i6T6bTs9OivoQAbViz85jd8U6VfqdNZgg9B9a8wPZ85jQS6KSAN60nCAh5MJHIhvntE/89Gq7Z9N9A1oJTei1SROyT9dHFZAYVuD709sFjVQ4bXSO145SbPTVIz9LpG3SfTxX2GyIwTnqIjtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628202; c=relaxed/simple;
	bh=+5f3pQIcrsht9TJNmeYDTh0g9iHNh1yJycuaysOWzXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMwXPrHv/CcAlkdNo3q/2GY+BkrWxX9C2AuaKZEsZcQ3QnKZp+c8D6bV+l3cLc7B4aBg0QWjoJT3UcdO1sus32VughP6Qm83kK/YoFdRIZzH6feqZCvrhDtbb+XRWVFVt4MNn6QOkkORLwyk0Un9ijoTUI+G6bxfdcCUTYwWiLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiUd9Oa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiUd9Oa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7C0C4CEE5;
	Mon, 10 Mar 2025 17:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628201;
	bh=+5f3pQIcrsht9TJNmeYDTh0g9iHNh1yJycuaysOWzXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HiUd9Oa10SHHTXQrO9NOUikHkCssuWEoihcgRD3ngXfTJsA28OI4Y98wmbqYT968m
	 OgGKf0t11jxTjKTa5nZUqLuu/F8gorFpyG51yavI8bKv5TMc2PCHB97jhyZ8C06HQC
	 1r9ldybqSlo32nFqrn6by6OkXWOvHTcjG8Ve+qFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 122/145] eeprom: digsy_mtc: Make GPIO lookup table match the device
Date: Mon, 10 Mar 2025 18:06:56 +0100
Message-ID: <20250310170439.696873532@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


