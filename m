Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061347;
	b=TwsmgVJJJvSFuePMUbVTtvcpnuPN29UNK39IcvS46ZsnE8ikB/dNjyvibd3a0KU9sBRh
	 nv6Flij9Lfb3b9yuQzkjc+6dq7poLiHYE9vnrhwrsFk6sdhjxj0iQRV+3h3D83gKGksEq
	 H7WgvWo9o3IIgwsgo99+wfyGXGyAbWxQ1m1JMdXJHNQIQuQe9xzUXl5Dwaj6CIaT17DVd
	 Kyh0AfyRlgJ/cg5w+9ty40s0UEQHeVPMlqjqcRCYcWndmxpimM+qvfazpMSRtLkIZT9Qn
	 MpP5/TzLyW8FIsLAS5xdPTJEEvseTsckEQNcZcroS1dAffo3uGUGjvY9QY2Q3iW9LsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qDJwRtAYkXFSkKPeoAfGaNBmc3SMpdc2VQZkljKxtTs=;
	b=dpOcoe2nz2RLKsdrrd3p754Ch8Fbz5k7IMp1zcRdht1gtf9G2u6Os+ob27AyKPhSRQcf
	 QBOVvn3giBJryzMAYMZ9J5LQRx+AXau1lvljf/9J945+krFIC129EOTM+gpWHyy4a8K0g
	 tBbNKkutp4MIXK9VZn5WdgoyL3+kvgF/bWYqDuzWHeXFX83AMBp+iLOOAgrccH1unav69
	 U6wA7wsBVsJnZN4tMGtG1ZKI6/R7l+2qH6xOLWM1c67syiC724vpDp8zZ4r46O176r+gm
	 /ZhNGpZYgMWtGe2K63X9bLbQX73H7/JH22+dkwSRjL3wD6OfVJ2WaPBcS/J2au0YqvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBucycGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5170B606A320;
	Thu, 19 Nov 2026 04:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBucycGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0151F000C4;
	Thu, 19 Nov 2026 04:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061347;
	bh=qDJwRtAYkXFSkKPeoAfGaNBmc3SMpdc2VQZkljKxtTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBucycGlRL4pNHyu5fkZr+xsGgwdr3trfiC0d9IfC7MuHEraYZ9F/pxXidhkkf2zi
	 1GjNITd8OoKQhPLePt/XT4WoIAJChafLLGHO32V8R+cnw+AnM6K8CQSUd1AAoWJXPP
	 W/a5iHB1dW+S+fxklI70NymjKzKzu0epgBziR4CU=
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
Subject: [PATCH 5.10 1521/1848] PCI/AER: Add optional logging callback for correctable error
Date: Wed, 18 Nov 2026 15:59:19 +0100
Message-ID: <20261118150023.006078008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 84ceebb08cac1..576c61736bffd 100644
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
index 8d39116e07af6..688b9e7345380 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -954,8 +954,14 @@ static void handle_error_source(struct pci_dev *dev, struct aer_err_info *info)
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
index 47c53bbf3f9d8..062079de28de9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -840,6 +840,9 @@ struct pci_error_handlers {
 
 	/* Device driver may resume normal operations */
 	void (*resume)(struct pci_dev *dev);
+
+	/* Allow device driver to record more details of a correctable error */
+	void (*cor_error_detected)(struct pci_dev *dev);
 };
 
 
-- 
2.53.0



