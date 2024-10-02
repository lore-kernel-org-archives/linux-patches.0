Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07461D0E3E;
	Wed,  2 Oct 2024 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880477; cv=none; b=XTEW8eiWZgtaHZp3O07s4llW8+t/XuQoXmwyJTic90d6m+dc1BVPHeqGKhRJH3MoHxAxncx/2Fl0nZXCWlVwG95WLnzDZI/vFjryf3jdtKNdPH04r+U7RqZpuz9I2SHelhqVc2qaNNnPZlK3Vhgbv0JhjrGwf6wcylaa6vE/Zsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880477; c=relaxed/simple;
	bh=l1bk/kbAfOVAFw1kafaNYi7jGIBzVnci7QAXoabBCpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPjN4GkpeQiLxiqIufldHvexK5Bpr0WRUuoVCP+tO3tgQA+LM+/R2EroWgUSy7G2uhHPIKPr899GZdqOACmZgAOK9mzyiOISGkmdlVDPAG9CciN8TBaSfVakoWVT3SHi5fCgEXykWbwd5aSPpsSzRMQH+UlbHM0G3dtnU+PlM/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHl/NzUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHl/NzUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D40C4CECF;
	Wed,  2 Oct 2024 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880477;
	bh=l1bk/kbAfOVAFw1kafaNYi7jGIBzVnci7QAXoabBCpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHl/NzUM4YrAk10tYPOBtkDRCAC75tN7jNRGevozSnq6kGkM8hMammFHYH3+nPvV+
	 E3xNszlEjRadHk6aMZ9nKT3Ha023CYJ1qSrMhnq7HYFU5xcMexU42FSmotZ+UvMto5
	 lIm9ZHjW4ndHpDlK2F+STnJRaBz5R+fZxSpc/ong=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.6 440/538] bus: mhi: host: pci_generic: Fix the name for the Telit FE990A
Date: Wed,  2 Oct 2024 15:01:19 +0200
Message-ID: <20241002125809.807370519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -578,6 +578,15 @@ static const struct mhi_pci_dev_info mhi
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
@@ -595,9 +604,9 @@ static const struct pci_device_id mhi_pc
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
 	{ PCI_DEVICE(PCI_VENDOR_ID_QUECTEL, 0x1001), /* EM120R-GL (sdx24) */


