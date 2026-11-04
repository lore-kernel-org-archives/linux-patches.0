Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829548;
	b=0YBkPGLDO1iIUoNiaIcxMgwGKSpcsS8rov76hck0qgLb+19KreAcjLv1v8h5n2bdDjsn
	 Wvz3evTVpFVYeJX6LWpTfN3ugcG567XWzcnpfCxIe8hKlEyXUboFPU7+3DDdi851rINwj
	 j8NKosz3PCaEy8D+xaixxOkcpFVfanY4pprg6wNJ7ZX0MdJgAK50z1E/jnUBP8fiCz1lm
	 oGar8eJT8fvs4DHDLXO0aNMXNEdcsDwuekJmLznG71C2gqbFz2aCCfn2X1anIUMjkvNAv
	 oWUwilSth1ck3y8N/4G4vsZN+AWq43Y8njoXZg6HLmb13JySOeMizjuaqMnca1X4vvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RqanmeVxeyz/XVqXMI+ravYCa0mMeSVYkhS6CAveFow=;
	b=N+czkExXOWjB/NAf6MYgAtTogogmX2Ih6b3p0u3ySDE7G5aN8Du1uHY+DvcOjDJm4Xu3
	 tDtM/4OcNFMrgMXsHfWUUKBqzsPxBBfvC7i31mCARsIuTu4EMUnKW85HYvGdEqFOt8p0k
	 uOhfVLgs+SWbFFRgfAmB/tZhsVZdZNDVJGClCKoTwfkYtgoyJHfj/6jjDv+hYm1uaL6pd
	 A/10at0uCzlmw835fki3QL/feYGIrbWqAUt4j5xnxyze/aZaPWXX2SpLkMDPHvDLCPs3P
	 ENldBj0Z5FZlCwIDYYGKC9J3y1ZvYvQV47bE6rs2whrM++C7W4Iq2DtSMiL5t6+2TKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCVvC0dX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF536075273;
	Wed,  4 Nov 2026 21:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCVvC0dX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518111F000C1;
	Wed,  4 Nov 2026 21:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829547;
	bh=RqanmeVxeyz/XVqXMI+ravYCa0mMeSVYkhS6CAveFow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCVvC0dXKQmZcHaWz9F42/1VDzcuOdC0ONZqv1oe0mbDaAiblLQaoAR1gJ8eNzlwh
	 vXaSpHeTUjupBQweJRvN30FtXU3BhQQIwEt+vsQZ9+KcsnxU8OBvUjRqb1shCDpEJE
	 KFPj8aWboVmd05GZ8COP91Ve3HEd/eEisf+SQSj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0195/1005] PCI: switchtec: Add Microchip PCI1008 device ID
Date: Wed,  4 Nov 2026 15:58:48 -0500
Message-ID: <20261104211049.259518509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 0d8a6306c680ee534be131e360f0cafa2bada7be ]

Add the Microchip PCI1008 device ID to the core switchtec management
driver's PCI ID table. Without it, the management endpoint on a PCI1008
switch is not bound by this driver, preventing userspace tools from
configuring or monitoring the switch and leaving NTB functionality
unavailable.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-3-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index f32ddfa79da99..30566c2d9f806 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1874,6 +1874,7 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI100X_DEVICE(0x1004, SWITCHTEC_GEN4),  /* PCI1004 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1005, SWITCHTEC_GEN4),  /* PCI1005 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1006, SWITCHTEC_GEN4),  /* PCI1006 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1008, SWITCHTEC_GEN4),  /* PCI1008 16XG4 */
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, switchtec_pci_tbl);
-- 
2.53.0



