Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060463;
	b=GQ1jEdETpcDO0EvT8nin/52bi73K/QkTQwtXjqzo4JpBpFnPeUiYr60bCUNzVVTkIAJ9
	 fg5z1ZjFL+2HyfDsxjz00LEwKfyI/Ie9/NjnLlztG1eDlUKNE/LJOuYSIXcAwzX8s9UlS
	 i+Cko7zAE9IIOvSWvIVzjg6vQw4pbGxrPDUpTF5M2xXpVTJtEWlWznRl+pX/QBOyPYHCH
	 0qnzVo5V6FyHM/wOJPBB18X56K8CuSZ7DwFs1Eg8uyPmAlwUSkuU7ytG+1kSdvddjUxWZ
	 U1B9FN/Zcz+aqUdu7qmX5b1GZ0A6hPaAVvIvq0cWzyX3m+wirJZ8V9DM9lTF385uxkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JplKVH+pLIopaO7GdAL1Hzsl+manL18lOG7rZUOXXls=;
	b=PK74q6THOUg9+HJGQdFfK77TEZ/RXGhz7ox24rQgZmYEzWvOMI96dgHSin2OYVm5KDjN
	 KWNCyC7p+8uq5zl19xwgwDgYqeka2fQDTWLRbv5sL/EIaN3MWjDSl8dHbiVTZAaNztcZC
	 Lln0iV+kiR37TCEU3W9vEc/KaAkH44JGhEvoR2irqp/eSlQ5Chcqy/0x/dHRsUbMLKGFS
	 FqBhM3tmSHz4DTK8M+Gq26z1ow6t4a0KWs2of6e/uFgekbdeWOgWeVN+wbMgWY7N21w6V
	 5/KmNVPa0P48jnuo17A3pCZSfWQg2ZSRLDwZt5ktn10jVsab78FAbtjheyD9uvPqAcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mL0GXVc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E216606A325;
	Thu, 19 Nov 2026 03:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mL0GXVc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21731F000C4;
	Thu, 19 Nov 2026 03:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060463;
	bh=JplKVH+pLIopaO7GdAL1Hzsl+manL18lOG7rZUOXXls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mL0GXVc780+lwGxkkdVPqw9+Sr8MkCfVn5+N5G/3m+D2MbvVsWELiDl6DBaKixIVR
	 8maJjCKwhQcX44Z4aqcfq/+XXV38fIM6QbuztYtOMwjzk7s1ux+vRmsVUaat9Y0+Z2
	 XWv7HnVgGPkXUnlW//+onyM8PZO/xPWV4i5vBvj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1209/1848] USB: pci-quirks: Release EHCI device reference
Date: Wed, 18 Nov 2026 15:54:07 +0100
Message-ID: <20261118150010.617263546@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit e93731c29f749d5b2495a67109d1f0804ab3b89d ]

for_each_pci_dev() holds a reference to the current device.  The Intel
EHCI lookup breaks as soon as it finds a match, so the iterator does not
get a chance to drop that reference on its next iteration.

Release the reference before leaving the loop.

Fixes: 26b76798e050 ("Intel xhci: refactor EHCI/xHCI port switching")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260807024304.928708-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/pci-quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 04336c1d8dcb4..e676f9aa778f2 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -1063,6 +1063,7 @@ void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev)
 		if (companion->class == PCI_CLASS_SERIAL_USB_EHCI &&
 		    companion->vendor == PCI_VENDOR_ID_INTEL) {
 			ehci_found = true;
+			pci_dev_put(companion);
 			break;
 		}
 	}
-- 
2.53.0



