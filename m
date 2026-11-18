Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039676;
	b=yfZNaUOqg3mieHCq+NZ3gl0QMU603VgQpwiwI0YrBqeZIAL2Q9qRnCSTpw7M9c8oKz3G
	 3aMA/A2BpTCPmtjPPFNPWLrbfqOuzAphVzfx0HehVuQHlXG965CKmo7mlFOdcWf3ahTlz
	 RQzhfzqqrmuFiynWlU4BexitEptJ8MJimqvWMDFc35+/WwppMmJBnzJSZ8YRsrwj+S+Z5
	 oVr+NgEx8xjE9wiqgH/bvFTjDNXDYGhDaFRADxR0MACeOGfoN1ofK+GErV5qQpSdllj+P
	 NA8DiB1E8oUjcwFpX8I3wD8+fAKUXc3y79GJB5x4U3HuOHyVzKrm3EtIePqx+shosHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wF/aj3mNnZaUEB6QKsO93o+ImIZqnKO592rxTJrJd/o=;
	b=ehRZk7AdBlhdXCgwGSIg/uyuL6Ubv8Ps3cNMaRXOH6l9pi8fpIwkB/folaBQRm8WV7F0
	 z8M0h7JWyH3yCNBssTvw1vMQbju3qQAGiQgT8FDx9VNTJ/HUIeysyibs7T/kzbNlVpl5J
	 Kyeuh3CK5W0FGryOcdFAHcwXFb9FpZKTuyj3IkGY9yrUI0JcE/q1oPIABXwyUQUewc+zC
	 aqC52HfdabNy+4PzPmgSB/qCAIsVNrH7lDPkApQWOEneEWa6omBe5N5nPuwAsDHFFCsdD
	 /Wi+KbhL2MWauVYROH5ZMLRuiJRyiLzDeLGiyXIEgmxaUbLsJrAbPLd9cSFeU/JGRBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTn094YS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7219D606A331;
	Wed, 18 Nov 2026 22:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jTn094YS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FCF1F000C6;
	Wed, 18 Nov 2026 22:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039676;
	bh=wF/aj3mNnZaUEB6QKsO93o+ImIZqnKO592rxTJrJd/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTn094YSMSVsGv2hckcIFJ29nIYkDYu4v8667zsa6Y/tfbcxy1H1KaCZWk/9zexHw
	 LQmBeWLuOutkFOWdVspacN+05X0CXgL/BO9DJ6V1V+ADDZCmJAEIHGakuXwQavdMau
	 crLRETgjz/anZIAxr6mpP1CmeSXK+2aeugegAYUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2144/3318] USB: pci-quirks: Release EHCI device reference
Date: Wed, 18 Nov 2026 15:46:06 +0100
Message-ID: <20261118150426.369614400@linuxfoundation.org>
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



