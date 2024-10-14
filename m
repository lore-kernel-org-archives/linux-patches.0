Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB3C1B4F0B;
	Mon, 14 Oct 2024 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920113; cv=none; b=uW07IQBydFe1mK+3dStl+VfcvpjoyJIV6yTfChBGzYz3kjWVp6BZa/QB9cQIiiy/tVYsxj6Ch4mDoKWLQbb80TZON+Q4Hh16GgpHeQTG9IYZvJDveTFSWTORz6PsDc6SQ/7Wrx/kWfiQom8l58Rked4UzqT8p8zD1klXQ+KGwis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920113; c=relaxed/simple;
	bh=PI8JIyr9PPAA+3gzbXDcF3Wv8FcToqv0FPsQI2nYUvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BETNE9t/lcSFYBHRsk+bxmGwcic2gywr9GGFfB3iUUcQqQZAATzEiGbu2/hSyO/CcBScug9N+awGsz4CEuGmFejAZxHsNWGVmIbh6cAgGSnA7OKZmWPzbrc6DsBNR3irjEj7C5nlQBLo0MyQOJCHT4uJz8MCi7Rr8DeoMCtEejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSFQq6xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSFQq6xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1DFC4CEC3;
	Mon, 14 Oct 2024 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920113;
	bh=PI8JIyr9PPAA+3gzbXDcF3Wv8FcToqv0FPsQI2nYUvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSFQq6xrVh8WEd6iOQKaOcaYuBbsjNqW7ZBxlEXbqJ0Y4B8xKaRPQxSU/+XaxrymT
	 HVRPOYX0ma7vbl9nDIF6PPWAtCOc/KzlJLr6CNZZAg3gKQEEeOE8/JnqWTvpQrMxtD
	 0CQEdT5RovGeSGCY86U7gxrkIwCi2W2hfYZQR5Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Tremblay <etremblay@distech-controls.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 769/798] hwmon: (tmp513) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:22:03 +0200
Message-ID: <20241014141248.276494695@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 193bc02c664999581a1f38c152f379fce91afc0c ]

0-day reports:

drivers/hwmon/tmp513.c:162:21: error:
	variable 'tmp51x_regmap_config' has initializer but incomplete type
162 | static const struct regmap_config tmp51x_regmap_config = {
    |                     ^

struct regmap_config is only available if REGMAP is enabled.
Add the missing Kconfig dependency to fix the problem.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410020246.2cTDDx0X-lkp@intel.com/
Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Cc: Eric Tremblay <etremblay@distech-controls.com>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index a5143d01b95f8..6d4c4003c1e46 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -2101,6 +2101,7 @@ config SENSORS_TMP464
 config SENSORS_TMP513
 	tristate "Texas Instruments TMP513 and compatibles"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP512,
 	  and TMP513 temperature and power supply sensor chips.
-- 
2.43.0



