Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5398462;
	Thu, 17 Apr 2025 18:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915416; cv=none; b=hpceQXXwjtsazCzvRuLbjJRvanZFQn9vTIBcAx4xcviUN0RJqZJfa/RPFm2lJ0ocPmucTDFCTRY/GpFZ4LSjlX6uybs89z61m02ES8o9yR2GYpEEGdMdEdxEMQvpGd+3h8WqS7XjuhEi0Vj2m+wZp6a8TugRFe1ephfPwvttaws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915416; c=relaxed/simple;
	bh=Y4hA6MvnvIO+r+0tK/ZJOYoilKaR8Xtcf27Xn+OphdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sy4qVmBwS1GFp1tgkal1+wrQ8kVl3rJ+6L+Xnkb7Whve21AMUrNS7KDrWqM4psDDJ/tkeFDBR58tnpyDruWM238hFzMBUn3bDbP5I3n6P5w91zGBW2m9H/rV+fr4Ci5dOgxrinojhUWdEGj7z1F/yY/iRE5HhlegD8VUsMwVIQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiTV2iny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiTV2iny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67576C4CEE4;
	Thu, 17 Apr 2025 18:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915415;
	bh=Y4hA6MvnvIO+r+0tK/ZJOYoilKaR8Xtcf27Xn+OphdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiTV2inyblxLrcEWoqykJhc/A84av0/KOiO9AhiYgTlmEq6UIBoww74mAXm+EMveY
	 nloqDodmnl/RJKyzJptDc6eDaZY54hv753Y2qDqOBXmXqSrvui+MEGa/MTgycDDt7L
	 lOWgYFcHxJseiwHcicHfCpFqEtvDFgIp2fgdJacM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/393] Bluetooth: btintel_pcie: Add device id of Whale Peak
Date: Thu, 17 Apr 2025 19:48:48 +0200
Message-ID: <20250417175112.383030345@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 6b8c05e52d66e4fe4ab1df4c6e15f339ecd9aa51 ]

Add device of Whale Peak.

Output of sudo lspci -v  -s 00:14.7:

00:14.7 Bluetooth: Intel Corporation Device e476
        Subsystem: Intel Corporation Device 0011
        Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 11
        Memory at 11011c30000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
        Capabilities: [80] MSI-X: Enable+ Count=32 Masked-
        Capabilities: [100] Latency Tolerance Reporting
        Kernel driver in use: btintel_pcie
        Kernel modules: btintel_pcie

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 53f6b4f76bccd..ab465e13c1f60 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -36,6 +36,7 @@
 /* Intel Bluetooth PCIe device id table */
 static const struct pci_device_id btintel_pcie_table[] = {
 	{ BTINTEL_PCI_DEVICE(0xA876, PCI_ANY_ID) },
+	{ BTINTEL_PCI_DEVICE(0xE476, PCI_ANY_ID) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, btintel_pcie_table);
-- 
2.39.5



