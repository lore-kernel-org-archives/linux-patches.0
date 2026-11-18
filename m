Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054927;
	b=3zyQYDs2+Gnlx4UISq3lK90z2Z2RY8Csih/qlWDAOBt19l0833r7uMN+hWjRMBQXwku9
	 plxYwTI7LGlNBRfpTWczspSI3tyt3IBB+xUa5wGlbv10fe7SG0X6X6Rxmvcj2z2XwQ6LA
	 i9EhJQxSgo8EcRVXpPfqZ0+Qx9XkoLaU9GXr2TvvQ0frp39RHJTaAorfKP3mqDA7aeJWM
	 CMHV/jlf2o/3Xt9+ueBevhaQa4j9KxSH7LEVMvmRjFIujYk81l8QcvH3V2bzFUdQkCRs9
	 qlQ3RH/anv2tUmTGGHW+tWXAxnMxovXgwaF0+fcLzasN+na40+ZCvjZN5ZTUwSvlAYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1qf3l92dk4tHWRdJ4o8DYEf+9ywbSUEL3YYHeAyOvFI=;
	b=Oe/gtbi5nc2rfB2sBbTgE5WSHhRpp/Qu3/rC8jtafhAeBYTSfjKgyPyCcXRK//eyCuLF
	 ULrL91rYLTSKZfdMjY1nunec3sDUlqlEPk9C36Ynh6l4MmjtfNjCN2Ov6soYaVdVdIt2L
	 WpMSZUAsbgZz1/w79Ug4r5iWbdxjb5mnAhz71dDc2SudfESZp7xBP3D1oVL3Y8C1Q2cnM
	 ZTmxOIHcL/mOkxeseBGkSoKjAPJoAFqQ6I1VAc1wNNZKYPM5FtPTsxGnrLWhD4tqTOnb4
	 x8yNqkTqkUg6fVYCqA4IXMDG4kVTcYycpN0NasYYLnmX/Bxw2hh7oHMzLLd29MVS+OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKu9iQ7Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046FA606A31C;
	Thu, 19 Nov 2026 02:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EKu9iQ7Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F711F000C4;
	Thu, 19 Nov 2026 02:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054926;
	bh=1qf3l92dk4tHWRdJ4o8DYEf+9ywbSUEL3YYHeAyOvFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EKu9iQ7Q533rTMR0HISF2G+hcJizPIFKYwyRi3IlPoF5t8vRTnm0iow8REnroxsSZ
	 AwLt4vAnVsm+HfMEvOvUbBPm3VGH1XlIpToCsCFeQvGQyFsu8jcA0KiHEXZvNtBl43
	 Qybnn49AIetWVWTvBEdR8U4ND59+2HxdQtOYId/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1448/2214] USB: pci-quirks: Release EHCI device reference
Date: Wed, 18 Nov 2026 15:52:04 +0100
Message-ID: <20261118150109.025608905@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



