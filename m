Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016008;
	b=X9IKvvGwEHIFbzhuhWD2sorSqYTwbS3QVFr3FujcCmR9oviDJT+tqpmnkAmqzvamCPnC
	 OkgWFrL2Jqf8YoohYp5Rw0hgux2DFoWNdvjPQS3dCgLzOR1CiO49QuYIZWmYYLi8b+jCd
	 3N+4ZZOHobcRP6I3tKu9jvqhS0qEaQekVzZ91IcIwsqiYCNP/8k/Ema099bm1UO9/2IWF
	 2A1F7DwklzZNYu1ch0WNOHOLiCCGDYrj7ZnUgbS6UWNmnLBg+nENuL6ZdVAKygOJW0vou
	 1ibMvsGi5MIAm/LVgnGgbJEAWLTawAAxJjz5s/ufaCmTu0/miF7SJ/hYcvIS1IXaevg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6couq/FvUJIP44TZOxCgcFYedCTaBSBq+QMH5BjZIWM=;
	b=BXDG4vHo1D6cFNQP31oN5G0yCS79xJ9OjZ2UV0k5p6lB3tUOu0V/av0PaPnxQNXo8dHh
	 AT15K4ld34rZVEEopPxnfv+jLM6A+no/S6Z0aH5vCpeqHzFjGBWtQbqPctNoQtZ6F68KA
	 jzASh0vOIaPUN+0KmY0jrsdjNSkvcTMAG+qTR0F+WDcqIEvak3+N2W21BsyFwME2AXcx8
	 rJvNLtGJbaFp02bS+HY9KUKsw9kw4gCWRm+dZP2O65ig4sOqPbAd/SaXTHU0Or4oZqxEg
	 yqxF9wbfLGQfo1GqwIe6q2PGA+hwcwEBh0Mz9PdflthYq+hxsUNNEKPJDCxN6Oz3xyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0DJQ3PM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDB2606A32C;
	Wed, 18 Nov 2026 15:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0DJQ3PM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E501F000C4;
	Wed, 18 Nov 2026 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016008;
	bh=6couq/FvUJIP44TZOxCgcFYedCTaBSBq+QMH5BjZIWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0DJQ3PM/j8mj5bavrEM/k5mBBOo3f9VFkLUluNfldX90VqyM+NNyKvZXbKECza0Z
	 t8vp7Kse9ab10KXhqh90tdl4DI10TxxkBAw3k+cBzTboUn2Kpylx/21+RHMFCxEzbW
	 G0ZOsWuZOJokI1fX5NezU1DoiXw1R7NJLPbHoBjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0375/2651] PCI: endpoint: pci-epf-vntb: Serialize virtual PCI bus scan
Date: Wed, 18 Nov 2026 15:26:55 +0100
Message-ID: <20261118150301.336065990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b6139e8e09a23..07ba338732d4e 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1342,15 +1342,20 @@ static int vpci_scan_bus(void *sysdata)
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



