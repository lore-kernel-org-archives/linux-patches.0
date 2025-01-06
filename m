Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC313B59A;
	Mon,  6 Jan 2025 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178842; cv=none; b=DxQG6m1NGKF0hxYkCEkhlSiFBWH1vSfaJnK4OZwAfrOIREPNTxluJr4VWrX9grSUjdMfwDcZam/0VMOCe0EXcDaxeGqSlJpCw+ZeJcfeJSPSNI5Uabqew2Tr0RPMQGCC+OTVKLg7yJ/QzMvLQMqhYAbvR6GBf1GQq3R40CcRoUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178842; c=relaxed/simple;
	bh=txUJ6a76/310NfDAmUNEbgA4oeKGH/aR3i93Seo9jcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raMw78wzW/JXXsBh7FWbSZ9cioLmgDmhoP8QzLGwUChVLJlNN8LTEfN2X7dhlwx+5Iwo6CwCfaDL/Nfzkdp1Aaw9bpG0YiTefLVAG/h6/RwkJ9cOGW2tzGFDB0g++ShyBdcnfyQKSQQsMcY63ZsnB0De2YLxspW+GG7NvPaDgC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBqguNxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBqguNxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCA9C4CED2;
	Mon,  6 Jan 2025 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178841;
	bh=txUJ6a76/310NfDAmUNEbgA4oeKGH/aR3i93Seo9jcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBqguNxL0Y7qSwcigPwLPh85tNe/tPITiG/1Gi/Z9Jzb2HC+KITv9GjMBlvYLzF/1
	 lxX93sv9WCUpGLyXvHsRDkEo6EKc8hYNp5sD2SS3RXTnc3jRFYKkP7desYtDI+sY/g
	 ENvxjHzagaE1AZAgxBDpWT/rFP3CCUr2tmut+8r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/168] thunderbolt: Add support for Intel Panther Lake-M/P
Date: Mon,  6 Jan 2025 16:16:59 +0100
Message-ID: <20250106151142.648086517@linuxfoundation.org>
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
index ed028b01f14f..1db233c44851 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1451,6 +1451,14 @@ static struct pci_device_id nhi_ids[] = {
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
index 4b0fccf033e1..67ecee94d7b9 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -90,6 +90,10 @@ extern const struct tb_nhi_ops icl_nhi_ops;
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



