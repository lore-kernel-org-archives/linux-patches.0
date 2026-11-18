Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034449;
	b=SHKXcJJaDdNJHalQmWnqVS2mqahBxukvtyqxRv82iV46yAb1+cfOMhMfPfQCKzfXVSjM
	 PkqXVIg7kBtVbjUFreljnCYdKEmSwLQMUxFAyyp9/iWiu/2K9Pv2pEbiQ7w3vi6/l24Hc
	 bl7vgWeTy9Xmg/FZcOYIyIgkqUKtALzXhJ/GMwoOCGOpYCVz8uF7RgEchsxNXb20NzakU
	 wLTdvbQiICuPZRIQIsOow7+aGKuj09xhG2Rf5G88FbGzyfBeD77ZT7/HlzeEO51Yh7X2H
	 bf2zA738mgEUjUAQ43JasM9tkteU95j4By29YmcDn8pPsABi/2SkqgglqwD9iwIXRbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J7oJMtD/4jju50IKkQSc7B1rgUQPNFjyfxfw5n+oXho=;
	b=MandeatyxEUb2Ui8sIpMYqXotrAAqIV7JZ+X1w6I0RU8KCiJLJMvmsE1vdZsiaGz050M
	 RTFFUu8mGnaK3kAv7nZHjgUxuws5U45KF9qbcCGb50D9GZ/Ae6pBfE44ycj/h/UPjWs4u
	 FQypy4+zRPUKZDlzma0jkaqBxRxnZi+6uhhWRX9o1OGKGGl4p5DEyZVjSZFUCQOQlY8FN
	 euVARyhU5ITh1kVS7CR4zj+g/rcP20PWsukkFfEzrfZ4gGeCE8DauvHqeQr/yQaeAxHp+
	 +kjFBz7sgrnrsJQVOLFDdqqF4YKmxqb4xQRslSqbNeOzSR57dtpGt6VeKIBBLWld7tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJBT1V3U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F06606A31C;
	Wed, 18 Nov 2026 20:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJBT1V3U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BCA1F000C4;
	Wed, 18 Nov 2026 20:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034448;
	bh=J7oJMtD/4jju50IKkQSc7B1rgUQPNFjyfxfw5n+oXho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJBT1V3UfNM00hlLkUL6MOhVAIn55sexis2Hx/cBD0SG5Dx7Du9iSWbxogPEQb1IQ
	 1LfIf6yAfED2g9XM+gDK1ZwuAPHUd6ulM9JGPq8kyrgET6u0tLcPyk2E1EpQgv2qN0
	 m8G/ibCd4Zg3vFD6wMam+nQWh/WJE+NPjvjfZF90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0371/3318] wwan: wwan_hwsim: Pin module for debugfs file operations
Date: Wed, 18 Nov 2026 15:16:33 +0100
Message-ID: <20261118150327.337601991@linuxfoundation.org>
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
@@ -378,6 +378,7 @@ static ssize_t wwan_hwsim_debugfs_portde
 }
 
 static const struct file_operations wwan_hwsim_debugfs_portdestroy_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_portdestroy_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -402,6 +403,7 @@ static ssize_t wwan_hwsim_debugfs_portcr
 }
 
 static const struct file_operations wwan_hwsim_debugfs_portcreate_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_portcreate_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -423,6 +425,7 @@ static ssize_t wwan_hwsim_debugfs_devdes
 }
 
 static const struct file_operations wwan_hwsim_debugfs_devdestroy_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_devdestroy_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -446,6 +449,7 @@ static ssize_t wwan_hwsim_debugfs_devcre
 }
 
 static const struct file_operations wwan_hwsim_debugfs_devcreate_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_devcreate_write,
 	.open = simple_open,
 	.llseek = noop_llseek,


