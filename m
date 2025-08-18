Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319DE227BB5;
	Mon, 18 Aug 2025 13:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523376; cv=none; b=pGo3CjRA/0sxqlBOxdH+rk2Uktl/7ZRWP5FPUH9esLuCYGZ17SYmOqJWPkfRzL4chfi70hHtcLj26/MRSkAFEkDIA7Ou75UngZ4etNtJ/pzTMN3CgX0DFz4RwWn5WA8gybSdCexU9qJ6PZr1TfyMWJiMc60z1JbpDGYl7qggHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523376; c=relaxed/simple;
	bh=fbl6ErO+LWaf/t0ifKAXK++x9OwlawVGTlPjD+SITOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TleEmmuD+YZfKmq/sfFTU6M2rrL4WHC6jVpKsKaMVI5wkDI2P+0Wo/QKW6hg0CbOVhxN9RzsgYatM3nucqjHRLOgghZFaH0/5dHQ0caOl09x/eFsGgPKj6P2Xb7o+0AAAhfptoHNilIsVt6yRkvACXD+EnNDfQVJzzVOMvvZGkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6+EOsFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6+EOsFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95687C4CEEB;
	Mon, 18 Aug 2025 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523376;
	bh=fbl6ErO+LWaf/t0ifKAXK++x9OwlawVGTlPjD+SITOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6+EOsFtCXkRnva5a9ovGoZCXXpDErP8X6G7JNTq0zXUPVa7RATL3VzEXLjSx3MZY
	 cMz9/LngERjvL3P8W9f8i7SfB/yK8YZn8cpN5cMVftuAdkI9tYh18hGPthRX8ST65o
	 RoUOYaQdUu7xzEGEp7E54M/a20aaqopGxt7Dr1AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Pernamitta <quic_vpernami@quicinc.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 119/515] bus: mhi: host: pci_generic: Disable runtime PM for QDU100
Date: Mon, 18 Aug 2025 14:41:45 +0200
Message-ID: <20250818124502.930100112@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Pernamitta <quic_vpernami@quicinc.com>

[ Upstream commit 0494cf9793b7c250f63fdb2cb6b648473e9d4ae6 ]

The QDU100 device does not support the MHI M3 state, necessitating the
disabling of runtime PM for this device. It is essential to disable
runtime PM if the device does not support M3 state.

Signed-off-by: Vivek Pernamitta <quic_vpernami@quicinc.com>
[mani: Fixed the kdoc comment for no_m3]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Link: https://patch.msgid.link/20250425-vdev_next-20250411_pm_disable-v4-1-d4870a73ebf9@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index c8f82219006f..e5af0beed050 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -43,6 +43,7 @@
  * @mru_default: default MRU size for MBIM network packets
  * @sideband_wake: Devices using dedicated sideband GPIO for wakeup instead
  *		   of inband wake support (such as sdx24)
+ * @no_m3: M3 not supported
  */
 struct mhi_pci_dev_info {
 	const struct mhi_controller_config *config;
@@ -54,6 +55,7 @@ struct mhi_pci_dev_info {
 	unsigned int dma_data_width;
 	unsigned int mru_default;
 	bool sideband_wake;
+	bool no_m3;
 };
 
 #define MHI_CHANNEL_CONFIG_UL(ch_num, ch_name, el_count, ev_ring) \
@@ -295,6 +297,7 @@ static const struct mhi_pci_dev_info mhi_qcom_qdu100_info = {
 	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
 	.dma_data_width = 32,
 	.sideband_wake = false,
+	.no_m3 = true,
 };
 
 static const struct mhi_channel_config mhi_qcom_sa8775p_channels[] = {
@@ -1322,8 +1325,8 @@ static int mhi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* start health check */
 	mod_timer(&mhi_pdev->health_check_timer, jiffies + HEALTH_CHECK_PERIOD);
 
-	/* Only allow runtime-suspend if PME capable (for wakeup) */
-	if (pci_pme_capable(pdev, PCI_D3hot)) {
+	/* Allow runtime suspend only if both PME from D3Hot and M3 are supported */
+	if (pci_pme_capable(pdev, PCI_D3hot) && !(info->no_m3)) {
 		pm_runtime_set_autosuspend_delay(&pdev->dev, 2000);
 		pm_runtime_use_autosuspend(&pdev->dev);
 		pm_runtime_mark_last_busy(&pdev->dev);
-- 
2.39.5



