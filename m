Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7046422CBF1;
	Mon, 10 Mar 2025 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627784; cv=none; b=Fkh+Rqcq6S2SUTb0vbltSpAW7j4YDU9m3HloJb5MwJLnBAr5u+gu/Ct29jcFpET3DISbJ+eQo8a1FUPcKyuHvl6l9s7KkPQWYBrR7S5xPqEflLape/eqDmStuLAnlwXOHp9siX5j0/v6rsSgULT80Dl7sLd88ARAtFZ8J3vxdeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627784; c=relaxed/simple;
	bh=FDLDK0uBwFq/fPU0CVaRpf+wFmubTUbyWqrXCDOGJeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpMp9yDC9g33xZM9lA1UvN0tb6bndZiRCZ5ewxt+Q94gIjT0M33bFsqT3PkKE1S8NSNAvpFxoGWl7bfDUp2liBtQ2Yyp9d+zWBDMzJwEmyFOvX5+dXZVI90EMaCqYDy/HI816g6Rq7gPttkGhy2TiDChYxN6AQy9GWvHVxHhnf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQYOR8lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQYOR8lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC02C4CEF0;
	Mon, 10 Mar 2025 17:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627783;
	bh=FDLDK0uBwFq/fPU0CVaRpf+wFmubTUbyWqrXCDOGJeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQYOR8lZXBk7bvN8OV2bC35WsQRJD8ZAhZbCm1kOFnMiFP/CZSjsdfZjHp95Nv77D
	 oKyjjavrZ46eS7er4l/pm1P7S4j6M0/xMElmcSxTNowC3frrC4ULLDV6mhRDvujbU2
	 Yc1YRFW/8jeWq3y1C8+ffZKOPXUt7FgKWMLhG5yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.12 247/269] eeprom: digsy_mtc: Make GPIO lookup table match the device
Date: Mon, 10 Mar 2025 18:06:40 +0100
Message-ID: <20250310170507.640243017@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


