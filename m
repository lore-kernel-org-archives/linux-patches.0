Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6075F2343A5;
	Thu, 12 Dec 2024 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019598; cv=none; b=Y5qD7uvykPkVFMgcXSI7pymmaXbA3E5fbUW3Hm4ILzmcO6sKEJXZ4n5oWvbmjMRKtqm2L0N0EZGESjmqbCfx8Z87YsHipyKkXtX/H1uLpXVhPrLWlt7S0kuHoTINxWXBBPruQrsFN9ptoVJR9ssXDti4gwakPwaSTAQb4dA2SHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019598; c=relaxed/simple;
	bh=uxuLlKcTvk2tuB6WAhLv3M9CG8RN46VkTZ53ToAJFKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbaJShM43YwGhyvm6nlBUPpvj6GGwy8hdDcEbdFvVNRqt1DBUmF/snLlxomk/bm8EFNB6T4MlWwe+OVJDMg6JLIExBFtGGUuoE4s6V/zYjRo9t/aQRprH87qOVQ5ZbukX3eu0hzn8w9rW7tPwYHPQXHt/G5WnZNquoKKWVmyo5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2ofg+Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2ofg+Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A49C4CECE;
	Thu, 12 Dec 2024 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019597;
	bh=uxuLlKcTvk2tuB6WAhLv3M9CG8RN46VkTZ53ToAJFKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2ofg+CrMr1dHMWHmtA/PbpLg/KroMDpGpUR7WbeQCBQFRPi51XTAGquhkfO+ZhTg
	 /tPoHmX9QSwUMBt4JRTjvBUBS+q3+8phlGsLsLuURztjS+JzzKjxvFhIAULoumRPAK
	 e3zC0cwD/i3XDgUOt7vYMl2m7XM08j8BmQAao2Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/772] dax: delete a stale directory pmem
Date: Thu, 12 Dec 2024 15:53:13 +0100
Message-ID: <20241212144400.163024984@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit b8e6d7ce50673c39514921ac61f7af00bbb58b87 ]

After commit: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT") the pmem/
directory is not needed anymore and Makefile changes were made
accordingly in this commit, but there is a Makefile and pmem.c in pmem/
which are now stale and pmem.c is empty, remove them.

Fixes: 83762cb5c7c4 ("dax: Kill DEV_DAX_PMEM_COMPAT")
Suggested-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/20241017101144.1654085-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/pmem/Makefile |  7 -------
 drivers/dax/pmem/pmem.c   | 10 ----------
 2 files changed, 17 deletions(-)
 delete mode 100644 drivers/dax/pmem/Makefile
 delete mode 100644 drivers/dax/pmem/pmem.c

diff --git a/drivers/dax/pmem/Makefile b/drivers/dax/pmem/Makefile
deleted file mode 100644
index 191c31f0d4f00..0000000000000
--- a/drivers/dax/pmem/Makefile
+++ /dev/null
@@ -1,7 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
-obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem_core.o
-
-dax_pmem-y := pmem.o
-dax_pmem_core-y := core.o
-dax_pmem_compat-y := compat.o
diff --git a/drivers/dax/pmem/pmem.c b/drivers/dax/pmem/pmem.c
deleted file mode 100644
index dfe91a2990fec..0000000000000
--- a/drivers/dax/pmem/pmem.c
+++ /dev/null
@@ -1,10 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright(c) 2016 - 2018 Intel Corporation. All rights reserved. */
-#include <linux/percpu-refcount.h>
-#include <linux/memremap.h>
-#include <linux/module.h>
-#include <linux/pfn_t.h>
-#include <linux/nd.h>
-#include "../bus.h"
-
-
-- 
2.43.0



