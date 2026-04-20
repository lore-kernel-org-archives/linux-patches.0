Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA21EB5CE;
	Mon, 20 Apr 2026 15:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700728; cv=none; b=gUZUBR6M6WydJ1BvxbUNUgYy3KyU53t/cmFGcNM5uBIHLVn9UrZqrGCF6EApgsLhV5uu53BNRH0LhTztjaLXwedj0Tn9JiJmHmIMlIcmBrFlBmITOqlNQ09+T+9qqPUbTRDhWWZJceP2UAOoCR70plcMqJaZ/r7d1yP34q0D3WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700728; c=relaxed/simple;
	bh=L9Zi6pnOVJwQVEM0/0oFHDRCh/EsqFWPHGUXqkNFDWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu8K9rkgFDlUQX9vfeFt72/k3q/FLW5ZoGCCZHNRWDqeMA7vxQrUk7bhMiddcdsnMUXgWbCVqtGn12qR4jPiaItLbH/JPBB4gxsKRxk+s/w2qo690mSa/4ENQ7YFiKwoyFALepddEBs7OMLOo8JzlNKV53di572OmneuAhthOYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txbuPOB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txbuPOB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DA9C19425;
	Mon, 20 Apr 2026 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700728;
	bh=L9Zi6pnOVJwQVEM0/0oFHDRCh/EsqFWPHGUXqkNFDWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txbuPOB9BW83l9q3WNcsGkl0a4MJ4XhssNLeFXgJwib8+dHrUVXUmESTtlkPoJB4V
	 0MeqZ94GF62PjfbtaMqW/S5DRgnTfP45LjgG15pQEG2WG0s8+fLGUpZRCBDrcxhpjy
	 LyNjjh3387KX5UoqMasmh7JtTjE8ttv1VdKcVC2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/198] HID: Intel-thc-hid: Intel-quickspi: Add NVL Device IDs
Date: Mon, 20 Apr 2026 17:40:16 +0200
Message-ID: <20260420153936.953846736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Even Xu <even.xu@intel.com>

[ Upstream commit 48e91af0cbe942d50ef6257d850accdca1d01378 ]

Add Nova Lake THC QuickSPI device IDs to support list.

Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c | 6 ++++++
 drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
index 14cabd5dc6ddb..f0830a56d556b 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/pci-quickspi.c
@@ -37,6 +37,10 @@ struct quickspi_driver_data arl = {
 	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_MTL,
 };
 
+struct quickspi_driver_data nvl = {
+	.max_packet_size_value = MAX_PACKET_SIZE_VALUE_LNL,
+};
+
 /* THC QuickSPI ACPI method to get device properties */
 /* HIDSPI Method: {6e2ac436-0fcf-41af-a265-b32a220dcfab} */
 static guid_t hidspi_guid =
@@ -984,6 +988,8 @@ static const struct pci_device_id quickspi_pci_tbl[] = {
 	{PCI_DEVICE_DATA(INTEL, THC_WCL_DEVICE_ID_SPI_PORT2, &ptl), },
 	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT1, &arl), },
 	{PCI_DEVICE_DATA(INTEL, THC_ARL_DEVICE_ID_SPI_PORT2, &arl), },
+	{PCI_DEVICE_DATA(INTEL, THC_NVL_H_DEVICE_ID_SPI_PORT1, &nvl), },
+	{PCI_DEVICE_DATA(INTEL, THC_NVL_H_DEVICE_ID_SPI_PORT2, &nvl), },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, quickspi_pci_tbl);
diff --git a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
index c30e1a42eb098..bf5e18f5a5f42 100644
--- a/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quickspi/quickspi-dev.h
@@ -23,6 +23,8 @@
 #define PCI_DEVICE_ID_INTEL_THC_WCL_DEVICE_ID_SPI_PORT2 	0x4D4B
 #define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT1 	0x7749
 #define PCI_DEVICE_ID_INTEL_THC_ARL_DEVICE_ID_SPI_PORT2 	0x774B
+#define PCI_DEVICE_ID_INTEL_THC_NVL_H_DEVICE_ID_SPI_PORT1	0xD349
+#define PCI_DEVICE_ID_INTEL_THC_NVL_H_DEVICE_ID_SPI_PORT2	0xD34B
 
 /* HIDSPI special ACPI parameters DSM methods */
 #define ACPI_QUICKSPI_REVISION_NUM			2
-- 
2.53.0



