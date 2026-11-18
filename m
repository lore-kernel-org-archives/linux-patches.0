Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053181;
	b=ID3iIFs1ZjXJKM+T/r1PIciomV2Vz2jJSF3MVsQErFFy0XLMKfjydVsBT/OG5HMGIpMV
	 uQl4H+11dxXMiyxsWnDxZhqW2ToO+PknrDhEo1amd62izYoCFeQrBpAIDZDEqra7t9lf7
	 Hn/SqB6EXG0EY1NuSCH+QKldpp7nyreHZBqOzocXscc+QuvuY7F9W2xFxf5pAvs2jAvP7
	 ljWrqf7T5ro3n9IZz5qFEmh563tu7kXsrbetfU0sZh2CUrPdwab6M105/VjH+IQINRqeA
	 q2GbowAoCa7lB7NRrDV3v85ZodhwpzOL0X4Ctn9uxRTkabjJdQRmxN1vwDrafNM9NHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B0b/BY59dVy2rxDt4Au1oveBxI08Ooz5r76pvdEpVvM=;
	b=uEeCvFl2p/mJa19bdjg2C76k+tKfn/3yQgISwgdgJhhyZmQ0iveQ5PE+SibMxLasmFfJ
	 Zc9XAph+9EUkhHNULisko4Egt6M116OXjeDN3oGlhXSMcIf8VZy8e1CefMGgjus9vEwPm
	 HNb3z1NWYSPjNDmtvtJTiEo2P9zBsBbxdNq6QnLy2ozT46a6aJV0t+M5/UIO0vSZnDwaG
	 1cS0Sm8HGomNfZRomwhKsru3hBwDyOd/Adm88/6NOgu0heVnVXcWZHCVnlhxfQnS7/jSM
	 oVm7rbxVwCU2vtXZNr4C4QQ4wQch+f2mgn0fxJO9y5E1Jbjm+dkk599fznhmuRRqcsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GK74vcsK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB3E606A320;
	Thu, 19 Nov 2026 01:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GK74vcsK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2661F000C4;
	Thu, 19 Nov 2026 01:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053181;
	bh=B0b/BY59dVy2rxDt4Au1oveBxI08Ooz5r76pvdEpVvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GK74vcsK66aHNK3QEzNn32MTl0JXN5luX4h0AqCLTMbfqkeXUMICOnieJsDzmUjJP
	 aTA1PBRI0bkW4pK3bM1tu6RsaWn/boSpii5fD4r/tWr3t5wblmNXN+4S0M83kUMM00
	 fT1jahxMJOsot8JNgMM12Vspub3IOipCvJLqHUK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0826/2214] Bluetooth: selftest: Pin module for selftest debugfs file operations
Date: Wed, 18 Nov 2026 15:41:42 +0100
Message-ID: <20261118150044.825692647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index cfb99ef65e7d3..570dd94af3c3e 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3742,6 +3742,7 @@ static ssize_t test_smp_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations test_smp_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= test_smp_read,
 	.llseek		= default_llseek,
-- 
2.53.0



