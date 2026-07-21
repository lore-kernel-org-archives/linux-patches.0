Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B3D44AB9D;
	Tue, 21 Jul 2026 21:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670151; cv=none; b=iuYcs44C5JPuXC3FCgS57iH1xvffQSez3AkLePIB1opTguX6fxs9PTSt3ujFnTaPaco0LcZ0QukBoH1J/hOGlnG3RlMpH/zdIJZ9yWjFGVLbvqsCVPna3PjrCoAhUrX43LcKwOb9/DBdGSbA9HxECFjcGwN2nRtRe+btH/GSs8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670151; c=relaxed/simple;
	bh=wRnrtXPrHZeebJdtaVcBT1ilZH+d02/jLJH9CTKeqq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQWjfL3ntblESGsG0KjevPcb7ktkXG1VKUu/4ezoo2zxSV/YNDEEZed82HG/l600+XXSs+Kg5MPS+CVHcgFrJLqNW2LwjD718HaDlTprDjsw+mZuMXJJOmLAOjkM5HTWU9I53y1cGN4rCMZvyvKdORYRAc7xoxVUbINQb3K+UsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmtD3zV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmtD3zV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA1C1F000E9;
	Tue, 21 Jul 2026 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670150;
	bh=VJNP3NWRk5tV0JI/RBIFHf6bfse2RInTdPKj1TvUYfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmtD3zV8AGR1HY4qfqNWkCxco4CRj+uEKNidQTq0szf33j8WVmA+Ba4CHMkDD+2oq
	 NJMmHwwQuqa4jlXN8f79ywlEJY8ScYm5BasKiKSQTklKgc/RxRTdaX1c+lBZg/ELjR
	 Y7iH90sJZ4x0vmV+34lf4biwv5tbR5OWDQhzl7KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 0823/1067] hwmon: (ltc2992) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:23:44 +0200
Message-ID: <20260721152442.961878732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -910,6 +910,7 @@ config SENSORS_LTC2992
 	tristate "Linear Technology LTC2992"
 	depends on I2C
 	depends on GPIOLIB
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Linear Technology LTC2992
 	  I2C System Monitor. The LTC2992 measures current, voltage, and


