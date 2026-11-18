Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025925;
	b=VAXMFmU5HBvXF73qah0PsQNPAY5Oj5mN6FmHAYCHhJVRNyszrTa7b8xyZ5cGic5fgrz7
	 V6q9ug0pjT/OwGBpuByNptFf+S8m2yS54nTFZr60ju9l05wdtUQ8Rlj1j5GbVbkdCvuc3
	 jZimvLh6mjQhZcM2n0U1GmTl/Z773EMR0UE2tkRXBZ+kmECBfnzCP0g9H3jeSmjMeuR68
	 FksauGqm/mpbdK6eD1I11ouzH8djh7zQJkYVfH8t4ZV5XHx9Se2D560xnXL/SRty0983O
	 +EIUmJ7L/mojagQmaCmNYQHSRy7nwcHUKCWp1aQ5DgcVRezBozjae6UJNAkR2scfkAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f0lFDF/t3h45HkOd/BsosqcmlR7F4DqVpqpXL8y7JM0=;
	b=jyEekaUfGEZhqldqh8zTVJnSZOxMsV3kKiSKm/90qAgloqb6oL7cpvA/N60m0L5rVHlP
	 ZhPc7Nvvs9erJjQ07ZRla1/fxoH4LWgU/8Nm4q7VupVYg/bF2rhKOFhePQX+x5F5o7Vt0
	 ZB4nF7IwGiMOobtyjBPFeck+fKNGZheM054X9mkP/ZASJGh7EpZvPbCnWe4npoYff3Z0L
	 dGmTC3x69UML0OytyxpFYm4/r5UuKeQiGQLTGQLRenDnzzYRtkN8RctuCC40L6Mb57s9P
	 vHQSJU2T/Bwfj+D5KNlAy99AoOVXdNZ0z6ZEm/POfYhn1yoJrnkFkBr28wAU6ESCdNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="X/YtRI/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AA0606A335;
	Wed, 18 Nov 2026 18:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X/YtRI/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC5B1F000C4;
	Wed, 18 Nov 2026 18:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025924;
	bh=f0lFDF/t3h45HkOd/BsosqcmlR7F4DqVpqpXL8y7JM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/YtRI/4jgoY8Yi8PBzeiFUOvXrgrTxlZMXioLb1TPNGAhpDnT/LK0gePgSgptxH6
	 ddohLQs6j9X17eC3EduM3SGdkyQtenAoDjsmPQGPiJrvF+isgQ8rQ05v2fXitS6F7H
	 i6bVL+u5+Uo+0rI5XVCBKTAL1r3GVbmet27Rhdcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1253/2151] PCI/sysfs: Stop reporting _DSM failures as -EPERM
Date: Wed, 18 Nov 2026 15:49:48 +0100
Message-ID: <20261118150207.806932753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



