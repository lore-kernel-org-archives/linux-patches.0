Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8D35CB6B;
	Mon,  9 Feb 2026 14:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647232; cv=none; b=Js9TPWgs7E+r56VBBnVYygmUCQaikRLrxiEO75+Ifg2UGPov8VKfI/Blxc7uMOFov0Dhx2pZvkATnQMfMJrnK7UhNsQKpgNQhaD4M650va0LgzLAKBURXUPeUxE6xmAYNEV7BLcVMsSOkO5wjw2ZzMg2THTZHCrIqjObzU5RHZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647232; c=relaxed/simple;
	bh=Lzg6CkP7WD0wqi7d7vOrSXjcHB92uGLHwqS1/3vRXKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB3ZgBHP2JC6RWThM3gjLSvX+dLTJQll9Wp7hJnBiPIxetRQkMobqFKbNHmBXOwoZKHARQr0eMVMLOWAd//Kn05IgOTOHnpHy0rgnc2HFlbv4bBLPxeO5SAVAYYMumHjIWidvilAPVey1HMMqhDA0wLW1olHouXsMgdqwq7zgwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1DxYEbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1DxYEbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0666CC116C6;
	Mon,  9 Feb 2026 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647232;
	bh=Lzg6CkP7WD0wqi7d7vOrSXjcHB92uGLHwqS1/3vRXKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1DxYEbYA2nDgtJ4B47UPAmddinNMU7GjPzLkepaTxakMTbZgnai8Wn+z5Xs9zTQk
	 b+Cm+UF7AnIhKZx/dKLJSBZH1NIi9AMbmxBqybtWNCeW0S6KKcqVTTy7Bpz+aFtLgu
	 zNmXOy2nIV6nNVXDPS0YrHEpig/QmxW4BnKaJ/0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 6.18 038/175] bus: mhi: host: pci_generic: Add Telit FE990B40 modem support
Date: Mon,  9 Feb 2026 15:21:51 +0100
Message-ID: <20260209142321.845732383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 6eaee77923ddf04beedb832c06f983679586361c upstream.

Add SDX72 based modem Telit FE990B40, reusing FN920C04 configuration.

01:00.0 Unassigned class [ff00]: Qualcomm Device 0309
        Subsystem: Device 1c5d:2025

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20251015102059.1781001-1-dnlplm@gmail.com
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -877,6 +877,16 @@ static const struct mhi_pci_dev_info mhi
 	.edl_trigger = true,
 };
 
+static const struct mhi_pci_dev_info mhi_telit_fe990b40_info = {
+	.name = "telit-fe990b40",
+	.config = &modem_telit_fn920c04_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.sideband_wake = false,
+	.mru_default = 32768,
+	.edl_trigger = true,
+};
+
 static const struct mhi_pci_dev_info mhi_netprisma_lcur57_info = {
 	.name = "netprisma-lcur57",
 	.edl = "qcom/prog_firehose_sdx24.mbn",
@@ -933,6 +943,9 @@ static const struct pci_device_id mhi_pc
 	/* Telit FN990B40 (sdx72) */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0309, 0x1c5d, 0x201a),
 		.driver_data = (kernel_ulong_t) &mhi_telit_fn990b40_info },
+	/* Telit FE990B40 (sdx72) */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0309, 0x1c5d, 0x2025),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fe990b40_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0309),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx75_info },
 	/* QDU100, x100-DU */


