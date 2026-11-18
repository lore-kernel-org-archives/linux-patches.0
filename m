Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023109;
	b=nZBci+jjcmricMMjU4rT7g70cg9j6Q6N99XLp8TyUuXZ1ZOf12Y94ctn5JrmIckoKnQf
	 5O5Kk93rV8kO9qFwAgSqIyhAgV5Zd2s+5RNkdJ0KtxG242DH2cMoYp8eWnoR8n5otZxTu
	 MMhq9GPwk24P1RXgMu5xyl62Ce5dtIvOFY8DOOCxRs+M+RCDUr9v7VsgvTsocsiVGWyfA
	 p1maqXqMjg/Ekq+KQh3w1q+FGqAXiN9ydG+shFELLyQ9xUe8I371sNnyxSDMiBlrhz3ND
	 XYbCXliiDvmqjqNohvN8+1VFXwzRQ8zMmm6zIaJIqn6c+K8zXsUYII0iA36BjvMGGNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xAsXVqYdQ4jq7pyrvFU4Sg2hqpUJgYw2wSV2mXjqvwE=;
	b=sywYeVc/ug2tC/NJDreN7uIxtYQ7PYcV9lb5NE3OeBf0zxpIjnkvdrieMhmMRTycwrUQ
	 yKWgSaNap/FiHQG8gKGRcvxOCuZC/8WNXBFo4Hs2dNndRrDkYVp521vq3OGRedVbcuEcr
	 wS+LiB+TJKYKFgl3AhZX0KBWLdfGjBEkBDg6kTpYDUH4Qyev0TlI9NhYImELaR40JG/6H
	 BPtHP5nu7+6fkXnOC1T2l78vZMT8CTGjssjcT0bPjnvsMuy3Xhr5zzzIoJTQP1PRA5CBe
	 hgDfeO8OnbRrTMZXQ3hXabaLSKJH/8H/9aShm9g37TGKvIMRJF1IE+OBB221AGEVFmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gy+VqOIv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7511606A325;
	Wed, 18 Nov 2026 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gy+VqOIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DEE1F000C4;
	Wed, 18 Nov 2026 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023109;
	bh=xAsXVqYdQ4jq7pyrvFU4Sg2hqpUJgYw2wSV2mXjqvwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gy+VqOIvQnaKI+96Eb5exezMZcXs1TgOtTjgUh3IyeIveaJxTCsjn14ai8B4SpYdk
	 bRYilI8ng/lwqYicbNgIelgMevxBvKH//YO7uJx8jY3hdr9iq/71z7jV1m7MWDhx9V
	 0+o0/Eg1PXSiL52UBwgQ4600GXltMiti/N9cbf+Q=
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
Subject: [PATCH 6.18 0253/2151] ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy
Date: Wed, 18 Nov 2026 15:33:08 +0100
Message-ID: <20261118150131.004743785@linuxfoundation.org>
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
index 2451362e696dc..5ad4b02c995d1 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -228,7 +228,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 				acpi_hest_get_payload(gdata);
 
 			cxl_cper_post_prot_err(prot_err,
-					       gdata->error_severity);
+					       gdata->error_severity,
+					       gdata->error_data_length);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 79b1c3dd8f71f..58c7caa6d3d3a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -740,12 +740,12 @@ static DEFINE_RAW_SPINLOCK(cxl_cper_prot_err_work_lock);
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
@@ -919,7 +919,8 @@ static void ghes_do_proc(struct ghes *ghes,
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
index ea0d16af87194..0360efc78001d 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -76,7 +76,7 @@ void ghes_estatus_pool_region_free(unsigned long addr, u32 size);
 
 struct cxl_cper_sec_prot_err;
 void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
-			    int severity);
+			    int severity, u32 len);
 #else
 static inline struct list_head *ghes_get_devices(void) { return NULL; }
 
diff --git a/include/cxl/event.h b/include/cxl/event.h
index ff97fea718d2c..912305bee3bcb 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -321,13 +321,13 @@ static inline int cxl_cper_prot_err_kfifo_get(struct cxl_cper_prot_err_work_data
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



