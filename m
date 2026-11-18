Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055923;
	b=dj5gFdn92lVI5MY3DVlCyQZNtwQiSUDiwWHGABZd89JRX2em2rVg9y9bDhzHBDPPqobI
	 ZHY2I+fXmzLMy+2rVaaZQYkeykqNjgSzGUpmAIs1b/0+NYr9Pb1eMC9VHTiO21SOCw8cQ
	 hKwIuVPZIsrfDZ/O6OpwP9xTmfNtspOY/wZVQgwQc0EUhvXzjCJHRjTcUVydnJH/Eg3RU
	 OXM7I2mCiJNBRbtsXvIWQ3yg2j4pI1ndIjW/yFPtaigW9v0F3O3BqJNeMM7De2Dw3Lw1K
	 pq1DQVYxkMK5mQgAvGFw3yjL+y0o0oiepkvYMld0bKpseqTRCBk82BMmBCxuA1D717Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7SXQ2BGJCCEezEiJ5tdzP+PZXW/1obqdzD3249PDp1c=;
	b=3d8pKtRS9bTQ86mHO9hK3U7ik0+uBb4F2lL8W20UuJ2mK4Rz9kOe/lIiiBKgXlgtvHV2
	 s+Vq1nNERVrBRMHcj6UK99Mw5vZfYC+yWY3t+8pBck+tdzdPV6+H0WJJ5IYaRruoK3Gz5
	 LW2KipPl5omjr3eUu+a76G5MnRen40I07vPZoJHbZ1BRM/WtbF6cAO5cAuGtnL8pYpN94
	 XtVBYMH9ybaecBXs5+5yXT6niGUMKdtJdEZSckRcOMU+ouLkKo3Ay2L34t3yFwV1eLbKm
	 XCmycqWhuwrgMksd9SpgtguLgp3WZEj2D9o3CJHFZuq46/WozIRGw3LRTIMAy1QZBaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RQ+kTM/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403E6606A320;
	Thu, 19 Nov 2026 02:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQ+kTM/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913041F000C4;
	Thu, 19 Nov 2026 02:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055923;
	bh=7SXQ2BGJCCEezEiJ5tdzP+PZXW/1obqdzD3249PDp1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQ+kTM/OEL+WfPoC+VZVdbsNo8sRkfgrERsqpq/rv9UMRID87g0W4bFVz4AcRWZKZ
	 2abSD6GXb1/l2YrfNdAgzUKfEYfMiPBvyMaxFcWxuAXTtWc1BN3Ra5nNsWUY3gyyHP
	 PQklkbLvIkRpnwVDfneDM5PO3elUkzbz/lDtDRuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1803/2214] PCI/sysfs: Stop reporting _DSM failures as -EPERM
Date: Wed, 18 Nov 2026 15:57:59 +0100
Message-ID: <20261118150123.629279044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



