Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020789;
	b=VGm9PAZXYHL48LawRGATXP2gWslyZWeJBKimTvmZK0rj6Gb/wIPjzbdP4+vpETJtfirN
	 PsrPSyoz+Glsz0cG/2CTjX22OkZ7PIV0+32jJGTebRWDN5dc5f+tphUPb8g9RbGzK+MMn
	 Tz0nLN4P8AXYT6U/ruE9qCBn0uA4owTOIyClg5D2GaqunoQZnfE2WLDRudPVQ3SjOX53Z
	 VTCM1KvKtQ3cKGU79T0lFLcYUmsfD2Dbv1T0av6Y/dIoRuQdHNHF3cOuQjM5u/Jj65S54
	 IY/3GCexkaih6XLy/FaYLVApAvKn39F5bgS+4aRit1VyQBMK3NuaPNVnctTl//enirg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JMZfxiJP/FEw1YTidd0xYlzggqqeNHQkEKe/+WXgQ6s=;
	b=gndG7k/anMfJIXq932+i2fJX3dIM9FnmOOg+t7O+/DvoBWkJfbdtd+km+eCXAlOCi2zt
	 foDcLw4rGxc4P/csjRVUQHo/Kxtt5LzVfyxiC7bk/EYYhy3Ncofu2EesrxP25NbTl+lM5
	 J1nX0D+ny+MPu60Xq2v1HeIG5DQyIkLmAt1Z+Eqc777E6BqtSixD/LfpXbz1RrZBSe3nf
	 o5z7EC62aoH+emG9Y4q63KpGLs4Su5t6NQrX/K/SncuimZW8voHx18i+q/BNILjWT13N+
	 AVl7wQp8k0TXdu8ktV1aXa0FaiG62YC+cNxEP5oCnlcD+QNFMSaYrAXo4Xw+muuJleA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nPuhYVcE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66AB606B596;
	Wed, 18 Nov 2026 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nPuhYVcE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A251F000C4;
	Wed, 18 Nov 2026 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020789;
	bh=JMZfxiJP/FEw1YTidd0xYlzggqqeNHQkEKe/+WXgQ6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPuhYVcEfCDgLcslYMuuhDNawY4rPYn3bh3f5oW7duZD9srCCnOZdJQs1fkY/+QGs
	 RF4j4rp1kZFOOmL2HuImuqHo0feCFRs/zjBFDO6pPvcLuCwH1idz5kh6sfP0KACGih
	 V1PsOHPM7SPKaa831LZPUAMyilEu89k5x/SO5Y9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2077/2651] PCI: endpoint: pci-epf-vntb: Use a local epf pointer in interrupt setup
Date: Wed, 18 Nov 2026 15:55:17 +0100
Message-ID: <20261118150400.805304692@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 17c4115cbe99da4d147aee778c308da1d4bb000d ]

Use a local epf pointer in epf_ntb_configure_interrupt() to shorten the
repeated ntb->epf accesses.

No functional changes.

Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20261015014402.2976188-2-den@valinux.co.jp
Stable-dep-of: a5401ce3ab23 ("PCI: endpoint: pci-epf-vntb: Honor MSI-X selection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index bebdd93a067c0..61858e3739438 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -546,12 +546,14 @@ static int epf_ntb_config_spad_bar_alloc(struct epf_ntb *ntb)
 static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
 {
 	const struct pci_epc_features *epc_features;
+	struct pci_epf *epf = ntb->epf;
 	struct device *dev;
 	int ret;
 
-	dev = &ntb->epf->dev;
+	dev = &epf->dev;
 
-	epc_features = pci_epc_get_features(ntb->epf->epc, ntb->epf->func_no, ntb->epf->vfunc_no);
+	epc_features = pci_epc_get_features(epf->epc, epf->func_no,
+					    epf->vfunc_no);
 
 	if (!(epc_features->msix_capable || epc_features->msi_capable)) {
 		dev_err(dev, "MSI or MSI-X is required for doorbell\n");
@@ -565,10 +567,7 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
 	}
 
 	if (epc_features->msi_capable) {
-		ret = pci_epc_set_msi(ntb->epf->epc,
-				      ntb->epf->func_no,
-				      ntb->epf->vfunc_no,
-				      16);
+		ret = pci_epc_set_msi(epf->epc, epf->func_no, epf->vfunc_no, 16);
 		if (ret) {
 			dev_err(dev, "MSI configuration failed\n");
 			return ret;
-- 
2.53.0



