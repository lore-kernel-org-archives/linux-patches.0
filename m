Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F9B7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E80C433D2;
	Mon, 24 Apr 2023 13:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342648;
	bh=RyVSaSqn4wBFKnxu9j97/taoihP7qRmiIOVsbU8gKuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/BacM2Lcm27zr5oiIU3be4GSfq41q8LfmLFhZBWz5b8MvgqMbmgLPFKmN1rzAL/u
	 u2jqRn88bQlXhwhI7s6AicjOSnzz+eax/RNcmoZ4vIuY+TejBzLiFuwftDqex+mXWm
	 f8eJ0PylsdeBNhKFKRzg58nRKf6bztYg9SaA6c4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/39] regulator: fan53555: Explicitly include bits header
Date: Mon, 24 Apr 2023 15:17:07 +0200
Message-Id: <20230424131123.207723649@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 4fb9a5060f73627303bc531ceaab1b19d0a24aef ]

Since commit f2a9eb975ab2 ("regulator: fan53555: Add support for
FAN53526") the driver makes use of the BIT() macro, but relies on the
bits header being implicitly included.

Explicitly pull the header in to avoid potential build failures in some
configurations.

While here, reorder include directives alphabetically.

Fixes: f2a9eb975ab2 ("regulator: fan53555: Add support for FAN53526")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230406171806.948290-3-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index dbe477da4e559..99a1b2dc30933 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -8,18 +8,19 @@
 // Copyright (c) 2012 Marvell Technology Ltd.
 // Yunfan Zhang <yfzhang@marvell.com>
 
+#include <linux/bits.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
 #include <linux/param.h>
-#include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/fan53555.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
-#include <linux/of_device.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/regmap.h>
-#include <linux/regulator/fan53555.h>
 
 /* Voltage setting */
 #define FAN53555_VSEL0		0x00
-- 
2.39.2



