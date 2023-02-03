Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE0E1FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F14DC433D2;
	Fri,  3 Feb 2023 10:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420155;
	bh=HN0VHEpgGcHB0xexks/sWMOfOg7F/2yWXVj5l/Vt4X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffknQllCU1e7GeKrVvk5aZ5VKQxWzou/jFkelxjy7JnV+dImUXHH7TLlHp7b/v28B
	 F6t6xtBKsuKHHHRoKVJBDSKR08XtujHUEINTEm3Ryz+fOqUUarE//5XdQG0HJy1Yu7
	 Ctx4tGA23lKqytclrfcIv4Lel3qhTG1uVh5DUIQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/134] net/phy/mdio-i2c: Move header file to include/linux/mdio
Date: Fri,  3 Feb 2023 11:13:24 +0100
Message-Id: <20230203101028.300350389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit fcba68bd75bb1d42b3aec7f471d382a9e639a672 ]

In preparation for moving all MDIO drivers into drivers/net/mdio, move
the mdio-i2c header file into include/linux/mdio so it can be used by
both the MDIO driver and the SFP code which instantiates I2C MDIO
busses.

v2:
Add include/linux/mdio

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7083df59abbc ("net: mdio-mux-meson-g12a: force internal PHY off on mux switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                        | 1 +
 drivers/net/phy/mdio-i2c.c                         | 3 +--
 drivers/net/phy/sfp.c                              | 2 +-
 {drivers/net/phy => include/linux/mdio}/mdio-i2c.h | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename {drivers/net/phy => include/linux/mdio}/mdio-i2c.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 973fcc9143d1..ea8f1c885089 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14661,6 +14661,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/phylink.c
 F:	drivers/net/phy/sfp*
+F:	include/linux/mdio/mdio-i2c.h
 F:	include/linux/phylink.h
 F:	include/linux/sfp.h
 K:	phylink
diff --git a/drivers/net/phy/mdio-i2c.c b/drivers/net/phy/mdio-i2c.c
index 0dce67672548..5969878e0aa7 100644
--- a/drivers/net/phy/mdio-i2c.c
+++ b/drivers/net/phy/mdio-i2c.c
@@ -10,10 +10,9 @@
  * of their settings.
  */
 #include <linux/i2c.h>
+#include <linux/mdio/mdio-i2c.h>
 #include <linux/phy.h>
 
-#include "mdio-i2c.h"
-
 /*
  * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
  * specified to be present in SFP modules.  These correspond with PHY
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index beaa00342a13..9639aa181968 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -7,6 +7,7 @@
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/mdio/mdio-i2c.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
@@ -16,7 +17,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 
-#include "mdio-i2c.h"
 #include "sfp.h"
 #include "swphy.h"
 
diff --git a/drivers/net/phy/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
similarity index 100%
rename from drivers/net/phy/mdio-i2c.h
rename to include/linux/mdio/mdio-i2c.h
-- 
2.39.0



