Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760411DED5E;
	Mon,  6 Jan 2025 15:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178400; cv=none; b=iCpgn99FE2OsMR54SplHUZfVfBpP2oBgknN2eCX5UFvEhzWoMnTnQz8d1Xd92WM8733lx2c1K1CewfPOO46iQKSb4/xwWow8nHGsdxkoEmYqV9UNhklaZDpWXjEmHCozXPTIvlop6jYf2CWdZHSOk7ljIciRTW8FU8yDH3ObrTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178400; c=relaxed/simple;
	bh=ZcD4V3EpBu3nzPaEisMeASMvtbxDeMbWwnfFQ6AZuFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkcWP37lqH0EE8nmR4FuLgPgEcWv/RfLmcboXfowOOXK0jHc0FYoBasSnUqgqlEGyGk3RKyY0z8O5ks7knHUpCQESE3jjc4S6U3yoezA0V6wpCnWor1s4NwyjMhwN4WLTt31BnmAiHvuOGjm0jF+HG2Ej6PdSTY9FkpyiLJ7Zdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdzB+Nno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdzB+Nno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED217C4CED2;
	Mon,  6 Jan 2025 15:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178400;
	bh=ZcD4V3EpBu3nzPaEisMeASMvtbxDeMbWwnfFQ6AZuFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdzB+Nnoe3au9xzcK2RQ43JT6HS8GdXJBVKamx5tue38+XCaPbsnjxREr863vH+7d
	 O9mg8pbmMqBQ1V3HP+HZFRQDjzUMBp+gax8qlVca/44g3NiqMIvcVwOvwxteAVeSIR
	 td7X4xmXDv9+Ht29g0RO5vsrccTXDbDJ3sk1LoZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/138] thunderbolt: Add support for Intel Meteor Lake
Date: Mon,  6 Jan 2025 16:16:52 +0100
Message-ID: <20250106151136.565685828@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 32249fd8c8cccd7a1ed86c3b6d9b6ae9b4a83623 ]

Intel Meteor Lake has the same integrated Thunderbolt/USB4 controller as
Intel Alder Lake. Add the Intel Meteor Lake PCI IDs to the driver list
of supported devices.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 8644b48714dc ("thunderbolt: Add support for Intel Panther Lake-M/P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/icm.c | 3 +++
 drivers/thunderbolt/nhi.c | 6 ++++++
 drivers/thunderbolt/nhi.h | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index eab5199ccc5b..51e3ac78c022 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2294,6 +2294,9 @@ struct tb *icm_probe(struct tb_nhi *nhi)
 	case PCI_DEVICE_ID_INTEL_ADL_NHI1:
 	case PCI_DEVICE_ID_INTEL_RPL_NHI0:
 	case PCI_DEVICE_ID_INTEL_RPL_NHI1:
+	case PCI_DEVICE_ID_INTEL_MTL_M_NHI0:
+	case PCI_DEVICE_ID_INTEL_MTL_P_NHI0:
+	case PCI_DEVICE_ID_INTEL_MTL_P_NHI1:
 		icm->is_supported = icm_tgl_is_supported;
 		icm->driver_ready = icm_icl_driver_ready;
 		icm->set_uuid = icm_icl_set_uuid;
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index d41ff5e0f9ca..ea2fff90d162 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1357,6 +1357,12 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPL_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL_M_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL_P_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_MTL_P_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 
 	/* Any USB4 compliant host */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_USB4, ~0) },
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 01190d9ced16..b0718020c6f5 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -75,6 +75,9 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE	0x15ef
 #define PCI_DEVICE_ID_INTEL_ADL_NHI0			0x463e
 #define PCI_DEVICE_ID_INTEL_ADL_NHI1			0x466d
+#define PCI_DEVICE_ID_INTEL_MTL_M_NHI0			0x7eb2
+#define PCI_DEVICE_ID_INTEL_MTL_P_NHI0			0x7ec2
+#define PCI_DEVICE_ID_INTEL_MTL_P_NHI1			0x7ec3
 #define PCI_DEVICE_ID_INTEL_ICL_NHI1			0x8a0d
 #define PCI_DEVICE_ID_INTEL_ICL_NHI0			0x8a17
 #define PCI_DEVICE_ID_INTEL_TGL_NHI0			0x9a1b
-- 
2.39.5



