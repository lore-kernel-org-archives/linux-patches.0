Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3D12356CF;
	Mon, 10 Mar 2025 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630537; cv=none; b=gj8PKm9HkOTMGdq8yNo6OtNU9EjDih4fxkBKZQmEL0GO+V2efy6Ly73udro3bvCrwb4yU2II+is1UnumqcuD4k3V5DnZSsXamd3dvg/5sp0MXmC7LEtjMOr1EBlp32yM1ka5C4uesZXzjAJSDP1mK04dIJkH+LWsrjk+SK9iFcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630537; c=relaxed/simple;
	bh=oD/dROy/s6Z/POlOtP0izcIqJMHRNkXBG0WzNCeMNeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJVsPAQdof5jjQ4dM0FRy88CH4zSJRggkBK+m1bhXRZBdcSGcUBUgBFNgOCD5ipmtSF75ExaukqETpoXmSEhgQfXDlNhbL7pWLeE+kv8PKC9lu3YTi1Xk/SZ/PJpfSmc++AnNgVoWiJd/iodtDDMcWwBU9ndUgdl9MZkxmDCNEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=on4goGSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="on4goGSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92384C4CEE5;
	Mon, 10 Mar 2025 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630537;
	bh=oD/dROy/s6Z/POlOtP0izcIqJMHRNkXBG0WzNCeMNeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on4goGSMhQ0gAvtZ7L3XI5Wz8UVz22+pzmPH87yjajwsZvqFo9/QLLCS/oydj8PkW
	 f1XOV3B43NgbkzxTDSw4X5iuE1eADB3etHVafTQB7f0VFkAv1+IcztoJTdcXD5wPJE
	 wo8sfcrwgbEFCVbnFZysV5q+hcTbOOWOye6GmNzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaqing Zhao <jiaqing.zhao@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Tomita Moeko <tomitamoeko@gmail.com>
Subject: [PATCH 5.15 421/620] parport_pc: add support for ASIX AX99100
Date: Mon, 10 Mar 2025 18:04:27 +0100
Message-ID: <20250310170602.206688030@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>

commit 16aae4c64600a6319a6f10dbff833fa198bf9599 upstream.

The PCI function 2 on ASIX AX99100 PCIe to Multi I/O Controller can be
configured as a single-port parallel port controller. The subvendor id
is 0x2000 when configured as parallel port. It supports IEEE-1284 EPP /
ECP with its ECR on BAR1.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Link: https://lore.kernel.org/r/20230724083933.3173513-5-jiaqing.zhao@linux.intel.com
Signed-off-by: Tomita Moeko <tomitamoeko@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parport/parport_pc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2611,6 +2611,7 @@ enum parport_pc_pci_cards {
 	netmos_9815,
 	netmos_9901,
 	netmos_9865,
+	asix_ax99100,
 	quatech_sppxp100,
 	wch_ch382l,
 	brainboxes_uc146,
@@ -2676,6 +2677,7 @@ static struct parport_pc_pci {
 	/* netmos_9815 */		{ 2, { { 0, 1 }, { 2, 3 }, } },
 	/* netmos_9901 */               { 1, { { 0, -1 }, } },
 	/* netmos_9865 */               { 1, { { 0, -1 }, } },
+	/* asix_ax99100 */		{ 1, { { 0, 1 }, } },
 	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 	/* wch_ch382l */		{ 1, { { 2, -1 }, } },
 	/* brainboxes_uc146 */	{ 1, { { 3, -1 }, } },
@@ -2766,6 +2768,9 @@ static const struct pci_device_id parpor
 	  0xA000, 0x1000, 0, 0, netmos_9865 },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9865,
 	  0xA000, 0x2000, 0, 0, netmos_9865 },
+	/* ASIX AX99100 PCIe to Multi I/O Controller */
+	{ PCI_VENDOR_ID_ASIX, PCI_DEVICE_ID_ASIX_AX99100,
+	  0xA000, 0x2000, 0, 0, asix_ax99100 },
 	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
 	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },


