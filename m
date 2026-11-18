Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029517;
	b=GERkhu9HEe2MPOvVVfZRHk79jt1uYWzZGezzq33Q+CBVwug3q0mdCqHyaMsJV+drsGJs
	 TjQuMQ3h8nNY0oU6YB0s7DGvRDeG5ylqtE3k2tnOusxQEchChwNiOTgnkcHMuTk9zXux2
	 vb7gQuzT/5UkO5f0he+wm8Kxdi1PBOAguovhNi58IIAM6YC4AXivZPFRNqFHOmTOFKvEq
	 riZrCZvBpTIuJqTbFB+IZmTidHbTfPlzhMrX9UdATjsWn0IxSK/8ctm0j5XZYZZx/iXUt
	 s0RFgQvgh+Sp3kaV1l5eByNrjAz/PqfskTPWgjV3FXAbhmLZO9JlVLcbMfrywUo9nCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VULqr1q8ve5Rp+oPzqFoWafCIbPx3IxF+Uc2JQ8m9Pc=;
	b=CAu1F8LkLqB9YmGZD6T6GgICTguj8TqDgdurjzzKXgnpZb91xSpNLrW1cLIG+EIHTYEk
	 h0hq57pT0AfhivgOigNGR2I4+yJz4PU7H0yx7pIU+8Y4LsPw7+anNxKp0gLbE8Zi6BIs5
	 vxlyZF+PMQvq4uR98fWbZc3PQ+hmjiyI5+V8aGhTLr2ePcnuUosGxi46TO/Cr5BCWmKuu
	 jDD7Z9B+5zK7nMV9qD+nUWDw35soEvWKG87NSaCDMabswVQCJQu/xTucOlkKIBuiDG8pw
	 F7e+mviSDQhcZ3mrRkwqCHpMdldVN8vRl2C1IBtLdn1Hh7JepvjvFgVyQgll1CL1gpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvFF29Jz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F67E606A320;
	Wed, 18 Nov 2026 19:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lvFF29Jz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8D51F000C4;
	Wed, 18 Nov 2026 19:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029517;
	bh=VULqr1q8ve5Rp+oPzqFoWafCIbPx3IxF+Uc2JQ8m9Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvFF29JzTmnMgk+LsZkggh+m1qYZy+JnvYswRLeplyzt00ugVvbebm8vPSpaohQd8
	 pdms7mRsrYB6oxE/dQWE2qH4LwT49+8oQXU0nP3LNcqssm1X3MjkxES+zJFaoBTBVD
	 +E5Rxd1xwJ1hBXWcrAjQXy72IVQA4mMotsxbow2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0327/1756] USB: pci-quirks: Release EHCI device reference
Date: Wed, 18 Nov 2026 15:40:54 +0100
Message-ID: <20261118150021.292253698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 0404489c2f6a9..ba158d63bb8bd 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -1073,6 +1073,7 @@ void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev)
 		if (companion->class == PCI_CLASS_SERIAL_USB_EHCI &&
 		    companion->vendor == PCI_VENDOR_ID_INTEL) {
 			ehci_found = true;
+			pci_dev_put(companion);
 			break;
 		}
 	}
-- 
2.53.0



