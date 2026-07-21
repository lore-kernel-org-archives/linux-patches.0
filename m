Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD06137647B;
	Tue, 21 Jul 2026 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654673; cv=none; b=BKKkJ8BDXAiEPXKuERwmbScq75QLk/QFVPukeKVqb+ybcOiaORswVeK4kEvFTk4InT1bSfj+7hiZbr340CIgff7mPt3GZt91QKOyg39P3hCVRwItV7iDV/AMuYMjzQkPekDIqaGMvUPpLGQb4rtRNfxU4G8ztYRXRQcHFVf7eNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654673; c=relaxed/simple;
	bh=kfND5VDQ8wfJEXTzpOfv8gEeSig3KYHOHVU7WAJSgoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ls7Xh+j2rf/gjy0/JoTivpVKMFfAQmbR78aWOFW3Zp7yu+xJlu+NwzGJ/OyWSNfFe+Hi86nKyYuQC+S7QZhQhohAjXLTrOOYpZqu8BBVubfxBbsJdOAWKmHjeMefQDkWyfQTpxhWMIGthkG+LvalYjnG5LwuO+KyXOrnzmaveYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbVMi9TW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbVMi9TW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4D01F000E9;
	Tue, 21 Jul 2026 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654672;
	bh=Nl/gcM6UMl7mUyitA1BZ8vy88kHlD1FIbXqNCw3LsUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbVMi9TWZm706nPXzWC+d6H2A6K8R06p+dsvRmV7W3AboSt+XNzuR5WvrDgqjCqoH
	 3kMS0snrYCl3RR/mI8ZdlX7HQFguRe2iswZWjcbncHHqHgyaNQrKr/SmFexRbMiX5D
	 xDSqOiA6Vg0vzJHALayqP5qZR9mOTTdpTc7rSQMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 1792/2077] hwmon: (max6697) add missing select REGMAP_I2C to Kconfig
Date: Tue, 21 Jul 2026 17:24:25 +0200
Message-ID: <20260721152635.014038543@linuxfoundation.org>
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

commit ed576f2f4eef8cbe2c110da503825a8dc4717030 upstream.

The Kconfig entry for the MAX6697 sensor doesn't contain a
`select REGMAP_I2C` parameter, causing build failures if regmap
isn't selected previously during the build process.

Fixes: 3a2a8cc3fe24 ("hwmon: (max6697) Convert to use regmap")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Link: https://lore.kernel.org/r/20260629-add-kconfig-deps-v1-3-8104df929b1a@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1333,6 +1333,7 @@ config SENSORS_MAX6650
 config SENSORS_MAX6697
 	tristate "Maxim MAX6697 and compatibles"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for MAX6581, MAX6602, MAX6622,
 	  MAX6636, MAX6689, MAX6693, MAX6694, MAX6697, MAX6698, and MAX6699


