Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831451;
	b=ndl7bNx9xWImGd0YBD2MZrdpx7Hfzan1sH/tdZCBsnCmfyLWC1WpzjhZR0v5UF0F3D7Q
	 ZuTnTD4bOaiOVQTx53GOFeGyolBlJLdmiVOor8IkEs3y77AlP3S6JYnCXvDsVuh3LbUSq
	 I/cx6xyUS2O2pHB9gAPd6YRp+6PaWatxAszIybP1Nb/TPyVuayAs7kCGBAMZrOXob+TtV
	 +7JaLarbaniUEI/XcLX4EL3UzNMc5C2IRoG2ZG+t5ZlU6Q438NiIC3ZNx2w7m7ei98WKO
	 7kn4fysHYNVZTb3pNSirUVXCgfy3VU3Imeqivq005M84L7G0Fw+zSdy/GPcI3WC1UHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k43hQ3sj7C1nFl481c61p9xEWLof1sQbTSwgBRDYMLY=;
	b=A/cV0F793OHPs/E2+Oume+3Cr5cD3kl9Ltcj8XIQrK9IhBrR2lqLaw3gPWS8+Izi3hGQ
	 o4TRE41gpdn61yWoYGVTiz+KF8JN22OYh5Ovt9PLwRsTYGfKn9nCXpiZqXv1ibKdsogSF
	 fpAn9qdW5d+XRkkSbOsTSDMW2fCUHx2Z+uKtblAg1e7X9nYghW/tlz3sGam7KS81K1RsW
	 7q+1CD61VDINoJ+65nR8umDTas26rd8AiBwp8aUp7SWc3SJVM0oKGELw7nmLc84cdun6o
	 FURxvHG66sRv3rwOeIghdlCE9dRxWafLAVa0AEBFLnAs3ArXFSfx4EZxveuheojyB4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSY6rUtF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B4E606A328;
	Wed,  4 Nov 2026 22:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSY6rUtF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739791F000C1;
	Wed,  4 Nov 2026 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831450;
	bh=k43hQ3sj7C1nFl481c61p9xEWLof1sQbTSwgBRDYMLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSY6rUtF0ABDXVfgc3wNnsRhuWqJIvM5dje9fgfPo12y3NTo2w4YLa/FYXUAQBpmR
	 b0XPwRjlcfsRNBy/5VyaEDmUg5joRZaM8Fk82o30a1KMsAXj2o3byYER1tx4DuCvYQ
	 3ebvNg9G+ZDPzp/TRv2Mt+HcPs2TtDSg4hPzXhrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 0709/1005] Bluetooth: hci_vhci: Pin module for debugfs file operations
Date: Wed,  4 Nov 2026 16:07:22 -0500
Message-ID: <20261104211103.423487600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Bui Viet Dung <dungvn2345@gmail.com>

commit 645ee6b176c958579cff1c783413d5cff65c8197 upstream.

An open debugfs file retains its file_operations pointer in the
debugfs proxy state. However, force_suspend_fops, force_wakeup_fops,
aosp_capable_fops, and force_devcoredump_fops have no .owner set to
THIS_MODULE. As a result, full_proxy_open_regular() calls fops_get()
which succeeds without taking a reference to the hci_vhci module.

When userspace opens any of these debugfs files and later closes
the /dev/vhci file descriptor (triggering vhci_release() and
debugfs file removal), the open debugfs file descriptor remains valid
in userspace. Because the module refcount was not incremented,
the hci_vhci module can be unloaded via delete_module (rmmod hci_vhci).

When the userspace process subsequently closes the debugfs file
descriptor, full_proxy_release() accesses the already unmapped
file_operations structure, resulting in a kernel page fault / oops:

  BUG: unable to handle page fault for address: fffffbfff846f18b
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:full_proxy_release+0x8e/0x140
  Call Trace:
   <TASK>
   __fput+0x39f/0xa60
   fput_close_sync+0xff/0x200
   __x64_sys_close+0x8c/0xf0
   do_syscall_64+0xc3/0x590
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>
  Modules linked in: ... [last unloaded: hci_vhci(E)]

The issue was discovered via manual code audit of
drivers/bluetooth/hci_vhci.c and verified on a Linux 7.3-rc6 test VM
with CONFIG_BT_VHCI=m by keeping a debugfs file open across controller
teardown and module unload.

Set .owner = THIS_MODULE on all four file_operations structures so that
debugfs pins the module until all file descriptors are closed.

Fixes: 28010791193a ("Bluetooth: vhci: Prevent use-after-free by removing debugfs files early")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_vhci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/bluetooth/hci_vhci.c
+++ b/drivers/bluetooth/hci_vhci.c
@@ -155,6 +155,7 @@ static ssize_t force_suspend_write(struc
 }
 
 static const struct file_operations force_suspend_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_suspend_read,
 	.write		= force_suspend_write,
@@ -194,6 +195,7 @@ static ssize_t force_wakeup_write(struct
 }
 
 static const struct file_operations force_wakeup_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_wakeup_read,
 	.write		= force_wakeup_write,
@@ -263,6 +265,7 @@ static ssize_t aosp_capable_write(struct
 }
 
 static const struct file_operations aosp_capable_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= aosp_capable_read,
 	.write		= aosp_capable_write,
@@ -386,6 +389,7 @@ static ssize_t force_devcd_write(struct
 }
 
 static const struct file_operations force_devcoredump_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.write		= force_devcd_write,
 };


