Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034617;
	b=wU6h4Se2Lv4Wv+FuB96hHcpYg/hCsC++CgHgX7wQQAvEViK4ODR5EM6oRuoQM/Gc3hU5
	 o8EX/lFz7Cx9cigx6J7cVN3605COoz0u9OUzj1pJ6SYlW7jdowWzgYvv/Toar7w6l51nO
	 8vhZ+kyopC7A/FXxqGBgJHS5gD+W/WU3S5heUmpjQlS8K/mMs5iGNbqT0vkSYJmOCRcWV
	 hzvWVFOP3xOGFqy+ndLCR6HJ5522nHRmOTDyAz/xV57xyixHSvPws51N5yWB/XV7xb1L2
	 3kQOTLBLxoFKkSijRauPQOB8rzfCFcU4u6xOaJUK+xU7OYvtN4VeO0gv0r6LKlfaCGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bOqegnx/bbD237Xy32ClMAjCA840d5u6rjMDWmDM9+A=;
	b=VU8VOdCNMM8Rj+pz+AtHlaLdYTj3wxPDD4KP2LwSRiZ7LPr3yycKua80m0Yq/7LQVZjF
	 Mth5D2vdvP7hninkarIW4NOYzxoq9mORtHTyp+apP60W7X1qAbwLi0Gc7B31ehkn9JXgE
	 Z1WBKyc8E6RHcZPDwmqkC/OGWgmzcv6ATzBhT+Ufk2D4Rv7tNB9HTPykyXWfxRppCCJ/6
	 e6c/7sVwwNYvpX1RUo3Oxi1L2Yy7AE+R3vlRfwAY1TSQlpkgM4net5NfPwnl/5x9BPtdQ
	 4wsfOugeekT6c3NoaHw8OW8AGZiNespyyRdW+9UFieJyxOoiPveP9jt5PQamZ2vi64w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HMV93gN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E52606A32A;
	Wed, 18 Nov 2026 20:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HMV93gN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C915F1F000C4;
	Wed, 18 Nov 2026 20:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034617;
	bh=bOqegnx/bbD237Xy32ClMAjCA840d5u6rjMDWmDM9+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HMV93gNPrIany1qIJWjWQpYTXXrMsj3QIfQ3jvnaxwXn6cBOMDFyHxg5CdFT35Wi
	 +XL5T9P7C7vBj8KOvYy4k1vRaSWfW2eIYoTjVQrEbBtOX8BsbR/sW+yZ3kot55PG4r
	 3LvEGzKK1MsTiPL2dmOpawp7bz41B3vfChOJNIhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0384/3318] PCI/AER: Emit TLP Log only for unmasked errors
Date: Wed, 18 Nov 2026 15:16:46 +0100
Message-ID: <20261118150327.801796180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Open-coded the & ~mask change into the existing status & AER_LOG_TLP_MASKS checks in two places, since the tlp_header_logged() helper doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index f40a6f4c79a58..628ca8a597061 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -785,7 +785,7 @@ void cper_print_aer(struct pci_dev *dev, int aer_severity,
 	} else {
 		status = aer->uncor_status;
 		mask = aer->uncor_mask;
-		tlp_header_valid = status & AER_LOG_TLP_MASKS;
+		tlp_header_valid = (status & ~mask) & AER_LOG_TLP_MASKS;
 	}
 
 	layer = AER_GET_LAYER_ERROR(aer_severity, status);
@@ -1107,7 +1107,7 @@ int aer_get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
 		pci_read_config_dword(dev, aer + PCI_ERR_CAP, &temp);
 		info->first_error = PCI_ERR_CAP_FEP(temp);
 
-		if (info->status & AER_LOG_TLP_MASKS) {
+		if ((info->status & ~info->mask) & AER_LOG_TLP_MASKS) {
 			info->tlp_header_valid = 1;
 			pci_read_config_dword(dev,
 				aer + PCI_ERR_HEADER_LOG, &info->tlp.dw0);
-- 
2.53.0



