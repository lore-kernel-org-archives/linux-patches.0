Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A9182D2;
	Mon,  6 Jan 2025 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178930; cv=none; b=LfeDyVvxMlUxhsKYX+mwXx5yL3BHAZSU/0qV2mqCiX2uxyDreQgd+yIv36NwiofmlC/PzaD3Vg1P8tHEUZGchCWQg/LEeMEcO4Z9cG7ZVokxb/6NGaLlE4diB2jddxBiGYGQC2L9roXLFON4cWFjx57/utZjaJHh66538KTPNT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178930; c=relaxed/simple;
	bh=ti1edcRxYLmdqvJAysqNtu7jaBeTi2PEXFqhpDytblY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq1OmgMHxSNQVIfbJ902h90ony50Oh4DjM1t2jb5gEvO8lZ013iu68V3fa6oqtgJAFjWRfHa0BsZWBIiBZQvHRitF0FVBbLCTcfKpyaCmtkRCHHMKZePx7Net5y6feClqHanEtyOMBpS7Kb7y28X8Z5X8HFoaBPN7zVCNKOnPZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkmQAh/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkmQAh/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D12C4CED2;
	Mon,  6 Jan 2025 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178930;
	bh=ti1edcRxYLmdqvJAysqNtu7jaBeTi2PEXFqhpDytblY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkmQAh/Wfiu09X7c1A+rYIr0652GmCo/wGDgkXXWDRg3uWg7fGC1wRPH4RPD7upZ9
	 YBXsgg/g3ebv0GAv9mbTvhzT4/Fye7HZRgQuD0bhr4UUxLtxy8peI8j3ixu8kHpbZm
	 96Xx1Fq8zc+HorPszZthYikEH88YAxdlDkLuiy88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/168] thunderbolt: Add support for Intel Meteor Lake
Date: Mon,  6 Jan 2025 16:16:56 +0100
Message-ID: <20250106151142.537160667@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e4e92f014a8b..e6849a272f8d 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2513,6 +2513,9 @@ struct tb *icm_probe(struct tb_nhi *nhi)
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
index 99faa8a5e9c0..3b47eb2397a1 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1441,6 +1441,12 @@ static struct pci_device_id nhi_ids[] = {
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



