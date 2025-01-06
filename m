Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE36F1DE4CE;
	Mon,  6 Jan 2025 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178368; cv=none; b=LAYTfaGzRvjKKtW3zqDNxQUvVZEMvb55WIDAkhNgRtXV8/9IjPO3NzcU+/BhWpiwFGhF6jPtSI4fEfk0SHFjzVcSv6JL2yCc/m3r+eHVdnEx5MAC0j4rQwZdjKW3OoBehwjWKyTOyVjvgfxvXzpfvH6dgGfUpmxfVXBK51p7Br8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178368; c=relaxed/simple;
	bh=RZNHL8a9INdEChnFxoN9hFF6UZRE/Is/Pz7yi9qTJn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAHsQTCHIRxdrBR9asZe6szhwoSPIO2MPtDXcK+b7Lrx3/s0xV1J3ty4W6Ux+CWd0XSfc5geGs38DMI4ga6moc22P9CKDGPFj03aUTeDfF/YKrSAGeuyDmRxNCD1ePTDq1lLsw9DpKL233RJSoQNVbYPjh8cDpoa0tgFIsYn78c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYDMTt/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYDMTt/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB47C4CED2;
	Mon,  6 Jan 2025 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178367;
	bh=RZNHL8a9INdEChnFxoN9hFF6UZRE/Is/Pz7yi9qTJn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYDMTt/VJIQJ6GZoPpYNymTm1cYzzmO8S2mffwhQQsYv6ZLW9a9ykp2LMvtQJvGo3
	 8aDWQXlgf3vWZyhyq9dcPhGaueHZ+U2ILt4p/lvJqXeMI7UEjREyOT7k48V+lRgnqk
	 DB8fkNfhYQQWIlwN10UPBo3ItW/HxJCxcyTkCAYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George D Sworo <george.d.sworo@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/138] thunderbolt: Add support for Intel Raptor Lake
Date: Mon,  6 Jan 2025 16:16:51 +0100
Message-ID: <20250106151136.527516309@linuxfoundation.org>
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

From: George D Sworo <george.d.sworo@intel.com>

[ Upstream commit 7ec58378a985618909ffae18e4ac0de2ae625f33 ]

Intel Raptor Lake has the same integrated Thunderbolt/USB4 controller as
Intel Alder Lake. By default it is still using firmware based connection
manager so we can use most of the Alder Lake flows.

Signed-off-by: George D Sworo <george.d.sworo@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 8644b48714dc ("thunderbolt: Add support for Intel Panther Lake-M/P")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/icm.c | 2 ++
 drivers/thunderbolt/nhi.c | 4 ++++
 drivers/thunderbolt/nhi.h | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/thunderbolt/icm.c b/drivers/thunderbolt/icm.c
index b038e530d6cb..eab5199ccc5b 100644
--- a/drivers/thunderbolt/icm.c
+++ b/drivers/thunderbolt/icm.c
@@ -2292,6 +2292,8 @@ struct tb *icm_probe(struct tb_nhi *nhi)
 	case PCI_DEVICE_ID_INTEL_TGL_H_NHI1:
 	case PCI_DEVICE_ID_INTEL_ADL_NHI0:
 	case PCI_DEVICE_ID_INTEL_ADL_NHI1:
+	case PCI_DEVICE_ID_INTEL_RPL_NHI0:
+	case PCI_DEVICE_ID_INTEL_RPL_NHI1:
 		icm->is_supported = icm_tgl_is_supported;
 		icm->driver_ready = icm_icl_driver_ready;
 		icm->set_uuid = icm_icl_set_uuid;
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 1e732d2d15ad..d41ff5e0f9ca 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1353,6 +1353,10 @@ static struct pci_device_id nhi_ids[] = {
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_ADL_NHI1),
 	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPL_NHI0),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_RPL_NHI1),
+	  .driver_data = (kernel_ulong_t)&icl_nhi_ops },
 
 	/* Any USB4 compliant host */
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_USB_USB4, ~0) },
diff --git a/drivers/thunderbolt/nhi.h b/drivers/thunderbolt/nhi.h
index 5091677b3f4b..01190d9ced16 100644
--- a/drivers/thunderbolt/nhi.h
+++ b/drivers/thunderbolt/nhi.h
@@ -81,6 +81,8 @@ extern const struct tb_nhi_ops icl_nhi_ops;
 #define PCI_DEVICE_ID_INTEL_TGL_NHI1			0x9a1d
 #define PCI_DEVICE_ID_INTEL_TGL_H_NHI0			0x9a1f
 #define PCI_DEVICE_ID_INTEL_TGL_H_NHI1			0x9a21
+#define PCI_DEVICE_ID_INTEL_RPL_NHI0			0xa73e
+#define PCI_DEVICE_ID_INTEL_RPL_NHI1			0xa76d
 
 #define PCI_CLASS_SERIAL_USB_USB4			0x0c0340
 
-- 
2.39.5



