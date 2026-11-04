Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827013;
	b=5no8JlOSgM3OjHY6TcaeqAXEORR37yd5KzEHpcs2C7bxrZpPMo3ZGULxq1at9j89yRhQ
	 SDvD+j6sjESTHfmnUrSm0uO+04z6yDgTer6k1zcTIqTARbCVjoY8XIsD89iBJ8SpgcVPs
	 mjzXcFJPefziOLuqUMA89ykjZPz5xrBXQ2ii/2ecFFBGk9ianbUXfPjU2TekP63xb1MTc
	 U7zgrZr0Z1nnNwS56Y89mbpXHp6T46boeuEXkIEZvbsPwLFAL8tlB/2mK1NUGJOQ1b8UO
	 Hm6j+fPzPG2dCzplxWAuR30n5TCVZAo1zHuMDg8sppIxDj9oBKn8RTBYKhOsbGZGj6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxKPDXBEjSNFzzMAz+3iSeyAeKyBRxksskc/sU+8xwQ=;
	b=ZFwzBSc2RS2SLfCXWXLttqh/NW3iacC9VjAWBtNOxUgwkc07oQwPE4CxYdu4eCRG5MmE
	 VV5+lNA/WxROIE6EiRYdmi0tZU91hZuBgz7DYOz1sBCPoZwjPAuisjxEB5wuORr7SwBP8
	 jzyiwCGss2PVYxpKdWc80vH4As++s6icwrR9zVTvjUwZ26o55ILP2NiT7CX2WAKHhUKoQ
	 VTPgSYuqoykftMWkNVjtwkv6wnMblucscQAp/XSN+F1g/RgKkM8bJERZCKd2BrMQ6YGQK
	 TrMrGLjmVhEn9cl51dBZorMDnlunFTK/MtxMWX7WoPEgcudPKmY9h0s0Gh7gb63446A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+wQyWc4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BDD60BF2F9;
	Wed,  4 Nov 2026 21:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+wQyWc4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47241F00A17;
	Wed,  4 Nov 2026 21:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827013;
	bh=dxKPDXBEjSNFzzMAz+3iSeyAeKyBRxksskc/sU+8xwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+wQyWc4Rm726QuyWXPYqQPxWS3QKD1qu2SWV6mXg0nha/TQnHt+J0qnykmferrMw
	 HV7Gmlx2RY1IOTvz6X5Tl2CfH0p33YNrQzGmF+fyeR09g16ILbzQu2fEqQjgT2L09a
	 C7ve9hSQBwdw+NPu0RiTfpYigPjFxUc69MYOGXq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.3 093/547] wwan: wwan_hwsim: Pin module for debugfs file operations
Date: Wed,  4 Nov 2026 16:04:37 -0500
Message-ID: <20261104211040.866759698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -500,6 +500,7 @@ static ssize_t wwan_hwsim_debugfs_portde
 }
 
 static const struct file_operations wwan_hwsim_debugfs_portdestroy_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_portdestroy_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -524,6 +525,7 @@ static ssize_t wwan_hwsim_debugfs_portcr
 }
 
 static const struct file_operations wwan_hwsim_debugfs_portcreate_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_portcreate_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -545,6 +547,7 @@ static ssize_t wwan_hwsim_debugfs_devdes
 }
 
 static const struct file_operations wwan_hwsim_debugfs_devdestroy_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_devdestroy_write,
 	.open = simple_open,
 	.llseek = noop_llseek,
@@ -568,6 +571,7 @@ static ssize_t wwan_hwsim_debugfs_devcre
 }
 
 static const struct file_operations wwan_hwsim_debugfs_devcreate_fops = {
+	.owner = THIS_MODULE,
 	.write = wwan_hwsim_debugfs_devcreate_write,
 	.open = simple_open,
 	.llseek = noop_llseek,


