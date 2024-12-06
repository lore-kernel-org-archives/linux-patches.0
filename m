Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E57148314;
	Fri,  6 Dec 2024 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497644; cv=none; b=mxCE21e5wB+29UhzI+iB0tGzkA+8q/XuKwNZ+YGM0bPxgVXKs0DDPZnvyBTfsGINBGmDBqYzA1p1zYYSjgpNKR/HwTt/P/vKC67D/J0UUaaB0W0zR1vwIxid/phPKrx18gwxc7AFPcSJiIlSi2cN36Zc5YDp0BTkcEPVUg/wNY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497644; c=relaxed/simple;
	bh=+YZPgs9+Q+l2SXbYIorOk5LCDILHFeuVlAdrk8cUUF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUHyxkWa78gJpNP+LkNOnztKk0E+UOkZQVvpbScSrDTMXcjw5hZHty8gaEntMmaBKs5bb7EHhgHdniv9qc1m5mELgAZ1CMVVwcl1rHV7ImqukPL20kydXB8pzBEz0h9XcVD/SjRAoMTEnTCu2wms88SiSaWT5vfcEyOBjBoIXfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZxdhHEEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZxdhHEEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3396DC4CED1;
	Fri,  6 Dec 2024 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497644;
	bh=+YZPgs9+Q+l2SXbYIorOk5LCDILHFeuVlAdrk8cUUF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxdhHEEHWdMbnvZdVMUqwWYCF4d5jtpKqd8XilDBiZ4fZNgfGcn2Su+Ojbd8gtGZX
	 ePEpQTCZND+ncStIaOij7yfyagsay2KmZ9meKgizHmst2H2ue3TLpYVBM19BqcJB+C
	 QCaqB78PB7NHdHlf7crI48D7e5RfgCcvuYgLkXQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 318/676] dax: delete a stale directory pmem
Date: Fri,  6 Dec 2024 15:32:17 +0100
Message-ID: <20241206143705.766429515@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



