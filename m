Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035984;
	b=gO5J3YPV1QYPZt1FKlxbljkkWhLMZsM1J7iMO57oFAD4BOpJSpeV5fu6ax3M8LPDE5dP
	 t38FYUdH1fnRi5TAZcPlCGrgZYhnc5aiUQro0HkNsv1QpnUmBZ39F+1AvgPxSGh2n3JA0
	 G8wfv9QukBm/YTwKITdCK2SrzwhdQbBj5X1WKUSMu7lI3irUe8ECtoHrztw/RB3PHnb8T
	 wV6/mGSBPxEYtZdPUNmEpVnQtFSvmDBwd9k9IkX5HBj1L8rBG45wdIW3/smA8Pfnq9li6
	 IlRH9k3se0rerRxOYNSEefLqs7Yf/dP1VIhqGNuoO2rf4mwik6iYf1Rvsyz9/FY/TwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tP/+2sXABpcCl24dx++do+TtUt8KvZ/WfBx1iATRzak=;
	b=lVIsFkLoHM/OW3t9WoSS+o126rOvPdkDR4hXS9yn2XRwH0m3LuObLNjjfFrbZ0yo/g/O
	 3VDj76Z2xiLPZfvAhmiCgSaPbffaC0hpVlsYf07T8byFpkODvE6gvC1VDcvjjVY8ifH+D
	 +t5LQE1VkIJhs+Cp58XfNJcoZUT9LGg+pMrxzW8POkyKwI5fPci3Mpc4LIjY+EIRqtiM5
	 08jmnNvl7iJI+4o51VEPiGW8MxPER4OYn+HNErRxhn3xtUCettCiRr5gDYj/RfCRq5ZBl
	 Sr5/brCbSQx/HkizkBgorGnXI8/hVHvOz2P9guV0JvQPCPsN1gOLxsxyT/Cf2zAQFfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPDhLsvL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D186606A31C;
	Wed, 18 Nov 2026 21:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EPDhLsvL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73601F000C4;
	Wed, 18 Nov 2026 21:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035984;
	bh=tP/+2sXABpcCl24dx++do+TtUt8KvZ/WfBx1iATRzak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPDhLsvLzaIgI/ZVpfM/jcjDgYF00P55uAJcjrriiEXRUEwca7r2cRE25pvC0q2wg
	 v89k+qZwUBDQCUuXkfpB2inpYYU15xH0UniiGPVAc4/R/tP20qLt9zOGUVPNr4q2no
	 p4Ph4LgVAbkHwiTw4HDRH8FJnmpkm6ZD+Z7J8568=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0897/3318] PCI: pciehp: Make pciehp_poll_mode parameter read-only
Date: Wed, 18 Nov 2026 15:25:19 +0100
Message-ID: <20261118150346.374422501@linuxfoundation.org>
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
index 4042d87d539dd..e5ab8b33918a3 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -37,7 +37,7 @@ int pciehp_poll_time;
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



