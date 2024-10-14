Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351CD481B3;
	Mon, 14 Oct 2024 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917296; cv=none; b=mGnD1q60DGyjktG90zcyYd2BszKwiymhxjUWP7xs+uJiAOZ7VF71fYKjqN29sRf492s2/VzHO/hS//AD9BdsdPsZW4VqJiBUOxcvfPNOFBkFLNEkBX32QTZf21MxdzpwnowMTxB8Q2sIyfLteZejiD6KCyjDjmtsBmDhfGECCyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917296; c=relaxed/simple;
	bh=6Nd9tzq07H0K9BKWBKlmyf9G2xTXYtY+qEdiy+3u/CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e61ddH9mVAV6D+wiLdMm8vJWqIUHC4Voc5JPGCWblwSd2oQl37rw1Ofw9mksfBKP8Ru2peu6HRfS0E09OWiWyRMhjNTDvk2EZdhuc9oaUD/xqsRS225kYeY6ZkXXLWm58fN/koZWbpLkNd8IuT/uoEh/UlFYdBvx6iogJIy7qXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqDHtz3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqDHtz3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BD7C4CEC3;
	Mon, 14 Oct 2024 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917296;
	bh=6Nd9tzq07H0K9BKWBKlmyf9G2xTXYtY+qEdiy+3u/CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqDHtz3jjMCVZGOJPlFIIbE9ufL5Yb4spsa1cgym3Gyvxk8y5WxASJmyDUkKyPLvI
	 Z9zmjBV+M5iQ2AudOjTGMxbJh6VVx/DvXKwEc+lnkHXrN1YstF2mR9KgTspEvsC6UM
	 GTKUKqtrzErdYIZ3tdscql7OpUKhYKf+umbtLdOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/213] hwmon: (adt7470) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:21:24 +0200
Message-ID: <20241014141049.912709350@linuxfoundation.org>
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

[ Upstream commit b6abcc19566509ab4812bd5ae5df46515d0c1d70 ]

This driver requires REGMAP_I2C to be selected in order to get access to
regmap_config and devm_regmap_init_i2c. Add the missing dependency.

Fixes: ef67959c4253 ("hwmon: (adt7470) Convert to use regmap")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Message-ID: <20241002-hwmon-select-regmap-v1-2-548d03268934@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 5121005649fec..a4c361b6619c1 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -236,6 +236,7 @@ config SENSORS_ADT7462
 config SENSORS_ADT7470
 	tristate "Analog Devices ADT7470"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Analog Devices
 	  ADT7470 temperature monitoring chips.
-- 
2.43.0



