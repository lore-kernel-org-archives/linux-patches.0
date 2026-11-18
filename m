Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048087;
	b=XVVPy5R75euCX13XKr3ytz0A7IzJBv8FXxnl+aEVyF4tm6a8FkBqxoExyMAvU2XC/a4C
	 2a6j0u6yeyUxvnxW/q+tpeJohG+Z6xUywXWddyVZk1YyCiQ4bRzLeqMyJcthckOkgUAZm
	 AqXVN10iR7eSZFO3JViXbyNcO0SmuVDePupTNA+A1b9MCcwEUfjLrKWC0RaldwodK0ZNs
	 4mIg3x6TlkN+xxqmsgLGm/gpUTtdjbRs/jRczZ4QsDWyFXqN8VweAD780JA7O6cKLXiDr
	 t3Iexdhhz68xYrkeBJasR2J0A7ZAtVBWnwu1b2eCjQq8lxeP2t5csrpkmRHTGWHQAYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JhWLQsOHtxex+UEl/lvr2pvJQ0OIKz9FAOhVDyoyjBg=;
	b=UFooXqxU/DgZ86NeXroOHfjx2jMpnj9JHHaJG/JqiYOK2xU+xYUJu2VcG+hckdIHmZ8e
	 MSctduHQfXsFeeFu6bsh3v0iWD+n5ZocziQew/TRktwL9Rg/kReaUC90kChBosJbY2WJi
	 fhc+Ec/vxRaXPFhsG4BJM+Qt9Jdnqc8seI+2JSjej495/grD71KQQ6eTaHUJ764ZOntCn
	 HptIf8PGUw47p1OM2sZ4f5tYRbf+bkcS+VjhDcRu2t/Vffq6lDaDSO2TFEwYv0yklwGc8
	 wzf8GY6NK1iZVkG70DekLQYJ8xW+qlM5fu3JQvTP0OeoA89rTiA/k6cpC9GI09IM7gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyrP+XWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC527606A31C;
	Thu, 19 Nov 2026 00:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyrP+XWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C851F000C4;
	Thu, 19 Nov 2026 00:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048087;
	bh=JhWLQsOHtxex+UEl/lvr2pvJQ0OIKz9FAOhVDyoyjBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyrP+XWXsLIViWtxMMMsOX646LFs63kBMDlLq01AeYFSK8n6a1ToEr6D2vy5PkRKX
	 vmUxKPLhbmCz2eQtM72bv/HJlm7DZ+srAE2IhgR3mdHiHi1K/WSEJwQiVtZ4SJHt0u
	 PUwKDQLdDhyQLrn1hsjZW9t4EHeGMt92BFvMT0bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1871/2857] USB: pci-quirks: Release EHCI device reference
Date: Wed, 18 Nov 2026 15:48:25 +0100
Message-ID: <20261118150308.608467950@linuxfoundation.org>
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
index b96d9062a0837..554c910a49304 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -1061,6 +1061,7 @@ void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev)
 		if (companion->class == PCI_CLASS_SERIAL_USB_EHCI &&
 		    companion->vendor == PCI_VENDOR_ID_INTEL) {
 			ehci_found = true;
+			pci_dev_put(companion);
 			break;
 		}
 	}
-- 
2.53.0



