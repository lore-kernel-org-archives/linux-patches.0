Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590148;
	b=joIHzypO+28BYFH3t2TZlc7VUjAAuVYWlORTXWaw0e2dhITrRIMzmpzhg3EjRmydB4PP
	 IQOzj08Dej39UiEQI/saTbzWC7C3XVjk0YI7QUKyDbtmAv+GJ/iBvTI2dJUpITvgaTypS
	 sRdJ24ZYeDo3iw6s6LT1t2RTeVA6SF2xaFSGD2OcydVXhnFiJjn/Pj2GvjrRS4zpGsNmc
	 fcapMKWfSbaPDuK8F4IzqiuHbNqxQt0lTNjo5aL1tvYAzsQ040mKZ6oAtDEQ9iO+up0kR
	 ABaBrFmBQPGcC0FMZEayH/BOpoMqH4BSxo2hI4iQmW4lRrJmGS9kTtuooRS3Kytj87w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E5IktGFF6vvl1Jx84FPAilmMORU6bzGH5EO75Y8Np8w=;
	b=sAshNt+oybQX2GQXK4OsAHvyLGYhQCm09/lw3Xurh5Y6f2k/Y205wFpP1yagwpwt3vcE
	 SBpZTFfSCXArd5LSghEJbwRKpurPdw/qG1DE+pE/9Ek3Vj062SgRc7rBHxWCZRVTHYbfz
	 GsGQU+1qS02cDdHFDVPA1DzMtHLtyzfIi1RrxnszWRjpum9UTNeY5TZuGTyHKDbyQvuQZ
	 ZL150KId5BOPGp+PrDjXKUFvkkMg4DR+SpJQPR7GfByTU0N2lupMtJF12Fz7lYOjdgZx7
	 gUl0deSdTKzrRQMAD8E/q0rMgNLF4JaxPO5AYr4eIEsJW5jenvEaO/lz9N97cVLOjNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XqBkGf2y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00956606A899;
	Fri, 13 Nov 2026 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XqBkGf2y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06151F000C4;
	Fri, 13 Nov 2026 17:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590147;
	bh=E5IktGFF6vvl1Jx84FPAilmMORU6bzGH5EO75Y8Np8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XqBkGf2yJWONvA8WQGqqmySnZoTeIZpHBaDdpceHYI2jjQKVTKyS3koLDqSJoCkRl
	 1ozmJH3nSu+ZohPg2PMQ7vYdmBn9m3n2VNzQX4FUX/rxzfqpZRGPxRn/iIEXl6qP5M
	 cS1eljbpyGGBJBhgdttED34CrAAWkH/iAyurbMtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/686] Bluetooth: selftest: Pin module for selftest debugfs file operations
Date: Fri, 13 Nov 2026 10:44:56 -0500
Message-ID: <20261113153826.317566243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 81bf67af87fcb..e4cdbb7df16a7 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3735,6 +3735,7 @@ static ssize_t test_smp_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations test_smp_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= test_smp_read,
 	.llseek		= default_llseek,
-- 
2.53.0



