Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023442;
	b=k+Qf48HL0WBciwF8sQ0f1nhRt5BOcnJ32Z/fyLV2XFYkzGuITAPZTDBvvJZdBn1NTcku
	 GW9yZjpudoSVvMhQLHg3M2t2nFquJ7ONLQABKHzKJjk4kp9zyZm64y/Uypw4kzt1fdDap
	 lQo/z7QsqMyzoBq9gkIHcxcJBJl9WTI31oa34tCa/aEE6xH5AGbJsvRnlt0n0hZSCH6n2
	 HYPYNVGH5q8A03cnIvu7gOUmfEIJXRzCO3DFpY0d7wBYZ6v+uSlJjQaZmvCGPV/rA1NEU
	 k8t+9GixZk4BJKnRiufl/lqVk7HQxt5gG3EfHmJ+R1dKd5AhWABlDn0lRo8nG1Sw0yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LuIUeeqKS2jp5G/56zeEzg/e4kO31skcBzvZ9QgP+Ng=;
	b=DIL0aVhktj4QiOXrYinoIXMf70yREgaupvjPOA68BGXY9tvxEXAlke5f2qBH4CpR1ovS
	 zUcfaYRh98lRHNmUJ38t3bpvxbf/Kqiowpyz7tVRJyD3Vc0zP6re9TKWbSTKEmvqHBakY
	 wZ1Wr7T9f2o5odWv9bnvKAN4raRaWCkXmV6XA13i6eGYMoZUaX2FznQLyehP4Q7n1dcRq
	 9PnTb2KszhyLrII1jJvYcIHZ1yJU7nQky0gznfDgNSAWzpiyRcG8ZR1PQYp9vJDa5k2pL
	 c68IeDUmvto3F06/u7XQ46tL2HOtu9b5ifQN0xrPogd6O/LcKj11sF/77ojH6kNKPJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgYJRKX+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4BC606CA7D;
	Wed, 18 Nov 2026 17:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OgYJRKX+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131331F000C9;
	Wed, 18 Nov 2026 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023442;
	bh=LuIUeeqKS2jp5G/56zeEzg/e4kO31skcBzvZ9QgP+Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgYJRKX+6jtLzDZ9ovWSUk0xxeXo+nOpNGPP6P+qvMm+thL8V1y/4oSCHhj6+ukbZ
	 goBLK/Rwu2S2+0dbqxLo6hONX96c24ny0buaZTVV1fZl64zcD+pCD3LK17U95rByHQ
	 bOA7RXosa2E87xDcYcjL9rd0gI4R2zpVF+aY4cwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0370/2151] PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan
Date: Wed, 18 Nov 2026 15:35:05 +0100
Message-ID: <20261118150135.568582209@linuxfoundation.org>
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
index eef9d0e724381..53bf54edd5353 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1099,15 +1099,20 @@ static int vpci_scan_bus(void *sysdata)
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



