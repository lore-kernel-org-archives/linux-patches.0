Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8EA15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F07FC433C1;
	Mon,  5 Dec 2022 19:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268112;
	bh=xWBH+rj+UlzdVHuvJaGumSdIcpOkso0C+5ZUmEncoPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAsu8XmODuts9YTF50x6SMtBVwgLMyZRhR4MSucARsUxZswch6LnNWHVv5O7P/oXx
	 XyEC2iOhsGfkcc1g6NoIWY7/PzWuf4DVV1ANu9csKSK2x+pmcf/xQArVAvj4YqF12V
	 nI2le2mkgNUaNikaUJ+Tjl+eZAjNSua8AoCCnC6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Gazzillo <paul@pgazz.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/105] iio: light: rpr0521: add missing Kconfig dependencies
Date: Mon,  5 Dec 2022 20:09:35 +0100
Message-Id: <20221205190805.296779789@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Gazzillo <paul@pgazz.com>

[ Upstream commit 6ac12303572ef9ace5603c2c07f5f1b00a33f580 ]

Fix an implicit declaration of function error for rpr0521 under some configs

When CONFIG_RPR0521 is enabled without CONFIG_IIO_TRIGGERED_BUFFER,
the build results in "implicit declaration of function" errors, e.g.,
  drivers/iio/light/rpr0521.c:434:3: error: implicit declaration of function
           'iio_trigger_poll_chained' [-Werror=implicit-function-declaration]
    434 |   iio_trigger_poll_chained(data->drdy_trigger0);
        |   ^~~~~~~~~~~~~~~~~~~~~~~~

This fix adds select dependencies to RPR0521's configuration declaration.

Fixes: e12ffd241c00 ("iio: light: rpr0521 triggered buffer")
Signed-off-by: Paul Gazzillo <paul@pgazz.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216678
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221110214729.ls5ixav5kxpeftk7@device
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index d66ea754ffff..485362f0a213 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -238,6 +238,8 @@ config RPR0521
 	tristate "ROHM RPR0521 ALS and proximity sensor driver"
 	depends on I2C
 	select REGMAP_I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	 Say Y here if you want to build support for ROHM's RPR0521
 	 ambient light and proximity sensor device.
-- 
2.35.1



