Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062896;
	b=uJ4fHrnxPsEFyDnl4PF22gHu+kmXAf7PPJwuoPkS4kguQU9Ym9DemV8PQDeqRC1Rolb0
	 3D0waotUUrDNKjpZy6fV1HfkV/gqNl21oC4PG6CV/6a2Ysr3BEH8RoHRb3cFsc3jgEgo8
	 6AD7pSSshO1/tmNwE3yws29x8UYDvciiM1vk2sUfxKVVCNTn55YlYVSwtsMXiZuoHQLmw
	 g9rP9GrSHFRZ1vnyrf1cvQdJkYn2STOZ7RByLZAjcdlhV0jQVAI+rF6dfXNlvx6R5Jc3Q
	 KCj8hm2lgX1sGG9/Y4qPT/24yNSxxfImQzCkXY+OoBhd9ZGXA7/7i8JeHvAA4DMSeAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hdfbssHOswuSzM9oUkq0a7q9lxNrW/AIbfX+uNqSPlU=;
	b=aeKK/np9II+h88e4ulFSiwmmD5HmdboSi87fX/utLnFcLE60GlWohtjpoQRRJjgTrVU6
	 ra5npTL2WCLpR/WxsQwd0gWompkUluRLlCurjCioxT08RLnGv+lFcPyhApi/b5J0tAFAv
	 asbyFl8oHUYXCR9tZCguJXo3gjzlPLO4N69MvxvBOTLgLav8SiUPrjzNrmPKGpbPX3ljn
	 p6hM4gcG2KG6RVUll5TLP8914zM6Vcft2SVSK/f1VDDfh5Btqd9R3PoB/sLPrrED9o0/w
	 ocejjRA1Duc2G/bJReJvqt+79q/QRAmjQGN8tGkD0HXMCKnt91btXeUdF/bq8+iWF9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbvWRmI6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D5606A326;
	Sat,  7 Nov 2026 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbvWRmI6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1037E1F0089F;
	Sat,  7 Nov 2026 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062896;
	bh=hdfbssHOswuSzM9oUkq0a7q9lxNrW/AIbfX+uNqSPlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbvWRmI6Q9VdI3jFyJ2lsl8hlXBiUlGiSb/BVtVd24oaX1PLo1d6ppRKuWq4lTqip
	 0qtZRnAD1FrXTfSty3C++OV0LLvSu4DkA/zlyTl7HKCQezffLRKJOb+44vVYHwTMzH
	 DYRqylMkNx8OmaYDs9vsg4bL7aCk5CLSB9dcxFMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/869] PCI: pciehp: Make pciehp_poll_mode parameter read-only
Date: Sat,  7 Nov 2026 08:47:35 -0500
Message-ID: <20261107134858.062196318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index f59baa9129709..785b7d5e7c096 100644
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



