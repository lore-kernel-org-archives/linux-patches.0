Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BDE481B3;
	Mon, 14 Oct 2024 14:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917293; cv=none; b=uzZ4qhWfPB0/VJHe4ODNgq82vZBKWfGUzxJ4vhJsD6CJZ3M0SJI4Ce9t9KrMadW+vX3+dcQjUpflJmqSo566QaQdVZMzcdbq7lQAsqXJgaO80gAmMCe009Yktua6b3Z7pKwC/S90DXqf7ljuhmBL+nG4f2DY0xSeHsNVrMJQO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917293; c=relaxed/simple;
	bh=mqZqMaPrml6e66mrMOOP3t/yKX53xNdvltPsYaIANX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huQfABzmt0up1KLDB5yBIz9pqOKKcz1sVmw0UNvLQMtqr8zTbmHn7wQ+Mli7KuWrAkxsLpenLFp8v1qy51QWQmNUosmKMoUanFrReArTOZYTDhwRGT369ZUt6y7FA/C9XTgC7qh3M1unNvVfOtr7JUQIwCgCsH0yTUwbsM2c2xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plgr7jKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plgr7jKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21158C4CEC3;
	Mon, 14 Oct 2024 14:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917292;
	bh=mqZqMaPrml6e66mrMOOP3t/yKX53xNdvltPsYaIANX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plgr7jKOLw52CdPc58QBOza/gdfBY+F1WHvUQo4GAH0konqmp+HkSGcoBdJ2WeW0G
	 mW4ay/QWMzSElhhpGONpi8qFNF6gB6HxNiGyMnrWAQr9YcSBRqew8Q2L99hjGMZKXf
	 7v1owS4If6mzB8ZpRTDHD1CpE59Lncy0mYojrAy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/213] hwmon: (adm9240) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:21:23 +0200
Message-ID: <20241014141049.873951102@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 14849a2ec175bb8a2280ce20efe002bb19f1e274 ]

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: df885d912f67 ("hwmon: (adm9240) Convert to regmap")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-hwmon-select-regmap-v1-1-548d03268934@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 393ac124012ec..5121005649fec 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -174,6 +174,7 @@ config SENSORS_ADM9240
 	tristate "Analog Devices ADM9240 and compatibles"
 	depends on I2C
 	select HWMON_VID
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Analog Devices ADM9240,
 	  Dallas DS1780, National Semiconductor LM81 sensor chips.
-- 
2.43.0



