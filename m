Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773946;
	b=S9OFn504ZGx6T8B1qDEalyZ0LLE9Cf03lxuliMsbeYXuXZ1bVS56TxxKoCtmSaYEINHf
	 9qCPIxEO6Ukn7uaqe7e5RYeRauUsxmEqWIbGkjYbkmRocTUwd4WsLrTPkUxWLayJd4UmU
	 LiQxBr4O34jpWOYH9pGavRCsi8Bm/c8QrvFb7vzEYhsZnxmlJVeiXsbOLANyetV81k8tM
	 FXHLkTdJxzOYCgMVBrnD14UvmGAIevD5bpiwlHB2oT/yw3FmFgBqPSTgAUFg60ENYH+YM
	 FviwPOQR2Yom2NthLCDmyGkkBuQHKMfazjBD6YzIbxrocXsvkJcTwrKRZH1Jyh3PY7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iPp6TyqDB7HK84LAXrVeC8oZA8tpXaWh56uTvKkxHmw=;
	b=ej7KW82N6bq/ko4iGwJILNvG+LMAUd417vAq6Dk1WR4nhfKovZyVSrjPEMcwc05iYCel
	 msXF46odmpu/gGwouak6O7W+r/UQF15eva+zIFv7WELL5VALMMZ+OPrYz6aqC04zzBHI0
	 eWH8qHXoBxG3Hwv/0lqoExCXVLCiguEkM0luLyPYgpG5rdvSW5O4LIOrbNicPDRqorhnG
	 7KP8SNxZbO7pGSWmY7QbVAH0sK6d1dOlqQPJUGe1hellAbWkNr6DgqFDw1287mUs8kxmG
	 ns/XJpiMeJW7kvH/DPEb6twAS6dlxxUBmzUCVPAxtW5Ib9fSc54TVCNDW9UTMdoDrdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWhcCRfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DD7606A31A;
	Fri, 23 Oct 2026 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fWhcCRfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158791F01825;
	Fri, 23 Oct 2026 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773945;
	bh=iPp6TyqDB7HK84LAXrVeC8oZA8tpXaWh56uTvKkxHmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fWhcCRfdUKLSthn5I7fWkqjGTCZJFDbennnSgurdUpkXi76tDAuqxLrGpyBKyDxtv
	 FF/2+likxvq0vbhH3sIdVY2WuekWOL54wdPcB2pRLSTf4+bR44hy1dGB10mLfLjQtB
	 NgVnfjHSsyHNYeC2WfLxG6IInyURuCzfgIJz+9c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Alexander Gruhlke <gruhlke@mailbox.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/193] PCI: Dont treat ~0 as ready in pci_dev_wait() with RRS SV
Date: Fri, 23 Oct 2026 18:35:47 +0200
Message-ID: <20261023163715.859884116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index 264213aa7630b..78d4411e3255b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1227,9 +1227,11 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
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
@@ -1249,8 +1251,13 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 
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



