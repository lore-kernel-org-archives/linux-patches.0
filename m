Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058233;
	b=3WTkfsCkbd4748VvC3XaOWW6H+0JlbZ8t8+yxYAJ8EUqA71EDzO0BhoqeCIb5/Aons+6
	 CLQBT7zVDJOSgY+DgdjOAEURwWQe/AdxDq9ihsj9wnD/zK8bnJxS2CU1KU3YQ2hGc+9fO
	 9EK4weTHG7mqelaPsbY27bIxu6l9Ow3TucPy36eneQVUDu+9rYw8ibHKZeT7RhNUTOnYI
	 B/cuQpmKx1uq6fpU9oBFGVgiWn+q1SWxjBH1hNh8/4mN7QrPBerY5dNVh7+voA/EUruKB
	 ACTe/pDqrm/49GNGoFo5JhX3rrJHAspEYbFn34w5IzZtVOs2Yim3/8EVf4ns1T177uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUhmB2O3SkfGpbPhqvmNE0LOjO7mfwYRVUU276v+nw0=;
	b=OyqsUlQmkbRZDazWhQ5O+DuxE2/lr8bQIhYObV1aplXsJwuzHsnTa5gp+JbKRdbmTjId
	 wVN7dazcwbd1t4+5oC3lgdeIrSt0/+UykIDdh4yo7dFBU+W6j5hhNJ6WPLQGVzaqKj5ub
	 2+7Uiqc/t0R1g/bl4IMq8rmO5wxKpOJ/AW0C1t8wibvFpO2lYOwOZBLHHlfWjxP/1lw+3
	 DZAx0OyiVOOFzurllbF6VKWnlgb+G7mHHNkR++LiiV0CTKeqfP8CGk+RnXE/JvHCiwW6I
	 XPDSDx4AHYPaaLnEL7UizjqjNlESVzzAmlejiDNrKJK1b+cjiQyd5hz3LQ/MrELcZmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbolX3h+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E1D606A31C;
	Thu, 19 Nov 2026 03:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DbolX3h+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFED1F000C4;
	Thu, 19 Nov 2026 03:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058232;
	bh=tUhmB2O3SkfGpbPhqvmNE0LOjO7mfwYRVUU276v+nw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DbolX3h+qdRNSxtMat4hzzRK1SCCQRToakLNA8RRJpawsvOix1fBBPoGJZ03EcRZG
	 fAl7WrjKPEkidBys3PFJOaHDN8SrzgTQ04Ge5uV+Ge198GhlDwifTLwlYukTMp9cFE
	 nH0ZDS+GegAapeJBY43pNxUixJx6yOcAxSk2HOno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0414/1848] PCI: pciehp: Make pciehp_poll_mode parameter read-only
Date: Wed, 18 Nov 2026 15:40:52 +0100
Message-ID: <20261118145931.302248177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e7fe4b42f0394..7254cd4a3da20 100644
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



