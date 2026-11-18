Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021306;
	b=id09VoJqiXWk9i4XrnqwuPuOvORCXQ+72LKoLdqdhSY90f/H6IlZ7rEisRbFspfmabhz
	 vH5+mD50yhirXjRmfXQgjmmPS5SwdhdgnV3SyOTPwMowwv4P9zkrCdykIZiiCTVL5gJ4m
	 OUssraGXe0RoBw5McfJHkynBYNdKDlhPmLnmTQEu7kndYo1geLKDMWw3NV5i+GtOT1h2m
	 P2TjXKpZ4dV3hfG/ttThsTHBY9AGrPF2+y0da3BNjld/8RiTKH9TYENM22OxrHCTLw/7Q
	 4hgfaeoete+6jD1tIAR2tnDaJSlzvdD3bJEArC2sVruhKNngh/BPXWWSj9EmoDPVEgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/+f0uQ3jq0CZHRXvvijw1z0S3A1gawmqUuY4yUouYuQ=;
	b=zufv/bk96+iKG9w2QKs0LLRGgAUB8j16Har4r4Abu8K2awMh5Us4Cg3ljheg+vXL5hWR
	 wZP+BleiSTRJKhtBJozDdXFGilzbrzkKeC0GCUpF/X7U9ap1r9b/6ndvR82jY5NARABZ8
	 IcqwizYi9Ec6iSJk8Vqfu08OXFEndEZtITI2R5EPvB18HsLwOxnxyGE2wWWCYI/mXHeup
	 Y9Y1D5A3ERpszVIyFpoAEE2lzjzMoyyMlWWQ7PKlK6dNGWm5P2S/+ifVBJvgynhG7hhix
	 EZ8rSr2XEpR+dyw4LII/8UM/9fo+bCVhUbBitD1WKP3cVDRs8TTsKqLwDiad7jijxjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWmDxj2Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E13606A330;
	Wed, 18 Nov 2026 17:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWmDxj2Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9418F1F000C4;
	Wed, 18 Nov 2026 17:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021306;
	bh=/+f0uQ3jq0CZHRXvvijw1z0S3A1gawmqUuY4yUouYuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWmDxj2Z2Z8ZKFAGaymCSTX4prFkir7V+bBm8Atqjn2gaUnE6njRdjOzxEINDExTX
	 oKoZEr60AOHxHEoH86SfBmOiPolYRTNfdnZU9HgLBI6nQKa9Idxl7WhN1tQc/mqtCL
	 BGIOBd2/F7aggUiUNssWuaPLsKhSF1HnDF/dHrOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2259/2651] PCI: qcom: Ignore -ENODEV after Root Port reset
Date: Wed, 18 Nov 2026 15:58:19 +0100
Message-ID: <20261118150406.736646116@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit bea2ff3b9de1e32716bc517082b7e3c7330e2151 ]

Root Port recovery may race with a device hot-unplug. In that case,
dw_pcie_wait_for_link() returns -ENODEV because no device is detected
after the controller has been successfully reset.

This is a valid outcome and should not cause Root Port recovery to
fail. Ignore -ENODEV while continuing to propagate other link-training
errors.

Fixes: 4d88cb82a6d9 ("PCI: qcom: Implement .reset_root_port() and use for link down")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-topic-pcie_portrec_enodev-v1-1-5dc7bde39552@oss.qualcomm.com
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 95db0f866909f..13c172bf4933c 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1859,6 +1859,9 @@ static int qcom_pcie_reset_root_port(struct pci_host_bridge *bridge,
 	qcom_pcie_start_link(pci);
 
 	ret = dw_pcie_wait_for_link(pci);
+	/* This linkdown might have been a hot-unplug */
+	if (ret == -ENODEV)
+		ret = 0;
 	if (ret)
 		return ret;
 
-- 
2.53.0



