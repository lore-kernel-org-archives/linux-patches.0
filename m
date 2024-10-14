Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ACC17C77;
	Mon, 14 Oct 2024 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916338; cv=none; b=IHi76FuA6hFPiih6j/h6MToCYqz6II3SUhxQT6SB9qvEtAnxmyApPTIwfclnnPvlj4CoT1+cdGEKxKB4T9b3lcHoFflkAYprFNSeYhuy3cfwBf285fALVYLKMN0+DQCEdgJtukfAo4iUNQzQw+e2LhNuXNbEUXznLvF8kmnhZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916338; c=relaxed/simple;
	bh=krBwssS6JrCXBGyaUO6BNpo2+229IkPf1iOS4wHSW6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VufIzdsS6Vi/lTapHa3XdSSaNxYV8+muQm8oNd3zJZ62owfXZ0kKShkwtY3NfngEZdwAE/CjsFiaZmFB55LnXPH+MuIKX0x67wC6h1ma3eWGjs6IJ/sDQKGiDFLv1514xaqjiyoEf4xRg3zBZspffYDXU7287X4xz/4JlNxCUEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blVojzUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blVojzUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA614C4CED0;
	Mon, 14 Oct 2024 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916338;
	bh=krBwssS6JrCXBGyaUO6BNpo2+229IkPf1iOS4wHSW6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blVojzUvyN9rm7ugnf/HZ3fvm2bmBIwK9pJO9rM6ZKIJwXKuITevOAF7EE4DL4FAs
	 YbgcxkqN/Fj3Kr/kdb7rRANDaT4W2agmzMV7+yQmwJs/B5lVoBBwbNVhOm8sARwL/6
	 FV4Y+J6XhV6RGTpG5cSArpAlwskw34gSIr7jqT24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eric Tremblay <etremblay@distech-controls.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 154/214] hwmon: (tmp513) Add missing dependency on REGMAP_I2C
Date: Mon, 14 Oct 2024 16:20:17 +0200
Message-ID: <20241014141050.998558837@linuxfoundation.org>
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
index b60fe2e58ad6c..543c40630d67e 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -2288,6 +2288,7 @@ config SENSORS_TMP464
 config SENSORS_TMP513
 	tristate "Texas Instruments TMP513 and compatibles"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP512,
 	  and TMP513 temperature and power supply sensor chips.
-- 
2.43.0



