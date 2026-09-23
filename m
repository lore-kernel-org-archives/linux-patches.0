Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F3E448D11;
	Wed, 23 Sep 2026 14:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174622; cv=none; b=dtLl8LvH4Q4gYoNLNG4pMc5Cj9H9h8x8B665fO/O2aqwc/XWQOzTF457uxBtdlrgXcEm/ewIZBBmDQh3mgb0cKf1xxkASn6FHWakRq9Fw2bse0U2ODzFpcNMKUZc6nRJgExFOVEYmf6uOTmia+Ufk/X5sIIC1BXggq8tJo4PrGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174622; c=relaxed/simple;
	bh=KvJrE/WpHy5MNMAEKoSdID+XwdrIZxwBX7IHpQ7GJsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/f8YqlUvD+ljG5pxLU3j+6Uo8y6SWhkAENEcOgMkgjGAwTGqYrLmmpWaQmFl4DWAXIsgnw/2fyGvk2h/3V2FNR9mYE+mGg4iv/23kC2OpIjirFi7kNc9Y+C5Cg1JhE33cZQY6LaKN0CXY379P0CnfaWJiyO+pJC3oQ+SsudjDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUFszBbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUFszBbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9501F000FF;
	Wed, 23 Sep 2026 14:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174620;
	bh=zULC4U/p2uFz+cBGSs7m9ss9x5pPP8xZXPPNgRuO1N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUFszBbEt2rCD3WHyiMxKzbEv0Zhp8WCo7F5zv6qyuQWtiR7f19C3mVaGG3it4TjX
	 D2C3YCp6SfdQhZ1bSMSvZa62FBMb7kN7j/bi2qSlUX5YBH9ngDG1k/a/FA4kQkjeWf
	 HyR7W7/Mi6R6Jb4Zy1j5TGiJlzS8JInbU4suWrtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mengshi Wu <mengshi.wu@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/398] Bluetooth: hci_qca: Refactor HFP hardware offload capability handling
Date: Wed, 23 Sep 2026 16:03:38 +0200
Message-ID: <20260923140647.164898936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Mengshi Wu <mengshi.wu@oss.qualcomm.com>

[ Upstream commit 22d893eec0d52fa97d25d3de248285648f26ef68 ]

Replace SoC-specific check with capability-based approach for HFP
hardware offload configuration. Add QCA_CAP_HFP_HW_OFFLOAD capability
flag and support_hfp_hw_offload field to qca_serdev structure. Add
QCA_CAP_HFP_HW_OFFLOAD capability flag to QCA2066 device data
structures.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Mengshi Wu <mengshi.wu@oss.qualcomm.com>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 4e93c65f8782 ("Bluetooth: hci_qca: Do not write to the serial port after it is closed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index b510b03dae870..5c03f8f3a53ab 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -86,6 +86,7 @@ enum qca_flags {
 enum qca_capabilities {
 	QCA_CAP_WIDEBAND_SPEECH = BIT(0),
 	QCA_CAP_VALID_LE_STATES = BIT(1),
+	QCA_CAP_HFP_HW_OFFLOAD  = BIT(2),
 };
 
 /* HCI_IBS transmit side sleep protocol states */
@@ -228,6 +229,7 @@ struct qca_serdev {
 	u32 init_speed;
 	u32 oper_speed;
 	bool bdaddr_property_broken;
+	bool support_hfp_hw_offload;
 	const char *firmware_name[2];
 };
 
@@ -1915,7 +1917,7 @@ static int qca_setup(struct hci_uart *hu)
 	const char *rampatch_name = qca_get_rampatch_name(hu);
 	int ret;
 	struct qca_btsoc_version ver;
-	struct qca_serdev *qcadev;
+	struct qca_serdev *qcadev = serdev_device_get_drvdata(hu->serdev);
 	const char *soc_name;
 
 	ret = qca_check_speeds(hu);
@@ -1979,7 +1981,6 @@ static int qca_setup(struct hci_uart *hu)
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
-		qcadev = serdev_device_get_drvdata(hu->serdev);
 		if (qcadev->bdaddr_property_broken)
 			hci_set_quirk(hdev, HCI_QUIRK_BDADDR_PROPERTY_BROKEN);
 
@@ -2073,7 +2074,7 @@ static int qca_setup(struct hci_uart *hu)
 	else
 		hu->hdev->set_bdaddr = qca_set_bdaddr;
 
-	if (soc_type == QCA_QCA2066)
+	if (qcadev->support_hfp_hw_offload)
 		qca_configure_hfp_offload(hdev);
 
 	qca->fw_version = le16_to_cpu(ver.patch_ver);
@@ -2157,7 +2158,8 @@ static const struct qca_device_data qca_soc_data_wcn3998 __maybe_unused = {
 static const struct qca_device_data qca_soc_data_qca2066 __maybe_unused = {
 	.soc_type = QCA_QCA2066,
 	.num_vregs = 0,
-	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
+	.capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES |
+			QCA_CAP_HFP_HW_OFFLOAD,
 };
 
 static const struct qca_device_data qca_soc_data_qca6390 __maybe_unused = {
@@ -2542,6 +2544,9 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 
 		if (!(data->capabilities & QCA_CAP_VALID_LE_STATES))
 			hci_set_quirk(hdev, HCI_QUIRK_BROKEN_LE_STATES);
+
+		if (data->capabilities & QCA_CAP_HFP_HW_OFFLOAD)
+			qcadev->support_hfp_hw_offload = true;
 	}
 
 	return 0;
-- 
2.53.0



