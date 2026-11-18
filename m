Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023107;
	b=013/KdmDX6esKuzVQDDk+632Q/5KWZ27LgkBqrL2NbRd2GKWu6uIbJ1iarFtAEYhs19G
	 hPZuaiebtM1d42vJzutBiF7hsuzp2bd+qHBMzkcKxFWxtb/+quFWCjfRMBfk9Lr5Tt7pY
	 ujkEPFkPKlfXzziWI+hjR2W0waUdcTKApTL0m3Z0B8frD9Ba7L8PedzGe9ZyX6ayq0f4W
	 X7AFtPTd39h3pWyyPKmUGWm+PfmI4pdb6MRrqcRLgvx0Y193si0VqRck9DwPAYfYvGTV1
	 zSHNoTvXxqf0V2kOf+G42gBRgLVAZJTuo5101p2Ie9Vt6F3O3sYmNbghMEfj1Ya7eIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6DDh+uxxUQxw9bRvqivhORuo4g1TphWKVaO5AzIwAc=;
	b=UqklNWcxZaU+VxG2X/eVByX5S3SshjOMqyDy2jkJltGFRaQ0guBdmTwecpSKD+/7USPb
	 DVWodvxj9gEpGeSvZofRVQzPCQv3JjXfWX5+APcVb6beRwGorWirr5L8Yt9pCdNkhhsIW
	 DgxSHHEPMBt0GCSrPwlYPAjEQpPmxUiIVYv49HWLcD4YX6iUhklcweGFk8lDahlF4akX9
	 rDTSVhyA+qCyidwKImxfkKyi47rCt+qv07qLNepMHTBOeTSXUW5XNaOhXcCVQsbhD/77b
	 Wzz+CnwfLyU74mjUIkX3yAOewUkgCsMan0zBpluP+rUXXnePRZXhb9PWBKDCXHdpH5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ca8p/hb7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC53606A31C;
	Wed, 18 Nov 2026 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ca8p/hb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF9D1F000C4;
	Wed, 18 Nov 2026 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023107;
	bh=H6DDh+uxxUQxw9bRvqivhORuo4g1TphWKVaO5AzIwAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ca8p/hb7OOHhG6Eaar4xAGnJr49CyHn59slK5IYMKxK4dPArJ+xF+wHcC3w9r+S6C
	 rKo3Th/rfAADlcLrHyEoQ/yU1EqZmChJnSNWTn8JG5Nn3ZjlsrEmgk6MjnwenzOxYC
	 iFFXPdTBaqCIUoISEkWyU+3bQNL0o6wfJ1iP6rck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0252/2151] ACPI: extlog: Defer CXL protocol error handling to avoid lock inversion
Date: Wed, 18 Nov 2026 15:33:07 +0100
Message-ID: <20261118150130.968169402@linuxfoundation.org>
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

[ Upstream commit 179ef6d7f971d72a0f54b7c499daed1b244ee1a5 ]

extlog_print() calls cxl_cper_handle_prot_err() synchronously while the
MCE notifier chain rwsem is held, and that path takes the PCI device_lock
via guard(device)(). The probe path takes the two in the opposite order,
holding device_lock while mce_register_decode_chain() takes the rwsem, so
they can deadlock AB-BA.

ghes.c already avoids this by posting protocol errors to a kfifo and
handling them from a workqueue via cxl_cper_post_prot_err(). Export that
function and call it instead.

Declare it with the other CONFIG_ACPI_APEI_GHES exports rather than at the
end of the header. No #else stub: ACPI_EXTLOG selects ACPI_APEI_GHES, so
the only caller cannot exist without it.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-cxl/20260709165457.8BA181F000E9@smtp.kernel.org/
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-5-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 8bf58815315a ("ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 21 ++-------------------
 drivers/acpi/apei/ghes.c   |  5 +++--
 include/acpi/ghes.h        |  4 ++++
 3 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 046e92ee195f9..2451362e696dc 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -163,23 +163,6 @@ static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 #endif
 }
 
-static void
-extlog_cxl_cper_handle_prot_err(struct cxl_cper_sec_prot_err *prot_err,
-				int severity)
-{
-#ifdef ACPI_APEI_PCIEAER
-	struct cxl_cper_prot_err_work_data wd;
-
-	if (cxl_cper_sec_prot_err_valid(prot_err))
-		return;
-
-	if (cxl_cper_setup_prot_err_work_data(&wd, prot_err, severity))
-		return;
-
-	cxl_cper_handle_prot_err(&wd);
-#endif
-}
-
 static int extlog_print(struct notifier_block *nb, unsigned long val,
 			void *data)
 {
@@ -244,8 +227,8 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 			struct cxl_cper_sec_prot_err *prot_err =
 				acpi_hest_get_payload(gdata);
 
-			extlog_cxl_cper_handle_prot_err(prot_err,
-							gdata->error_severity);
+			cxl_cper_post_prot_err(prot_err,
+					       gdata->error_severity);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index e386a00515ce0..79b1c3dd8f71f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -739,8 +739,8 @@ static DEFINE_KFIFO(cxl_cper_prot_err_fifo, struct cxl_cper_prot_err_work_data,
 static DEFINE_RAW_SPINLOCK(cxl_cper_prot_err_work_lock);
 struct work_struct *cxl_cper_prot_err_work;
 
-static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
-				   int severity)
+void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
+			    int severity)
 {
 #ifdef CONFIG_ACPI_APEI_PCIEAER
 	struct cxl_cper_prot_err_work_data wd;
@@ -764,6 +764,7 @@ static void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
 	schedule_work(cxl_cper_prot_err_work);
 #endif
 }
+EXPORT_SYMBOL_FOR_MODULES(cxl_cper_post_prot_err, "acpi_extlog");
 
 int cxl_cper_register_prot_err_work(struct work_struct *work)
 {
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 93db60da5934e..ea0d16af87194 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -73,6 +73,10 @@ void ghes_unregister_vendor_record_notifier(struct notifier_block *nb);
 struct list_head *ghes_get_devices(void);
 
 void ghes_estatus_pool_region_free(unsigned long addr, u32 size);
+
+struct cxl_cper_sec_prot_err;
+void cxl_cper_post_prot_err(struct cxl_cper_sec_prot_err *prot_err,
+			    int severity);
 #else
 static inline struct list_head *ghes_get_devices(void) { return NULL; }
 
-- 
2.53.0



