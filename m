Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34523214A71;
	Wed, 19 Mar 2025 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395053; cv=none; b=WoHVKDKakPTNPH/bjCY/WzQ0W2xc6az5sy/WJy4QVLWKKKseempm/7O6iwPeR/bXv2RRX5U0tbQ6DOgj50WoRmiWQyuBp3T7ubgV0hHHSQ3TeuDoVaevUAy8lfn5dJL74hBBYKvFbkxt0KPoODa/5zCHlOOtoAzyYhWc9LYSsjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395053; c=relaxed/simple;
	bh=0MepOu5eJXwcrd3/r2Gz0TA9KOFaMd9SBGfetfaFNfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxnotOKQ8lIlwErgPz8m87QbOvOHw88LorSvka34Ut+Imyjp8AfZKOqYqFLkXPQ0Bvu1IgWgl3t98Rlt7Yhy9//y9QvDNNdQtorPK1puKGaA7AxVzsuqoJmeuOhZ3HHuAxN21Bw9DOaZWif40UzGR1XtUkjyrTEmr79mQ8hK80o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK2Pnbw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK2Pnbw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F421DC4CEE4;
	Wed, 19 Mar 2025 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395053;
	bh=0MepOu5eJXwcrd3/r2Gz0TA9KOFaMd9SBGfetfaFNfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK2Pnbw9zjgdNg9jUpqTmVzklfcEcR8h2Al2uATq0Ne3ou+bsN76KnIasRfJwdsrR
	 pfhmRB2s8u+v+3obVRmN0WwsH7Ea0QGtwaPKIJePU42DJ4gCjiK6ol0K3WbomMFUMv
	 RvxlN7ZkugsnGFCErj8m5DP/QpAhAdT77O86bY4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/231] HID: intel-ish-hid: ipc: Add Panther Lake PCI device IDs
Date: Wed, 19 Mar 2025 07:29:33 -0700
Message-ID: <20250319143028.811582300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aae0d965b47b5..1894743e88028 100644
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



