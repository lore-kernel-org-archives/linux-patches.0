Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023101;
	b=PmmxhGndLXaG9J5/6++YYKXMmNK52792Vd192Zx6TP/Iapts3+m8uEbmQoDhSYpJx8Cv
	 yhbrxw/HsRSgEp3Dyt48Uep2w5mHPpW1YHbEONUuG/Dx1jaGtTGQeHpwRA2hD1aor7+S/
	 QaKAvgtOzrPugYiRQNr12MWuczOg8LA1Oo6sGWRbXJ2eCwxw32tOS0yISfe8hO+wsRama
	 vUzvAKgoiOFM28i24N6gljCX3lg5vRtuz4mpEM4Y76ku/D7beIjlDMN+Lxls2lvssWjDv
	 6vGclWkubC/h2sNTo4jatfsCt1V6qgjdLbp00FbTGcOEbyhOGcJ/LKtvaAfHd8n3b8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=laohJVZU4Bml/Qlwuj7rokiH9OvaYuZw8xCzt95HBKY=;
	b=xmihBRr8MrW57i+ibwCmtIwhEzEtn7j8pxSJJwiONGaqvp3n/f4dH8JsQ1Jroy+Fyf5l
	 3HPP1DgbKfHX32dpTyE+lfnJS/wjCMXIpyO3Sl5yKES5uxc5IYmul+kJ1KKpRdfw7Ox2p
	 22nhTdlDN6Y1jT5hBXtGzaqbEGxM6Yj0GrJzTFJiv6X8y7SKxU52I9VcX8c2MIBsgmT+o
	 KQBeCOqVYH0Iq26oBQvIeuTNzPY2Kj9UsiWBj5UQOCsiMERso5ipFYnP4Xpif80spZWpJ
	 0qtj4KqnFSrQqhsYlt1Nv4B+9QqmSdZVhlLTrM6BdTYImacG/Yter5INQ7pjdjRzqtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpPjxNAI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CF5606A31C;
	Wed, 18 Nov 2026 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpPjxNAI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36401F000C4;
	Wed, 18 Nov 2026 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023101;
	bh=laohJVZU4Bml/Qlwuj7rokiH9OvaYuZw8xCzt95HBKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpPjxNAIFXqMw+jOoJgUTuU3u4cK2fTP4MGFcgF/4dvwfFU5glGsxmzzS7VeEyMpL
	 R9Dnkc0M/JwNJDYyrpWcrjyQhb/lSwcGBE4upe+QrQvsW2tX6uiXQ59FCl4osK0osc
	 LiplggCnil3IfHUpoVbhFhoJ2usYhYgoEaXh6oqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0250/2151] ACPI: APEI: GHES: Add helper to copy CPER CXL protocol error info to work struct
Date: Wed, 18 Nov 2026 15:33:05 +0100
Message-ID: <20261118150130.898310441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>

[ Upstream commit ba8af8e1f1de32f14c98bd4a7da8b270284ffce3 ]

Make a helper out of cxl_cper_post_prot_err() that checks the CXL agent
type and copy the CPER CXL protocol errors information to a work data
structure.

Export the new symbol for reuse by ELOG.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
[ rjw: Subject tweak ]
Link: https://patch.msgid.link/20260114101543.85926-5-fabio.m.de.francesco@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 8bf58815315a ("ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c         | 22 +--------------------
 drivers/acpi/apei/ghes_helpers.c | 33 ++++++++++++++++++++++++++++++++
 include/cxl/event.h              | 10 ++++++++++
 3 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 3031447e1fc0e..e386a00515ce0 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -744,7 +744,6 @@ static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
 {
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 	struct cxl_cper_prot_err_work_data wd;
-	u8 *dvsec_start, *cap_start;
 
 	if (cxl_cper_sec_prot_err_valid(prot_err))
 		return;
@@ -754,27 +753,8 @@ static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
 	if (!cxl_cper_prot_err_work)
 		return;
 
-	switch (prot_err->agent_type) {
-	case RCD:
-	case DEVICE:
-	case LD:
-	case FMLD:
-	case RP:
-	case DSP:
-	case USP:
-		memcpy(&wd.prot_err, prot_err, sizeof(wd.prot_err));
-
-		dvsec_start = (u8 *)(prot_err + 1);
-		cap_start = dvsec_start + prot_err->dvsec_len;
-
-		memcpy(&wd.ras_cap, cap_start, sizeof(wd.ras_cap));
-		wd.severity = cper_severity_to_aer(severity);
-		break;
-	default:
-		pr_err_ratelimited("CXL CPER invalid agent type: %d\n",
-				   prot_err->agent_type);
+	if (cxl_cper_setup_prot_err_work_data(&wd, prot_err, severity))
 		return;
-	}
 
 	if (!kfifo_put(&cxl_cper_prot_err_fifo, wd)) {
 		pr_err_ratelimited("CXL CPER kfifo overflow\n");
diff --git a/drivers/acpi/apei/ghes_helpers.c b/drivers/acpi/apei/ghes_helpers.c
index f3d162139a974..bc7111b740afb 100644
--- a/drivers/acpi/apei/ghes_helpers.c
+++ b/drivers/acpi/apei/ghes_helpers.c
@@ -2,6 +2,7 @@
 // Copyright(c) 2025 Intel Corporation. All rights reserved
 
 #include <linux/printk.h>
+#include <linux/aer.h>
 #include <cxl/event.h>
 
 int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
@@ -31,3 +32,35 @@ int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cxl_cper_sec_prot_err_valid);
+
+int cxl_cper_setup_prot_err_work_data(struct cxl_cper_prot_err_work_data *wd,
+				      struct cxl_cper_sec_prot_err *prot_err,
+				      int severity)
+{
+	u8 *dvsec_start, *cap_start;
+
+	switch (prot_err->agent_type) {
+	case RCD:
+	case DEVICE:
+	case LD:
+	case FMLD:
+	case RP:
+	case DSP:
+	case USP:
+		memcpy(&wd->prot_err, prot_err, sizeof(wd->prot_err));
+
+		dvsec_start = (u8 *)(prot_err + 1);
+		cap_start = dvsec_start + prot_err->dvsec_len;
+
+		memcpy(&wd->ras_cap, cap_start, sizeof(wd->ras_cap));
+		wd->severity = cper_severity_to_aer(severity);
+		break;
+	default:
+		pr_err_ratelimited("CXL CPER invalid agent type: %d\n",
+				   prot_err->agent_type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cxl_cper_setup_prot_err_work_data);
diff --git a/include/cxl/event.h b/include/cxl/event.h
index 4d7d1036ea9cb..94081aec597ae 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -322,12 +322,22 @@ static inline int cxl_cper_prot_err_kfifo_get(struct cxl_cper_prot_err_work_data
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err);
+int cxl_cper_setup_prot_err_work_data(struct cxl_cper_prot_err_work_data *wd,
+				      struct cxl_cper_sec_prot_err *prot_err,
+				      int severity);
 #else
 static inline int
 cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
 {
 	return -EOPNOTSUPP;
 }
+static inline int
+cxl_cper_setup_prot_err_work_data(struct cxl_cper_prot_err_work_data *wd,
+				  struct cxl_cper_sec_prot_err *prot_err,
+				  int severity)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif /* _LINUX_CXL_EVENT_H */
-- 
2.53.0



