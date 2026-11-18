Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061394;
	b=T69Aexu1jyCPT2XOe5buK+ncSj0kIX7EvvQZGXm2z+Th3gPrs6nQeWMCMffQJu08+5ph
	 DUpWZLAXyRCAKRmz+oiZzDL3QB5sJNxltOxJ3fiTvjH40sZSF96pqKuN4QLInaGVLz49d
	 L/QuF6c56d8vMjYa23Sr4BNJh79pcABdZofMcJWpnPz5pQZOzG0HUT7sX4sd0fKTaC5qD
	 vyFht4JQalrJ6X7Uo7Ga7XapXu5HyerawhGD7fzV8vog5UCPdbZ19WmXExjnxZhkbCwQw
	 MeaFZFJXiu84sqwRyrBFTXtjRkpQhJew9CQSsJSrQYiMkiN2xwPNuXKzYsRTsi3z1hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vg6qnVDNgCPeW03Eoi3k30ShyrCxdIITicEuKIi6LUM=;
	b=MlMMb9ktGeBhq7Mf2xPIu0Z3ivEXrxhVTzqwKyAuHQiRxLNRr4TkJJ6e1iHeQ32/At9x
	 McKQ7kqTP67EE/Rb1b46SHLw7M3wHEFfFhPLwssqTEKoMtGB6eCXxZYkaFt9+NiJin7uZ
	 MsklZVj1n4jymTwGtNNQtAMMfwV0i/19xFIhvRNbb3ny200geNDa57zVE0CLkJZp7vFia
	 XHThtsj2FluKJ0tvU0LGs8Oic3+dvv9p6/xeuGUwPUj9CbzOXmzoVBt47soibMAoAppV3
	 lqb233LuGKQ4Gr1c6cBpkjYPpE9P5G0LpHLX0WLQMVsTvze1XRlsLpgJKNyJgYz9luA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+kSDI9t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93A4606A320;
	Thu, 19 Nov 2026 04:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+kSDI9t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0911F000C4;
	Thu, 19 Nov 2026 04:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061394;
	bh=vg6qnVDNgCPeW03Eoi3k30ShyrCxdIITicEuKIi6LUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+kSDI9tGuS12Veu54Sp7h9DTVqwD+KHU5UIxJImgfaPoGtQ4haS1yE2zAwOn94JZ
	 ZsOP3Kj61LlY1k2vLC+Rup2f+M+wDqTygcQhoDxNMT4EpbLObNI7N9cFyHpQLjcQIB
	 cGvM4ifrPRYSLh3f6FzL7CiNLbv3WDCmqa6jzlzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1536/1848] PCI/sysfs: Stop reporting _DSM failures as -EPERM
Date: Wed, 18 Nov 2026 15:59:34 +0100
Message-ID: <20261118150023.813723499@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5b59b1870f3f0..959a277d5ddec 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -176,12 +176,12 @@ static int dsm_get_label(struct device *dev, char *buf,
 
 	handle = ACPI_HANDLE(dev);
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
@@ -206,7 +206,7 @@ static int dsm_get_label(struct device *dev, char *buf,
 
 	ACPI_FREE(obj);
 
-	return len > 0 ? len : -1;
+	return len > 0 ? len : -EIO;
 }
 
 static bool device_has_dsm(struct device *dev)
-- 
2.53.0



