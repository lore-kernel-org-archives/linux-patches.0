Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061139;
	b=SqSZsD4O7Mu6Zbbt6zB4HBkI3lNll0/2YpqW3ztj9ncj7q8MpwM147adB8fj7O9WvQEj
	 Q1vS5hf9zMcQEK4UArPpoOdEHv4uQZ7bILYvZUuDxVlQzbRnfe7kw1F7YcVyJa6VYy+0i
	 vIJoRsXZ20QelNDyuBe2GU1DXCiAjalV5JvChckvjnq2SsZb5ehpIW21fEcpH8Pj8v/9x
	 XpvPziMcW7v6JWSkV0yRtjDvzaH007I3iHC0T7DtbsOp5yb65T451uBYhp6Pj5+3APwgk
	 71vREACbEoOf51SkwOKHlg46fUo2mkBuUPIEgRULhUPx1mPNRtVmu3uctkIly+LJ9IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eaYQntWfi+WqobRQuB3uakLoi6O+K8wEM97yahwMOUA=;
	b=RN14OvmxzPT10cH6C6KhZelpbFgnBODpEa4lf2Zq76v2pfEAil9DG2hyeo8FpmNucm0h
	 0fBhf0dgvkf4uN5eShG59c8I8qiLzEWmThP9mToWoxu4oRf4UbuIc/+8KnPeMrqWfAshl
	 YyzJeh4irOfmnura61iYJv48x6HDW9sXqVPGIC0qnlCaAy7b0p8fTXzJ6gYjdKd7TuCVB
	 Wl7CKVUNryoDjQG/0VcOzReEBVACIYUOOLrb5eGdmKToTH5SZtA7X/n8Lg5NUDCMWj9ws
	 IxTkzYlY5+U7Yi+xdKmum8NvqE5oTYrFlz527QN//TXcati28Y6u6VGtB8SObI2a1oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUsrxfh2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1828F606A332;
	Sat,  7 Nov 2026 14:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUsrxfh2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA53B1F0089F;
	Sat,  7 Nov 2026 14:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061139;
	bh=eaYQntWfi+WqobRQuB3uakLoi6O+K8wEM97yahwMOUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUsrxfh22451l8m/0Pg6SP+8ILt/HCTj2nQFDOJTuPf9mo9v7VvOakE+jLnUt+8qB
	 JWCAbcWsgreA55xSTm6nrGU63mv+/9VohXN1bkeYm4Yfxpoa8nmU18CnzqvZL0dvwS
	 FOmVpUOdUwDYcK/TqoWIASk9azJ+I6g40s2nPpYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 0447/1536] wwan: wwan_hwsim: Pin module for debugfs file operations
Date: Sat,  7 Nov 2026 08:41:03 -0500
Message-ID: <20261107135010.094769589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

commit a388f17e23b7e305cb306aafd73bb10d6b8ca452 upstream.

An open debugfs file retains its file_operations pointer in the
debugfs proxy state. However, wwan_hwsim_debugfs_portdestroy_fops,
wwan_hwsim_debugfs_portcreate_fops, wwan_hwsim_debugfs_devdestroy_fops,
and wwan_hwsim_debugfs_devcreate_fops in wwan_hwsim.c have no
.owner set to THIS_MODULE.

As a result, full_proxy_open_regular() calls fops_get() which succeeds
without taking a reference to the wwan_hwsim module. When a userspace
process opens any of these debugfs files, a subsequent module unload
(rmmod wwan_hwsim) can succeed while the file descriptor remains open.

When the userspace process subsequently closes the descriptor,
full_proxy_release() accesses the already unmapped file_operations
structure, triggering a kernel oops in full_proxy_release():

  BUG: unable to handle page fault for address: fffffbfff84f90ef
  Oops: 0000 [#2] SMP KASAN NOPTI
  RIP: 0010:full_proxy_release+0x8e/0x140
  Call Trace:
   <TASK>
   __fput+0x357/0xaa0
   fput_close_sync+0xe6/0x1a0
   file_close_fd_locked+0x17e/0x2f0
   do_close+0x33/0x70
   __x64_sys_close+0x44/0x80
   do_syscall_64+0xc3/0x590
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
   </TASK>

The issue was discovered via manual code audit of wwan_hwsim.c and
reproduced on a Linux 7.3-rc6 test VM with CONFIG_WWAN_HWSIM=m.

Set .owner = THIS_MODULE on all four debugfs file_operations structures
in wwan_hwsim.c so that debugfs pins the module until close has
completed.

Fixes: 9ee23f48f670 ("wwan_hwsim: add debugfs management interface")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20261008130753.313875-1-dungvn2345@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/wwan_hwsim.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wwan/wwan_hwsim.c
+++ b/drivers/net/wwan/wwan_hwsim.c
@@ -380,6 +380,7 @@ static ssize_t wwan_hwsim_debugfs_portde
 }
 
 static const struct file_operations wwan_hwsim_debugfs_portdestroy_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_portdestroy_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -404,6 +405,7 @@ static ssize_t wwan_hwsim_debugfs_portcr
 }
 
 static const struct file_operations wwan_hwsim_debugfs_portcreate_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_portcreate_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -425,6 +427,7 @@ static ssize_t wwan_hwsim_debugfs_devdes
 }
 
 static const struct file_operations wwan_hwsim_debugfs_devdestroy_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_devdestroy_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -448,6 +451,7 @@ static ssize_t wwan_hwsim_debugfs_devcre
 }
 
 static const struct file_operations wwan_hwsim_debugfs_devcreate_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_devcreate_write,
 	.open = simple_open,
 	.llseek = noop_llseek,


