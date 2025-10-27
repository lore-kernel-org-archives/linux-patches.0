Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79AE2D5A14;
	Mon, 27 Oct 2025 19:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592705; cv=none; b=n3hWhtIzI1dsGA0XwEkf4VfxraqqNKaUt51Ll0hUhIUJrHKm4fvqInf2V70RtEg6Ax2nn+m4k7tCAiFpRmhCRtviPz9f2cHL9YTcLL0z1pCxjRusk5dAUlOh8JXj0+xmpRXQ8WYUdTmyiN4sXGxvOUZZBXqmVqG5++zZhLH3bdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592705; c=relaxed/simple;
	bh=FVCficxlZM4mxxaM8zqDqidTxFbUSMKV8V22IcXdzCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3GVjDf9+6cRu7DwFInjrRSa/ZA0GMhnVJvmBFr10aMzj8nH42fE3UhVWHBcxQ2NvRP4onApiqKi6ki+UqzqAku7vQ4y9Yv5H/hia7qrJ0SNwfJmjTNF0yKR5Fv2jylinMWJi6FH87C3yqFPfFlt7WjrYg2vKfnhlTsj/3eREu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2EHZnj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2EHZnj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31774C4CEF1;
	Mon, 27 Oct 2025 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592704;
	bh=FVCficxlZM4mxxaM8zqDqidTxFbUSMKV8V22IcXdzCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2EHZnj4Ftzd1cFjPf0S72qzmF1jCYxhNmVJjYPcJyocEmrx3zP3sp43OkX7Bpf9G
	 1ZSWbEp6k25ax6tBoHI2iHXNH4Sv1bdzhjYBxWrqtFOfOR5aqqtR2PJs8l8MQqccly
	 TGJw8psLJW/ws/IGiUhHhoS5F4pgy24o1cWCA3Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	William Breathitt Gray <wbg@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 35/84] gpio: 104-idio-16: Define maximum valid register address offset
Date: Mon, 27 Oct 2025 19:36:24 +0100
Message-ID: <20251027183439.755351026@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <wbg@kernel.org>

commit c4d35e635f3a65aec291a6045cae8c99cede5bba upstream.

Attempting to load the 104-idio-16 module fails during regmap
initialization with a return error -EINVAL. This is a result of the
regmap cache failing initialization. Set the idio_16_regmap_config
max_register member to fix this failure.

Fixes: 2c210c9a34a3 ("gpio: 104-idio-16: Migrate to the regmap API")
Reported-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Closes: https://lore.kernel.org/r/9b0375fd-235f-4ee1-a7fa-daca296ef6bf@nutanix.com
Suggested-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20251020-fix-gpio-idio-16-regmap-v2-1-ebeb50e93c33@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-104-idio-16.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-104-idio-16.c b/drivers/gpio/gpio-104-idio-16.c
index ffe7e1cb6b23..fe5c10cd5c32 100644
--- a/drivers/gpio/gpio-104-idio-16.c
+++ b/drivers/gpio/gpio-104-idio-16.c
@@ -59,6 +59,7 @@ static const struct regmap_config idio_16_regmap_config = {
 	.reg_stride = 1,
 	.val_bits = 8,
 	.io_port = true,
+	.max_register = 0x5,
 	.wr_table = &idio_16_wr_table,
 	.rd_table = &idio_16_rd_table,
 	.volatile_table = &idio_16_rd_table,
-- 
2.51.1



