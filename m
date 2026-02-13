Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD99352936;
	Fri, 13 Feb 2026 13:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990933; cv=none; b=r0i7ZKKksv4dEaFbJFAn1kDlyEgXOF0DkLUk1/8+FmM0iV5nwdB1wAifQ7YLetu/rdqLOpumwi6y3yha1bVQ4A9UzJYv46WkLPvybi0eZVVZfhScMvFkyAhaWGLcFe3wa0or/mTaJOeASBms29nUK3W0J+/BuuOlS69S1dFV4qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990933; c=relaxed/simple;
	bh=FFNQTOGxNEoQaVRZlE9ICXxdF+o+NjMWjHJlVMK7G7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pa1ifxVuuryLd/YYa8+FBJUMIKR8AzTwWGu+CsW2Rgp36Tq99he0e+bKPBprsw4uWhhXQubBasimA4LsT1Iv2RxLQiqR1+GJ+0RFVlYgkpj64EJcrBpduGmwybjOZIc49LBVfyghce5DeilJ8/lWAsl96nfKJmhNcFCr7IWhO5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HU393L0X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HU393L0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3A0C116C6;
	Fri, 13 Feb 2026 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990933;
	bh=FFNQTOGxNEoQaVRZlE9ICXxdF+o+NjMWjHJlVMK7G7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HU393L0XAqYzkjmCspbEy0Fywp6igkWbYbMgkOuD64/qdzvrcoZFoqdTNSjmkuq0f
	 7UgTQv4S0NroEut5DfzCfqZ+2+qAjVb5OXrnwquuT7xkb2frN+90q5VZG3FttVExzS
	 MzH1YHuPnuTAL7krfCfO2Ikovk8rDZPW9aloyOF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: [PATCH 6.12 18/24] bus: mhi: host: pci_generic: Add Telit FE990B40 modem support
Date: Fri, 13 Feb 2026 14:48:37 +0100
Message-ID: <20260213134705.390435841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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
@@ -744,6 +744,16 @@ static const struct mhi_pci_dev_info mhi
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
@@ -792,6 +802,9 @@ static const struct pci_device_id mhi_pc
 	/* Telit FN990B40 (sdx72) */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0309, 0x1c5d, 0x201a),
 		.driver_data = (kernel_ulong_t) &mhi_telit_fn990b40_info },
+	/* Telit FE990B40 (sdx72) */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0309, 0x1c5d, 0x2025),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fe990b40_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0309),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx75_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QUECTEL, 0x1001), /* EM120R-GL (sdx24) */


