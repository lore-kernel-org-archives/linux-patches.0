Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052294;
	b=ahDhaqF0HFcqLXRD/IZCOzvbbB8b9O7fwGJZ0yqXSgzx33fFzybCa/ZtoQ95+N56DuZ8
	 FAqfxaFvn26cTcEfjT7hnVZUmukPW+UT9vMFzmO7njN+16/oFfPrQV2aR4oM/oVcBcNky
	 kTzLfQCHPnEE2IAfNw8w0y037Hze8zoMDdjJE8OWWIyxJwjSqAtvTmdpAATxDJEHHWTVt
	 7K7FYLtceNPLA/8Wuv4w04qrSJytE4fgaQJVRz2QCHtKOAq7LqIz7RuWaPExupoyEM45D
	 XtDALuE16B98BBhMrhrbtOHGh5EvH5ffrB/Lkwzaq2cl8JIW8osLcWmqmSSNsd5BKEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=816NdoeQjeKff4DKfiiD0UKElqKVFZTsUB4Xn4v7vCI=;
	b=ZEdaiqbHXvKW5h30zMEPen37iLuZyqCVG+CLfJ65nF7DgM6zFPGVZSjdSmBXlEdy4eCV
	 94N2ZHRo7/F475Px/aYFwJz2cjumf7nssrmC+6NF3fr1p+9ZLyStoUDTPDzdIit3yM241
	 SWXI6ABxdeP4zImDZ03YojKIlln07a31j5fc1F5SsJe+0hHmKauYS1gxgk3KSpFhQOxuw
	 zOlbMTSHZt8JnNVJSWLlKjsJ1NDU8fsMa370m/1onNUnkrSrjYpl5vsdzPmPLz0nd0GlG
	 N3UwtxIxw6nR0jyqnxNxxIXrblWcviDQWU9mD/xKgxFol3Z2tDMELQKwT71iO595nZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppfBhH4H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98267606A31C;
	Thu, 19 Nov 2026 01:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppfBhH4H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FAB1F000C4;
	Thu, 19 Nov 2026 01:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052294;
	bh=816NdoeQjeKff4DKfiiD0UKElqKVFZTsUB4Xn4v7vCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppfBhH4HmEbadRWLDhwk94r9wMn8hWbYGtASGPivU2SogBhf9Vhwbv8Hpu04DhTBO
	 VHUG6sOPxe/wms9iGWvFwTy8DsTjeGnrKdXstDRMdETqGgQ+q1Ws+2qilN3BggW3/w
	 c38bTKHphYKQOvS1x3k5jzx4rdHI1VP+BUyk7zyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0510/2214] PCI: pciehp: Make pciehp_poll_mode parameter read-only
Date: Wed, 18 Nov 2026 15:36:26 +0100
Message-ID: <20261118150031.524143746@linuxfoundation.org>
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



