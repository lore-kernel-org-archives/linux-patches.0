Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034177;
	b=SDc6zc5KVEpFXBFJD3B0GvAlpEEf8nw6U9BM5XRAr6xMQc9RkSQoSupOx5TOs98d/Dn8
	 nMbK8wCNKwnTWUlhQEI+sWy0M5c9U7BwRsUiBtFslGSDNnNFAdLstdK6CtHfFFUQrYz+v
	 uHra+B8cTwU5aFH7nwK1EymXPjpR2EbomW4bxBmPVrK//IvDTrIon9XiRBWIAayqChUX9
	 IW5wk7DNgD3Rt/joLZlRTPKk8OjwP2XirQUW6Vi0xQ6u98tf5FuqMxMA9Q8kA2n1q9mMO
	 Q7GcVeQbiXpLoMHuIZDDIQnsL0dJGpQpua0cN2ofrwsxrBDCm8Wn9NsN6xSaZSm9AEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzL9FrMtMmxsR46CTyIUc0unDaI4OumVkb3QbYKNclc=;
	b=ykAL5WtYwYn3KWpLL7zaCBYzTWUI+9URdtov2nhk57e4EzI1bxGeTZrzgk5yd74pW6IX
	 YLbWeItOBmfg613NAczZ2rieSBaO2dAy8RyrhfAH4rn6tXHbIYihAIRyvGmq3hNJFHRjc
	 xmzrKeG3mKNCmEgpa+YDAkWHWjDYlvOeBV4s+HBVgMnoF3jf4Q4NMNnlEoSSsezYFPuVm
	 XeVUxWPhy91hC3BwiC6VuWFgcPOibdW1eOsPVbyjhU8UpTC8vMGk+760IQt8yx7vxBp1X
	 9HLnLOv0j5cw56YRxM84/vv5MwYQcFVL8okn+4rHuy2RRFByonPo5N+7Sy6UUj+ELyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNIyTJ6w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAD6606A33F;
	Wed, 18 Nov 2026 20:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNIyTJ6w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707E41F000C4;
	Wed, 18 Nov 2026 20:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034177;
	bh=BzL9FrMtMmxsR46CTyIUc0unDaI4OumVkb3QbYKNclc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNIyTJ6ws704pJdj4D+NJZUVBT2PovUv5luTqAAR8l7Qp1Ut5vexG2I4kH2pwMWbr
	 lJ5XUciMHqOGQzhL6kBsc5H8/MbjRAdasIiYWcYVIq8duLz+JBAggYPhVabmjkNyDr
	 J5e5ks8H1PBzYOQEwGtbiQ3cKWQoOa1CHI3hmgDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhan Ali <alifm@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0276/3318] PCI: Avoid saving config space state if inaccessible
Date: Wed, 18 Nov 2026 15:14:58 +0100
Message-ID: <20261118150323.768720167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e8186da64463b..ba6eccd699ef4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -783,6 +783,28 @@ u16 pci_find_dvsec_capability(struct pci_dev *dev, u16 vendor, u16 dvsec)
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
@@ -5334,6 +5356,9 @@ static void pci_dev_save_and_disable(struct pci_dev *dev)
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



