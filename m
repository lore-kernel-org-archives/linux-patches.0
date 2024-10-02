Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D0A1D0E12;
	Wed,  2 Oct 2024 14:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878776; cv=none; b=PrbO37+jFq/oj67mPPfJMdpr9QS6WcVODcY4WBwIivS5Ur8pcNiDSzcZyIiVt9BkInXu4w71lB2KbnFizkpArVXuoiH0NZFTbQt1m7Qhlh8Co38ta2CppPYrgvZ1RoaAgz5i3MABCjxlO7gvyZKpjXEiXcPiZHbEDPNJZUcVpWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878776; c=relaxed/simple;
	bh=N6xMzKRFu0R/p1kFjrE7/YI8Frp0zu9Kl3ztGKGPCSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMKyLFT9kKay+usZuw69bLfbn7VDN8xiHgLC+289QDrNEmsc9g/oRHfyAV37mHDpRigIjo71dYK3Re0isRNnyL+dYUvIxba11jIu8eDBQwyjcnL5/HThWMU/ovUqhnaEyxfPAipoRb0guL8v374h9BGkbwBXwxLRyw9Lcxf7CgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7cTc5pw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7cTc5pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA85C4CEC2;
	Wed,  2 Oct 2024 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878776;
	bh=N6xMzKRFu0R/p1kFjrE7/YI8Frp0zu9Kl3ztGKGPCSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7cTc5pw8nPn2OeLJahzhDYpkXcXdtoD5/rqA+KWOVAAdTnf965XnEGRfLiTJCPfn
	 NoYN4H5QE+9/VGPyTLQJAbJicLkllGa6LJu7K7zSZpVhfS2LXCBXmdJla++3kS0kVq
	 QIDd6bwJ2wxblJO4qMwKv22OiBBvKYiIzSajm45Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.10 528/634] bus: mhi: host: pci_generic: Fix the name for the Telit FE990A
Date: Wed,  2 Oct 2024 15:00:28 +0200
Message-ID: <20241002125831.945783704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit bfc5ca0fd1ea7aceae0b682fa4bd8079c52f96c8 upstream.

Add a mhi_pci_dev_info struct specific for the Telit FE990A modem in
order to use the correct product name.

Cc: stable@vger.kernel.org # 6.1+
Fixes: 0724869ede9c ("bus: mhi: host: pci_generic: add support for Telit FE990 modem")
Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240820080439.837666-1-fabio.porcedda@gmail.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -606,6 +606,15 @@ static const struct mhi_pci_dev_info mhi
 	.mru_default = 32768,
 };
 
+static const struct mhi_pci_dev_info mhi_telit_fe990a_info = {
+	.name = "telit-fe990a",
+	.config = &modem_telit_fn990_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.sideband_wake = false,
+	.mru_default = 32768,
+};
+
 /* Keep the list sorted based on the PID. New VID should be added as the last entry */
 static const struct pci_device_id mhi_pci_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
@@ -623,9 +632,9 @@ static const struct pci_device_id mhi_pc
 	/* Telit FN990 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2010),
 		.driver_data = (kernel_ulong_t) &mhi_telit_fn990_info },
-	/* Telit FE990 */
+	/* Telit FE990A */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2015),
-		.driver_data = (kernel_ulong_t) &mhi_telit_fn990_info },
+		.driver_data = (kernel_ulong_t) &mhi_telit_fe990a_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0308),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx65_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0309),


