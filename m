Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC8E43AB5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7zYOMkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0371C433CC;
	Wed, 15 Nov 2023 20:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081846;
	bh=XkNQowdwAFw/Vjp/naMdXeMPQPp3HaL21hJxkegX9IQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7zYOMkpnQhpC/cy5I4diu9bFbK79c7oO732Vt5iDw5+Mm3RhQy6KCikkwd1XUa9r
	 GPKS13M+ADoyyUJuUCAVIg824t36vtIU60zBODL1MehJcgD3bbhlCuu+k5AMr5IynY
	 tKlMhy5yGqA80vkhSlq2/jA30cbXbcmfcx0yPdcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/191] interconnect: qcom: osm-l3: Replace custom implementation of COUNT_ARGS()
Date: Wed, 15 Nov 2023 15:46:53 -0500
Message-ID: <20231115204652.803182999@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 577a3c5af1fe87b65931ea94d5515266da301f56 ]

Replace custom and non-portable implementation of COUNT_ARGS().

Fixes: 5bc9900addaf ("interconnect: qcom: Add OSM L3 interconnect provider support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230920154927.2090732-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/osm-l3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index 08a282d573203..f7407b930d23c 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2020, The Linux Foundation. All rights reserved.
  */
 
+#include <linux/args.h>
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/interconnect-provider.h>
@@ -77,7 +78,7 @@ struct qcom_icc_desc {
 		.name = #_name,						\
 		.id = _id,						\
 		.buswidth = _buswidth,					\
-		.num_links = ARRAY_SIZE(((int[]){ __VA_ARGS__ })),	\
+		.num_links = COUNT_ARGS(__VA_ARGS__),			\
 		.links = { __VA_ARGS__ },				\
 	}
 
-- 
2.42.0



