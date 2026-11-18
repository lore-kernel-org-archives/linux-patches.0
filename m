Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043884;
	b=RzaoX+3bopPQXDYpBwKVE7B63vggv3WWZ88GetgwZ7+5JVxpyjCv+5ad1o2ef5aBq3oY
	 cJPo0qyGrFlEWYhmHCrEsaGALlxEWAvA/i0rplH1wtrjhGPu7UnIfXLEMPb0IDAiHr1CZ
	 3dBrPRkp6dIxmq8vGWVpzBratNqNpX0RncfcWSvbFERq7GoVgFcuydqlBxpLahLcXjVEE
	 HwZr6usnUL4nuz946zW0fPwxicdOd6I2tlbbDoOTw28t0ahKH2MOnL7N/YneCCPczJ8FG
	 ZLcpGkOl/fRcaldEZ5ERRIua3gfIEUb3Et/yXpnY9vAjAiVa5MkmPl+cHQ1Y+92tj0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WfpuI6PGiHY+7j+h7KzL9chmLtdVEwjSpqDSnsS+DLM=;
	b=R84CHininUnFFGmKjzVApWMbDhAAnZ59LoM9W0Tvc5hhYZu60JG+CSWllA7O16G5L6qk
	 iSaWWFPlBHwrfdKxTC5Wcmq7nwbY+6p3urrLPh7rVA9PxYlejULjz1n4xjXmrIBcVvruf
	 Jfc/D31iF9DVaAvCiBLvgWPO8i5xl5IO5RvgKmhuwhW6/tqNnAgkeSgvd4NCewF//d3w/
	 dSnU874iiHOozJboitQ77PKImId8yrHLiu0yu7yGnKvhyl5MUpwUTDdMe8IfANne6uont
	 U7GTootkDcxz5nbsd06BSJJ2ea92d+FBurdxDe9bj15A8GYyGvLxq+MsdJFckPxA6Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awhGZTYd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E47606A31C;
	Wed, 18 Nov 2026 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=awhGZTYd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20351F000C4;
	Wed, 18 Nov 2026 23:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043884;
	bh=WfpuI6PGiHY+7j+h7KzL9chmLtdVEwjSpqDSnsS+DLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awhGZTYdA0D389AzOhzSAiQnAeclxKlvB9nxNkT7OLeK5fHN6MY9v989QmY14agOl
	 4rRf75XlGBITpogQhXmIVXEn5V2DnQIkIP6lq6y6WPilDAJgRLVVB5ymEwNeVUyFR/
	 VxM57siwFCUDvAQphZPeAuLmLzTOGkb+fDfC4BRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0319/2857] wwan: wwan_hwsim: Pin module for debugfs file operations
Date: Wed, 18 Nov 2026 15:22:33 +0100
Message-ID: <20261118150212.925955462@linuxfoundation.org>
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


