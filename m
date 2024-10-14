Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A8719F43B;
	Mon, 14 Oct 2024 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920117; cv=none; b=bs4wSXlGyj1cA1NxVNIl7liQOER8cBtzp959nHKPAsqwq8JTPcNV6wtdRXaTCoSdR0g+acYNJ051rkXKWkpNYgk+I+CQLg2DaWxgcN+/Wo2JwDoPTfuR/INQUiT1ZKQ3WOm2Ci2O5ZrpWA7xs9dsiu+2Vif896IFPRuje5m966g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920117; c=relaxed/simple;
	bh=AwhE1kxivupc9o7/tknF894eAEA59E2GJ5mHLGE6YwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxzyHIXhVg0odsR9X4sTbzAVOiyR3KSR2GXI+80tDtR0k/e98Wf6r9cnqItZfJYfoGiZKxg5wc8uiF0MvnQxZ5etz0758HtjY72/tMeBxpEmtgA63VfRb8diD+YODgaTQLzbvwOqK6gcmP/H5yHF7NbqhN6ghrrtNctOGx1QZIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTRD7BFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTRD7BFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AE2C4CED0;
	Mon, 14 Oct 2024 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920117;
	bh=AwhE1kxivupc9o7/tknF894eAEA59E2GJ5mHLGE6YwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTRD7BFyLrj19JEyukClGkw+DTAWr3iMphoRiXSQWsUHRp67of36vBUckk4Q3z4p7
	 befLJx8UnVmcTq1Fmm/RzPuet53UiutlrScj35ORNqATK/vxQj0ZbjmjjYfvJPjepo
	 VH7Cfq5WsYFEcO81bDWtApVjnpsE7+TGx9lGVm80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 770/798] hwmon: (adm9240) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:22:04 +0200
Message-ID: <20241014141248.314279824@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 6d4c4003c1e46..054ceca18e20c 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -166,6 +166,7 @@ config SENSORS_ADM9240
 	tristate "Analog Devices ADM9240 and compatibles"
 	depends on I2C
 	select HWMON_VID
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Analog Devices ADM9240,
 	  Dallas DS1780, National Semiconductor LM81 sensor chips.
-- 
2.43.0



