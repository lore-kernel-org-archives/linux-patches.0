Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68693433BAC;
	Tue, 21 Jul 2026 19:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663955; cv=none; b=gnk34yyWs87wlb4tZr+Z/0HimtO8brR915lrZXRz4XZ6yMFaszh9X/WbDNAkGY+idLQITXxKF6scztN30kS0TB5Z0m+a7W5Dd68cpI/clyEZmM6+xHTj+YOo1lopUPcWlNQg/n0KK21YhnN2GHm1dFMyLufWvsMy8UlA1+Uas9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663955; c=relaxed/simple;
	bh=jpg0AXZu8s6s7Uzb24oceNJOjmM5hlHLoNtg8W66c2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q01uqfU4k710nSBn0IeZXTRySIfQOO3u6dr0uG9fLNQBI0S04BLJpWASPnXB4/jHEJBZOuAg7OxfP01PMLIfzFTfX/upeBCunuYXNaVWyO7UM9zjuvMtvL9cZDw04ilU9X7098rZLCRa9tQ2mWDgKlibHjDk4OPja+vRlFlGP1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jbli/d0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jbli/d0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D4F1F000E9;
	Tue, 21 Jul 2026 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663954;
	bh=5vJmjQqHn0ZtvIKzikMogM2MehBEA0p8htQq8ajdehQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jbli/d0wf1DagQLbD9yUM0fXWC/Gp159mXpLSl+SrU7iIFoH/UylJDYhYOpt82Uc9
	 qmu6Jym4vTvv72xS6tNuGGL75a0dZ4mb27rZdlX1Jn+FCOwpk7kzihl4qrP6+wUGpO
	 36RTEFvZxwO+fCCPzl748JTZbia8rtTu9NWxTODc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 0975/1276] hwmon: (ltc2992) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:23:38 +0200
Message-ID: <20260721152507.837893069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1014,6 +1014,7 @@ config SENSORS_LTC2992
 	tristate "Linear Technology LTC2992"
 	depends on I2C
 	depends on GPIOLIB
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Linear Technology LTC2992
 	  I2C System Monitor. The LTC2992 measures current, voltage, and


