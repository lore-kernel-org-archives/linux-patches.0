Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F10134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7CFC433EF;
	Mon, 12 Jun 2023 10:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567098;
	bh=khTySXve3q1fPZUymo85ovTEQXkanLvf18RuLKGE8Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZibuNxWyefqzr2LZjn7HA6dmUMTNUK1KIU01rEVWBN7eFmwt68dyC98wFKT4WJ8r
	 c45tpUDfU9IB4DovLFuA9frfE0Jotpa5FJ84D7Qx40yR+Y4LThPpLGzgVWsWFMb9ak
	 rWAVwKrr1PnNNi+si4C56VZauvzLnCtbMeo9L61M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 142/160] eeprom: at24: also select REGMAP
Date: Mon, 12 Jun 2023 12:27:54 +0200
Message-ID: <20230612101721.577591853@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 7f3c782b3914e510b646a77aedc3adeac2e4a63b ]

Selecting only REGMAP_I2C can leave REGMAP unset, causing build errors,
so also select REGMAP to prevent the build errors.

../drivers/misc/eeprom/at24.c:540:42: warning: 'struct regmap_config' declared inside parameter list will not be visible outside of this definition or declaration
  540 |                                   struct regmap_config *regmap_config)
../drivers/misc/eeprom/at24.c: In function 'at24_make_dummy_client':
../drivers/misc/eeprom/at24.c:552:18: error: implicit declaration of function 'devm_regmap_init_i2c' [-Werror=implicit-function-declaration]
  552 |         regmap = devm_regmap_init_i2c(dummy_client, regmap_config);
../drivers/misc/eeprom/at24.c:552:16: warning: assignment to 'struct regmap *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  552 |         regmap = devm_regmap_init_i2c(dummy_client, regmap_config);
../drivers/misc/eeprom/at24.c: In function 'at24_probe':
../drivers/misc/eeprom/at24.c:586:16: error: variable 'regmap_config' has initializer but incomplete type
  586 |         struct regmap_config regmap_config = { };
../drivers/misc/eeprom/at24.c:586:30: error: storage size of 'regmap_config' isn't known
  586 |         struct regmap_config regmap_config = { };
../drivers/misc/eeprom/at24.c:586:30: warning: unused variable 'regmap_config' [-Wunused-variable]

Fixes: 5c015258478e ("eeprom: at24: add basic regmap_i2c support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/eeprom/Kconfig b/drivers/misc/eeprom/Kconfig
index f0a7531f354c1..2d240bfa819f8 100644
--- a/drivers/misc/eeprom/Kconfig
+++ b/drivers/misc/eeprom/Kconfig
@@ -6,6 +6,7 @@ config EEPROM_AT24
 	depends on I2C && SYSFS
 	select NVMEM
 	select NVMEM_SYSFS
+	select REGMAP
 	select REGMAP_I2C
 	help
 	  Enable this driver to get read/write support to most I2C EEPROMs
-- 
2.39.2



