Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029416;
	b=Hq1wTZuI+rdhjX331q4ReLXZJa2FulXNGjBlIVcBRmS50kmi6XG6Ay8Y1RNPvnFDszvH
	 qPS4zXPK+peBhAin82fqeiLh/e/dMG52jMWckA37lmImYUufXj9DvpZuBXV/bTRuv9/v9
	 yRr2gKhciT2YDHw8LPXaIxEwKb/+EEo4qJuNLQlo3SCpFcrQI7hnB1Utu5ytC1RRy2xk3
	 9F6/rjK02n8y9NgGu9pLwJqLBY6b7XsxORcY453GJGAnNF7W/CcMmetQV118/QVrtQN3V
	 P7TLtgm6sntXzmemKz0BJSSH1TV8e4R+2XprVPW43JgqEWMhOkkPAgqxwaXUyvz0/eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SlIHixiFT8RodQgzus0n5eUePq39MuSVWqiKUhYA4XU=;
	b=uDgM1E0/vii++Vk1NDNKtykx8nVPuvCcgHkaBUMh1VjJfbGQNE2dWjZ2t9qlA0IathuH
	 cLG5T7GcRq5l3gyMs5cLZBFpCjpy8zoQ3a2VMPC3pOjZSorkcjHYMMfqYbx8dRvvY2THb
	 0mpAjlT4ejEGKD0p6psMoNQFwsKtpMvv3An0Y/jsUuo6CXB2Kr3+qghNWRItf4Ey1m+7h
	 ea+DSf8keLleN8/OKLvvSRCu+7zry/XdDjFT/1UH3VarWmox28tlMgrVjsA7E88bKyBuF
	 KKQwZis8LOqGbN0/kvdfElZ5CJnoTDNpdLzxfNx1dCkq3h9rWiZDBdvP+ywBIBTeBHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z8CL77/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8211F606A325;
	Wed, 18 Nov 2026 19:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z8CL77/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0B11F000C6;
	Wed, 18 Nov 2026 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029416;
	bh=SlIHixiFT8RodQgzus0n5eUePq39MuSVWqiKUhYA4XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z8CL77/WZ4jOhK9BB/CE+d5jCPna5UtBoI6xxmZRHM5f0UIfPZCSS2dcC7+cBn3g/
	 ECRAXXZHa41GtC4NWGHihorGZXtn+fJ8E8YGeblNJ6iJoUCO5Zdb6y7kPc7ibbswGZ
	 Rfe53AZeLrxP6v7P2tG+bkZqXDRSo7MOnR3/bUYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0342/1756] PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan
Date: Wed, 18 Nov 2026 15:41:09 +0100
Message-ID: <20261118150021.961455092@linuxfoundation.org>
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
index ea96174cc5110..e5fd2bc04c23f 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1008,15 +1008,20 @@ static int vpci_scan_bus(void *sysdata)
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



