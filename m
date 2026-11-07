Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062026;
	b=btkrNpgarPwrbQzurQRD0KhZ88yNaZFRTUI0fMmU3aRHzsTJQoPW91T3w8NR+4h8gm/r
	 iemJQPgcOMagGJfilkdtOQwA/sykHDmROZmOxu4/k8OH4UPMFCbsRuvgOozgA75k4sZW+
	 bQPrS+PXKP2TrX/KJtYddjg0C9KO++CppTbKgZlEmJhsA1AHQpUpZn54YFSUNXS3DI+p4
	 i5OoyC6YzInLmnSeNAdUyjdqWhRQfryEuBRYezFLypKcmx1WxvKZ37aL7LFTqYjxvuqc3
	 S1pN337iXyPMYBNN249Z6r/GJjAcdIimizhXzv8w56S2262tb8jO5eksOZFq0nQ9MAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3AYJdWoCyGxhTq75r5liRJ9+zlf7inkc+wFgbLeXe/c=;
	b=op2SvIDrV3d016SwZsSZn3LAxi1LN8hXW3H1aa9LB7adRV8rrekgubUUZb3t3GV0T5no
	 hqoVs7gefAiGsGuYFE6/RN4h+dVwP6LJV5aUBdBSXrqxzI8TX2snFXzt+mrrUGWbIdfUS
	 7D/Yotlp53Rl+zNy+qsNneRxOsOi2qTVKx7ZuyDq4QVaYv3zV1wEXYnC2HmImXLBl6ZnP
	 D42GHq1m0jDzRyUgbkYRuB7Vxyc1RMT7FEweZoFAvCY6msxOTYcvKJ4uRVaAK1cfS+kRI
	 tK+ckrpNoFyiAPSLC3HiIWfHBsR54SSGgW2WRipVIonFXqsJ0/NYABrUypxXQNLLhRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWphQIda;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE98606A332;
	Sat,  7 Nov 2026 14:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bWphQIda
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132C41F0089F;
	Sat,  7 Nov 2026 14:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062026;
	bh=3AYJdWoCyGxhTq75r5liRJ9+zlf7inkc+wFgbLeXe/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWphQIdagqATZOBsYcrDORb8iGFzJgGDqK7V7XQ+oCZ+c744sJoaze4PqQT3uWt9c
	 79rdvu9bdtZtZlc8x/CnaaDYR01XE7ppCkgWjijDuI9D/DSsi0O6/TKK+lIA61ta0H
	 dN+38ovO7/tfRmv/Y+CrzGTkfO4QCjvk1hEqiR0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1012/1536] PCI: pciehp: Make pciehp_poll_mode parameter read-only
Date: Sat,  7 Nov 2026 08:50:28 -0500
Message-ID: <20261107135026.097252800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 997841c698935..854b787fd8493 100644
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



