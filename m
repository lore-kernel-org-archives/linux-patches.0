Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037403;
	b=v9E0pF9AaBYkdSD8gKlddLP61mWjzkATF0/w0wl/tbprnd9CY6B8x64iRxuT+HP7+OsG
	 xL2jPO7zESiOxHN7CCqIADYdb6rHk69sUa0md7hGaIWA3fQ1NoGVE8i9XNEirbl8eSG5l
	 Z1MpzDWQFQjPlnGqwpKTNS0SIU2E3BipfwMLzi+fXRwmuxl0EEDoheWUmh8UsxdlRxSZX
	 NB5SEt6VTzCKYhSW4FcT56DDilTfjyfvPwCrSxdNwbvHC3Ee2B2gsjYnINmAV6VMYhNi/
	 ODGZCEpjudermGJYvBLKlCSYQKlAdTJhRg/Z5Lq2Or2sAJFumuQawbTnN+2TSS+YZOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LCE4FF6PjfiwES20+GqLuW0NHuwaaAnZZEGQ5dHGdGg=;
	b=CYVZegzJ1Q+7cgEyNOsbL1LfIBsIltMuRIzky2HSsAUQGlPx6rsKAPAYPtpZN/VoyXTB
	 6e3cHCGh4+KO4zdZrrQPti8PzKtS1P4B+lkHiO1BLHWg20tRP2pUANd7f+4z4FG3JH6UQ
	 e4Z5qGXhGxa5G5DDEnIUv35g2oZJf5mm8Qau6t1Oqn24iV0cN+ZmzSFZiQ/Ht41TYPWUn
	 ntohUtHiSSd1nsHgc40KRWdEKhSx2m3kOMK+cMK69k23415/8hn5zUge6whkWMOtiHLK2
	 RrN93AbkkMmhAUe5Fo0u3GRJqrqZulHXwO7R84Q1ed9mgfIojhSZb6Qc1B3gWo4OKtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04IQthje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B89D606A330;
	Wed, 18 Nov 2026 21:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04IQthje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119821F000C4;
	Wed, 18 Nov 2026 21:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037403;
	bh=LCE4FF6PjfiwES20+GqLuW0NHuwaaAnZZEGQ5dHGdGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04IQthje+ApLEX8Rs7k4wrT6gDBl8PJ5ozP/NKIrVsne4sWTJzCnR20k6Qb8LSs5Y
	 ujB63ALJNQSXLvNa1wAk+eW5TXEUF7aKeiFrth2Nz4nYt5gZLWZV+ZtvCzYgDcqgqh
	 xyiIGlPpS0MTBWFViqLHgD22Scd/GvcVn4sHgUmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1390/3318] Bluetooth: selftest: Pin module for selftest debugfs file operations
Date: Wed, 18 Nov 2026 15:33:32 +0100
Message-ID: <20261118150402.280296844@linuxfoundation.org>
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

[ Upstream commit 64aabf94ecccb1120a63b4ee5a6761871a181a41 ]

An open debugfs file retains its file_operations pointer in the
debugfs proxy state. However, test_smp_fops in net/bluetooth/smp.c and
test_ecdh_fops in net/bluetooth/selftest.c have no .owner set to
THIS_MODULE.

As a result, full_proxy_open_regular() calls fops_get() which succeeds
without taking a reference to the bluetooth module. When CONFIG_BT=m
and selftests are enabled, a userspace process can open either
/sys/kernel/debug/bluetooth/selftest_smp or
/sys/kernel/debug/bluetooth/selftest_ecdh and keep the file descriptor
open while the module is unloaded (rmmod bluetooth).

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

The issue was discovered via manual code audit of net/bluetooth/smp.c
and net/bluetooth/selftest.c.

Set .owner = THIS_MODULE on test_smp_fops and test_ecdh_fops so that
debugfs keeps the module pinned until the file descriptors are closed.

Fixes: 64dd374eac15 ("Bluetooth: Export SMP selftest result in debugfs")
Fixes: 6de50f9fdb60 ("Bluetooth: Export ECDH selftest result in debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/selftest.c | 1 +
 net/bluetooth/smp.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index f49604d44b877..6abf70c14f598 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -191,6 +191,7 @@ static ssize_t test_ecdh_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations test_ecdh_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= test_ecdh_read,
 	.llseek		= default_llseek,
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 83eef7a02e0db..cd224215e08c4 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3736,6 +3736,7 @@ static ssize_t test_smp_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations test_smp_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= test_smp_read,
 	.llseek		= default_llseek,
-- 
2.53.0



