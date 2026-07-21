Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248946E012;
	Tue, 21 Jul 2026 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659593; cv=none; b=SLB9Ph13BfgSPCHE3G73QmfGFSmHpaHNZRcofDGsziRaF7DOIGf4fFTbUJhzd/vq3S+Y5q2mQmKfKrh6eXkwrNFDahIjB2GV5s8hkv4nyW0r1M8RpZ2OL31HLpDObcnvklP0+Nxj40dtanw3+vWumkjPJ+ff1q97UFMn6d/LhZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659593; c=relaxed/simple;
	bh=ve4ySDGBOsOIq5AbcbtpHpXqtkzkwf1F8jeXU8lt9BM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JPSFf0PLqebxWluWg9qYO+n8VLgGHwGHJ7FYn4LAvvU38zTVmi9fNU7EuJwpPm7QRsFDhkCD3vdmCGh67mhx9ZLsJ8RqR5k/K4VGSi1vroaSvB8ZUtyqi3cayj5D+KtZ+tBYHAKXAY0K6MDJjMNFY9BuiXikIx6GI/GquGTi328=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhVIYc7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhVIYc7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9D01F000E9;
	Tue, 21 Jul 2026 18:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659592;
	bh=3E8PvtwWJNpQKFqaKiLgUdJEAoPqlx+sKxjizve08YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhVIYc7vZTZH2k8TV0IjK5aW8kWbX2/WENrUGKNn0/FRH7JsLBt+SFnZa1UM63lHf
	 BtqyzYaHN3AIaTzNShvIlgjpTojK77NQGkf9QB1xLSzd04SW5MVymR97PXFLgKa4qa
	 cQCy3BWZOJ3ECGcOR8G2lQZkJ4WS0nE0wPNINqIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6.18 1536/1611] PCI: Add kerneldoc for pci_resize_resource()
Date: Tue, 21 Jul 2026 17:27:32 +0200
Message-ID: <20260721152549.997091801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit d787018e2dfdc4c1331538e7a8717690d1b7c9b3 ]

As pci_resize_resource() is meant to be used also outside of PCI core,
document the interface with kerneldoc.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-8-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/setup-res.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -457,6 +457,26 @@ void pci_resize_resource_set_size(struct
 	resource_set_size(res, res_size);
 }
 
+/**
+ * pci_resize_resource - reconfigure a Resizable BAR and resources
+ * @dev: the PCI device
+ * @resno: index of the BAR to be resized
+ * @size: new size as defined in the spec (0=1MB, 31=128TB)
+ * @exclude_bars: a mask of BARs that should not be released
+ *
+ * Reconfigure @resno to @size and re-run resource assignment algorithm
+ * with the new size.
+ *
+ * Prior to resize, release @dev resources that share a bridge window with
+ * @resno.  This unpins the bridge window resource to allow changing it.
+ *
+ * The caller may prevent releasing a particular BAR by providing
+ * @exclude_bars mask, but this may result in the resize operation failing
+ * due to insufficient space.
+ *
+ * Return: 0 on success, or negative on error. In case of an error, the
+ *         resources are restored to their original places.
+ */
 int pci_resize_resource(struct pci_dev *dev, int resno, int size,
 			int exclude_bars)
 {


