Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210982;
	b=xEtKT2B535PvUy9M7E34r1eh+3azfXOlTUt1E+gwFr1HNX2EMH0o90TafBfoK0OuOF6P
	 JqolZKPO5CTNRzRxKeAa8OZGekC+ylDQ0Lu603RWllacxDgMRBgs96xWLGGF2/bfHDTSx
	 eQk/IZkb4yOOEVi/Whpyf+c6HaZAUNCsAYt7LICxsgLwpo7+5GhqUZb7ug3k9gw1JMcts
	 cqwjOY0TllHOjZGuzcnCpbn0lY0yXgdloQtb2H/5RMhj+0ox+i2p9oNenezF36NtWZhuD
	 rCDR9m9RGUE+0ywb6l0YgWYUfQE2Omtfz78MN+mEkfpVJqd66He8VJ9kNxc19C9EB8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uVF+UWlZ1+UeL9vNtoo6bfB/+B5a0F4DyEA8lLTODsk=;
	b=wA8AeBXzbG3Ij03u1dr/MpEB9dpv5bGSQSpHPE25jKLmzytfZBpneQBBnLmDhtHL65Pz
	 YvMprP3uAbplUJvIzFsrxbvqrA/l8j9yp8uyCrqqsY3rw3WzRVkyvN19jEy/lOx8N7DT8
	 Jl4cy/qX+klTJbS3AfE+8SEuov/3hm+BLwDZY2ZYuVDR9oNI2pyweEXcoauW7/Wdhzn45
	 SJSYpF8SjWVy+ZA6RoB/x2zVP1sm3YdHUOsFtTnUWv0P7yFoOs5xkg618QC410/wfWiq7
	 AsYxpIqFyj9WzfuWQKZNUmdx1jVHUTbNiNaqeUfOot5+0txL+dE4x8joLCdlYyYeOlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h24p9SwF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B0E60A2623;
	Wed, 28 Oct 2026 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h24p9SwF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229B21F031E1;
	Wed, 28 Oct 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210981;
	bh=uVF+UWlZ1+UeL9vNtoo6bfB/+B5a0F4DyEA8lLTODsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h24p9SwFSQKn6cbqKQ9Jaf58yohCwJt4GpvrV2yMKahmw21U3wfeI3WGnRKW8Ycq1
	 Z0nsyf9mBYqBc5WxQ1A0EeakFRbS2qNMf+2w9AWG3CCYS+S4/FDvfWcfLuzKk30JDW
	 qoKqrvs6YimHzn6j3/OOnue2k8jbepeWQ62J8K1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jie Deng <dengjie03@kylinos.cn>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 215/571] usb: cdns3: Fix NULL pointer dereference in cdns3_pci_probe
Date: Wed, 28 Oct 2026 17:56:02 +0100
Message-ID: <20261028170013.104016814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Jie Deng <dengjie03@kylinos.cn>

commit e5052f2c5c73c1dcca42bafc0bc737af2b2af059 upstream.

The Cadence USBSS controller is a two-function PCI device. The first
probed function allocates the driver data and stores it with
pci_set_drvdata(), while the second function reuses it via
pci_get_drvdata() when pci_is_enabled() reports that the first
function has already been probed.

When the second function is probed while the first one has been
enabled but has not yet set its driver data, pci_get_drvdata()
returns NULL, and the subsequent wrap->devfn assignment dereferences
a NULL pointer and crashes the kernel.
logs:
Call trace:
  cdns3_pci_probe+0xa4/0x300
  local_pci_probe+0x44/0xa8
  pci_call_probe+0x54/0x158
  pci_device_probe+0x84/0x100
  really_probe+0x184/0x3d0
  __driver_probe_device+0x80/0x178
  driver_probe_device+0x44/0xe8
  __driver_attach+0xec/0x1f8
  bus_for_each_dev+0x7c/0xe0
  driver_attach+0x28/0x38
  bus_add_driver+0x110/0x238
  driver_register+0x64/0x128
  __pci_register_driver+0x50/0x60
  cdns3_pci_driver_init+0x28/0x38
  do_one_initcall+0x5c/0x280
  do_initcalls+0x104/0x1d8
  kernel_init_freeable+0x140/0x218
  kernel_init+0x28/0x1f8
  ret_from_fork+0x10/0x20

Return -EPROBE_DEFER in this case so that probing is retried after
the first function has completed its probe.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Jie Deng <dengjie03@kylinos.cn>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260810023626.70669-1-dengjie03@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-pci-wrap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -99,6 +99,11 @@ static int cdns3_pci_probe(struct pci_de
 
 	if (pci_is_enabled(func)) {
 		wrap = pci_get_drvdata(func);
+		if (!wrap) {
+			dev_err(&pdev->dev,
+				"second function not initialized, retrying\n");
+			return -EPROBE_DEFER;
+		}
 	} else {
 		wrap = kzalloc(sizeof(*wrap), GFP_KERNEL);
 		if (!wrap)


