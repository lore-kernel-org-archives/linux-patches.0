Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C571919DF99;
	Wed, 19 Mar 2025 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394881; cv=none; b=slvt3wJtUMseQMHevqkDs6H9hhAYQUmoLGpugftTq7Dd6ytJdkdnNIqZPm5qGtenFR+TXAPIFptlkIvENMuMdWa2RRges9/Bzyur5uPizawz8InGgsvCM3XVVAiXrA8IW3QTdcB5OB9ZFQunva0iTn5sb9y7M68aPnpjj4JuXHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394881; c=relaxed/simple;
	bh=ZNIwamaDOE0fb3U5JxZMLACHyePNgZQC3e1uaf3LY9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogWbgHp+rNq/Ct0R8vj5a/QdS4u4zT1B74Bd+4x3enkx4o5h+r4xAM+Z0RFMkio9uhSZbcnN5mi0eetdlX9P8oipAUmmp84P4jSG1e17+0Gd5vNiKNHmsX3aVlb07xvrLmMNpX8Qhvt+m4MfhugmfHGqMVkxJJMJkRYsnd8VEyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+um65Kp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+um65Kp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C8CC4CEE8;
	Wed, 19 Mar 2025 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394881;
	bh=ZNIwamaDOE0fb3U5JxZMLACHyePNgZQC3e1uaf3LY9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+um65KpIFAwV12jZA/RLNLE/qrZTEus97P6je2Q3p7SdPt4UaVxjwR0u9PNf4fBz
	 Zav+UJhnN64L0WPS7HFdsc+UydguNCHrgD18f05p9/sOXo2lUFAPe409SVedF3Orfv
	 2Vvs7ToxF8KCkAYStNlhgaMQPFkjg/tlFVIYApYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 082/241] HID: intel-ish-hid: ipc: Add Panther Lake PCI device IDs
Date: Wed, 19 Mar 2025 07:29:12 -0700
Message-ID: <20250319143029.760041022@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 18c966b62819b9d3b99eac8fb8cdc8950826e0c2 ]

Add device IDs of Panther Lake-H and Panther Lake-P into ishtp support
list.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ipc/hw-ish.h  | 2 ++
 drivers/hid/intel-ish-hid/ipc/pci-ish.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ipc/hw-ish.h b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
index cdd80c653918b..07e90d51f073c 100644
--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -36,6 +36,8 @@
 #define PCI_DEVICE_ID_INTEL_ISH_ARL_H		0x7745
 #define PCI_DEVICE_ID_INTEL_ISH_ARL_S		0x7F78
 #define PCI_DEVICE_ID_INTEL_ISH_LNL_M		0xA845
+#define PCI_DEVICE_ID_INTEL_ISH_PTL_H		0xE345
+#define PCI_DEVICE_ID_INTEL_ISH_PTL_P		0xE445
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
diff --git a/drivers/hid/intel-ish-hid/ipc/pci-ish.c b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
index 9e2401291a2f6..ff0fc80100728 100644
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -26,9 +26,11 @@
 enum ishtp_driver_data_index {
 	ISHTP_DRIVER_DATA_NONE,
 	ISHTP_DRIVER_DATA_LNL_M,
+	ISHTP_DRIVER_DATA_PTL,
 };
 
 #define ISH_FW_GEN_LNL_M "lnlm"
+#define ISH_FW_GEN_PTL "ptl"
 
 #define ISH_FIRMWARE_PATH(gen) "intel/ish/ish_" gen ".bin"
 #define ISH_FIRMWARE_PATH_ALL "intel/ish/ish_*.bin"
@@ -37,6 +39,9 @@ static struct ishtp_driver_data ishtp_driver_data[] = {
 	[ISHTP_DRIVER_DATA_LNL_M] = {
 		.fw_generation = ISH_FW_GEN_LNL_M,
 	},
+	[ISHTP_DRIVER_DATA_PTL] = {
+		.fw_generation = ISH_FW_GEN_PTL,
+	},
 };
 
 static const struct pci_device_id ish_pci_tbl[] = {
@@ -63,6 +68,8 @@ static const struct pci_device_id ish_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ISH_ARL_H)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ISH_ARL_S)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ISH_LNL_M), .driver_data = ISHTP_DRIVER_DATA_LNL_M},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ISH_PTL_H), .driver_data = ISHTP_DRIVER_DATA_PTL},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ISH_PTL_P), .driver_data = ISHTP_DRIVER_DATA_PTL},
 	{}
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);
-- 
2.39.5



