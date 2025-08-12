Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E482F4A0A;
	Tue, 12 Aug 2025 18:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023584; cv=none; b=YP/tmMad8ZkN0x4wV4T1MSzIwB7Csa7SGh4BesEg1oERyvUj80pq9xRI63Vlf2vFLxd1Q3HodWwal6P8sSUEfLFb8bBjAFHoZsr0bXbGKyXlJSwGbbifDT/88cPxwZNVceK5c5gsMSVDAcoTHUudrijegE61TTdhXiMi7o5RQc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023584; c=relaxed/simple;
	bh=zaSFBsORC13myHODCbOm4UYKW/UjCyZ3zAtXG78W0lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxBdzUChDRWw2EtL3lZRnpXmTdg3JuuYLwBa3QCaj31HO5UBsyUMsds6ox7Q9CsVEI8VAVDHe/1GkCXPxzn0WYkafO9mePckmmmUWHl9uu9WgqhzRVesAdxUeJA3l1+/CK1FkUGQTDdSnHe0qzn3PFSScfwZYhhfCbYkti6a1ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2n6duHan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2n6duHan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34113C4CEF0;
	Tue, 12 Aug 2025 18:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023583;
	bh=zaSFBsORC13myHODCbOm4UYKW/UjCyZ3zAtXG78W0lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2n6duHanLw9l82Kz1YsOiOPQJYPCwiKfkAkHZVYkHGP/n8QdpCkwFJMh3FIiDzM9r
	 5PDy7Qoq13yB+1t7LUVcdI2eKCACfKKop5+AJeDfaeeLw/PlhfS17Ol6UZstSBUGyG
	 w7VT8pgNGzbQTWGVgFp2CjpTM7aP5aFlS3srcNgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Slark Xiao <slark_xiao@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 122/627] bus: mhi: host: pci_generic: Fix the modem name of Foxconn T99W640
Date: Tue, 12 Aug 2025 19:26:57 +0200
Message-ID: <20250812173423.964608697@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Slark Xiao <slark_xiao@163.com>

[ Upstream commit ae5a34264354087aef38cdd07961827482a51c5a ]

T99W640 was mistakenly mentioned as T99W515. T99W515 is a LGA device, not
a M.2 modem device. So correct it's name to avoid name mismatch issue.

Fixes: bf30a75e6e00 ("bus: mhi: host: Add support for Foxconn SDX72 modems")
Signed-off-by: Slark Xiao <slark_xiao@163.com>
[mani: commit message fixup]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250606095019.383992-1-slark_xiao@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/pci_generic.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/mhi/host/pci_generic.c b/drivers/bus/mhi/host/pci_generic.c
index 589cb6722316..92bd133e7c45 100644
--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -593,8 +593,8 @@ static const struct mhi_pci_dev_info mhi_foxconn_dw5932e_info = {
 	.sideband_wake = false,
 };
 
-static const struct mhi_pci_dev_info mhi_foxconn_t99w515_info = {
-	.name = "foxconn-t99w515",
+static const struct mhi_pci_dev_info mhi_foxconn_t99w640_info = {
+	.name = "foxconn-t99w640",
 	.edl = "qcom/sdx72m/foxconn/edl.mbn",
 	.edl_trigger = true,
 	.config = &modem_foxconn_sdx72_config,
@@ -920,9 +920,9 @@ static const struct pci_device_id mhi_pci_id_table[] = {
 	/* DW5932e (sdx62), Non-eSIM */
 	{ PCI_DEVICE(PCI_VENDOR_ID_FOXCONN, 0xe0f9),
 		.driver_data = (kernel_ulong_t) &mhi_foxconn_dw5932e_info },
-	/* T99W515 (sdx72) */
+	/* T99W640 (sdx72) */
 	{ PCI_DEVICE(PCI_VENDOR_ID_FOXCONN, 0xe118),
-		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w515_info },
+		.driver_data = (kernel_ulong_t) &mhi_foxconn_t99w640_info },
 	/* DW5934e(sdx72), With eSIM */
 	{ PCI_DEVICE(PCI_VENDOR_ID_FOXCONN, 0xe11d),
 		.driver_data = (kernel_ulong_t) &mhi_foxconn_dw5934e_info },
-- 
2.39.5



