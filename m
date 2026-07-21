Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815C443A80;
	Tue, 21 Jul 2026 22:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672582; cv=none; b=PYkvBc+cL3RLH7Fub5uqVzSxVK8b6WZFYaUXiw+d1At8p+qyJDokq3ydYebs0SR7w79fFUBovGNp7T1yJFg3uJ5cE5lF+2fAQehmGOux16HCTIUAeA4PNTgY+7gHVyVDslH6ONOKv9LqlWwqRiLdd0hM3wlN3KJWeda+vjynwM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672582; c=relaxed/simple;
	bh=MTb5XWII5MiH/9HTtkxJg+VjZH9kX7R55f5x2cNxBdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prSgdXRnOZJHOnz8k20bdHLHblUWcGzc9mKcrUryDWwPMF4n5FV9mljoUMnlMMxfON37igJ7Y3Tp5uFEAVYIGim+wRp+cBk/89cSftCPfnQtpCy+jYnqtVRLfk9x16RrrIHvMqIe2oToZ7t0/GBUw2YOzghetyhNORR3JYy4yqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKeAhN60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKeAhN60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CC41F000E9;
	Tue, 21 Jul 2026 22:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672581;
	bh=OsL6n4CRXyq8LrKQ/ncDXEn+ULwqJMee0abw85TFgXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKeAhN60ZaCZeHptefVqLh3chJtKBUjQ82Nw3F/pE2bCWnyOajmUbJS2a3TLtqCsE
	 qxX4+pimBLnLkLPOyTvduLMnJ3MS1DoNsLyqUBN0CB9kihnnhpsSbKOzNoYjWO0iaC
	 nSb7IEcxwfvF/ZcYpUat8x73FWxM8aR/tKropFFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 635/843] hwmon: (ltc2992) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:24:30 +0200
Message-ID: <20260721152420.349168134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit a35a6f1b20100057c66b7be5a8f6864661c3945c upstream.

The Kconfig entry for the LTC2992 sensor doesn't contain a
`select REGMAP_I2C` parameter, causing build failures if regmap
isn't selected previously during the build process.

Fixes: b0bd407e94b0 ("hwmon: (ltc2992) Add support")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260629-add-kconfig-deps-v1-2-8104df929b1a@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -875,6 +875,7 @@ config SENSORS_LTC2992
 	tristate "Linear Technology LTC2992"
 	depends on I2C
 	depends on GPIOLIB
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Linear Technology LTC2992
 	  I2C System Monitor. The LTC2992 measures current, voltage, and


