Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930BA46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA58C433EF;
	Mon, 16 Jan 2023 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886530;
	bh=vpGOJlZnWCJdFYng8MLp/+dOFaVdXuNXoAZVa0P53kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+LAKyexENorsjaRwJ9fgwjzJuor12VWzOcEEpFVuqGudvpK20iVD9BuR+1+89w23
	 gL8k4SD42B+J3/JyqpehEZsz1/5WHegsHT1wDkroidcoJXGaDOg/th0lm2gcYZXmE1
	 NOZleWv/+l9QAhteGd3OX5hInBnvTj3oOaBrntfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 448/658] iio: adc128s052: add proper .data members in adc128_of_match table
Date: Mon, 16 Jan 2023 16:48:56 +0100
Message-Id: <20230116154929.992545761@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit e2af60f5900c6ade53477b494ffb54690eee11f5 upstream.

Prior to commit bd5d54e4d49d ("iio: adc128s052: add ACPI _HID
AANT1280"), the driver unconditionally used spi_get_device_id() to get
the index into the adc128_config array.

However, with that commit, OF-based boards now incorrectly treat all
supported sensors as if they are an adc128s052, because all the .data
members of the adc128_of_match table are implicitly 0. Our board,
which has an adc122s021, thus exposes 8 channels whereas it really
only has two.

Fixes: bd5d54e4d49d ("iio: adc128s052: add ACPI _HID AANT1280")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221115132324.1078169-1-linux@rasmusvillemoes.dk
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-adc128s052.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/iio/adc/ti-adc128s052.c
+++ b/drivers/iio/adc/ti-adc128s052.c
@@ -194,13 +194,13 @@ static int adc128_remove(struct spi_devi
 }
 
 static const struct of_device_id adc128_of_match[] = {
-	{ .compatible = "ti,adc128s052", },
-	{ .compatible = "ti,adc122s021", },
-	{ .compatible = "ti,adc122s051", },
-	{ .compatible = "ti,adc122s101", },
-	{ .compatible = "ti,adc124s021", },
-	{ .compatible = "ti,adc124s051", },
-	{ .compatible = "ti,adc124s101", },
+	{ .compatible = "ti,adc128s052", .data = (void*)0L, },
+	{ .compatible = "ti,adc122s021", .data = (void*)1L, },
+	{ .compatible = "ti,adc122s051", .data = (void*)1L, },
+	{ .compatible = "ti,adc122s101", .data = (void*)1L, },
+	{ .compatible = "ti,adc124s021", .data = (void*)2L, },
+	{ .compatible = "ti,adc124s051", .data = (void*)2L, },
+	{ .compatible = "ti,adc124s101", .data = (void*)2L, },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, adc128_of_match);


