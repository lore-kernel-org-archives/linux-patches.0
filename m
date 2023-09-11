Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBC31172F
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00315C433C8;
	Mon, 11 Sep 2023 15:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445671;
	bh=sA2w6D8rP0vawXD4vFDBFj4nG9jVkf4K4sBmEiv7L10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbMyK3LB/3/Dwp9Kk2AOaa5KdmSocYkuMZE9VlBFbNIfxdwmsYo/b+8+xQ7YdOfoc
	 yzWdprFhhVb1tgVvadKSsAvqNJzq/tCYIIP9DjtQw3XprY2xYkx8cg5t7qWxZbt6pH
	 5mECfkn3AtBSwM1C2Or6FvIk29GnRz2VpQcxb3BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Machek <pavel@ucw.cz>,
	Ricardo Ribalda Delgado <ribalda@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 392/600] media: ad5820: Drop unsupported ad5823 from i2c_ and of_device_id tables
Date: Mon, 11 Sep 2023 15:47:05 +0200
Message-ID: <20230911134645.247419001@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f126ff7e4024f6704e6ec0d4137037568708a3c7 ]

The supported ad5820 and ad5821 VCMs both use a single 16 bit register
which is written by sending 2 bytes with the data directly after sending
the i2c-client address.

The ad5823 OTOH has a more typical i2c / smbus device setup with multiple
8 bit registers where the first byte send after the i2c-client address is
the register address and the actual data only starts from the second byte
after the i2c-client address.

The ad5823 i2c_ and of_device_id-s was added at the same time as
the ad5821 ids with as rationale:

"""
Some camera modules also refer that AD5823 is a replacement of AD5820:
https://download.kamami.com/p564094-OV8865_DS.pdf
"""

The AD5823 may be an electrical and functional replacement of the AD5820,
but from a software pov it is not compatible at all and it is going to
need its own driver, drop its id from the ad5820 driver.

Fixes: b8bf73136bae ("media: ad5820: Add support for ad5821 and ad5823")
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ricardo Ribalda Delgado <ribalda@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ad5820.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index a12fedcc3a1ce..088c29c4e2529 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -356,7 +356,6 @@ static void ad5820_remove(struct i2c_client *client)
 static const struct i2c_device_id ad5820_id_table[] = {
 	{ "ad5820", 0 },
 	{ "ad5821", 0 },
-	{ "ad5823", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
@@ -364,7 +363,6 @@ MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
 static const struct of_device_id ad5820_of_table[] = {
 	{ .compatible = "adi,ad5820" },
 	{ .compatible = "adi,ad5821" },
-	{ .compatible = "adi,ad5823" },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ad5820_of_table);
-- 
2.40.1



