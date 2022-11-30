Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419BA79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F97C433C1;
	Wed, 30 Nov 2022 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833838;
	bh=3zNwnR+6qwxjKhSPOed61h4gjhKgLCovu/E6R7K48/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XC+hIcnJcw9XlqlLRwIvio12P4V5zMKQwg3bJLgB761qLbxsybd+B5DNl2XJEZ31o
	 X/0dR5FAdn7ZmmStDrcC48NHqpYqr47Aehhj/lAJrRXvze2VNwqbI/wBM69ke+/s+s
	 DL9/VykUO3rr+Gj19e3F4DNg5b/IrevZ8GqJy7Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 033/289] net: wwan: iosm: fix kernel test robot reported errors
Date: Wed, 30 Nov 2022 19:20:18 +0100
Message-Id: <20221130180544.883901038@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

[ Upstream commit 980ec04a88c9f0046c1da65833fb77b2ffa34b04 ]

Include linux/vmalloc.h in iosm_ipc_coredump.c &
iosm_ipc_devlink.c to resolve kernel test robot errors.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_coredump.c | 1 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_coredump.c b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
index 9acd87724c9d..26ca30476f40 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_coredump.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_coredump.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020-2021 Intel Corporation.
  */
+#include <linux/vmalloc.h>
 
 #include "iosm_ipc_coredump.h"
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 17da85a8f337..2fe724d623c0 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020-2021 Intel Corporation.
  */
+#include <linux/vmalloc.h>
 
 #include "iosm_ipc_chnl_cfg.h"
 #include "iosm_ipc_coredump.h"
-- 
2.35.1



