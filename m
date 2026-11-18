Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015612;
	b=wHNhjxC28AJYXwbHJnYepO2FyAqMFohfdL5Uu4aS3GdticS1HoS0Fhab0ly/x9nCzy6D
	 s314b3cGK2PAwgR+QRetFWNt17mKJ/fVJKD4ujmjtBypGwtZUFO6n2L9jf+InjtJAwJ2L
	 0tLL3Z2TONWhV17TstyNg3J6+NeDQN6la78+XgsuhtbS8L2Lrkw/IxXKnSqcbV32jQk29
	 MagRg6djOlcg9Nj85rTi3X55nAQ+0zGqCmlVlOstpb1qo7zBRbOCZ2/2EQAZRZE0w4biV
	 X4WdFXhla/x2iQk06mNc9hIdMt/mE6/wdYDRATyZmPPWcK5HcZa2Ji01WVcn7l9Pw0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uW3AFKNMgIauCDJqMLz7yondYg1UgboQl0S4GUt4a70=;
	b=H/X1H/IkO5/v8ZZDUuYxrd0QJzDefo1XXt8h8X3QudNJp4dncHaVfNvCq/ABeQyVAU+N
	 HETxmW2BjXQZbrJ6Ii1DiAGVfbNcmDzKOC9cgROdYowlfbOkb0PgoQHh4I5ZETiFxbTvb
	 nOdSB8MlghkAOVCV76e4yaveg+8fNTtJ6AsXFd3q1PudEU5db6RAY+X4DCAirWZut5Ed+
	 fCaNkYwqYAmx+UY1txSG5266gf7eJCe23Zwl0NDjkW1KX1HJyJiU1jQ6RGEDawlQMHWAf
	 YxfA6NjzJcyuls20Hdd4v2H1E3h2gD4ypiv/nuRqdNxwjFmu9YcMmClHSt6AeaBvMZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hq2KeHup;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C90F606A32C;
	Wed, 18 Nov 2026 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hq2KeHup
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704161F000C4;
	Wed, 18 Nov 2026 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015611;
	bh=uW3AFKNMgIauCDJqMLz7yondYg1UgboQl0S4GUt4a70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hq2KeHupx000Tjb3qRuGmwLal4XPXMSN02xHD4juRbzs7LdW+n7OAtBhUGD/EqBYM
	 t+KXap7pLEMSR4MnD+V61p/rF4fr7dVJafApwseC7bro/O5gNJdoHx18ns4YJ0WdIl
	 lDYV5sBkO/42GqLsiU2qreM/L7DEJkZGb71jN+lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0234/2651] ACPI: extlog: Avoid populating software AER metadata from raw hardware buffer
Date: Wed, 18 Nov 2026 15:24:34 +0100
Message-ID: <20261118150256.283332634@linuxfoundation.org>
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

[ Upstream commit 31333d134afb13e3942867d48efbcf8d6b88c849 ]

extlog_print_pcie() casts pcie_err->aer_info straight to struct
aer_capability_regs *. That struct embeds struct pcie_tlp_log, whose
software-only header_len and flit fields sit at offset 84 - inside the
96-byte aer_info buffer - so the cast fills them with raw firmware bytes.
pcie_print_tlp_log() uses both to bound a loop over dw[], and a large
header_len walks past the end of the array.

Copy into a zeroed local struct, and only as far as aer_info maps onto it:
the leading registers and the four Header Log DWORDs. Place the TLP Prefix
Log separately, from the offset the hardware keeps it at. The rest stays
zero, which covers header_len and flit and keeps the Root Error registers
out of the prefix log, where pcie_print_tlp_log() would print them as
end-to-end prefixes.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-cxl/20260709165457.8BA181F000E9@smtp.kernel.org/
Fixes: e778ffefa34d ("ACPI: extlog: Trace CPER PCI Express Error Section")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-6-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 046e92ee195f9..eed807dd160f8 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -137,7 +137,7 @@ static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 			      int severity)
 {
 #ifdef ACPI_APEI_PCIEAER
-	struct aer_capability_regs *aer;
+	struct aer_capability_regs aer_regs = {};
 	struct pci_dev *pdev;
 	unsigned int devfn;
 	unsigned int bus;
@@ -149,7 +149,21 @@ static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 		return;
 
 	aer_severity = cper_severity_to_aer(severity);
-	aer = (struct aer_capability_regs *)pcie_err->aer_info;
+
+	/*
+	 * struct pcie_tlp_log is larger than the hardware layout, so aer_info
+	 * only maps onto the struct up to the four Header Log DWORDs. Copy that
+	 * much, then place the TLP Prefix Log from where the hardware keeps it.
+	 * Everything else stays zero: nothing reads root_command, root_status or
+	 * the error source IDs, and header_len and flit are software-only.
+	 */
+	memcpy(&aer_regs, pcie_err->aer_info,
+	       offsetof(struct aer_capability_regs, header_log) +
+	       PCIE_STD_NUM_TLP_HEADERLOG * sizeof(u32));
+	memcpy(aer_regs.header_log.prefix,
+	       pcie_err->aer_info + PCI_ERR_PREFIX_LOG,
+	       sizeof(aer_regs.header_log.prefix));
+
 	domain = pcie_err->device_id.segment;
 	bus = pcie_err->device_id.bus;
 	devfn = PCI_DEVFN(pcie_err->device_id.device,
@@ -158,7 +172,7 @@ static void extlog_print_pcie(struct cper_sec_pcie *pcie_err,
 	if (!pdev)
 		return;
 
-	pci_print_aer(pdev, aer_severity, aer);
+	pci_print_aer(pdev, aer_severity, &aer_regs);
 	pci_dev_put(pdev);
 #endif
 }
-- 
2.53.0



