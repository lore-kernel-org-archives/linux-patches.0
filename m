Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033794;
	b=xgdU12ACaefbB6G3lE0DOEjijOl+qgrM3fFkqpOJNorA/IZIzQLO8u6dxhlZV4d28+mM
	 znQ48XM4OxTkO2zRsAyCnrSueGVGZkVkgP2WlR5PA+wiCDi9WIeeRLiJnuLJTOs5ZuAbr
	 NF2zTeIdV+YogGkU8btSzO8CHrSOLCMAzIRRHeTUgwY/5J/t6PS2nyjqPWUQfMvEjHYn0
	 53tsTyqwawI2fqf8fZFPsKoIEeGjiwEnns2TQPzKAVVQsux0M8GzT7A9dQtsVxEMFBQ6U
	 p9ExHkUfvUI4/VoaLGpXsU7aKM4au5BI6xTGBDWO4XFdSoda3GteACShSxZdyKsy1/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HIPsNOMIMTrUACQej0Y6P8YpS3CbyKiEw0ObZVIvcIo=;
	b=hjODTRMAcFeDm4omZ2gpu023/Zsud6XBE4eqjglWvmUfYyDyICXuys+SwhzAWVAD1hQI
	 60TFpuRDTlUpXYIgrrnrD6ZSVuGo4C2EishcK4Vg09rkdNiojOTk9LXLHQ2RKR+a6qDn8
	 LPGDXfDKPMcjK19eSo6t/s97hGLFM+qr54krcpTnFB5uhErFLZuR1LgKyslWPWR21sx4d
	 8q/2dkQbijgscLa3tc0ALxBPFXHm9ELZOKOprU52eWDbn0cJwkhGRi+LqowggYos1p+Iq
	 qeLWZtBg0VXBrsFfwBqeQYaJ3VbvtuSEApcfG2ulxLLTiOlpRwv1KwrjdWH3EUVSCuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngVCFqz2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AB9606A31C;
	Wed, 18 Nov 2026 20:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngVCFqz2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62F41F000C4;
	Wed, 18 Nov 2026 20:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033794;
	bh=HIPsNOMIMTrUACQej0Y6P8YpS3CbyKiEw0ObZVIvcIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngVCFqz2N4a5HjtQE9wvQTpgxpElxenSX5FwxjmPM6tyac3sIsTRrV2tjOOrnifHi
	 FyPVBew0nAe92NGnxBY5szbMcVJhEgAN4uasd7pt85q6wTz8hSVPECe+k+JlBbYuaS
	 LR9BMN7WwzLQdW4zxJgybNa2CKqUL+jgzecSUedM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0141/3318] PCI: switchtec: Add Microchip PCI1008 to NTB DMA alias quirk
Date: Wed, 18 Nov 2026 15:12:43 +0100
Message-ID: <20261118150318.689955927@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 00a479ba1d01249d43ca5e453380d1ed60946f8a ]

Add the PCI1008 device ID to the quirk_switchtec_ntb_dma_alias PCI fixup
table. Without it, DMA transactions from a PCI1008 switch's NTB function
are not given the correct requester ID alias, which can misdirect them
under an IOMMU.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-4-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 027f26035053e..6fd425ef7f8cd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6033,6 +6033,7 @@ SWITCHTEC_PCI100X_QUIRK(0x1003);  /* PCI1003XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1004);  /* PCI1004XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1005);  /* PCI1005XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1006);  /* PCI1006XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1008);  /* PCI1008XG4 */
 
 
 /*
-- 
2.53.0



