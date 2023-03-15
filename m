Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA54431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96CCC433D2;
	Wed, 15 Mar 2023 12:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883706;
	bh=if5yWvrLs7s3hjiF6DzbVuIrkn5oiXCRR1mNGRrXXRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QID0BcoZ9VLavo/oXdrATkJ+Ityf2wJmr3m0mVYbjAz5N3sjogIwh9cmAHhlDS6Xf
	 cystc7Lyt3oBU9F4YErP3HDGnkLOaOSI4WUStStDq3wjT5gCcYXzoFtcqd3McGv3wL
	 HzCZHEIFvRiyo5yy5CUs6Km81uL0Vq0ozVIA2+yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Michael Shych <michaelsh@nvidia.com>,
	Mark Gross <markgross@kernel.org>,
	Vadim Pasternak <vadimp@nvidia.com>,
	platform-driver-x86@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/143] platform: mellanox: select REGMAP instead of depending on it
Date: Wed, 15 Mar 2023 13:13:06 +0100
Message-Id: <20230315115743.545863500@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

[ Upstream commit 03f5eb300ad1241f854269a3e521b119189a4493 ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

For NVSW_SN2201, select REGMAP_I2C instead of depending on it.

Fixes: c6acad68eb2d ("platform/mellanox: mlxreg-hotplug: Modify to use a regmap interface")
Fixes: 5ec4a8ace06c ("platform/mellanox: Introduce support for Mellanox register access driver")
Fixes: 62f9529b8d5c ("platform/mellanox: mlxreg-lc: Add initial support for Nvidia line card devices")
Fixes: 662f24826f95 ("platform/mellanox: Add support for new SN2201 system")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Michael Shych <michaelsh@nvidia.com>
Cc: Mark Gross <markgross@kernel.org>
Cc: Vadim Pasternak <vadimp@nvidia.com>
Cc: platform-driver-x86@vger.kernel.org
Link: https://lore.kernel.org/r/20230226053953.4681-6-rdunlap@infradead.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/Kconfig | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/mellanox/Kconfig b/drivers/platform/mellanox/Kconfig
index 09c7829e95c4b..382793e73a60a 100644
--- a/drivers/platform/mellanox/Kconfig
+++ b/drivers/platform/mellanox/Kconfig
@@ -16,17 +16,17 @@ if MELLANOX_PLATFORM
 
 config MLXREG_HOTPLUG
 	tristate "Mellanox platform hotplug driver support"
-	depends on REGMAP
 	depends on HWMON
 	depends on I2C
+	select REGMAP
 	help
 	  This driver handles hot-plug events for the power suppliers, power
 	  cables and fans on the wide range Mellanox IB and Ethernet systems.
 
 config MLXREG_IO
 	tristate "Mellanox platform register access driver support"
-	depends on REGMAP
 	depends on HWMON
+	select REGMAP
 	help
 	  This driver allows access to Mellanox programmable device register
 	  space through sysfs interface. The sets of registers for sysfs access
@@ -36,9 +36,9 @@ config MLXREG_IO
 
 config MLXREG_LC
 	tristate "Mellanox line card platform driver support"
-	depends on REGMAP
 	depends on HWMON
 	depends on I2C
+	select REGMAP
 	help
 	  This driver provides support for the Mellanox MSN4800-XX line cards,
 	  which are the part of MSN4800 Ethernet modular switch systems
@@ -80,10 +80,9 @@ config MLXBF_PMC
 
 config NVSW_SN2201
 	tristate "Nvidia SN2201 platform driver support"
-	depends on REGMAP
 	depends on HWMON
 	depends on I2C
-	depends on REGMAP_I2C
+	select REGMAP_I2C
 	help
 	  This driver provides support for the Nvidia SN2201 platform.
 	  The SN2201 is a highly integrated for one rack unit system with
-- 
2.39.2



