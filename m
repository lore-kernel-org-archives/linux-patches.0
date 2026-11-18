Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039601;
	b=GYs9cwvoGbx5AF9+YPJCxzYpYyTEI2NnvZxXGlKYHy5oIzTuwLLT3q7z4MD5bsZajada
	 EN/7l6rXrjPMzZIAF+fmKHgzIOjX4U05km/Ryvm/b1H1OoNj+SXo1XG+D9FSgXPO3FdPX
	 AILmvnMRSKEq8iWE1QA9aPC85jOl1J6T2EHceswYREYwFnGvAW3zVcBO5DrkNbXNuC25o
	 aq+Wejm5UQkOlKZkTioepObgZPz4SN4qYOuf7c03hhc8Y5ytrjHWqxlYJzV7qApWlpCaY
	 BZGmIEI+8HkcY+Hmz3SsQiCo/x9fGBjdRcNn3xPZGFafRgpGMYiNC8Xn4gM0e1ZRabA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NIUNiJFqbtS7pbGsn1TEa/WWRR4SEzsLRdFEvwgUNys=;
	b=M5riLGsB7oxVBI3MAP+7SuHT9ZtTrHYl91Oj+FVkDyxdiX4lzv8zQyyYarDND3YIWMcJ
	 sR7qI5DDU0AFK9yFfBCACJoRRfiOIbyjBHil6u3NE0EVBW/vIqN6co4bofncZPAOJRA5s
	 NC3W5A5pqS6FptoZohv+Z+HcSYYjoSD7dDglkQYuZ1j1Kl3/tvdLXjshcXEI1B3bUaCRK
	 CStjcQP9aXy4gfTIwlqFvP0xBF+trrctbY1fMkOiiZa5qEK98M9/nbLy5WGoFmchSo38s
	 q+FlCllOvHjeTgsNpnptvyHfUsa4perSxoHoD56lkVvjEMWbAtrjxARAHRAGujYAAJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlkzUaZA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD82606A320;
	Wed, 18 Nov 2026 22:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlkzUaZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6B1E1F000C4;
	Wed, 18 Nov 2026 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039601;
	bh=NIUNiJFqbtS7pbGsn1TEa/WWRR4SEzsLRdFEvwgUNys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlkzUaZAztuVtHq+IbCaCLXxGE0C60PqREv2F3DYaCGQM5Ob9tx4S/r6L//OAFyv/
	 m0DHj8/ypPC7YZ+CnOBIUmzuaT1sMobt/MOaEzqcgpSDmFS4vx4xFzW1gFEICNcOj0
	 7xbyH+6/zh9k1/0mXpuO9FFJQGngmAyPUakemz9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2159/3318] PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan
Date: Wed, 18 Nov 2026 15:46:21 +0100
Message-ID: <20261118150426.785475547@linuxfoundation.org>
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
index 64732f1d704c9..4d50e4e6ddd86 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1019,15 +1019,20 @@ static int vpci_scan_bus(void *sysdata)
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



