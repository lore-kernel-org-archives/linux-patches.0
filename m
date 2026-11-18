Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049274;
	b=Skp314hTPtrwPLj/FcYI5h4cVXGmHmhRIAui+bImmcX6L0Y+ejMtNCkir058OlNOVOhI
	 DFAp2Z1PIfZxjcqFW7UxGReWjIl/rkhwWfa84rDiNBKkDADLNdV4dxymIVPFEDCJ8Ep/F
	 GwE5GyollWYoXMeuEbahs/Rd7f2/ftLc07uIOS8e7iqi0ccHgzvUIrZME8hQhgFI5L02z
	 qOqdhartytl5xchAZiActj4s3/6ZwzBPgWuy1bGDFILOC2gxifC5MN5vEHBaIGbzzjxG9
	 /EC0C23WFB3JPm11F+bD/IFxWtroPW8crEZ3cZ4H/ZqX+Jm/se/PziZ/ml6VwFBUG8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=510d34YBdEUA5ZDZD2TixvHzoUTKJWyoDaVG0ok4/po=;
	b=x32tDeIMryDiT2Z0h3ey0XoQYcY2MrrRMNtP3V3y+AKfKhwKpCWxAD8cl5tCb9NxeWn0
	 th3vsi8OdZGR3OxsXFV01KKxpogENYPYt/Ggy1cSY2ZN87cgNOhpKrZokFx+nUQDmZsTF
	 sWa4EM4cFaG8WP0k80MUNZL3csVPWRMGiC+vYjMMNmDuCLopIXF57x+ycO0FbwZs2eXzz
	 uNVa/BSIHtf6tU/7WWymIp261B4Tgaq2taW37gTZzg8ZXH0bPHRGDdbXh2aIJ2LfrI2Qe
	 IUFpMj75ohn1bFxvxvEzStsfC/GXVPOW2Xadm0H5hkCN7oFQM6/cKKh7YNfFXkWg5GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mw2ZMuy7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AC7606A320;
	Thu, 19 Nov 2026 00:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mw2ZMuy7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB10C1F000C4;
	Thu, 19 Nov 2026 00:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049274;
	bh=510d34YBdEUA5ZDZD2TixvHzoUTKJWyoDaVG0ok4/po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mw2ZMuy7ljxnOx6rcvofK9lgTPRyLP1Iv+Rc0FaipM6WM8RcnllLCX1/kjo4rm7hu
	 V3QuGQvBMSvajJA37rN+irieQulpGETfLFO/vQ5/Hi9TMa0iNaiaBSzyycbp5HEM0q
	 3Uy5IcpFTi4n/dPBC4RVY3WaKez4T1UEWkJx6eGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2293/2857] PCI/AER: Add optional logging callback for correctable error
Date: Wed, 18 Nov 2026 15:55:27 +0100
Message-ID: <20261118150324.041567937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 361187e04733eee19778ea9b01cb95a977c14c10 ]

Some new devices such as CXL devices may want to record additional error
information on a corrected error. Add a callback to allow the PCI device
driver to do additional logging such as providing additional stats for user
space RAS monitoring.

For CXL device, this is actually a need due to CXL needing to write to the
CXL RAS capability structure correctable error status register in order to
clear the unmasked correctable errors. See CXL spec rev3.0 8.2.4.16.

Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166984619233.2804404.3966368388544312674.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: e86ac10110d0 ("PCI/AER: Fix struct pci_dev reference leak in aer_process_err_devices()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/PCI/pci-error-recovery.rst | 7 +++++++
 drivers/pci/pcie/aer.c                   | 8 +++++++-
 include/linux/pci.h                      | 3 +++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/PCI/pci-error-recovery.rst b/Documentation/PCI/pci-error-recovery.rst
index 187f43a032006..bdafeb4b66dcf 100644
--- a/Documentation/PCI/pci-error-recovery.rst
+++ b/Documentation/PCI/pci-error-recovery.rst
@@ -83,6 +83,7 @@ This structure has the form::
 		int (*mmio_enabled)(struct pci_dev *dev);
 		int (*slot_reset)(struct pci_dev *dev);
 		void (*resume)(struct pci_dev *dev);
+		void (*cor_error_detected)(struct pci_dev *dev);
 	};
 
 The possible channel states are::
@@ -422,5 +423,11 @@ That is, the recovery API only requires that:
    - drivers/net/cxgb3
    - drivers/net/s2io.c
 
+   The cor_error_detected() callback is invoked in handle_error_source() when
+   the error severity is "correctable". The callback is optional and allows
+   additional logging to be done if desired. See example:
+
+   - drivers/cxl/pci.c
+
 The End
 -------
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 08e7f918f71b5..9ae9f64457d0f 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -961,8 +961,14 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
 		if (aer)
 			pci_write_config_dword(dev, aer + PCI_ERR_COR_STATUS,
 					info->status);
-		if (pcie_aer_is_native(dev))
+		if (pcie_aer_is_native(dev)) {
+			struct pci_driver *pdrv = dev->driver;
+
+			if (pdrv && pdrv->err_handler &&
+			    pdrv->err_handler->cor_error_detected)
+				pdrv->err_handler->cor_error_detected(dev);
 			pcie_clear_device_status(dev);
+		}
 	} else if (info->severity == AER_NONFATAL)
 		pcie_do_recovery(dev, pci_channel_io_normal, aer_root_reset);
 	else if (info->severity == AER_FATAL)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 39e9aea18f5d3..e7f4a2d4cefa0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -860,6 +860,9 @@ struct pci_error_handlers {
 
 	/* Device driver may resume normal operations */
 	void (*resume)(struct pci_dev *dev);
+
+	/* Allow device driver to record more details of a correctable error */
+	void (*cor_error_detected)(struct pci_dev *dev);
 };
 
 
-- 
2.53.0



