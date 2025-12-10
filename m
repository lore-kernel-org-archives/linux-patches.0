Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5D62E92B4;
	Wed, 10 Dec 2025 07:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351988; cv=none; b=Qq7tnlvneCuIGwdViA1kfA7ZGISDdoGQDNGGLTiVeOrJoUzB7vH1NjY/ta4sLPiTJVIhUj4ukfxX2P+KPYPaorPHCcrctp3rgP4HRYQOyn7bT8p9im97PqJSQHLx5s8Uu0mmp+iCnXNbu5pgUXiToNPjpvLOa204IZpgX+e60Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351988; c=relaxed/simple;
	bh=gxCp+4CpytovFnZdVjaOBXajUayOw+EyyDNFTVcUzOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TB5MZEWA4KFmJedaDUZfxf4cd3y9LosJ08Pas5fVSR2wsjFp2DPIFJ9HJEJZLqvHH8ieC1O7/MoOcARJLbmmtl+Fu0HA8Qbn2C5yXQ33Syyp9LHZjc1TcaXcRIhPsuhSf3YGBc/uJtRdDc8M/OPaOoFF3khc7po1MBEUE/4Adt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUJXCUbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUJXCUbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699A2C4CEF1;
	Wed, 10 Dec 2025 07:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351987;
	bh=gxCp+4CpytovFnZdVjaOBXajUayOw+EyyDNFTVcUzOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUJXCUbTc2kEuCRII74gAEJ8LAqtSk9tMmKJxBYKG2PEXU8KEAOW0nUaLjURytZyq
	 wM8lSSgco2tCl5cLQ8f/klnd+nNH92n4r4fTfBhNlSFqpAVTfNq92aaPR2kj1aGTmL
	 C1JHi9reQ9EjpCndYBAxX3RCGjsjkp+WZW66LYyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 6.12 49/49] bus: mhi: host: pci_generic: Add Telit FN990B40 modem support
Date: Wed, 10 Dec 2025 16:30:19 +0900
Message-ID: <20251210072949.384118829@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

commit 00559ba3ae740e7544b48fb509b2b97f56615892 upstream.

Add SDX72 based modem Telit FN990B40, reusing FN920C04 configuration.

01:00.0 Unassigned class [ff00]: Qualcomm Device 0309
        Subsystem: Device 1c5d:201a

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
[mani: added sdx72 in the comment to identify the chipset]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250716091836.999364-1-dnlplm@gmail.com
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -734,6 +734,16 @@ static const struct mhi_pci_dev_info mhi
 	.edl_trigger = true,
 };
 
+static const struct mhi_pci_dev_info mhi_telit_fn990b40_info = {
+	.name = "telit-fn990b40",
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
@@ -779,6 +789,9 @@ static const struct pci_device_id mhi_pc
 		.driver_data = (kernel_ulong_t) &mhi_telit_fe990a_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0308),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx65_info },
+	/* Telit FN990B40 (sdx72) */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0309, 0x1c5d, 0x201a),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn990b40_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0309),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx75_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QUECTEL, 0x1001), /* EM120R-GL (sdx24) */


