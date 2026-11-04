Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830902;
	b=jteGbaV08pk3GKiuc3YwfGaVSBt6smDf4b4YmLD/s0ougKEhMhbC/vtpU6XeAGzGI47j
	 FBBCfCjS3/IO/zuC2Og/auq9/9/AxAz3fPljReVxQTDz7Nf972jQXx8LmXPvwA+U30HWB
	 Kx/I4cZcFliIlo9Nuffx41v2Bd1kO8sIpamwi78u++HN1kgCEUmPG/7/FtVH+1r8fti1X
	 0R882lZjiWFiTXiHf4gYCT5vGGGMxRE5qp26nTbHhYnBwRIDtOw8b7tZGeY1uqzTH6W2D
	 D4LhrNu1HSMnn8B4h1QFjTNf+aDPol2YrxaJ5ar9T3LY8qDggQTnHmBzAlY3jCC7FIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=350+S1fnDJetBn1sPDFyDdacBwqmK7KHFtAnxyLnG68=;
	b=H9fAkn0wvieUcoQr4CyGXRrGj/xCG+Vi0RnfRhuDNp+t8V8yFVc0pknB1L5OeWjtlA/Y
	 2HQqkHXQs5/oy8Q+MgZZ0YobUSZBevmohJzD89PLuk3WGahezCbYN5eGBPZ8iG8Ponidf
	 7agQvD/GnoacW8kRKAtzPLU+P5ni9iYA5ahhJQT7vGZRfxhVIKzKv6dngL6+7UPWcvOpG
	 hTUIpBdl9a9zNfOhUNE7/oP6DcH2Ej12ml4K1akQFcJjxG9BwzvH0EHFDQlyraVu0DSIC
	 C2gV5/fp8lUB7P07LwYINHy1yvwJcHJw2dWVdBrR/Atvlm5iz5C3qEs79rvhr3Ow1dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mGl/F8oY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62596606D81B;
	Wed,  4 Nov 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGl/F8oY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702AA1F00A16;
	Wed,  4 Nov 2026 22:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830900;
	bh=350+S1fnDJetBn1sPDFyDdacBwqmK7KHFtAnxyLnG68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGl/F8oY0I3Y0zsREsq3sYYaiOO6LNu9x44nGqAgkFsKqdiDA/5HN8NjXJZpx5mY+
	 lzinFtkIlP0shnNNeVUJWGNilem32nWKLPiA/nHST68v9+I1e3HvxBw+ckFFRsC2Fa
	 uq0uFr5ZnRE0z4JFssuuoF2NcG+W9yCr3+8007Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0391/1005] PCI: Avoid saving config space state if inaccessible
Date: Wed,  4 Nov 2026 16:02:04 -0500
Message-ID: <20261104211055.032763039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farhan Ali <alifm@linux.ibm.com>

[ Upstream commit e18d1abc3bff0a24a5299f3c150ab9546e9439aa ]

The current reset process saves the device's config space state before
reset and restores it afterward. However errors may occur unexpectedly and
it may then be impossible to save config space because the device may be
inaccessible (e.g. DPC). This results in saving invalid values that get
written back to the device during state restoration.

With a reset we want to recover/restore the device into a functional state.
So avoid saving the state of the config space when the device config space
is inaccessible.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
[bhelgaas: comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260805165518.794-4-alifm@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 78d4411e3255b..bab3213bafbda 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -725,6 +725,28 @@ u16 pci_find_dvsec_capability(struct pci_dev *dev, u16 vendor, u16 dvsec)
 }
 EXPORT_SYMBOL_GPL(pci_find_dvsec_capability);
 
+static bool pci_dev_config_accessible(struct pci_dev *dev, char *msg)
+{
+	u32 val;
+
+	/*
+	 * If a device's config space is inaccessible, reads typically
+	 * return ~0.  Since Device and Vendor ID are always ~0 for VFs,
+	 * check the Command and Status registers instead.
+	 *
+	 * N.B. This is racy because the device may become inaccessible
+	 * before the next access.
+	 */
+	pci_read_config_dword(dev, PCI_COMMAND, &val);
+	if (PCI_POSSIBLE_ERROR(val)) {
+		pci_warn(dev, "Device config space inaccessible; unable to %s\n",
+				msg);
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * pci_find_parent_resource - return resource region of parent bus of given
  *			      region
@@ -5016,6 +5038,9 @@ static void pci_dev_save_and_disable(struct pci_dev *dev)
 	 */
 	pci_set_power_state(dev, PCI_D0);
 
+	if (!pci_dev_config_accessible(dev, "save state"))
+		return;
+
 	pci_save_state(dev);
 	/*
 	 * Disable the device by clearing the Command register, except for
-- 
2.53.0



