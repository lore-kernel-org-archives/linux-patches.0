Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485811F75B4;
	Tue,  3 Dec 2024 15:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241512; cv=none; b=OXiHx7TPBHmydaqB82nXYrTV7NlHDAULJGAE7+uXicN2237KRmxoWSvn8GgrmptQ+Tc6mDKqqVX590v+xBUCQxacjOof7yXpL9jqk4sSb7vign89eEAmtiSP00WdNieZaMebSbpB+ssbbJo6u3StHpf8fVEwYhW8aTXwa4exvz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241512; c=relaxed/simple;
	bh=Sg6EQT8ULsJbz5hkGa+oL/d8tu3TaBABL+BuncVYysU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5tp8f2TsTfcKPd+AucLYcKuAqrQg/VGDlHTapxwLoQm8rsvG5ttKW+wcOq0PW7kwK6v8+sbjlEg7qacTL4RX3V1VHHS3BIlexce4p+mikIeKguv89uK51pCHMFtv7erb1Vs17jMFdIBhHRy6SIO5ezpP32xtP/igDKv8wyox+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isLwLlh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isLwLlh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC796C4CECF;
	Tue,  3 Dec 2024 15:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241512;
	bh=Sg6EQT8ULsJbz5hkGa+oL/d8tu3TaBABL+BuncVYysU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isLwLlh+dHnYE7XCObSpSiTj4d6fv/YFrSo+M4eYg0p3TFB8Q1V35XVg/Ry8GuPUP
	 F7VPcuhht0z4P6NV1q+/L5GVZzpCL15xeKPMKUZNzowPjN8k3RCpdziCa7trUTVo9d
	 Lr57Nn+Ku3442XmQ5zykzaOEsEK41dGK+Xn8cZrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/826] dax: delete a stale directory pmem
Date: Tue,  3 Dec 2024 15:42:45 +0100
Message-ID: <20241203144800.849301662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



