Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015625;
	b=immqF9L+hvfse+MJcCsw19uaVcdZILXEpmC+ml5oWyb1O6JuMIM0e6XdjOqN91ECkwSX
	 0Rqz3a2LboyCf7DxYJwrIWjFyPhkCb+d2y9NrWU/IUai9JjWwEJNGaIm+hvb76RpxT0hA
	 8TPkAy3VDInjxrLQ45A0mnm25etwZm3GjffLGopjc/i9Lg5ldLvnbDLt2oVDrjH3rXRVJ
	 DX+a4bs+GBMcUhPxm0bgM/3O7kTQyKwBWegTQWM/6hCpZsF3FNGPp4k+2kAzlPzzVsa6C
	 N2s3/ZxGqTb0Gxm6qLOI1roeno8O/HvsP+6ApFBmoByUUkCQaB4BdlwXhqXzt1ojxag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gNSlPobKLXdxNi5Vf2H8Gb1AzfQM36ClobuTUwJv5SQ=;
	b=Xa6QNitnX+BIpkWIphWxuaTTB4icWj424lW8PL8GaZ+27iE2dy6UyxzIoGBq2xab8KD/
	 ZfgA6mZ45g++x0Dt827kVUjSAdg/ia7dCEDu+Qu+BAdozEOb/AfKD/SYxwLF9dimfbYnw
	 1KNf/NquLy4PIKJ+WDC7f/cDj0dp8tiXZOX0o8LV3Nm/Z/pCuP1XU/pcJ/HkprisRCoxn
	 QOQ82fwNvp3SGBFLCA3XBaRFEBd2C5w0Lx8iVJ3B6/U5cZcwnWqTozWIAvV2oyySaZlBB
	 9CFdZuBY0WP/iM6WIMBzQON64z5f7lBHl7+p/rATyb4FxPayhrUAcomLCgHmNhkb+OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQUMNwQO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C62606A335;
	Wed, 18 Nov 2026 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tQUMNwQO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB771F000C9;
	Wed, 18 Nov 2026 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015625;
	bh=gNSlPobKLXdxNi5Vf2H8Gb1AzfQM36ClobuTUwJv5SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQUMNwQOw1siqs24PAXDBTqDdpaHogMuCoNJj1ERZmprlatUJBXhu38weZE5wUQ1P
	 0Ru64BrDG7mqkREgLIfUGvRMfNQ0wuJugy9DH0PX8jzXZ9lXtL1Bu0QmgQf1wyzkoU
	 ghdV9UueFFnBqDRM1ZOG3iVrPhr9uuAW8COONngA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Ben Cheatham <benjamin.cheatham@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0239/2651] ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy
Date: Wed, 18 Nov 2026 15:24:39 +0100
Message-ID: <20261118150256.464384123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 8bf58815315aeb60125d26404d6fa7d576d5d518 ]

cxl_cper_setup_prot_err_work_data() locates the RAS Capability block at
prot_err + sizeof(*prot_err) + dvsec_len and copies it, but dvsec_len is
firmware controlled and never validated, so it can point the copy outside
the section.

Extend cxl_cper_sec_prot_err_valid() to check that the section can hold
the header, and that the header, DVSEC and RAS Capability block together
fit the reported section length.

Reported-by: sashiko-bot@kernel.org
Link: https://sashiko.dev/#/patchset/20260617-topics-ahmtib01-ras_ffh_arm_internal_review-v6-0-91f725174aa0@arm.com?part=6
Link: https://lore.kernel.org/linux-cxl/20260709165457.8BA181F000E9@smtp.kernel.org/
Fixes: 315c2f0b53ba ("acpi/ghes, cper: Recognize and cache CXL Protocol errors")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Ben Cheatham <benjamin.cheatham@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-10-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c       |  3 ++-
 drivers/acpi/apei/ghes.c         |  7 ++++---
 drivers/acpi/apei/ghes_helpers.c | 18 +++++++++++++++++-
 include/acpi/ghes.h              |  2 +-
 include/cxl/event.h              |  4 ++--
 5 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 8c17c2719526e..9e61354a807b3 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -248,7 +248,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 				acpi_hest_get_payload(gdata);
 
 			cxl_cper_post_prot_err(prot_err,
-					       gdata->error_severity);
+					       gdata->error_severity,
+					       gdata->error_data_length);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 96fdfb5830609..6dd2ee025963f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -753,12 +753,12 @@ static DEFINE_RAW_SPINLOCK(cxl_cper_prot_err_work_lock);
 struct work_struct *cxl_cper_prot_err_work;
 
 void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
-			    int severity)
+			    int severity, u32 len)
 {
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 	struct cxl_cper_prot_err_work_data wd;
 
-	if (cxl_cper_sec_prot_err_valid(prot_err))
+	if (cxl_cper_sec_prot_err_valid(prot_err, len))
 		return;
 
 	guard(raw_spinlock_irqsave)(&cxl_cper_prot_err_work_lock);
@@ -965,7 +965,8 @@ static void ghes_do_proc(struct ghes *ghes,
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
 			struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
 
-			cxl_cper_post_prot_err(prot_err, gdata->error_severity);
+			cxl_cper_post_prot_err(prot_err, gdata->error_severity,
+					       gdata->error_data_length);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_GEN_MEDIA_GUID)) {
 			struct cxl_cper_event_rec *rec = acpi_hest_get_payload(gdata);
 
diff --git a/drivers/acpi/apei/ghes_helpers.c b/drivers/acpi/apei/ghes_helpers.c
index bc7111b740afb..df41b993f4130 100644
--- a/drivers/acpi/apei/ghes_helpers.c
+++ b/drivers/acpi/apei/ghes_helpers.c
@@ -5,8 +5,15 @@
 #include <linux/aer.h>
 #include <cxl/event.h>
 
-int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
+int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err, u32 len)
 {
+	if (len < sizeof(*prot_err)) {
+		pr_err_ratelimited(FW_WARN
+				   "CXL CPER prot err section too small (%u)\n",
+				   len);
+		return -EINVAL;
+	}
+
 	if (!(prot_err->valid_bits & PROT_ERR_VALID_AGENT_ADDRESS)) {
 		pr_err_ratelimited("CXL CPER invalid agent type\n");
 		return -EINVAL;
@@ -23,6 +30,15 @@ int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
 		return -EINVAL;
 	}
 
+	/* The RAS Capability block sits after a firmware-sized DVSEC. */
+	if (sizeof(*prot_err) + prot_err->dvsec_len +
+	    sizeof(struct cxl_ras_capability_regs) > len) {
+		pr_err_ratelimited(FW_WARN
+				   "CXL CPER prot err DVSEC (%u) overruns section (%u)\n",
+				   prot_err->dvsec_len, len);
+		return -EINVAL;
+	}
+
 	if ((prot_err->agent_type == RCD || prot_err->agent_type == DEVICE ||
 	     prot_err->agent_type == LD || prot_err->agent_type == FMLD) &&
 	    !(prot_err->valid_bits & PROT_ERR_VALID_SERIAL_NUMBER))
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index be496bc0386fc..7acf209061ea7 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -88,7 +88,7 @@ void ghes_estatus_pool_region_free(unsigned long addr, u32 size);
 
 struct cxl_cper_sec_prot_err;
 void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
-			    int severity);
+			    int severity, u32 len);
 #else
 static inline struct list_head *ghes_get_devices(void) { return NULL; }
 
diff --git a/include/cxl/event.h b/include/cxl/event.h
index b5673384d9306..5779e35310c76 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -312,13 +312,13 @@ static inline int cxl_cper_prot_err_kfifo_get(struct cxl_cper_prot_err_work_data
 #endif
 
 #ifdef CONFIG_ACPI_APEI_PCIEAER
-int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err);
+int cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err, u32 len);
 int cxl_cper_setup_prot_err_work_data(struct cxl_cper_prot_err_work_data *wd,
 				      struct cxl_cper_sec_prot_err *prot_err,
 				      int severity);
 #else
 static inline int
-cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err)
+cxl_cper_sec_prot_err_valid(struct cxl_cper_sec_prot_err *prot_err, u32 len)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.53.0



