Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A9339FCE;
	Mon, 14 Oct 2024 14:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916355; cv=none; b=K7lRSYJFEn+4hn+IFSWYHsAVyVTzrAF9qZgBm57BJirRb4mZlVEfwgnkTCASGAAk6y6vhx1HvHXQTcrG0hfl2dxueiu1jFwAJU1JbQn44T4cHqhFiG+y0v114MXmNZzW/6OxWap2wUGajgqtjTu907y5q/14Qnd3bylutpa5ilg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916355; c=relaxed/simple;
	bh=CZTQh8IIRwffI5cWB2APW5TUS9Gfc8OOMapn7RToIeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RwGinmwcCH40DQusrZI5sh1GxFahI5IoNOMmGGgf4VfKJgOoJ2IPPHOapf+4ls4Ubh4JO9LN1nbVii8B3woMNnZHdY+bctXGpqXnrYR5lxiFKudwfooZCMMajqs8cCQT97V3Vq16vKABMlKH6JZy6lEZ5bd9bg7SETABehS1Lf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTzt9OVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTzt9OVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A1EC4CEC3;
	Mon, 14 Oct 2024 14:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916355;
	bh=CZTQh8IIRwffI5cWB2APW5TUS9Gfc8OOMapn7RToIeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTzt9OVWEKH2W4YTo7XMo2QMy3y9loxzVBQKJh0EuCaDvh9pg5vqiXL8W3oP1kfhl
	 cOIoxo2bB68C0WdtF9lMVsPsX9K68AtNhIijmsawWwkB5nCUdYmpIAUyDYtz/z89SD
	 Y10pFji9Tn60lEwVdk179rwftEHuPdb4wJf/+0wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 158/214] hwmon: (ltc2991) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:20:21 +0200
Message-ID: <20241014141051.152698045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 7d4cc7fdc6c889608fff051530e6f0c617f71995 ]

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: 2b9ea4262ae9 ("hwmon: Add driver for ltc2991")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-hwmon-select-regmap-v1-3-548d03268934@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index cfb22c2b9e61c..778e584c3a75c 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1001,6 +1001,7 @@ config SENSORS_LTC2990
 config SENSORS_LTC2991
 	tristate "Analog Devices LTC2991"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Analog Devices LTC2991
 	  Octal I2C Voltage, Current, and Temperature Monitor. The LTC2991
-- 
2.43.0



