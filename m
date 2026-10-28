Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214065;
	b=QYhKP6Tsmz+XXZPgMJOmU3TlK3GBP8iI5fcQGyJkmdEQRiL5tiu0SQjqT8OgVZeo+AMI
	 HZH+T6nvJu6lEf+h7ysX7yq/OrLyz5FjDWMJ+iuMWxLt9JIykfbsX5TujS22wyhHxnpQv
	 Pyy00hihuVBDb2uvRRVNZu9R/wpiSn6t2VLnJkeIyU0u4cMSC8laTKolWn62i6S/SkKA/
	 vBnZppI9Lvf1BHiZGFfopm51bRB31i1rKeAZYg2tQw+em3wI6z7VMjiNRFJ9jAkJG4kyx
	 2LvOFpo1gKYCd8NjxEzlLd9qksvYEJ35fogZ2UQ8Clts8oZY42IZX5zYd8KqJ2XzomQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LN0Wt/o2XCeBVeIjgyT3dF+ZT64q6SGWHeHyChH9hA4=;
	b=iPLczkGxJaVGtl2cv46fqgd4LyekQs2KEZsr1bt6Zwe3G5xdzJuY9X+L9FsDAYJmJ/gV
	 O2s/zNVhKKG1yDFkIr2RQM9Ns9eOM8cgLTOnL9SM7yfQxft/HSbDbXpkAEInTBzOP0pRT
	 goOLdLXqZC6DY99PGVrnePt0ssDGhNBGAF/jCp7NrRDok4agot/+QB+W/nheMG2PnNecA
	 7wrZNZlMi9E7gdUTWQHkcPF/DsrvGos9asDaOAy5o7rkOlhe/s2q5vRY3ztPUpNitn+NZ
	 gtesv4l+AojsrGuHwuhhRf4EMi/ggWV2dyHaPjYq7csNhnnhaun5O+wCJbmcozTdItA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWqO1jXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC3606A31E;
	Wed, 28 Oct 2026 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWqO1jXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF14E1F01825;
	Wed, 28 Oct 2026 19:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214065;
	bh=LN0Wt/o2XCeBVeIjgyT3dF+ZT64q6SGWHeHyChH9hA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWqO1jXo9htEj/b6e1ocXHVI/K9fG7Qo74iITNw+wu8egqxg87Pbe+JV4VgZhz7jM
	 sExDmjefB7cX3cvZxYJtFwAXU0ZzcphklSBT0CvpVzb0jm6O0cKuQngZ6m8WHhn6iB
	 Di64VnowS2mkq8M55dYCRnjQCVINjcSbsg8xXqMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0728/1887] PCI: dwc: ep: Prevent changing BAR size/flags in pci_epc_set_bar()
Date: Wed, 28 Oct 2026 17:47:04 +0100
Message-ID: <20261028170516.017103919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 3708acbd5f169ebafe1faa519cb28adc56295546 ]

In commit 4284c88fff0e ("PCI: designware-ep: Allow pci_epc_set_bar() update
inbound map address") set_bar() was modified to support dynamically
changing the backing physical address of a BAR that was already configured.

This means that set_bar() can be called twice, without ever calling
clear_bar() (as calling clear_bar() would clear the BAR's PCI address
assigned by the host).

This can only be done if the new BAR size/flags does not differ from the
existing BAR configuration. Add these missing checks.

If we allow set_bar() to set e.g. a new BAR size that differs from the
existing BAR size, the new address translation range will be smaller than
the BAR size already determined by the host, which would mean that a read
past the new BAR size would pass the iATU untranslated, which could allow
the host to read memory not belonging to the new struct pci_epf_bar.

While at it, add comments which clarifies the support for dynamically
changing the physical address of a BAR. (Which was also missing.)

Fixes: 4284c88fff0e ("PCI: designware-ep: Allow pci_epc_set_bar() update inbound map address")
Link: https://lore.kernel.org/r/20241213143301.4158431-10-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-designware-ep.c b/drivers/pci/controller/dwc/pcie-designware-ep.c
index 3b3f079d0d2dd..32a04ff86c5c5 100644
--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -247,6 +247,23 @@ static int dw_pcie_ep_set_bar(struct pci_epc *epc, u8 func_no, u8 vfunc_no,
 
 	func_offset = dw_pcie_ep_func_select(ep, func_no);
 
+	/*
+	 * Certain EPF drivers dynamically change the physical address of a BAR
+	 * (i.e. they call set_bar() twice, without ever calling clear_bar(), as
+	 * calling clear_bar() would clear the BAR's PCI address assigned by the
+	 * host).
+	 */
+	if (ep->epf_bar[bar]) {
+		/*
+		 * We can only dynamically change a BAR if the new BAR size and
+		 * BAR flags do not differ from the existing configuration.
+		 */
+		if (ep->epf_bar[bar]->barno != bar ||
+		    ep->epf_bar[bar]->size != size ||
+		    ep->epf_bar[bar]->flags != flags)
+			return -EINVAL;
+	}
+
 	reg = PCI_BASE_ADDRESS_0 + (4 * bar) + func_offset;
 
 	if (!(flags & PCI_BASE_ADDRESS_SPACE))
-- 
2.53.0



