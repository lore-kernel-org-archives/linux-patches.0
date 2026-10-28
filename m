Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207565;
	b=R+4yiQmixMmptioRZliGgCvGrMKPXXS5zgFhGa98WVC839aye/K4HaZy6XzbIiDWjyW9
	 4mwdFtUjyF0zcnFYrl4FmA1FKn5rDqPOKJlrm+FivF3EPhtHgBG+pJq+WgkGx7K8eUJO0
	 AxthuTLA7rUQc2DzcM2v5/qnefX9BhDcgpe/UIfwgJ3W822iGWPJ7OY/HDI686ktdvgQt
	 Fjr0s7XiuQoen22kKF0dGohzdVWPrY+odu3INkqWbTHQpY3pgrKMhrmGUgOxdGtasDMSs
	 VPtAO5K/DEujChIPiQ1c+WJwh4YbNT9NGd3HaPrH9KgGeE20IPHP2Hex6EMJ4Ltulvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A/cdsaTjK4M7gaa0vpHiQo6CXgm8fikygOQBCV/7Bdo=;
	b=OrI6rlvivEBsqGxHI0ZMqj4EWdriU2xXd3GQ22Wu1NOXsTOQ7xXaSJ04gXR0MicQGRyd
	 i7g4PjITJ2yIFK7VMu3/KdnRFHQMCDeQ8qyYSKSjT4BgstDY5d3E/2BwrIWH1tnbfhMUh
	 NWapKp6NRv3fBVvvyXTOH7+xOSe8ylYJcDZcZQGQ6W4CvLmfIks7+8WhsufUYj0sH3KZQ
	 aSNjBEN99pGLYTvtI2DOzb8MbRVVcH3EtFHRZJzksForFppMJKLoswhidIE2IAPk8x4eL
	 irAIJAE9YvmwRfSBSaso0UcpaCK3E1YXxRoDJRHnHXp6eEBWLuwp4hGBFsKHj/X5sCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbqo3WDS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47222606A31C;
	Wed, 28 Oct 2026 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qbqo3WDS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D421F01825;
	Wed, 28 Oct 2026 17:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207565;
	bh=A/cdsaTjK4M7gaa0vpHiQo6CXgm8fikygOQBCV/7Bdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qbqo3WDSoKc2ELZK7HboY8KfOxQjp4d6a1t3oxLJaLrGvdaNpVknEsc4h/ngVtPax
	 960lilnymW6SKf0lkkUbdwIsX5PkNfcoZb+8Amq8gpz/O7D58tzfs1V/IP9UH7Ifrc
	 yiTOu2ZmLND13f7R+/EG2566qw2VbSf/VqNxO0+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Alexander Gruhlke <gruhlke@mailbox.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/247] PCI: Dont treat ~0 as ready in pci_dev_wait() with RRS SV
Date: Wed, 28 Oct 2026 17:57:44 +0100
Message-ID: <20261028165948.826282436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Alexander Gruhlke <gruhlke@mailbox.org>

[ Upstream commit e8df1d194c39b7a5159d570798941851f70a8668 ]

With RRS Software Visibility, pci_dev_wait() considers a device ready as
soon as reading the Vendor ID doesn't return the RRS value.  Devices aren't
required to respond with RRS while they aren't ready, so the read may
return ~0 and pci_dev_wait() stops waiting too early.  This was seen with
Intel [8086:0a54] and Samsung [144d:a80c] NVMe SSDs.

Also wait while the Vendor ID reads ~0.  A VF's Vendor ID always reads ~0,
so check its Command register instead, as is done without RRS SV.

Fixes: d591f6804e7e ("PCI: Wait for device readiness with Configuration RRS")
Link: https://lore.kernel.org/r/20250611101442.387378-1-hui.wang@canonical.com
Suggested-by: Lukas Wunner <lukas@wunner.de>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Alexander Gruhlke <gruhlke@mailbox.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20261011190145.23621-3-gruhlke@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0d33b30ec2f67..f96801d1c833f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1312,9 +1312,11 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 	 * initialize.
 	 *
 	 * If the device is below a Root Port with Configuration RRS
-	 * Software Visibility enabled, reading the Vendor ID returns a
+	 * Software Visibility enabled, reading the Vendor ID may return a
 	 * special data value if the device responded with RRS.  Read the
-	 * Vendor ID until we get non-RRS status.
+	 * Vendor ID until we get non-RRS status and something other than
+	 * ~0.  The Vendor ID of VFs reads ~0, so check their Command
+	 * register instead.
 	 *
 	 * If there's no Root Port or Configuration RRS Software Visibility
 	 * is not enabled, the device may still respond with RRS, but
@@ -1334,8 +1336,13 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 
 		if (root && root->config_rrs_sv) {
 			pci_read_config_dword(dev, PCI_VENDOR_ID, &id);
-			if (!pci_bus_rrs_vendor_id(id))
-				break;
+			if (!pci_bus_rrs_vendor_id(id)) {
+				if (PCI_POSSIBLE_ERROR(id) && dev->is_virtfn)
+					pci_read_config_dword(dev, PCI_COMMAND,
+							      &id);
+				if (!PCI_POSSIBLE_ERROR(id))
+					break;
+			}
 		} else {
 			pci_read_config_dword(dev, PCI_COMMAND, &id);
 			if (!PCI_POSSIBLE_ERROR(id))
-- 
2.53.0



