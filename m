Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208668;
	b=ZCURkE3LHmSEh9mHA3QhUVz/MDNuHs0F6cbg1i4oeEioZ5linZEGPzVXx06qf85YuhnH
	 KnH+2wzFstQZrHgZb/TUibrF3iYqxIXdTj9bjYVhOUs+UaUCfCnl2oOUCdiic8FYGTfTN
	 0djPtSB9LULYV/7u7Z2E2BZ/FB4fhk1dUbpdQ7u+/z2OMDMmM/dr4ZETsJ++YQKEJ+tqX
	 xKQQxjnf3eDKhrL9NoQKoTIxZtCZXPYtR23kGOnuhm5MLYVAIvzCEFbC46KtptPMKfPtT
	 XUKNWDmdcdJWizuCTGcScnWUGlZFrZH1vqSNyQAbFO9ZeDsBp9pZt8dRpN29is1DYfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZFg9eX/wwEsgSUKyWTvPfchP54AcI/l4a8xdAnxCfyc=;
	b=NojWgK+beAUAbU9f2QN+0LOxMdNEJWi6zPDRG4PPeIyTMNoJaQq9oA99lP27LLcVabYZ
	 tgOxQX/zQkyMpB7+pXvMPH02KUvEwbhje2GYfYzTr23aX6UdylilpPSalRmZvSObop9Ee
	 vv8YQ2vJ7G60TXkX8QUcMw+aXmjv88XH+DxyWACOFPkfpGEJa119t0p9HH0tXYgGyf53D
	 eWXeFecCnu3e5u5/cFK13q48oYBrxxMlNS0DBqrlGvMFZsq3DkZ17P8KUzi0NQZcX674R
	 sjCk2T2G1/V45LKVgTg3XduEbdjLs4i4wEjNUr6aeLsfC2CHZxnUZCIPrHpq1c7GV4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqlV8KMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7D7606A31A;
	Wed, 28 Oct 2026 17:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqlV8KMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248A21F01825;
	Wed, 28 Oct 2026 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208667;
	bh=ZFg9eX/wwEsgSUKyWTvPfchP54AcI/l4a8xdAnxCfyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqlV8KMvtnQ97ZlG9XalUbJW3Y2qI+KGl2t8txDCzuTelHKoknVQrWgbjZPFMHa+T
	 Bw6ztjGGzprDQDvPmL/Qd5m/YjGRwqmzYY8CrQztGf0o/2kBqLfRD9EOOM6D/xhoE8
	 012zVG0EXrFCfvknqda6jFuVS79F/e3/yWEZtFNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jie Deng <dengjie03@kylinos.cn>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.10 201/516] usb: cdns3: Fix NULL pointer dereference in cdns3_pci_probe
Date: Wed, 28 Oct 2026 17:55:53 +0100
Message-ID: <20261028170008.264476037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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


