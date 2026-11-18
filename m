Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055015;
	b=g3isYqaOGcYNzw7SuZ6eKYRWkDgIF1oUqDT50bDFaVRg1qOjbwB8M4tF54pKH25Z7ZB0
	 /+Gv29f60sPWkjZni2W4FSk4JDMhiUBAbKc1mmY5GwDbG5u4/+onLn5vcji0qBit9iZrp
	 j6pA4CV8tAYVNlHtqx55hA2kaikj87dPcoBhvRyaFj8CVX1Fn3wV/d9k2TBmsg0ovFsw3
	 iZPXSzlIQOGhDNckdz080cwehb7o9Gm511atWGmRgKG0MF4nF+ugxt3zFsyquvqHbOh1d
	 9sLgA9Nb1DOJEj9qxh+5kg0cdm1nnbYyPvJnZk+wQjAxkFJOMIKizMrXL9c97hGs/Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ATUJybU9Mkr71TuYMFj6zdOUztqEbvm/amV8rOPDyDA=;
	b=A8O1dDEDPSRJ4SmvBsXDIMaMDrGpCfIEkRRiMn/eirfOftJntPD9rk8BpOv/Kmu/zohP
	 PAyPJTtCLudRWSLGM7RfBr7SVte2m4c8lKMDPmOD65aHum2yFFg8qiqFy3wlAiSXCfojo
	 pipT6f63l63T8aRGJ82CxaxvUmqVy//cZluoGJMDS4U5K4O/bHBRegS82heEOI/PAp0qL
	 2pVNBzX2urMNMJcJdTY5FZAuyuM/JLrNkz0Vvii92YguO6ANTWonwbpw64+Lht7zmZwaR
	 xVva4StfEOFM8xJ2IJ3Dv1beAYvXR6njzr9mFyPKGgpSqFUZSWlOg9qRS7eyvf3iUUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqlNxYyn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2028E606A320;
	Thu, 19 Nov 2026 02:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqlNxYyn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E0B1F000C4;
	Thu, 19 Nov 2026 02:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055015;
	bh=ATUJybU9Mkr71TuYMFj6zdOUztqEbvm/amV8rOPDyDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqlNxYyndNtIh1qVFWUQvi+pzGHXmlT+0LtKtPZz6B8N8MydJvCnTD4U6vvXWou0/
	 cY8o+CD/XsJP6J3R4QcyT1ycjoOyAmAhSqlao6nVtkWSNt2oEcs0gINFPkRFWwQGsG
	 ZDE3uu2eMVh0NRYu5j21hE956Fh6r4t7D4z3jCMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1463/2214] PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan
Date: Wed, 18 Nov 2026 15:52:19 +0100
Message-ID: <20261118150109.642500061@linuxfoundation.org>
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

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 84c3520c9e8c14b09a5cf645cc4fa7c6d9d61127 ]

The virtual PCI bus is scanned without holding the PCI rescan/remove
lock. This can race with other PCI topology changes.

Hold the lock across the bus scan and device addition.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Suggested-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/3tgrcel5fl55ulf3zjya4fkz4t2ms7iwwjif5rnzn2rafsydd6@i4e5etm7uqvz/
Link: https://patch.msgid.link/20260901063238.631166-2-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 30c003d8b0dd6..390bb9c9e8836 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -977,14 +977,19 @@ static int vpci_scan_bus(void *sysdata)
 	struct pci_bus *vpci_bus;
 	struct epf_ntb *ndev = sysdata;
 
+	pci_lock_rescan_remove();
+
 	vpci_bus = pci_scan_bus(ndev->vbus_number, &vpci_ops, sysdata);
 	if (!vpci_bus) {
 		pr_err("create pci bus failed\n");
+		pci_unlock_rescan_remove();
 		return -EINVAL;
 	}
 
 	pci_bus_add_devices(vpci_bus);
 
+	pci_unlock_rescan_remove();
+
 	return 0;
 }
 
-- 
2.53.0



