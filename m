Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064044;
	b=RiqlykCHekH9ZbXNCs8bGjN3HJpOk6yIrT2MT1CPWPxdj4zkAA1FRHI3eIAV0SNjYnNz
	 Ojgg+TDNN9hYfJP77Ev/mmjoKS2HnlZ6zjQ0J4S5BQu2Ze3aNDd73I/4UsdDk0zRsPPRB
	 9m2vQ1Xb/JwGCx0pU1KUZR/C6tWdZwgWde5VYhn8uloYN3KkgFVSxA6O7w0TNuPeL+rJS
	 8k0oYTAhW9yRdSrxff0gt+idcib4bR2dxvvaSXs7UxCx7DUBvnV+uAtfbdk4oNlIWtOMq
	 lOHRuqeTEbcsDiU9e2semawfqisiJmDm0MRdVB0hK3JsyukmicjIISN6hXV7/hgbnKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tRF/cr9Ah5Wk+aKMFjtKoU4p/ML8BII4TBYi+So+LWE=;
	b=DIAKEGXzq5iozBFs0QhtFVTG9II1++/sjM5PRafHyWAzoKOVsihtNK2aGiSauEzZvzm6
	 6w4PJAy7kweQyMqHk0za+dDZWsmp5sQTW0h1MJGeUklJ9UanDqKtHM/hjk3iRa9W+nX4l
	 4BCwzFB6X0Qt0zPtv/u4CfuHKN4bzhO/uY7c3AYpdzC98S9AZRECkR5GU/xQrq/HdXsBO
	 3XRl9fl8NTqmpgydxQyGMYPpA6O6kY/5lZAchZ4FB8p4C1PgrDPOrGy+iiJDm+H+h8sX9
	 w2KuOlQrPrsfHML9dQWfqeINDJEnpcXdek+PzpxdI6VbhKZZUxNvXsuPXseOVw09/oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1A7/t2mf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C6760A5BCE;
	Sat,  7 Nov 2026 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1A7/t2mf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9C71F008A1;
	Sat,  7 Nov 2026 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064044;
	bh=tRF/cr9Ah5Wk+aKMFjtKoU4p/ML8BII4TBYi+So+LWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1A7/t2mf55PEOb7eydUuCyublkbdBIiHmKhvbfC3sACxEPV8/8bsQxa6M/4AgtoSz
	 BJW+fWt0Y2zFm9yn5MJLtINMF3dBuuLQ38gizIV0xu0bye0vB+9VTowltlF3HjRv2l
	 X5+ymMydZwHwhqcfbkZXne5d7Ul78ww/WhxcIjMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0218/1257] PCI: pciehp: Make pciehp_poll_mode parameter read-only
Date: Sat,  7 Nov 2026 08:41:54 -0500
Message-ID: <20261107134945.556531713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 5ab17178fca6026d329cb6ced33c30f3b7d3e50a ]

pciehp_request_irq() and pciehp_free_irq() select different resources based
on the global pciehp_poll_mode parameter. The parameter is currently
writable through sysfs, so changing it while a controller is active can
make teardown try to stop a nonexistent polling thread or call free_irq()
for an IRQ that was not requested.

Keep the parameter available for boot and module configuration, but prevent
runtime changes to the registration mode.

Reproducer:
Boot an x86_64 guest in QEMU with a native PCIe hotplug root port and an
e1000 device, using these device options:

  -device pcie-root-port,id=rp1,chassis=1,slot=1 -device e1000,bus=rp1

Pass "pcie_ports=native pciehp.pciehp_poll_mode=1" to the guest kernel.  As
root in the guest, replace the device name below with a bound pciehp
service device and run:

  # dev=0000:00:1c.0:pcie004
  # driver=/sys/bus/pci_express/drivers/pciehp
  # echo 0 > /sys/module/pciehp/parameters/poll_mode
  # echo "$dev" > "$driver/unbind"
  # dmesg | grep 'Trying to free already-free IRQ'

The unfixed kernel accepts the runtime mode change and reports the warning
when the service device is removed. The fixed kernel rejects the write and
removes the device without the warning. The mode change is a deliberate
privileged test action and is not expected during ordinary operation.

Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20260921142608.270312-1-runyu.xiao@seu.edu.cn
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 2cafd3b26f344..5ce32dc7e178f 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -38,7 +38,7 @@ int pciehp_poll_time;
  * not really modular, but the easiest way to keep compat with existing
  * bootargs behaviour is to continue using module_param here.
  */
-module_param(pciehp_poll_mode, bool, 0644);
+module_param(pciehp_poll_mode, bool, 0444);
 module_param(pciehp_poll_time, int, 0644);
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
-- 
2.53.0



