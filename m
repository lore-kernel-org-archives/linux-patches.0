Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023104;
	b=bXUP8v9emMubm2QZj9XZ1DL+wyv2u+Uv2tNNEUyjrnSXLmHrsCNVGyOoEBPYq4uzWhTY
	 9hwVsnr5RmBc0P40g6grqm+qi5oTtCMBPv2Eykb36KewxEyKljy7o9UGQxS+DVFS0sQpJ
	 fGkFGSHp74VWgARFKEbbmNOs+fOlV63+bmrTWhYFIAnXcYCi5ls+WKDuI2zVPjHExxOB3
	 9DBz21J/0XMQyQgfWbLkijzYuxAWrIwLZsO0tW2Lc1m7BpVLZ3VLub93cOENcpnOegcXH
	 lRQza5PupjdyxsdBbgfZ1FDhJK9n9C0WgEynUYWVZStKhNxgNj4pHSL5iIBRwmXj7AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wt3M9GKbr58RJ14aua1imrUoSHe2x/6Ww/Q1XrtgkRk=;
	b=yNnk8fsjFTxKweZczownJxCs3hCFhsqQ6kHdcH9+q02y9wm0ZLX3CoA7blE+v9Kljrr+
	 ERyalEtepyQQAf7bHEMB5RzJEyszDmLsG5XjNNZgPC5d8P8g8aAQoWPGRqC0zECd+5SFi
	 FWzvK0R54um6ZEHdhIyVMV5yRHZoAsHIP3aeJ77rwW08ZGKvT3LiEaINlnRBGonxkTlhP
	 QyGCeumkXLOPhJeN1NO+4GkA39mr04nAwsouiVYFH+1Z8j1Fg0+cD7dIlPe16tfEsGrcQ
	 g8sMyRVPOdL88lt6guDWvsA7CHkIYTjR7BrjRuzEmETu5h7igJem5fBiGUvgZFeFspA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soviIH+F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAD4606A31C;
	Wed, 18 Nov 2026 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soviIH+F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20D21F000C4;
	Wed, 18 Nov 2026 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023104;
	bh=Wt3M9GKbr58RJ14aua1imrUoSHe2x/6Ww/Q1XrtgkRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soviIH+FDU8PTczcJm9xkwxrz1viz/H1qJT7QSD4uQJOa8FXebSNped5Ej330OT6z
	 J0K4gJxDyvwwDoMIzkyQRIMw6nwqPBw9JREYJS1Rum6qQCHCodVbV25zf5+i/dQfZb
	 ZhfW2IT947yN80jPbbdTuqqjxucM0IWVB8X5K6Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0251/2151] ACPI: extlog: Trace CPER CXL Protocol Error Section
Date: Wed, 18 Nov 2026 15:33:06 +0100
Message-ID: <20261118150130.933002675@linuxfoundation.org>
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

[ Upstream commit 95350effc3ad62582411f59fd08a7621ac82f314 ]

When Firmware First is enabled, BIOS handles errors first and then it
makes them available to the kernel via the Common Platform Error Record
(CPER) sections (UEFI 2.11 Appendix N.2.13). Linux parses the CPER
sections via one of two similar paths, either ELOG or GHES. The errors
managed by ELOG are signaled to the BIOS by the I/O Machine Check
Architecture (I/O MCA).

Currently, ELOG and GHES show some inconsistencies in how they report to
userspace via trace events.

Therefore, make the two mentioned paths act similarly by tracing the CPER
CXL Protocol Error Section.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
Link: https://patch.msgid.link/20260114101543.85926-6-fabio.m.de.francesco@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 8bf58815315a ("ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/Kconfig       |  2 ++
 drivers/acpi/acpi_extlog.c | 24 ++++++++++++++++++++++++
 drivers/cxl/core/ras.c     |  3 ++-
 include/cxl/event.h        |  2 ++
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index ca00a5dbcf750..df0ff0764d0d5 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -494,6 +494,8 @@ config ACPI_EXTLOG
 	tristate "Extended Error Log support"
 	depends on X86_MCE && X86_LOCAL_APIC && EDAC
 	select UEFI_CPER
+	select ACPI_APEI
+	select ACPI_APEI_GHES
 	help
 	  Certain usages such as Predictive Failure Analysis (PFA) require
 	  more information about the error than what can be described in
diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 6a1e4ca9b0881..046e92ee195f9 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -12,6 +12,7 @@
 #include <linux/ratelimit.h>
 #include <linux/edac.h>
 #include <linux/ras.h>
+#include <cxl/event.h>
 #include <acpi/ghes.h>
 #include <asm/cpu.h>
 #include <asm/mce.h>
@@ -162,6 +163,23 @@ static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 #endif
 }
 
+static void
+extlog_cxl_cper_handle_prot_err(struct cxl_cper_sec_prot_err *prot_err,
+				int severity)
+{
+#ifdef ACPI_APEI_PCIEAER
+	struct cxl_cper_prot_err_work_data wd;
+
+	if (cxl_cper_sec_prot_err_valid(prot_err))
+		return;
+
+	if (cxl_cper_setup_prot_err_work_data(&wd, prot_err, severity))
+		return;
+
+	cxl_cper_handle_prot_err(&wd);
+#endif
+}
+
 static int extlog_print(struct notifier_block *nb, unsigned long val,
 			void *data)
 {
@@ -222,6 +240,12 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 			if (gdata->error_data_length >= sizeof(*mem))
 				trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
 						       (u8)gdata->error_severity);
+		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
+			struct cxl_cper_sec_prot_err *prot_err =
+				acpi_hest_get_payload(gdata);
+
+			extlog_cxl_cper_handle_prot_err(prot_err,
+							gdata->error_severity);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
 
diff --git a/drivers/cxl/core/ras.c b/drivers/cxl/core/ras.c
index 1f8195fb51a93..34fd019da1cdc 100644
--- a/drivers/cxl/core/ras.c
+++ b/drivers/cxl/core/ras.c
@@ -77,7 +77,7 @@ static int match_memdev_by_parent(struct device *dev, const void *parent)
 	return 0;
 }
 
-static void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
+void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
 {
 	unsigned int devfn = PCI_DEVFN(data->prot_err.agent_addr.device,
 				       data->prot_err.agent_addr.function);
@@ -118,6 +118,7 @@ static void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *data)
 	else
 		cxl_cper_trace_uncorr_prot_err(cxlmd, data->ras_cap);
 }
+EXPORT_SYMBOL_GPL(cxl_cper_handle_prot_err);
 
 static void cxl_cper_prot_err_work_fn(struct work_struct *work)
 {
diff --git a/include/cxl/event.h b/include/cxl/event.h
index 94081aec597ae..ff97fea718d2c 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -340,4 +340,6 @@ cxl_cper_setup_prot_err_work_data(struct cxl_cper_prot_err_work_data *wd,
 }
 #endif
 
+void cxl_cper_handle_prot_err(struct cxl_cper_prot_err_work_data *wd);
+
 #endif /* _LINUX_CXL_EVENT_H */
-- 
2.53.0



