Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064853;
	b=rQvzNITUQWcOYrMoxMaz22iK2oC78RjFCND+8gdLH74rLB9oBEtr3uUxD6+tz20CQSAq
	 texJekuY6ktuSLvRZUMfl6oYcknLJfujxjvfvph2q6B2x93B+2zsmh4QjiHpaJ7wwsESe
	 fbXTtAZu9GtIR1p6jNBNc775wV0USaLjGObao8oz6EWSE4FnyQlkqmdqUqAafs7HAc5OY
	 +IgKYyYydqT9csIE6tcjUFXRqmzqW2tYPK0xtInLquoX4iFdx1D9B0UwSf+3YunG8bcLr
	 3UA3jdDOU5/vCoRH2Ywdu0zY6B4FVBVjVLRMYoSTXcEDxJo6P4kvN9PsNqyLUr6AkOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ir9gfSb9kdBTBK4MUsSk9ouEfe2fb5fUpFwkwJKO1I=;
	b=JaEQJfwYJt/yXuoQJtjQtXJ4R1B781RZetZp0xib8GRKqOuPNXxoEPA9eq6h5IhrlqNt
	 CdUEbFzoMVnSvZX/GzFGx1kfo9AdG8lb76BNb5fr+N607V+EYxy7Bf/Mw5sRA8Bmd1YbS
	 +aGVFojEkL887W4TlGPiIqDBdl5VVSdQ/vPug0Kw7N4Ynvc5VLgeRpdIA0I4G/iud5FRI
	 JPQRm/rWixBw82uYIHnlNC27FjVHJPtZVYtTFIukionCFsWg/m1peVLSc1yoTsJ03Ba59
	 l5P35Uo5/e5jMhK653orOhjMjJDUoL8KWXI4S/gVBuH9cLgG1cPvpSu0gXy+gc5t9pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEp7Vpmk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB6B606A335;
	Sat,  7 Nov 2026 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEp7Vpmk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1F81F0089F;
	Sat,  7 Nov 2026 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064852;
	bh=+ir9gfSb9kdBTBK4MUsSk9ouEfe2fb5fUpFwkwJKO1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEp7Vpmkjy7Iv01FtMl1y7sYshD1ap7RPIa4uoXeonzC/X0fJmcR4CFuo1cLmtSJ1
	 BYzfg+uaJ/LC4ehXxl3kBfFk37+UMC2McTIGY0G9YnHwc3KJvA23Donvp87ze1ndmk
	 aOK9TR4swBiFA4QGMUJ+U7PWqNFR14iTFcJmD0Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0775/1257] Bluetooth: selftest: Pin module for selftest debugfs file operations
Date: Sat,  7 Nov 2026 08:51:11 -0500
Message-ID: <20261107135000.708718898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ae5b44bb9d3d3..cdfc40e0016b4 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -188,6 +188,7 @@ static ssize_t test_ecdh_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations test_ecdh_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= test_ecdh_read,
 	.llseek		= default_llseek,
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 2df303f6a38fa..81d255525fe07 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3696,6 +3696,7 @@ static ssize_t test_smp_read(struct file *file, char __user *user_buf,
 }
 
 static const struct file_operations test_smp_fops = {
+	.owner		= THIS_MODULE,
 	.open		= simple_open,
 	.read		= test_smp_read,
 	.llseek		= default_llseek,
-- 
2.53.0



