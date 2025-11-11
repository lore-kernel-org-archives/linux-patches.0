Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A403469F2;
	Tue, 11 Nov 2025 01:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824201; cv=none; b=P6YtISn6SM4+14iAQ7VkOgL6okbqtwMX5nOiRpXbRBXfdQjm3eNlWSMUTLqAIXNYjKQZMRO0WsuzAJ6dww4LpPjRcrqx4kELCujLh9R57dbBFDHJ6WoJkw2JkLKnFbrcEzVFssHhKBT8TxBbEYnVfNH6xgKQ7kQ/LKDnRnK5+Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824201; c=relaxed/simple;
	bh=3AR8Vl1OiMR9bSmR14vjmioDL+M6R09T35dKcUAFs/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEPiP5FRZyOfk7uD5r4RECd2Hb4Xx+pTNyqmjIVa+Z1smAmkkvCEDcCQztMHQSvEqGV7xfqkAGC6+35sgmVP9nlum8oR02IcA7xCMTvDSLogV6eYmp8CXGGkPtj8U8aEBLGk/zNZGnGmngJX9jMfLUI1SX8GU+nNqYl6Z3iNo54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOkLKRNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOkLKRNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729C0C116B1;
	Tue, 11 Nov 2025 01:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824200;
	bh=3AR8Vl1OiMR9bSmR14vjmioDL+M6R09T35dKcUAFs/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOkLKRNH9Xo9E9uk4quhHooQ4mr4f4zOSf3A3YFdPCJDogN4YSkobGULtI8ISA0wh
	 tq5Dl9/ViTW/XbAvKmSXEaQzEcou804bJbZ0929ZOzWl/CIm6o0IOaaS/Cj3SezqG1
	 VciAykWDMQ6FpfLGH2+mKD/XgN2rut4dGxN0q0Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 452/849] bus: mhi: host: pci_generic: Add support for all Foxconn T99W696 SKU variants
Date: Tue, 11 Nov 2025 09:40:22 +0900
Message-ID: <20251111004547.355741066@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit 376358bb9770e5313d22d8784511497096cdb75f ]

Since there are too many variants available for Foxconn T99W696 modem, and
they all share the same configuration, use PCI_ANY_ID as the subsystem
device ID to match each possible SKUs and support all of them.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
[mani: reworded subject/description and dropped the fixes tag]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20250819020013.122162-1-slark_xiao@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 4edb5bb476baf..4564e2528775e 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -917,20 +917,8 @@ static const struct pci_device_id mhi_pci_id_table[] = {
 	/* Telit FE990A */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2015),
 		.driver_data = (kernel_ulong_t) &mhi_telit_fe990a_info },
-	/* Foxconn T99W696.01, Lenovo Generic SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe142),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.02, Lenovo X1 Carbon SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe143),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.03, Lenovo X1 2in1 SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe144),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.04, Lenovo PRC SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe145),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
-	/* Foxconn T99W696.00, Foxconn SKU */
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, 0xe146),
+	/* Foxconn T99W696, all variants */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, PCI_VENDOR_ID_FOXCONN, PCI_ANY_ID),
 		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w696_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0308),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx65_info },
-- 
2.51.0



