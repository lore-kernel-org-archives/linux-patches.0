Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043790;
	b=la8wYNjif1iUdEw3DAxOBk6ZvxQ57zTP0r7rcP2Dplzseb/msGWiUTaM/sDyopWa5Im8
	 PaZlLDCfBbInNsCIwnjJ91Zi64kQm6Jv13FodX4Rr906eNuB0a0aacAacqUraEDu82rlH
	 +4aP/4Ldk78ZZKcxJdm21IIFhpS7SwQEiFAuqqUo+uqDTUmVk8cE8mKWv5COegYOkgS31
	 c2N/5Xa2+UqksbSebBYM77sQ0e8lmENrN6IHK625nmWh2nnMZOTffdoNgsgxqGHYWns02
	 xvY/RZftfEo6JjECicYORmRLjIKvlXvdAeRx91Hr1/motw409aDybRFf8f0ctY9/Oyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u7Vhg6rT93Dqpdty46FnZikxUbgqTUQXLQZ+M0J0bd8=;
	b=GYXrVaF1BRBru3XRvqBP44KwBp5uuhXam874dAPa1HFINz7ZYrmvO50jKFQXbZBGzHgk
	 F54p/q+17WjE8dkajcM20Z8rP6SZUsY1jZzntI/oF0bacEL2jbT633ymDb8PPN7wTF3Bz
	 RxYq96D4/NETK/GJOna8CUaMYAWMgEaz7P4RmbGj/gi3WctxtyvZ7WZVPZbVeQTxydM2m
	 jGT/EQFv70PxrpLXVbwkAraivCvivyw5SMN/YvLQ/eddbE6IIkuUFNU8MHlhlzS1uRjMC
	 0bTdrOEkg6zYW1TdD5PmqqI+dXhbxHJS24vAvyRqHn0+rVHRXnro0XKXxnvhVl3l5Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G+N/Ed95";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A20606A325;
	Wed, 18 Nov 2026 23:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G+N/Ed95
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3539B1F000C4;
	Wed, 18 Nov 2026 23:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043790;
	bh=u7Vhg6rT93Dqpdty46FnZikxUbgqTUQXLQZ+M0J0bd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+N/Ed95LpRaF35JmvBYBfWWy1jxKgCRRep2LI5G4LaAYQ3Lms2LahXptLkwVIvyS
	 fNAXuAqyiIr2/HDe1EFE6UYfAOeh+5q3e4VD3lYwst9gzAv7lRCMzWG1HTbYiTJSgB
	 lTnsm7qwrZNXIv3FiaEdj/r2rZ/gWF76yaCZDoDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0337/2857] nvme-pci: disable controller on admin queue IRQ setup failure
Date: Wed, 18 Nov 2026 15:22:51 +0100
Message-ID: <20261118150213.574530701@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 08660a5c8d497f43191635d97efd31cd35051f15 ]

nvme_pci_configure_admin_queue() enables the controller and then requests
the admin queue interrupt. If queue_request_irq() fails it returns without
disabling the controller, and no caller compensates: nvme_pci_enable() only
frees the IRQ vectors and calls pci_disable_device(), after which
nvme_dev_disable() treats the controller as dead and skips nvme_disable_ctrl().
The controller is left enabled (CC.EN set) on this error path.

Disable it in the failure path, while the PCI device is still enabled so the
CC.EN clear handshake completes.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: b60503ba432b ("NVMe: New driver")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[ sashal: Dropped the false argument from the nvme_disable_ctrl() call, because this tree's version takes only the controller. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8639c8f2066f3..37d00f577f7f4 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1892,6 +1892,7 @@ static int nvme_pci_configure_admin_queue(struct nvme_dev *dev)
 	result = queue_request_irq(nvmeq);
 	if (result) {
 		dev->online_queues--;
+		nvme_disable_ctrl(&dev->ctrl);
 		return result;
 	}
 
-- 
2.53.0



