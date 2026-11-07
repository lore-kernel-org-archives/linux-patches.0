Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062308;
	b=mxmCiwhGoYpegEwPPoKrqMXca/kMl5gcVW9fZi+TVRBvt9IvjX4iIArWWLh49EJxGDF9
	 HzqWzV1Eix21G74hC27jWX8A5lVr8fMTWD0ob8qM5YzOBIYzcspW0i3qpeMHWFHKbDgeX
	 iE77P75zdW2nUdp4JFQrVAwfnLafoHF28vustg28bI/2MR1H+bIFDU2sWRzr3kDI/Ax3b
	 S/qYU0xBikYLHZRwNhp8TU2tZyuoT9Por/5pvUwfb0RjwgXjUBEWI9BmdnzH9OAqAL5x8
	 Ig4qKsFiDQQUF5F2q3JoCFHkxwMhkcnKK4p4KEGcI7rp4MfqYC1/De75X4dQ7ay/eeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8jsdnmellSl1h7OpEPuj3sd4lxnO+4ND5B3AvLbZKVM=;
	b=0T5LETZCKY0USSTEXodsryEb9mMWseKtNG7EbDV+KPDy0oI3gFIxaBbUOTFJN0TfOv2c
	 Vt8VLhAIifro/1azrOJFKt7bU9ebF3dYymBJTVrvFMrVmW7UFKbAPgtPS1Bdcxy7bqlUr
	 6AHMfL9ren7FcCDY6PmxRxFM3plcgkb0KPEzyprlIToiw1UtxKGMbD2ghK5Cew1kEZkqA
	 tjCz4jd4BRYfisML7sZTsmHEApajwCgN6MQrSD3gQzXkGaGAMOFUrnfUzhsvI6LhbdWt1
	 bUjAjHcWSVRsnRNjftDdjIABy/EH+uXgPu4CaHvn23zTb9jM/bIFK4mHvD3sPwY1omg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHNlVOKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7021960A3839;
	Sat,  7 Nov 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lHNlVOKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDBE1F0089F;
	Sat,  7 Nov 2026 14:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062308;
	bh=8jsdnmellSl1h7OpEPuj3sd4lxnO+4ND5B3AvLbZKVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHNlVOKpm7v5XXB3jpK9TSrW+z4bGjnaOyevKWEcIjH2Eemb2ARfsLAWjSxthbL78
	 H1xMdxlYIbwwlHoj4Bg0/dvX+tgNW95UKrI4wzRRyxtdH7XLQFk2w2fdWEhJ67VFas
	 SaeinScI6SMPDBU1DDj7+J9v3dU6j6Eqf4gEzqbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1236/1536] PCI: Avoid D3 on PLX PEX 8532/8533/8548 downstream ports
Date: Sat,  7 Nov 2026 08:54:12 -0500
Message-ID: <20261107135032.472241133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 8e923e51892c7da91687dd5b8081ddb1f0fb395a ]

Runtime PM suspends an idle downstream port of a PLX/Broadcom PEX
8532/8533/8548 switch to D3hot, but that takes the whole switch down
with it: any device behind another port of the same switch then
faults with a fatal bus error on its next access, e.g. mptsas probe
on a Sun Ultra 45.

This surfaced on sparc64 once commit a5fb3ff63287 ("PCI: Allow PCI
bridges to go to D3Hot on all non-x86") let bridges enter D3hot. Keep
these downstream ports out of D3 by setting PCI_DEV_FLAGS_NO_D3.

Fixes: a5fb3ff63287 ("PCI: Allow PCI bridges to go to D3Hot on all non-x86")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260927105609.8813-1-kaloz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index af9ef2b60b8ed..8cfa7a3f55cb3 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2378,6 +2378,24 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2000, quirk_plx_pci9050);
 DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2600, quirk_plx_pci9050);
 
+/*
+ * An idle downstream port of a PLX/Broadcom PEX 8532/8533/8548 switch
+ * autosuspends into D3hot, and that takes the whole switch down with
+ * it -- any device behind another port of the same switch then sees a
+ * fatal, non-recoverable bus fault on its next access. Keep these
+ * ports out of D3 entirely.
+ */
+static void quirk_plx_pex_no_d3(struct pci_dev *dev)
+{
+	if (pci_pcie_type(dev) == PCI_EXP_TYPE_DOWNSTREAM) {
+		dev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+		pci_info(dev, "avoiding D3 on this downstream port\n");
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8532, quirk_plx_pex_no_d3);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8533, quirk_plx_pex_no_d3);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PLX, 0x8548, quirk_plx_pex_no_d3);
+
 static void quirk_netmos(struct pci_dev *dev)
 {
 	unsigned int num_parallel = (dev->subsystem_device & 0xf0) >> 4;
-- 
2.53.0



