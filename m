Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49F33803CD;
	Tue, 10 Mar 2026 11:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141984; cv=none; b=Phgmm+Gcirp61vAe1pn1lDPUJqdfiyv0/NB7Q9/lOwB30zkvnfDH06T+1Sw7p6HYfXbV0wk/L9tNkexuV6J2h3dovjOwCGe9mhU0+h1DUzec/BJKvGXQgOIi7bd+FhyrgYJi4NBx9ZtaD3uBcmZ8S+OQIzu3oD35BhuGjTD+V7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141984; c=relaxed/simple;
	bh=/o4B6R6En5I0+NQN7vng8/0JGSeRRUnDpzEDp+GExHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9y3wlSjMPvMv35reJHCA6iDg13CJ9DXmrKefIdl6r6SwOP4fMgfECj1rsKJlUYriVmYVifitMfDvCNGjqlLB4XuVb9tSfqGo5DGc2D8BBgUw1RAZkw7nOyLLob0GnMjXBpsU3Wvpg5O4NszyD4DzkmOG2WgRya2Px2i/p0YfzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FYIddpGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FYIddpGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9742C19423;
	Tue, 10 Mar 2026 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141984;
	bh=/o4B6R6En5I0+NQN7vng8/0JGSeRRUnDpzEDp+GExHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYIddpGyq6u9gabhSJrlvVNZJTiUis3sIlfGl9dzRM85o8ikCEVLDHbCOAiTJLufU
	 0oTZLPE44Wr47t0xCVu7Tb3Yuo0A2zyL+UZ28JUy0ShxdTZnoLzOtMpOyGN1yylRmI
	 nOP1yeLw1Y2IdXB4xK7myvj4lCM9UmTQwUc6epBZGu6YRY7bUyX55ixghx8wseakEp
	 anB01VCtLfcct4Ko4pPMiwhGj2K4KGbmZIIUPRFxSZTnipYTuEG2ScLxzcXe0AtovG
	 o1hii6rjAfRP6q7A44ZH/VyMUKfTptwPFM9lthx5z4ZC5A3n332Zi6njn82mNvdlnf
	 +DrVx08+UvRPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/314] ACPI: APEI: GHES: Add helper for CPER CXL protocol errors checks
Date: Tue, 10 Mar 2026 07:16:08 -0400
Message-ID: <c4291b028db62e2c6d7126df863759c749c5421d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>

[ Upstream commit 70205869686212eb8e4cddf02bf87fd5fd597bc2 ]

Move the CPER CXL protocol errors validity check out of
cxl_cper_post_prot_err() to new cxl_cper_sec_prot_err_valid() and limit
the serial number check only to CXL agents that are CXL devices (UEFI
v2.10, Appendix N.2.13).

Export the new symbol for reuse by ELOG.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260114101543.85926-4-fabio.m.de.francesco@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: b584bfbd7ec4 ("ACPI: APEI: GHES: Disable KASAN instrumentation when compile testing with clang < 18")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/Makefile       |  1 +
 drivers/acpi/apei/ghes.c         | 18 +----------------
 drivers/acpi/apei/ghes_helpers.c | 33 ++++++++++++++++++++++++++++++++
 include/cxl/event.h              | 10 ++++++++++
 4 files changed, 45 insertions(+), 17 deletions(-)
 create mode 100644 drivers/acpi/apei/ghes_helpers.c

diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index 2c474e6477e12..5db61dfb46915 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ACPI_APEI)		+= apei.o
 obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
+obj-$(CONFIG_ACPI_APEI_PCIEAER)	+= ghes_helpers.o
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 einj-y				:= einj-core.o
 einj-$(CONFIG_ACPI_APEI_EINJ_CXL) += einj-cxl.o
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 42872fdc36bfc..fc96a5e234f06 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -746,24 +746,8 @@ static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
 	struct cxl_cper_prot_err_work_data wd;
 	u8 *dvsec_start, *cap_start;
 
-	if (!(prot_err->valid_bits & PROT_ERR_VALID_AGENT_ADDRESS)) {
-		pr_err_ratelimited("CXL CPER invalid agent type\n");
+	if (cxl_cper_sec_prot_err_valid(prot_err))
 		return;
-	}
-
-	if (!(prot_err->valid_bits & PROT_ERR_VALID_ERROR_LOG)) {
-		pr_err_ratelimited("CXL CPER invalid protocol error log\n");
-		return;
-	}
-
-	if (prot_err->err_len != sizeof(struct cxl_ras_capability_regs)) {
-		pr_err_ratelimited("CXL CPER invalid RAS Cap size (%u)\n",
-				   prot_err->err_len);
-		return;
-	}
-
-	if (!(prot_err->valid_bits & PROT_ERR_VALID_SERIAL_NUMBER))
-		pr_warn(FW_WARN "CXL CPER no device serial number\n");
 
 	guard(spinlock_irqsave)(&cxl_cper_prot_err_work_lock);
 
diff --git a/drivers/acpi/apei/ghes_helpers.c b/drivers/acpi/apei/ghes_helpers.c
new file mode 100644
index 0000000000000..f3d162139a974
--- /dev/null
+++ b/drivers/acpi/apei/ghes_helpers.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright(c) 2025 Intel Corporation. All rights reserved
+
+#include <linux/printk.h>
+#include <cxl/event.h>
+
+int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
+{
+	if (!(prot_err->valid_bits & PROT_ERR_VALID_AGENT_ADDRESS)) {
+		pr_err_ratelimited("CXL CPER invalid agent type\n");
+		return -EINVAL;
+	}
+
+	if (!(prot_err->valid_bits & PROT_ERR_VALID_ERROR_LOG)) {
+		pr_err_ratelimited("CXL CPER invalid protocol error log\n");
+		return -EINVAL;
+	}
+
+	if (prot_err->err_len != sizeof(struct cxl_ras_capability_regs)) {
+		pr_err_ratelimited("CXL CPER invalid RAS Cap size (%u)\n",
+				   prot_err->err_len);
+		return -EINVAL;
+	}
+
+	if ((prot_err->agent_type == RCD || prot_err->agent_type == DEVICE ||
+	     prot_err->agent_type == LD || prot_err->agent_type == FMLD) &&
+	    !(prot_err->valid_bits & PROT_ERR_VALID_SERIAL_NUMBER))
+		pr_warn_ratelimited(FW_WARN
+				    "CXL CPER no device serial number\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxl_cper_sec_prot_err_valid);
diff --git a/include/cxl/event.h b/include/cxl/event.h
index 6fd90f9cc2034..4d7d1036ea9cb 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -320,4 +320,14 @@ static inline int cxl_cper_prot_err_kfifo_get(struct cxl_cper_prot_err_work_data
 }
 #endif
 
+#ifdef CONFIG_ACPI_APEI_PCIEAER
+int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err);
+#else
+static inline int
+cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 #endif /* _LINUX_CXL_EVENT_H */
-- 
2.51.0

