Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B15313546;
	Wed,  3 Dec 2025 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780444; cv=none; b=eOgevZgKNyEMIgaeI31eU3hcwE2YnTzMJO8OZaEc51lxRIdNfJ4ODN80KJ/oohPsXdBcLxNFMvyfcqjY3cuWdCXbQrOmNeJhkkOznueBk4/BvSslo1moYanismOXOCZGquCGYSBLPUhNUYNN64CjLz7ePGM/7A/oBaa9ETKjvkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780444; c=relaxed/simple;
	bh=uj4uyP8FVz+WCnQTVCbipqrwbUlrIsstD3SGfOZvNoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7mBoV6gFvu/SeiAj78tqf6vpFoahMljgbkzKCYQ1V3csT3GvIw97Wc2iprwH9l4YNLejLDImKMhl8GdxJ8Z48yFtsXLEAsVChSUMqpM5+NV6dH+bMpBa8xbULO4YxW2y1kvLcSIGVUMWSlSKzMaeyhXcHVE6vLYGKMPUMNYlf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AA0iwJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AA0iwJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE90C4CEF5;
	Wed,  3 Dec 2025 16:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780444;
	bh=uj4uyP8FVz+WCnQTVCbipqrwbUlrIsstD3SGfOZvNoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AA0iwJrINnhG+hmPLxpLAscy+AfLTCJvbejgEJBet92xtAchm/MzrUM+nNSYiNmC
	 ZJTce1rIPhhfUXaYzR3mScqT+mxDSjbOsCxdXN+wcS/gJ8AhjAyBUnWljuQUR8qqTw
	 pQyMNpYclfVq+AkEbpcIgKlNsTPaDgF/EVIbUpbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 531/568] thunderbolt: Add support for Intel Wildcat Lake
Date: Wed,  3 Dec 2025 16:28:53 +0100
Message-ID: <20251203152500.163233227@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

commit 3575254546a27210a4b661ea37fbbfb836c0815d upstream.

Intel Wildcat Lake derives its Thunderbolt/USB4 controller from Lunar
Lake platform. Add Wildcat Lake PCI ID to the driver list of supported
devices.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |    2 ++
 drivers/thunderbolt/nhi.h |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1491,6 +1491,8 @@ static struct pci_device_id nhi_ids[] =
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_PTL_P_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_WCL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI) },
 
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -75,6 +75,7 @@ extern const struct tb_nhi_ops icl_nhi_o
 #define PCI_DEVICE_ID_INTEL_TITAN_RIDGE_DD_BRIDGE	0x15ef
 #define PCI_DEVICE_ID_INTEL_ADL_NHI0			0x463e
 #define PCI_DEVICE_ID_INTEL_ADL_NHI1			0x466d
+#define PCI_DEVICE_ID_INTEL_WCL_NHI0			0x4d33
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_80G_NHI	0x5781
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HOST_40G_NHI	0x5784
 #define PCI_DEVICE_ID_INTEL_BARLOW_RIDGE_HUB_80G_BRIDGE 0x5786


