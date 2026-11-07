Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061374;
	b=nzVrfUlD7co5h7SlrpLyXmg80KBm4iA5sqySUkuAmgRkU3h+2kI0esQQxmukWfOwmXa0
	 gAcb/ZYGcD/lmJXvahBWgbi/c187fAuBLgbd2Q3gZwU7W2irexfrqLT6TRMIN2e61dDYN
	 nSXeX0HVY/FeGJ7XoMxHsyQv0WwEXrKvqeLovGOP/jKryPr1SP2Wl4nGbpVvNDlVhLVLq
	 cP0oPXq21PRQLy0cqtyiXH67mlA3Z/lMydCEcu7HTSDywgzSsliN6e3iA1f++7Kekd3cw
	 FMnrpmXkiFkr2zWx/CEsqdU8Mv/A47r83v9064sStJzAtYyGjBPMJViNsLRdRzZfJTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LKhJgbNBYrfzeu/wyH68hgAb9WqnYRVHKRVZsdMxUBo=;
	b=H6orHx4xPZhQY2ZhN8PZBKF17vaScKouwNaLuZejsLGgMzxj987V6H9Lzq8YmOea3vIb
	 IRNsWgBc1RhSMJkv71wZzOPjtdoUHI7IHCYPM6VqqGf+xPIUH3ZA+j5MC3Z4mLXfyh6r/
	 xh+ph1YashvrxcubStAQyLytQaXFdt33yPUgHiIbkCaB/NR6ly8ZaWu7/assb8W5jTwjK
	 cOt6LFr0cI2E5Nh7myvjKsQXckc1lbBr3SZ1hnm5s7bKVpQATwaG9iLs9YCyaxwep4qjS
	 qdYG4KeXGB/6G9Zm07yW//3LzmM/VJQRY7h+jRWGgECUQnzfxvAsb0OZ0bDXqGRxhpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbN8toD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D7F606D829;
	Sat,  7 Nov 2026 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbN8toD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EF01F008BD;
	Sat,  7 Nov 2026 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061374;
	bh=LKhJgbNBYrfzeu/wyH68hgAb9WqnYRVHKRVZsdMxUBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbN8toD0QSzdppKOYItucvELPKFGL/0jKk0tenr8YFhWSd9qLQUpCAD/XFztk7uO8
	 am3ZmGefKdo2zpQxGnJqXAre++S5gcSxXNeg3ctrmUMJLzGHwVFOfoP5TeK+jMUYru
	 SReidRFaIMClB7S8phVk6s8IXKzWddp0fLJlkU0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0459/1536] PCI/AER: Emit TLP Log only for unmasked errors
Date: Sat,  7 Nov 2026 08:41:15 -0500
Message-ID: <20261107135010.416580379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit a8bf2dd750de7d682fdaa2127f4e3217ce9c4a82 ]

Per PCIe r7.0 sec 6.2.5, the prefix and header of an offending TLP is only
recorded for unmasked Uncorrectable Errors.  Yet when the AER driver
determines whether a prefix and header has been logged, it does not take
the Uncorrectable Error Mask Register into account.  Fix it.

Fixes: 6c2b374d7485 ("PCI-Express AER implemetation: AER core and aerdriver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v2.6.19+
Link: https://patch.msgid.link/2e712b96ba5bfc729d78bfc23f7fb7d285aa3d6d.1784905909.git.lukas@wunner.de
[ sashal: Open-coded the unmasked-status check as (status & ~mask) & AER_LOG_TLP_MASKS in two places, since this tree has no tlp_header_logged() helper to modify. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 0e00ea3ae0b5a..592b40e51eaa2 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -785,7 +785,7 @@ void pci_print_aer(struct pci_dev *dev, int aer_severity,
 	} else {
 		status = aer->uncor_status;
 		mask = aer->uncor_mask;
-		tlp_header_valid = status & AER_LOG_TLP_MASKS;
+		tlp_header_valid = (status & ~mask) & AER_LOG_TLP_MASKS;
 	}
 
 	layer = AER_GET_LAYER_ERROR(aer_severity, status);
@@ -1252,7 +1252,7 @@ int aer_get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
 		pci_read_config_dword(dev, aer + PCI_ERR_CAP, &aercc);
 		info->first_error = PCI_ERR_CAP_FEP(aercc);
 
-		if (info->status & AER_LOG_TLP_MASKS) {
+		if ((info->status & ~info->mask) & AER_LOG_TLP_MASKS) {
 			info->tlp_header_valid = 1;
 			pcie_read_tlp_log(dev, aer + PCI_ERR_HEADER_LOG, &info->tlp);
 		}
-- 
2.53.0



