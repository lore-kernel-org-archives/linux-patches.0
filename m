Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2284F1DA62E;
	Mon,  6 Jan 2025 15:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177178; cv=none; b=MdlNpKzcp1plQ/zmqvQzFcsxALlG0W+kNV9qm3wvVaCRcweeQQ9rwqmFyZUDE8lIGrOOT6F9o5Vz+rTjz4vHBkMWJIMY/FfA2rCK/Q8XZ2zUZU/Vt23ahlwsFzJZxutx3/qqmyyplvnZcSQbOekOpoMjm1Fh3991+EXc8R6bwQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177178; c=relaxed/simple;
	bh=tGYkwpDDxwQD3FDLOPn6Zy6Kw1d3AymEW03LoAwt4g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0FnD0on7k6ti+A5zHc1xqW1To1NpQaTbiZ1eMnyQOblaxbdbmPFDmictNuaXo7aDxjrCCtTtBFQA3I8ZpHdhWuqk7HX4QE3CKzOXVvVRQa6eP3qTAnhFZF5yDZzqq5jv/fLVaSt8PnooOB3f873kxqHyMvybWWcbvaK50VbIcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZh0AsEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZh0AsEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDD9C4CED2;
	Mon,  6 Jan 2025 15:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177178;
	bh=tGYkwpDDxwQD3FDLOPn6Zy6Kw1d3AymEW03LoAwt4g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qZh0AsEYiDrsvZxw7vsKFUoxZgNMTVNV+wmU1K+O/wO2MIrkmHEUlYXNNldySBZ9X
	 ZQZ/O3CK74REP8L47xtqdCpAH8vMrGI3rRqoaQKLyAygmDzEXWqNc/TCiDoCr7/Ayj
	 hpFulTORIEGoB1gD4GQMvYB6bi5vt3/6BGytKndU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/222] thunderbolt: Add support for Intel Panther Lake-M/P
Date: Mon,  6 Jan 2025 16:14:41 +0100
Message-ID: <20250106151153.518113769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8644b48714dca8bf2f42a4ff8311de8efc9bd8c3 ]

Intel Panther Lake-M/P has the same integrated Thunderbolt/USB4
controller as Lunar Lake. Add these PCI IDs to the driver list of
supported devices.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/nhi.c | 8 ++++++++
 drivers/thunderbolt/nhi.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index b22023fae60d..79f2bf5df19a 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1528,6 +1528,14 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_LNL_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_M_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_M_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_P_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_P_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 7a07c7c1a9c2..16744f25a9a0 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -92,6 +92,10 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_RPL_NHI1			0xa76d
 #define PCI_DEVICE_ID_INTEL_LNL_NHI0			0xa833
 #define PCI_DEVICE_ID_INTEL_LNL_NHI1			0xa834
+#define PCI_DEVICE_ID_INTEL_PTL_M_NHI0			0xe333
+#define PCI_DEVICE_ID_INTEL_PTL_M_NHI1			0xe334
+#define PCI_DEVICE_ID_INTEL_PTL_P_NHI0			0xe433
+#define PCI_DEVICE_ID_INTEL_PTL_P_NHI1			0xe434
 
 #define PCI_CLASS_SERIAL_USB_USB4			0x0c0340
 
-- 
2.39.5



