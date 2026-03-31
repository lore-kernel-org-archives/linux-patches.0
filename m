Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1581C402BA9;
	Tue, 31 Mar 2026 16:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974763; cv=none; b=AMZBYnZoPQYszPRi2QeZx/HkM1eXkdKmVBynOC3Okg/2Xstg62mm7weDViEAgPUmnZKJ7C3z2HmoMl4ylXo2AnPYSa69Q3bCZUmnSxDxgQExKKr90NL6aSX3BS/9WNY310j8FTjkQQPKDigJLpHw+bxSrBP9uOVE5XITENkODS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974763; c=relaxed/simple;
	bh=d0HFUCsBnbELIw/X5dRiDdQ8PIqJk5K45OS2CFTBQmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKWFzBGAToYK9CGrVY3zm4D7hFYjKpJNles+TrbaYh+yQ1s9cSURBlEfP0mSbQB6TmL/X8FIiENjM5/MU8pKD2T8zBUJ1R8TPVzl7WZEIJITAtXjj5GjrdicUvT3WtaX2uq1JdJOCrzy2/4NqZb7Qija3ytBZEmns3PhH929v/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GND/kr+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GND/kr+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EDEC19423;
	Tue, 31 Mar 2026 16:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974763;
	bh=d0HFUCsBnbELIw/X5dRiDdQ8PIqJk5K45OS2CFTBQmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GND/kr+lWZ48NwmNbokHRnjNziOmHvFs0dL/U3WgSdROpuz/HtTxOBogswUt2fDml
	 AXqLgA5pGnheZ+7Sxy4meypeo6jFCxkcCrsv9jDy/d15jj9u6F4zj8kjX0s+2SicMn
	 HqoR4zdV2qCVkfPnl3BEljpQeSwZLBELiMUesJFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 035/342] HID: intel-ish-hid: ipc: Add Nova Lake-H/S PCI device IDs
Date: Tue, 31 Mar 2026 18:17:48 +0200
Message-ID: <20260331161800.198338022@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 22f8bcec5aeb05104b3eaa950cb5a345e95f0aa8 ]

Add device IDs of Nova Lake-H and Nova Lake-S into ishtp support list.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/hw-ish.h  |  2 ++
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/hw-ish.h b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
index fa5d68c363134..27389971b96cc 100644
--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -39,6 +39,8 @@
 #define PCI_DEVICE_ID_INTEL_ISH_PTL_H		0xE345
 #define PCI_DEVICE_ID_INTEL_ISH_PTL_P		0xE445
 #define PCI_DEVICE_ID_INTEL_ISH_WCL		0x4D45
+#define PCI_DEVICE_ID_INTEL_ISH_NVL_H		0xD354
+#define PCI_DEVICE_ID_INTEL_ISH_NVL_S		0x6E78
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 1612e8cb23f0c..ed3405c05e73c 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -28,11 +28,15 @@ enum ishtp_driver_data_index {
 	ISHTP_DRIVER_DATA_LNL_M,
 	ISHTP_DRIVER_DATA_PTL,
 	ISHTP_DRIVER_DATA_WCL,
+	ISHTP_DRIVER_DATA_NVL_H,
+	ISHTP_DRIVER_DATA_NVL_S,
 };
 
 #define ISH_FW_GEN_LNL_M "lnlm"
 #define ISH_FW_GEN_PTL "ptl"
 #define ISH_FW_GEN_WCL "wcl"
+#define ISH_FW_GEN_NVL_H "nvlh"
+#define ISH_FW_GEN_NVL_S "nvls"
 
 #define ISH_FIRMWARE_PATH(gen) "intel/ish/ish_" gen ".bin"
 #define ISH_FIRMWARE_PATH_ALL "intel/ish/ish_*.bin"
@@ -47,6 +51,12 @@ static struct ishtp_driver_data ishtp_driver_data[] = {
 	[ISHTP_DRIVER_DATA_WCL] = {
 		.fw_generation = ISH_FW_GEN_WCL,
 	},
+	[ISHTP_DRIVER_DATA_NVL_H] = {
+		.fw_generation = ISH_FW_GEN_NVL_H,
+	},
+	[ISHTP_DRIVER_DATA_NVL_S] = {
+		.fw_generation = ISH_FW_GEN_NVL_S,
+	},
 };
 
 static const struct pci_device_id ish_pci_tbl[] = {
@@ -76,6 +86,8 @@ static const struct pci_device_id ish_pci_tbl[] = {
 	{PCI_DEVICE_DATA(INTEL, ISH_PTL_H, ISHTP_DRIVER_DATA_PTL)},
 	{PCI_DEVICE_DATA(INTEL, ISH_PTL_P, ISHTP_DRIVER_DATA_PTL)},
 	{PCI_DEVICE_DATA(INTEL, ISH_WCL, ISHTP_DRIVER_DATA_WCL)},
+	{PCI_DEVICE_DATA(INTEL, ISH_NVL_H, ISHTP_DRIVER_DATA_NVL_H)},
+	{PCI_DEVICE_DATA(INTEL, ISH_NVL_S, ISHTP_DRIVER_DATA_NVL_S)},
 	{}
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);
-- 
2.51.0



