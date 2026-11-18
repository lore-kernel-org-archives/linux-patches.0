Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048127;
	b=2mj9d6To1jGI0xzpZOA8Dx9/M1yLVNhP5IaO8k17EQimnhubuJQadQza1rf6xYSxWF5w
	 O8NVvI2M+FutfN49uNC8xK67am/GK2hqJh3ZHYYVnYsewRrR6Mz708Ylz2/xTeqqeBSro
	 DTe7UhVPw7DD+ECAEb8LFU92aqgrz46It6Ozd4a6MQouNPC3Bnv2/yANiMk1+wjkpdzF3
	 qXl+YvAdunNlvJIc3k8k7ViwLJgtDmCicPvG4vj6nZRyWhJsQ0puV/hROM1GfndMPJsbT
	 dnuqDpXsQnBkQkZeUU+SFZApPa2P8ypVIcDHOeHF20ORQqeYoqjt6u7f9LmF/09kgow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sYogsjaobbbqSg/xCnCiGjwDSusPIObaoo2H5bTu26E=;
	b=5h64Heg1n2y5Geh8btoM/w/6uAaRLJL+9qdkaNMC9qHU9W+ZoqMNEB5T/t8qnlOYdjwC
	 RHKa04R4wKY+1TQEG3qZl369qpWczyMkuYSac2OsWnTSBpg5HHLRTcjqBEy3azxNfw5X4
	 R/Wm6QRZo5bRle3qAfebrrq+YxWHYdAqDY69BtedYtwh/L6vL3MLiSrvw9daEHs7cIoO/
	 EZkbsa/uAoHMNOC9/GRk2FRb/SRn1oqdmrsuKrjLCd9P4zwfawhlovk/CoCQNoO4LiwC2
	 CDr2eT7hSVioBJrBfpjbF2AyfNBR0Qogq6YjWw82I4Kik/CzS/dZLvDJq53w0bFwWYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i61AzvHc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B214606A31C;
	Thu, 19 Nov 2026 00:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i61AzvHc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFB91F000C4;
	Thu, 19 Nov 2026 00:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048126;
	bh=sYogsjaobbbqSg/xCnCiGjwDSusPIObaoo2H5bTu26E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i61AzvHcPBs7ijKFf5O5vJN6toigC23mvuozJyEEb3U1E7xf9NVgTAa4hS1SW6qaT
	 1kKmwf66IcA49iI6L+yQ/74RfS6eSS3JrwqfhnflY/wzZNstfKmeZ37ftRrjIy4sfU
	 utVBflMDjfuf/V5V+YJUs9p+lV7r5Qob9OLHIPLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1884/2857] PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan
Date: Wed, 18 Nov 2026 15:48:38 +0100
Message-ID: <20261118150309.068751255@linuxfoundation.org>
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
index f43e14d9d1175..219d04200c39f 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1022,15 +1022,20 @@ static int vpci_scan_bus(void *sysdata)
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
 	ndev->vpci_bus = vpci_bus;
 
 	pci_bus_add_devices(vpci_bus);
 
+	pci_unlock_rescan_remove();
+
 	return 0;
 }
 
-- 
2.53.0



