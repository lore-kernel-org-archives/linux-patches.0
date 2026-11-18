Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049420;
	b=X9LsnJrWRvf3Y3/8PjZFU1R3nWTDuhdwWpozcqKLKRTiFw/T26TPC9gdqyc1E3QQfey/
	 UL6d+yNVLzxauNOtMEfKHLEYS/MblmWr0dJpaAjkCnZwMSFx6g5810aW4PGn3XPpkWwdb
	 f6rmiVHHibmi/gzkWFUV0GYynRrHnrG6WyJivaB1AkGHhHelTaLLPq4o6Zm2Uu2Cg99j9
	 CluA1hOTwX4I3zdkJrPVwR4zGRE7eP4W5gj+ZUm7PK9+1B2fQOozUokEAKJ/VAbayjvjA
	 ZtBLa7FqoSCsIlYXKVyzVwZqiUxpreNWT+SP2z5OwkGKXiKOWlfma30lvQoNiPh0/8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0F5RwfPDnYmx4mX2uILW4WZ4+W/V5NjyScz/VOTir0g=;
	b=x7jLpfTkCsdGG1CeC5d/5oQKySgOrZpSw8EC4DVYz5bW4mPImFWofQwntr+TckTtpY45
	 xUBw3UbsFP03pUrPK9hG9bVRRyRqGXb9GZWbx3/USsp4PxaSkKGWsjatp/TgjUZ5oJGFk
	 +nWIjIZx2XWuGkmWmadqzS5TIquxd6N0KGc+peasJBYGeUFjcb7NhuHRyyyoLALkdfheH
	 xXnNyakcaicJ4sbrJl5UH6ayCshhKTMxNs+Max8VBRhdcaWkWvLRHuYojp+b/tcy9zzMJ
	 BbTOmUnIDQPj5HfofKDLOhT4WlzDlZzB0mlgvSkFhkBDHN7EdJHztJmZV/+Asli/XkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpEM1MM5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECAC606A31C;
	Thu, 19 Nov 2026 00:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpEM1MM5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625491F000C4;
	Thu, 19 Nov 2026 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049419;
	bh=0F5RwfPDnYmx4mX2uILW4WZ4+W/V5NjyScz/VOTir0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpEM1MM5GMCs8hhI4QvkCGvWd6BLkvTV4nj7wQTl6ANCuOG/XszmyPRkMfUidz0fi
	 Q03pLgV2e0in1HBF2Tk+1329YqT9JPJKwhVWmjNeTcNyzwpB4mFwFbW1OCKpgxzqjU
	 tDNQOFhINH2yKr7Ly56/TZBbx9DGdcsQUlTuMDvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2318/2857] PCI/sysfs: Stop reporting _DSM failures as -EPERM
Date: Wed, 18 Nov 2026 15:55:52 +0100
Message-ID: <20261118150324.993116058@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Wilczyński <kwilczynski@kernel.org>

[ Upstream commit 36f9bd09920ed71c1b79db397170412b2de22319 ]

Currently, dsm_get_label() returns the literal -1 on every failure path.
The sysfs read path passes that value to userspace as -EPERM.  Reading the
"label" or "acpi_index" attribute on a platform where the Device Name _DSM
returns a malformed result then fails with:

  $ cat /sys/bus/pci/devices/0000:00:08.3/label
  cat: /sys/bus/pci/devices/0000:00:08.3/label: Operation not permitted

Nothing in that path performs a permission check, and the read fails the
same way for a privileged reader.  The error code points at a cause that
does not exist, and tools such as lspci report it on every invocation.

Return -ENODEV when the device has no ACPI companion, and -EIO when the
_DSM evaluation fails or returns an object that cannot be parsed.  Other
_DSM users in the tree report such failures the same way.

The set of reads that succeed, and the bytes they return, stay the same.
Only the error code of reads that already fail differs.

Fixes: 6058989bad05 ("PCI: Export ACPI _DSM provided firmware instance number and string name to sysfs")
Link: https://github.com/pciutils/pciutils/issues/175
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260814070522.2327975-2-kwilczynski@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-label.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index c224619b9a266..17f1bc0cf458e 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -160,12 +160,12 @@ static int dsm_get_label(struct device *dev, char *buf,
 	int len = 0;
 
 	if (!handle)
-		return -1;
+		return -ENODEV;
 
 	obj = acpi_evaluate_dsm(handle, &pci_acpi_dsm_guid, 0x2,
 				DSM_PCI_DEVICE_NAME, NULL);
 	if (!obj)
-		return -1;
+		return -EIO;
 
 	tmp = obj->package.elements;
 	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2 &&
@@ -190,7 +190,7 @@ static int dsm_get_label(struct device *dev, char *buf,
 
 	ACPI_FREE(obj);
 
-	return len > 0 ? len : -1;
+	return len > 0 ? len : -EIO;
 }
 
 static ssize_t label_show(struct device *dev, struct device_attribute *attr,
-- 
2.53.0



