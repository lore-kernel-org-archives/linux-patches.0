Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035116;
	b=HaMrwaoAKW/r+t0Y8iji2SNJNNv/Vq6gpJSRr9V80LI8XRMiev5vVqTlBKltTf+nosLn
	 Bn01jHFHbN4lErbfJfx3NSfXzlIqQh0kYnvo+SRtTUZCGMbsLrFBSQUoQ966bTqHcEF/4
	 7DqC4OT2RZdx5FPXDc2Avmj2Pu7ftLVydEqzRgTa/6YUslFIDuQASdkhwjvgA3/vwYlr/
	 ZaPRtdZrt9pwK0/tJFyFSt9fKhD5j0HxUfE/h0gK74b4kiQWP0Wn7V13RDJkJxrC2Veb4
	 vyzLp9HJb8wvD10FBMvXSdSsJS9QOkm4CIJU5m+ohrWn8hF0nXwEMN9WMwXtHj+cg1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=joJvWoVJ8lRt64jq1ajWjF0BqCZJ60tTQ6G59VW3JJA=;
	b=niQAvBiG8Vle8PaAira3YNwM6hCSWgFGbBycjkYFSc52sjXr/ohO/BZ7Ey7UQr3buzwL
	 Ep7sNeteHoGmCcexY3US4DdOv0mZ+bh2ZqYX6rHaKJejxvPGrnCrVtmZXU/DbhCyTsR59
	 0fVOCiA/lgdsphMnGU8SRXAfOGyFqqafAI/KNu2SHir60NGe3zgbTUGQVPIXmEpQZcVoG
	 8H4iQ5QC25eh7KyUnCETWXlR/TiRnHIOGBw4LRONpCyXmbJ6bmD4E37q77tzKRhor/pbR
	 BQUNAOGafMB7tAcjAxZt2nVxou5KZVdPLN6UG4E24R6fZFar4/D9n9T3KFKR+SUscaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gR944x5Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037ED606A31C;
	Wed, 18 Nov 2026 20:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gR944x5Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F1E1F000C4;
	Wed, 18 Nov 2026 20:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035115;
	bh=joJvWoVJ8lRt64jq1ajWjF0BqCZJ60tTQ6G59VW3JJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gR944x5YlmOBIm2XVT8XYot9ccuNRUgf4XR3+Sktw1rAI2Gpwn0RQDJgSWs/AMW2w
	 Lu5v/x67vUZEGujGvTpHLDCRdALhSzHE2L9Alf6L/Y9s5QWChPob8mcqGevfqdwmns
	 y4wht+xcvDtZ4J69aZx7VrJwITuvYERmYVrzCyaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0611/3318] Bluetooth: hci_vhci: Pin module for debugfs file operations
Date: Wed, 18 Nov 2026 15:20:33 +0100
Message-ID: <20261118150336.078658556@linuxfoundation.org>
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


