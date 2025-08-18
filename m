Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA21A335BC5;
	Mon, 18 Aug 2025 13:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525036; cv=none; b=PRow6fZLFVlVvTAhH0AOgsfJFrw98VBXEQXRhi3Kurrk8OGJgjLMjmPdNAV9XfyDHXRSSipI5rA/m5m5SfY52Lqot70uV5dPzrQZ7ySBw6PNXenBJuyJhENonuc9fbHfNwLaZnhlCsNfvDa3Kc7EetGfhzlHvYIYZ4IkhWWJPfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525036; c=relaxed/simple;
	bh=BViXiQMkTTLs4LRF2hqYlRdNd41MFZZ9bO/m+65bdII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twsOfszutaWbmFATjdm28rD9B4eLhwlHXd/fGoBjNVCMHjBIJYijb7PW9d5BMxCj2hycqEsn5OTb40+2V1b6yyK/hPSCjYHtWvIKehUaQwds98bXtvdOspzKMJbvq9TIQpJtDG/cp1Ns/nc9QPmdsrOrKXpk+8iQGibNwemd4uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uqw63zHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uqw63zHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E2BC4CEEB;
	Mon, 18 Aug 2025 13:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525035;
	bh=BViXiQMkTTLs4LRF2hqYlRdNd41MFZZ9bO/m+65bdII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uqw63zHS8fF/eMq2K7nyI449UAoVaH/all9Vt7w251xHignsGWyPLzNMN4jdca4pW
	 gtYbhaCN+s9ld5PB11tLGHsmB2cQWcG1kuFY3o4YfdRGjMKB5yRx7YcRctp16loK63
	 dS812HQzRP3Ryaxd8ruL0FtZZo/+boWXMcL34i3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Palmas <dnlplm@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 131/570] bus: mhi: host: pci_generic: Add Telit FN990B40 modem support
Date: Mon, 18 Aug 2025 14:41:58 +0200
Message-ID: <20250818124510.870698923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 00559ba3ae740e7544b48fb509b2b97f56615892 ]

Add SDX72 based modem Telit FN990B40, reusing FN920C04 configuration.

01:00.0 Unassigned class [ff00]: Qualcomm Device 0309
        Subsystem: Device 1c5d:201a

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
[mani: added sdx72 in the comment to identify the chipset]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250716091836.999364-1-dnlplm@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 92bd133e7c45..0d9295535bbf 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -818,6 +818,16 @@ static const struct mhi_pci_dev_info mhi_telit_fn920c04_info = {
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
@@ -865,6 +875,9 @@ static const struct pci_device_id mhi_pci_id_table[] = {
 		.driver_data = (kernel_ulong_t) &mhi_telit_fe990a_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0308),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx65_info },
+	/* Telit FN990B40 (sdx72) */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0309, 0x1c5d, 0x201a),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn990b40_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0309),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx75_info },
 	/* QDU100, x100-DU */
-- 
2.39.5



