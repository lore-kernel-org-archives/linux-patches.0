Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590976;
	b=fBMmsmhJoxrP/eO5k1ueXp2n8AkE4m+lkyWXvXyDd3NQDEK7l18EDwsjfZfeCRo9cP8E
	 0377bAR8bNxVtVgEiA0QjRBfv2VTe6mqz3kY9z1uzKSEBYT1e+zz8jse/ByOqZ2INdfZn
	 GBFfdBd4OlaXS5Ot9ml5HjG0VFBZbOXRyEds4P+D72EV5mzjv2iqZw4AHfQxR4cOrux28
	 0MyhKI0web9A0cKS/urRQ4w3t+89u0nwR0fztXc7YAHlkXgYUOv0Ka1JCXsBFVWMK6GkY
	 9tWFV3C4/MhgTBsNJ73k53vVWRO5dQ0myot9aHLfpwvnozaqaqtCRnrJcRKRFj0IbUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x6ogscHC/tu+J/9bFR4rA4uom6vqIOEFk+mMDPjqpVc=;
	b=RCyF3K5aDuVjLgCYPGgVniHm8r24JSAWMeRdP+Qp3jsKErUFYyI9iMtKGBc/51C0JBEb
	 v7CseQU/p5qtSiNoC5t2cQZeI/p+beFMscSFx2Ejb4PWTbYkWU1NnyzNr+jKKNLnnhi8L
	 3p9+VSF4TFD3kSSghA4RDj73kscWoHVu8EhB8AGc4MdPPxehCBv0BOEduEL6x+PTXSpwz
	 t2BjPG2vK1YcJTmLUsxyvkx2hJs0bGR2DfbgEsO3oAFRlcToB9aMrnZx3PPpcCXE4fFqY
	 fooXOzKfT5NOePiYNkkRh3yi0yVjN4B4W6MSrhZGjGwEjCgft6sNVQIgkUPbR1FnwnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z+/KAnDX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703F4606F737;
	Fri, 13 Nov 2026 17:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+/KAnDX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1FE1F000C5;
	Fri, 13 Nov 2026 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590976;
	bh=x6ogscHC/tu+J/9bFR4rA4uom6vqIOEFk+mMDPjqpVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+/KAnDXopOsar4S5YOy2S60/oksXeqXUGPGbFYnA++7C8giHdJ4mR5QIAV/+sj3U
	 aeKwwLCF05f8xBrjkawqTmxL0CyoZux3elOoko9RvHm1qumXyjXyF0R+6q62qwitJv
	 C4G2rzypsJwCgPrnxS+O0axCMaJ1dyMmF49XuXBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/670] Bluetooth: selftest: Pin module for selftest debugfs file operations
Date: Fri, 13 Nov 2026 10:45:18 -0500
Message-ID: <20261113153817.360225547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c093797962266..be1bde5b8ed63 100644
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



