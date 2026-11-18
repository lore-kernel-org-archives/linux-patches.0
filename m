Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045517;
	b=IrdvJRUyUxJhtM1F5lhR3eSkCSK4nygjnHhAL6QYfe6jQTSY7EpP0xbsWUaT1l0KSxL8
	 m76j8XBrZfdpfu40Zhbrj2X9lnFChRY1ezkihIodGUG15hG8n+3gg7MvVRjUAxN0bu51I
	 cAYp6eb67iZissn5XlZc6biP5+Dtn3l16Wk1r15V/zhpsG4O5qCIIBhj8opKDcYTPGoxD
	 trO7I7eKYVe4N90CUUI0okop5Q5811oJiqvQh3m8+onrqrzvb9Tfn99VGbdPm2pOLBwIO
	 0p1f/PoGiZtOqAF8+3jLODRJ4J19Tvpi4Ow4ixWg8NwVXpmzXj+TeaFcMRTKP6uwNxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o6s7pQjnFr0R+u0gSQBEoab7wAMxrmMAQJ59t8987tQ=;
	b=QzcvrUgAESxMWFJnagOhhMZ0z6v8ApJwL70aUlcCJKz6cE6Ob8oMJ/CNnUDTC3gVRl8H
	 uyWSSqQndh/E/CBkRijZzDMKISBNpCW75uzdFNE2seau7YqmtR5uWCqw1IalokeEx/Hsw
	 6/QgkKO1NaPsfpOnt9FTdNs+lZnVH6Zr6zbuS+u/5scZpj5Lm1PKPeyhm6uDVDfSf2ea7
	 UNcuhYFdU3FUQI4jH3y0Rie1g2C18lvz2eLaY+UxUMiNMWEyOTbeBaROzgFLMTmArAB42
	 EL8gjxlB+KZwi669CNiCdBEJ5910VJu7aOtlBFLWwLd2v9OI4dDvzvHH1FN2qyhkKDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lk7IAvRA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF046606A325;
	Wed, 18 Nov 2026 23:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lk7IAvRA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAF71F000C4;
	Wed, 18 Nov 2026 23:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045516;
	bh=o6s7pQjnFr0R+u0gSQBEoab7wAMxrmMAQJ59t8987tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lk7IAvRAvAJ2lAmOI42fkL+Kh5r4DKhEAglox4cBAUVVW5DYmMTPAs3oFdGzS4NcF
	 uxaL76PCi/ix2Z2yPKchnCHv/n52B8ntfZ2vczN+EvqqQxounlid7rt6/6kFdt5IHd
	 xYwRaHeM5CE64c9INPmK97ZHgTTvy8RNVHI8QOd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0952/2857] Bluetooth: hci_debugfs: Pin module for debugfs file operations
Date: Wed, 18 Nov 2026 15:33:06 +0100
Message-ID: <20261118150235.884190113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bui Viet Dung <dungvn2345@gmail.com>

[ Upstream commit 2a3e2287877b1ee40ffb80b7d769b633866533f3 ]

An open debugfs file retains its file_operations pointer in the
debugfs proxy state. However, the file_operations defined in
hci_debugfs.c (use_debug_keys_fops, sc_only_mode_fops,
ssp_debug_mode_fops, force_bredr_smp_fops, force_static_address_fops,
force_no_mitm_fops, dut_mode_fops, vendor_diag_fops, and the
DEFINE_QUIRK_ATTRIBUTE macro) have no .owner set to THIS_MODULE.

As a result, full_proxy_open_regular() calls fops_get() which succeeds
without taking a reference to the bluetooth module. When a userspace
process opens any of these debugfs files, a subsequent controller removal
and module unload (rmmod bluetooth) can succeed while the file descriptor
remains open.

When the userspace process subsequently closes the descriptor,
full_proxy_release() accesses the already unmapped file_operations
structure, triggering a kernel oops in full_proxy_release():

  BUG: unable to handle page fault for address: fffffbfff8056f03
  #PF: supervisor read access in kernel mode
  Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:full_proxy_release+0x8e/0x140
  Call Trace:
   <TASK>
   __fput+0x39f/0xa60
   fput_close_sync+0xff/0x200
   __x64_sys_close+0x8c/0xf0
   do_syscall_64+0x115/0x6a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

The issue was discovered via manual code audit of
net/bluetooth/hci_debugfs.c and verified on a Linux 7.3-rc6 test VM
with CONFIG_BT=m.

Set .owner = THIS_MODULE on all debugfs file_operations tables in
hci_debugfs.c so that debugfs keeps the module loaded until close has
finished.

Fixes: 0886aea6acd2 ("Bluetooth: Expose debug keys usage setting via debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_debugfs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index aa71618f54e6a..257e1747227af 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -68,6 +68,7 @@ static ssize_t __name ## _write(struct file *file,			      \
 }									      \
 									      \
 static const struct file_operations __name ## _fops = {			      \
+	.owner		= THIS_MODULE,					      \
 	.open		= simple_open,					      \
 	.read		= __name ## _read,				      \
 	.write		= __name ## _write,				      \
@@ -286,6 +287,7 @@ static ssize_t use_debug_keys_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations use_debug_keys_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= use_debug_keys_read,
 	.llseek		= default_llseek,
@@ -304,6 +306,7 @@ static ssize_t sc_only_mode_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations sc_only_mode_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= sc_only_mode_read,
 	.llseek		= default_llseek,
@@ -440,6 +443,7 @@ static ssize_t ssp_debug_mode_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations ssp_debug_mode_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= ssp_debug_mode_read,
 	.llseek		= default_llseek,
@@ -532,6 +536,7 @@ static ssize_t force_bredr_smp_write(struct file *file,
 }
 
 static const struct file_operations force_bredr_smp_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_bredr_smp_read,
 	.write		= force_bredr_smp_write,
@@ -781,6 +786,7 @@ static ssize_t force_static_address_write(struct file *file,
 }
 
 static const struct file_operations force_static_address_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_static_address_read,
 	.write		= force_static_address_write,
@@ -1184,6 +1190,7 @@ static ssize_t force_no_mitm_write(struct file *file,
 }
 
 static const struct file_operations force_no_mitm_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= force_no_mitm_read,
 	.write		= force_no_mitm_write,
@@ -1322,6 +1329,7 @@ static ssize_t dut_mode_write(struct file *file, const char __user *user_buf,
 }
 
 static const struct file_operations dut_mode_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= dut_mode_read,
 	.write		= dut_mode_write,
@@ -1378,6 +1386,7 @@ static ssize_t vendor_diag_write(struct file *file, const char __user *user_buf,
 }
 
 static const struct file_operations vendor_diag_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= vendor_diag_read,
 	.write		= vendor_diag_write,
-- 
2.53.0



