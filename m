Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023392;
	b=JKbUvzWyR6fW7ORkYAhrXErURvKZWqV43lQFQHmHifnOOJrQowPuG6nBPsg69RPh1l+U
	 milwxkWAPkwyHq46Ucef1/fsCuI5nzcWgS3MV1iicH2seFm5xa/2FdVdh1+xT/fM4auTj
	 wl3ufIelxglMpR6jI7qTpZzgriUeIfy2KJkzH5LGZWOgS+uRImwsXeu1taevsILwCxTyZ
	 uAHm8w8HAY5wqL2/lRsfaibv9BiEPKgZMxWJPWnkhrvrkFllSYbZSYB1/UYXfsc8/jgjP
	 frot6bMctBZv9ECdlF80qMeqpNpUuixcxcu1a8so8VwBXVESxnkQeoPKg8XLF76asmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6YaY/9QxevA08Wt5zWZ4tLbEpi8rVsgTWJFdYcmCmfA=;
	b=Wr0PFizKzwhfY8r3xV8rZ9cHcB55jzcvl4TAJlIwdp2V//aHq4pxkrA9Xq4zeMC9c3Ir
	 4Xb0SBFHA4UsthoX9/TZSyvBYj4sxgvefUFTZvBSyzpv0m4oe8aT8S95nqgcfJ2Il9T13
	 csieimilS84km5xn1OafZanLc9eXgGAxV1cNaZ9qJWlED1wgOLcm9IvG6RPuD9VOQ50Ec
	 Un27Emkr5tTpVomnBqIb2+JwQiSA/9EGuXCJcw3DAUZXyXyjqepY+0vYn+LtVTtaFehDh
	 V2lVSzwwxtNCyFg+PiUuu5mh8/KK9CuJXWWaZmTEj4LskS3cPaqWUCxXwXJtnGqjorg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQJBbM3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD613606A325;
	Wed, 18 Nov 2026 17:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQJBbM3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283A61F000C5;
	Wed, 18 Nov 2026 17:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023392;
	bh=6YaY/9QxevA08Wt5zWZ4tLbEpi8rVsgTWJFdYcmCmfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQJBbM3Ve9qfYzA4JWO4sXVN6MYLL1PmGDm2rZvW2XMwlY2NbFnE4y/c5SKSBmlJC
	 cV4hmgESwdKe1vb8oLaaVwFnEIq360OexGH+FdMFqE+8SksGC4VYZMNdCuhqZxY+N3
	 7ziZXdVlHYiCBhxgdSFeJ+DCn29bgtq8OrrrhX1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0354/2151] USB: pci-quirks: Release EHCI device reference
Date: Wed, 18 Nov 2026 15:34:49 +0100
Message-ID: <20261118150134.995247693@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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



