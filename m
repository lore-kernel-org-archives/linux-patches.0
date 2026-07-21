Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C533368A5;
	Tue, 21 Jul 2026 20:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667335; cv=none; b=bSbUuQKWbWXKWGWtz0o9DumxlQMIqyRDEKtnmhU5DoQexujQppqiCD5P/Wc1YFaaRreAk5VwWyQQ1lAB4n4dVPadnS+a4WJF8jR5c+QN9LVZ47JaLt0+zTTprUV7pQnnnAZwFkn3SzboWdSkoWuq0CJsKfsvEnu0/c33KVHJGTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667335; c=relaxed/simple;
	bh=svwIMuz6SFzVzUFkNgC7R6l9K6DkYyD1mlLUtPU/6fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImcHhGCk1UTXrhAkpZzELDji4CPRzJsTeqreGOKdLPwJZBX9l4ve6T23W20uz0H48c1T+3FOErltrr7z6FEFSQF9I1SHrpN6GrL80LoMclglSfIeVYDV+DB8ZuF0pQIUqkBoGZhnGMyS4zpSMHTxx1lO7s8lU1AGpvrzQN5vPTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJPFqYXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJPFqYXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7B71F000E9;
	Tue, 21 Jul 2026 20:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667334;
	bh=cpJbf/EpUQ/dGehHr2WOXnUsrtaiBNrFL47AGcw3JTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJPFqYXhALyNOYIExP8vZX3zrqEnfGZPVmLFCNY7t6DDK6sFM8QNQvfsHRcAE49D7
	 YxoSBpLoxSdy+xzESQEvpgC7sg+9zXpnHVDDtMlunAq6USbl4jjxZWQ06yAANLfsVy
	 BcI8JAJCg7KIm3a7vCpXZW/qE9dkCA0TIMuwhNAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 1023/1266] hwmon: (ltc2992) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:24:20 +0200
Message-ID: <20260721152504.718391116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -938,6 +938,7 @@ config SENSORS_LTC2992
 	tristate "Linear Technology LTC2992"
 	depends on I2C
 	depends on GPIOLIB
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Linear Technology LTC2992
 	  I2C System Monitor. The LTC2992 measures current, voltage, and


