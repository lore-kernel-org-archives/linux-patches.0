Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94973B3C06;
	Mon, 23 Mar 2026 14:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274705; cv=none; b=ApkYtRVzJZDxjFGx5sKbykNnapdIX9Ba2tc5jqUBYD9moNR2jDJ0iWgl3yGi6f50xv13gUBF5j+SB5e/HJBTAYo0UwHZwdD8NGmw38YJyFS8av7Nb7/Nl8Gqly4nRNK8INwhNQ7WTaTcO/qCT8ammmAeM8OcVGPU0OGvRc9JoQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274705; c=relaxed/simple;
	bh=3WNVs1dmviCe8b8BFqfkdg/NyUB39gjyyOdV2F9/nmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKK/vI2p214nGGOAAOOJruVucD73YK6bO6uUPuwjDZzr5l54YXznW1uSyHriB9hnvpKOI/01AvgHcXgOdVvGSl5rnJtcNR38cnKSHW/5xgoD9OhRjmmnCmtmAboAK5aX1C1zYRJ/zaJUSgpgsZzJx1oym8IvXlnhEL6ABOl/GZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ph+bDYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ph+bDYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7D1C2BCB6;
	Mon, 23 Mar 2026 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274705;
	bh=3WNVs1dmviCe8b8BFqfkdg/NyUB39gjyyOdV2F9/nmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ph+bDYoWfKI9FKWjNPIfyxWzAg0rbqBxqZ6X9DtBWTzmbqgIzkEEQ+g13dlXb3ny
	 QAGAvzgoO2HQ3MXe8Z6Ge/Cdb908NsY0E+cVV3t3N/DnD3L/bT66OzsU2+vvefICHw
	 OTOuumOosi01jewkbNIt3Z/NkyQM5+2iPB0lGgsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Sean Anderson <sean.anderson@linux.dev>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/212] net: macb: sort #includes
Date: Mon, 23 Mar 2026 14:44:20 +0100
Message-ID: <20260323134504.998886137@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 8ebeef3d01c8b9e5807afdf1d38547f4625d0e4e ]

Sort #include preprocessor directives.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/20251014-macb-cleanup-v1-15-31cd266e22cd@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 881a0263d502 ("net: macb: Shuffle the tx ring before enabling tx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   37 +++++++++++++++----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -6,36 +6,37 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#include <linux/clk.h>
+#include <linux/circ_buf.h>
 #include <linux/clk-provider.h>
+#include <linux/clk.h>
 #include <linux/crc32.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/circ_buf.h>
-#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/etherdevice.h>
+#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/inetdevice.h>
+#include <linux/inetdevice.h>
 #include <linux/init.h>
-#include <linux/io.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/ip.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/dma-mapping.h>
-#include <linux/platform_device.h>
-#include <linux/phylink.h>
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
-#include <linux/ip.h>
-#include <linux/udp.h>
-#include <linux/tcp.h>
-#include <linux/iopoll.h>
 #include <linux/phy/phy.h>
+#include <linux/phylink.h>
+#include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/ptp_classify.h>
 #include <linux/reset.h>
-#include <linux/firmware/xlnx-zynqmp.h>
-#include <linux/inetdevice.h>
+#include <linux/slab.h>
+#include <linux/tcp.h>
+#include <linux/types.h>
+#include <linux/udp.h>
 #include <net/pkt_sched.h>
 #include "macb.h"
 


