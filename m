Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F334361
	for <patches@lists.linux.dev>; Mon,  1 May 2023 02:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6tZimcfHBp3vjpDs8vgvYhUPTHKa12CQe7EUdwtC4Og=; b=b/VTTHBp/NPZ9/UvIqn2ZKMgJT
	OcQ+r29qBfhEEn6Cu5Gy1/U+t3xfrzG2brtuT4lq6aU3kvJKni/Ids1PlAa5x7MJecfI/YF63Qrfq
	ou0+gd0nP/15n/voh17gtQ2WBZ9rqe9PiWkcI/E3s18BH9t6bc5G1Fd/zbbKVA14WEGtPTUGF2c8c
	bPDmZHIEJNnY6VyoKViCP6D0SvEcJIETTqhnsI2nlhwqJ3Sxv5gGZZbzP8oPN1aVxREuSDIDtUBgR
	fIjlG0yMGJ2nUXLt0zHkJgo+6uJVCHgs3ImumHEuQ/GPX5NdK6sJSUhTvUGvH2g/8mULtNQh30vPn
	8gk/r7xw==;
Received: from [2601:1c2:980:9ec0::2764] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1ptJbr-00F3Rs-2W;
	Mon, 01 May 2023 02:49:51 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-arm-kernel@lists.infradead.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-rockchip@lists.infradead.org
Subject: [PATCH] soc/rockchip: dtpm: use C99 array init syntax
Date: Sun, 30 Apr 2023 19:49:50 -0700
Message-Id: <20230501024950.31518-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eliminate sparse warnings in soc/rockchip/dtpm.c:

drivers/soc/rockchip/dtpm.c:15:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:17:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:20:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:23:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:26:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:29:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:32:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:35:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:38:12: sparse: warning: obsolete array initializer, use C99 syntax
drivers/soc/rockchip/dtpm.c:41:12: sparse: warning: obsolete array initializer, use C99 syntax

Fixes: b9d6c47a2be8 ("rockchip/soc/drivers: Add DTPM description for rk3399")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-rockchip@lists.infradead.org
---
 drivers/soc/rockchip/dtpm.c |   54 +++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff -- a/drivers/soc/rockchip/dtpm.c b/drivers/soc/rockchip/dtpm.c
--- a/drivers/soc/rockchip/dtpm.c
+++ b/drivers/soc/rockchip/dtpm.c
@@ -12,33 +12,33 @@
 #include <linux/platform_device.h>
 
 static struct dtpm_node __initdata rk3399_hierarchy[] = {
-	[0]{ .name = "rk3399",
-	     .type = DTPM_NODE_VIRTUAL },
-	[1]{ .name = "package",
-	     .type = DTPM_NODE_VIRTUAL,
-	     .parent = &rk3399_hierarchy[0] },
-	[2]{ .name = "/cpus/cpu@0",
-	     .type = DTPM_NODE_DT,
-	     .parent = &rk3399_hierarchy[1] },
-	[3]{ .name = "/cpus/cpu@1",
-	     .type = DTPM_NODE_DT,
-	     .parent = &rk3399_hierarchy[1] },
-	[4]{ .name = "/cpus/cpu@2",
-	     .type = DTPM_NODE_DT,
-	     .parent = &rk3399_hierarchy[1] },
-	[5]{ .name = "/cpus/cpu@3",
-	     .type = DTPM_NODE_DT,
-	     .parent = &rk3399_hierarchy[1] },
-	[6]{ .name = "/cpus/cpu@100",
-	     .type = DTPM_NODE_DT,
-	     .parent = &rk3399_hierarchy[1] },
-	[7]{ .name = "/cpus/cpu@101",
-	     .type = DTPM_NODE_DT,
-	     .parent = &rk3399_hierarchy[1] },
-	[8]{ .name = "/gpu@ff9a0000",
-	     .type = DTPM_NODE_DT,
-	     .parent = &rk3399_hierarchy[1] },
-	[9]{ /* sentinel */ }
+	[0] = { .name = "rk3399",
+		.type = DTPM_NODE_VIRTUAL },
+	[1] = { .name = "package",
+		.type = DTPM_NODE_VIRTUAL,
+		.parent = &rk3399_hierarchy[0] },
+	[2] = { .name = "/cpus/cpu@0",
+		.type = DTPM_NODE_DT,
+		.parent = &rk3399_hierarchy[1] },
+	[3] = { .name = "/cpus/cpu@1",
+		.type = DTPM_NODE_DT,
+		.parent = &rk3399_hierarchy[1] },
+	[4] = { .name = "/cpus/cpu@2",
+		.type = DTPM_NODE_DT,
+		.parent = &rk3399_hierarchy[1] },
+	[5] = { .name = "/cpus/cpu@3",
+		.type = DTPM_NODE_DT,
+		.parent = &rk3399_hierarchy[1] },
+	[6] = { .name = "/cpus/cpu@100",
+		.type = DTPM_NODE_DT,
+		.parent = &rk3399_hierarchy[1] },
+	[7] = { .name = "/cpus/cpu@101",
+		.type = DTPM_NODE_DT,
+		.parent = &rk3399_hierarchy[1] },
+	[8] = { .name = "/gpu@ff9a0000",
+		.type = DTPM_NODE_DT,
+		.parent = &rk3399_hierarchy[1] },
+	[9] = { /* sentinel */ }
 };
 
 static struct of_device_id __initdata rockchip_dtpm_match_table[] = {
