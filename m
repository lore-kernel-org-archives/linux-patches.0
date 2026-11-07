Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060974;
	b=kcuU6UR39G7xwmwrX96VTekjCs9ner0D6RtxCT1iDB/Xm1oCJbzkP9/gQlq2w645KcD1
	 n44C2w2cbcXM7X7sYDgO4SJruitrP/LTtpncAtA1Snig1jPtoIBnFfMUZFN3BIWGDCX5k
	 fdVs3U1Fy5ufC8T5VaV7Kx2l9wihz8RmLssatvPaolmwjy/5p6msOonPgG4oLsfnbXvVR
	 uSrZu7taWMZGG3giD6o0AxARee9KTGsoHM1ypWXCFwI4tBKG3ITkEZ1JHsaGUZs5k6fSN
	 0tU3LNP//2whdIJ14W6Vy9fMuFK7/4xWejv+kUy2mOLq6k8W6c+i3dmBzwJsO7d6QUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtZcXu7QsekBo1FD/lNjLdZZOw2gD3oDjMdOZWMrRmM=;
	b=qEZckt8lpHkWBc5CdDncpjAzveqmy7HWuYDRdrTcaQ5LK79maJL97PBK4TtjROPq1G9s
	 Uzqqg7h6uTwcyzM/QCDNyHWhgQIsCRVKrcOGYOAHvg1dPaY+nkuPGlyZojEA6FGIJXHBy
	 mcUNf6P/cJMICEw55N9SFwWg5kk2219JKJ0CoR2LFO3usH+D7KgdiVjf5oTBBayB2hh8g
	 CV5q/AxKmTwYYhrxcApmo6yRg6/96R3z7yZdumOeVZkWG/pliyslrmP0GqqBVj/ekI95T
	 fdQ/GelKRG/VnM6WCidzxG3kTTzEDF7DXafmQ1QE2hlkH6+9mg/0SHiwJlv8JRpmfRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOJfaLGw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787D606D82E;
	Sat,  7 Nov 2026 14:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOJfaLGw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A351F0089F;
	Sat,  7 Nov 2026 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060973;
	bh=GtZcXu7QsekBo1FD/lNjLdZZOw2gD3oDjMdOZWMrRmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOJfaLGwiOweyxBnvHHILR9OQez/PGGx3sLKKrjhOKzMwNqUxg3KPUMWU3u7hE4r8
	 VjrokzsuYznwOE3NJd0gMGHfqRDH7dJZ9u33PLX/XPrHoy7gv+Xlq5XnyjZKUvKDAk
	 o0DmGZed8tkf6+QUGKFVO+weUCwlERTulcfUcIAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0326/1536] PCI: Avoid saving config space state if inaccessible
Date: Sat,  7 Nov 2026 08:39:02 -0500
Message-ID: <20261107135006.868982250@linuxfoundation.org>
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
index f96801d1c833f..296f28073ec56 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -782,6 +782,28 @@ u16 pci_find_dvsec_capability(struct pci_dev *dev, u16 vendor, u16 dvsec)
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
@@ -5085,6 +5107,9 @@ static void pci_dev_save_and_disable(struct pci_dev *dev)
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



