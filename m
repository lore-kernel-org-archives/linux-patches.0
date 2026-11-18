Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023098;
	b=MCWrea86AaljMvA8lA+W+Ubghr40O2zEgu3DDnMaNmHZeyi6755olh+pFl7jkKW6eaYb
	 5vJO4Z23biSFGQmyQ9MBKRQyRe3o7Cujh6X2b5H+PV+E75VR/FkDyTJr+eDws82QP445/
	 XqBPdG72Boc2RApzbYW4Ziu2ZQSdL57hr8rpmMVCvaozItc3sEQPK+t3FN7zh87D0rKjZ
	 Bhi02uyZnmMG8Xh5DK+aV8ZM9PUpWw0cPwNLQ/Lkk3PJyBichZnkTnCIOntgk5wEltCJD
	 nr3yuD3fUYdc9TZOyNKBvNb8aOVVPL0o/gBAERa/0c6WF9fny2JXJm9XSbGBBFhkXXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/jAQB+Khu8h/GQXO60VEKSGAHvOmtIdHk6bnMegWzZU=;
	b=p8gdeGh6p+5fseSSnhzQDTRqEt6eQDvxB/Y9WVA8A6aYl4IyJPEcgI2Xuxl+dP4rlaDb
	 bP8qreZhU4CsQTUh2B3iDNgCgwnCM2/XpT3EuLT8aD9Gst/4wKUOYiTIigB7fyNOYq61F
	 nN/CgJCc4evPfhsPoLM4n59x3yWiI0jfTs1YBGKeAuW5mYJ/gGkH5v5e/GL7anx89Vr1T
	 niFUBvkCfbjSazZ6EEi3Vetl3pijuRlCPV+D2Kk4W3+3SPN7QYkrYcKD4ABoWbs748uz7
	 8IGYQ/LuFTIIzBHTeN11ypNeGiG3EIhD1Vnc8oqBzFTFnl3DD454ijrzQjS7snnyIxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLmDoZag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61DB606A31C;
	Wed, 18 Nov 2026 17:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLmDoZag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CAD1F000C4;
	Wed, 18 Nov 2026 17:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023098;
	bh=/jAQB+Khu8h/GQXO60VEKSGAHvOmtIdHk6bnMegWzZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLmDoZagWmKbvsNvFPph4I3NBuWs+/SQTUr1823fNbxi2Gbndm2dC50wBWg8uBYad
	 ZrmuCA8/E8LrV6cw5ztymjo7lW4OHMEGOt/NEi8eZKiTXdgLI9JONJVZb3uaVtA1wy
	 31RgjhN2Jcg6kJyBlSSwGe2l6tgAfYXB2cYw3ov4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0249/2151] ACPI: extlog: Trace CPER PCI Express Error Section
Date: Wed, 18 Nov 2026 15:33:04 +0100
Message-ID: <20261118150130.861783888@linuxfoundation.org>
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

[ Upstream commit e778ffefa34ddcdc32a260452627e390941812eb ]

I/O Machine Check Architecture events may signal failing PCIe components
or links. The AER event contains details on what was happening on the wire
when the error was signaled.

Trace the CPER PCIe Error section (UEFI v2.11, Appendix N.2.7) reported
by the I/O MCA.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
Link: https://patch.msgid.link/20260114101543.85926-3-fabio.m.de.francesco@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 8bf58815315a ("ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 34 ++++++++++++++++++++++++++++++++++
 drivers/pci/pcie/aer.c     |  2 +-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 542e8b96a86ae..6a1e4ca9b0881 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -132,6 +132,36 @@ static int print_extlog_rcd(const char *pfx,
 	return 1;
 }
 
+static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
+			      int severity)
+{
+#ifdef ACPI_APEI_PCIEAER
+	struct aer_capability_regs *aer;
+	struct pci_dev *pdev;
+	unsigned int devfn;
+	unsigned int bus;
+	int aer_severity;
+	int domain;
+
+	if (!(pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
+	      pcie_err->validation_bits & CPER_PCIE_VALID_AER_INFO))
+		return;
+
+	aer_severity = cper_severity_to_aer(severity);
+	aer = (struct aer_capability_regs *)pcie_err->aer_info;
+	domain = pcie_err->device_id.segment;
+	bus = pcie_err->device_id.bus;
+	devfn = PCI_DEVFN(pcie_err->device_id.device,
+			  pcie_err->device_id.function);
+	pdev = pci_get_domain_bus_and_slot(domain, bus, devfn);
+	if (!pdev)
+		return;
+
+	pci_print_aer(pdev, aer_severity, aer);
+	pci_dev_put(pdev);
+#endif
+}
+
 static int extlog_print(struct notifier_block *nb, unsigned long val,
 			void *data)
 {
@@ -192,6 +222,10 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 			if (gdata->error_data_length >= sizeof(*mem))
 				trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
 						       (u8)gdata->error_severity);
+		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
+			struct cper_sec_pcie *pcie_err = acpi_hest_get_payload(gdata);
+
+			extlog_print_pcie(pcie_err, gdata->error_severity);
 		} else {
 			void *err = acpi_hest_get_payload(gdata);
 
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 9ded8dacb62c9..c6a0e8969927e 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -983,7 +983,7 @@ void pci_print_aer(struct pci_dev *dev, int aer_severity,
 		pcie_print_tlp_log(dev, &aer->header_log, info.level,
 				   dev_fmt("  "));
 }
-EXPORT_SYMBOL_NS_GPL(pci_print_aer, "CXL");
+EXPORT_SYMBOL_GPL(pci_print_aer);
 
 /**
  * add_error_device - list device to be handled
-- 
2.53.0



