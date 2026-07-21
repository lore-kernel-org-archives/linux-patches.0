Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A69C375AC3;
	Tue, 21 Jul 2026 17:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654671; cv=none; b=HVUHNHbtFJPtAlwWWc9+7QeEK6R86eUWSt09Y7JFLBnqq3htByGd0GU5pvO9zb1PyLJ4/IsQZBdFFavL2E5Lhk7vxBamZpa28btt97U8FbOaXibNPdXWWgQBGKP0B9WY6uj2UQ/fHA2mg5dP08MK3K6uemwuax+YxWc63Mf7Vzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654671; c=relaxed/simple;
	bh=Sf26BozLNhVAJph1VBoqpvHUdzZQRXemPv8+3Uz/d4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTf4yelxzNuDwEV+BYWGAbDCgjOSrI6kPiwlq90k7CoQu7PElCg76abjo37lTBiAC+Rn+mo15sa2edAKYK0z0iAwlESK0Wg6R/x8VArz4gCsN7908djZfOWr2I6+CNv67TRBR/FJfrURDtI1htbiLQIWWsWw6RpA1HeR+5ga89M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYFqo/Mh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYFqo/Mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9817C1F000E9;
	Tue, 21 Jul 2026 17:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654670;
	bh=fo/TR5sMi0t2bGxXk4NdIQKSw83BOGhh/rA2Hns5IOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYFqo/MhvXx9jDa0cXJSTUstevPEKvsyZ1xpgQJv80FW/STBPG0jP2XkKhszOL27U
	 rRGQHDRb/gn7iKZDgUqY/Zy+CeVUj9oa9mJOVng1pyiaqsMuBUP70uihBsjg7A2kSc
	 YE9xqkxWXrqdeRzcSmW7lAKNBIK0Gj+IwivtZmnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 1791/2077] hwmon: (ltc2992) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:24:24 +0200
Message-ID: <20260721152634.989735559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1076,6 +1076,7 @@ config SENSORS_LTC2992
 	tristate "Linear Technology LTC2992"
 	depends on I2C
 	depends on GPIOLIB
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Linear Technology LTC2992
 	  I2C System Monitor. The LTC2992 measures current, voltage, and


