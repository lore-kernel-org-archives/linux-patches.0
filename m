Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043632;
	b=tUtHfTXzQ1g53pmUe92FxZFvBfOJzk+9IBNM6tCG2z/pcs4I+QtKQ6yr6LooH7GwFmfs
	 hSO8U8lARWAZOLciV5hCvjsBES+w7ILXZ2mO+hGO1SGEZ19r3vSh9nMcB1Srb95T0M3Xf
	 zem8IBJWHDuFFNSHAQ87D/tHI+nnEo1+UXpFfvHsEyBRUfOe1DzHzCiU9MwPFlIRJRaCP
	 XoMEG5oz2rrhYM1tBQ+zXEEw/vrdqQC8DQ6bGzCap47gMv2OoKlqKXq4narhWF1uOSpNN
	 HhfjllmGEe1GHa5L3w+hM5gjALElpyjzQGND89nLfUUaL9hiaQgA/EZp2XS+0L407/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yQxCiPRVDHMPTR1cgwMQBovrQQQRv62BSacKZsLAtgg=;
	b=HByF/j2CoQQ6pjT3o0zBDFN/YJEmX7NkmCq8GNu/wjIuE2Vmb6joc+JH3rjPWplUZNOP
	 8fcCCXEmcEk6xO8fErMuKsVNIR2UfV9sAgAy9Xe3vB7bEniFwDJdecj3VHX6Yx+ZZVb/u
	 APGoKvFuAJtM5TmYJJ14brpCJ+UrXmJNAu3nhplxTOpstwatPlDf5upwOeyPEGo+sEgwl
	 CzQy3Qet0/O+nhws416U/m3egUdJKqK2vieukcvDRy+nLEA2SIMbalHFyi6bP4r8xNbMw
	 XL2bjqY0ijDEdi9PyvIWB7hNLBIUk4B/04xOoQhiFHxRcAqtibr2Z4K26gzi71HiOog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PTLz4/6Q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12660606A338;
	Wed, 18 Nov 2026 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTLz4/6Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6346B1F000C9;
	Wed, 18 Nov 2026 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043631;
	bh=yQxCiPRVDHMPTR1cgwMQBovrQQQRv62BSacKZsLAtgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTLz4/6QrBXzLYPNlgUyYm85ZwYsD1+RFrT4iAkuh9575ftZ+pnPYVEPClOt4Z5Y0
	 p5pZZCst75Jip+THCIFDu571ewxmQwisBK1+37tpH7S5UVqFfJk3Dh8D1W8jB/OmmH
	 +nVq/QBqUqesztJaFefdscsHFDhjKcXfmXLBQaYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0238/2857] PCI: Avoid saving config space state if inaccessible
Date: Wed, 18 Nov 2026 15:21:12 +0100
Message-ID: <20261118150210.018794648@linuxfoundation.org>
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
index bc0588b5da732..b5b750119c8e3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -776,6 +776,28 @@ u16 pci_find_dvsec_capability(struct pci_dev *dev, u16 vendor, u16 dvsec)
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
@@ -5198,6 +5220,9 @@ static void pci_dev_save_and_disable(struct pci_dev *dev)
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



