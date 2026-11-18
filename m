Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028445;
	b=p+SCX1TFxuepTQPGmL4AaTBdhbw+sZwSXrs9mAbtII3rFjKEL3U/3GwfhVLSbs3zW9sm
	 WVV7ZPF73GzApxhat4vj7VyCp21Q1KqZ8uA7kYlnQTNNYObIHUs8gY7RInN7miSZsruJ6
	 LLN4+tjWax2kAtQ51Fb/cL47IvKbWPU4GDWqck010eolGe58uEOdxcuVamWouzIefSwfH
	 S4z7hnVU/ClkgcE8GNmhxuz24GDVkurRc6gb9ZhP0Nek35FMGiJLzg9Dak5vHRqZ7fxH7
	 qy4GPdeAj3cZAXbzCgJHVqVdqgz6bFx01w9iGH2LxbimiDiLUlKGuMJ4cF+UEWEtaNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jTN5nnI2riZ7HdIn/5m9o4w99oVtul5ie6sjhuR2ZY8=;
	b=Hpusd86l7NjDIo1r6+Q/mWvTgYVidSU6RdgpdYpZ2QB1rWtT8eWFIqAi3vL2GjbpQ1PI
	 icWpzriHlJuBA2BbSnMGBVcOGO6JjWRsfDm/CT2LOiOIR/SxPlnameKzoxMmP5cqSNJ+D
	 Pwqn7+M6F6Tm49zbMJphL2Nwi5ME0n3v2ojXTEqj8aMAMXT2AZ1DFyyzQk9buoFyJyL6S
	 Jz87W992x+HgdQCubxvUlsosmX0vfin7vs+oW6QSP+FK6+q/bbWm9hcL3jwQUAqajoaD+
	 ewBsNf2sfoUSAOt5S7pvP5pmmKNaoMa1WAZ0w+Pfy2i07ZoXPyyINbP76p7naJXCr+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AS+Q1J82;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D37606A325;
	Wed, 18 Nov 2026 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AS+Q1J82
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237BE1F000C5;
	Wed, 18 Nov 2026 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028445;
	bh=jTN5nnI2riZ7HdIn/5m9o4w99oVtul5ie6sjhuR2ZY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS+Q1J82R7hILXDONF6p/bHe6+nCsmVA79oc2ft8zcX3XhhamOi+/8gVJXXTZ6zq5
	 1wEhAtjQNGwWbNeoCkW3gyH2Mme1rIfBIpvkmtfU2FTtShiEoVsFPtgcbspKgBHAjp
	 gsXGUfjCkW29c3eOtYZHj8qEkSTs1QYN41DpgiCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Alison Schofield <alison.schofield@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 2148/2151] ACPI: extlog: Avoid populating software AER metadata from raw hardware buffer
Date: Wed, 18 Nov 2026 16:04:43 +0100
Message-ID: <20261118150239.917201525@linuxfoundation.org>
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

commit 31333d134afb13e3942867d48efbcf8d6b88c849 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_extlog.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -137,7 +137,7 @@ static void extlog_print_pcie(struct cpe
 			      int severity)
 {
 #ifdef ACPI_APEI_PCIEAER
-	struct aer_capability_regs *aer;
+	struct aer_capability_regs aer_regs = {};
 	struct pci_dev *pdev;
 	unsigned int devfn;
 	unsigned int bus;
@@ -149,7 +149,21 @@ static void extlog_print_pcie(struct cpe
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
@@ -158,7 +172,7 @@ static void extlog_print_pcie(struct cpe
 	if (!pdev)
 		return;
 
-	pci_print_aer(pdev, aer_severity, aer);
+	pci_print_aer(pdev, aer_severity, &aer_regs);
 	pci_dev_put(pdev);
 #endif
 }


