Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213314;
	b=rLz61Ma/9wuCZWlDB1dDhmQkU96TIfuJPrpuX/u9blHLQVgrl5YC44HwxiRQDVgHhS/n
	 2wJISnzaUT5ifsD+joc0u2W0/oNUDZ7W6mr6dVuT0J/v7MGzNBrQklG8EBn3o7HXBU06T
	 ZN+SU7X+IQyzmI8uRoh85jMlZgdZ9VAHFFHRYLDPm2wukUfAzsSrAfkYJCHiqaT2ZrsRz
	 yotVjVq7q+R/BDqyTKiXDJ7AnRMcwZtZ5Xlq7X506Q8bbp7+kFOvBE5rgY9QYy3MmmQmz
	 qHusVeo/LRNnWZhTgJYs+4pK5wNjf2lfGs1FmOW/mYK1cBikmSOgvsyma/7ud6kgwNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LxJ3Mn6z+IVSw4rIhmOUV1lvt46zYYUUH+3RFjY3BQI=;
	b=uqBrUBgF6/5M45RDbi2+QHdXT6qQnabXJAT/8fuPGE4CnanrAGj1YyY8Aj6w5W/TBVfR
	 j062qByJNkKJmTp2XWF2OtK9ypIBjYdW70tMRIEcwhsKCAe285hw4+q0sHCpn6Ke+K2ET
	 ywDUnJ+uErL3qnn+34yc+OHRI0a/tfivvKzdSpsK8dS5nB0zMoQb6OzfR/GZm5uLa1Sek
	 S7xmT3wNzrj3hHvgDSnAvY12IOWeHcaSYyH15yEDWHkuVl/4WjNTwdUU1OSv5gSGUVHdS
	 PSbYa9DUs94L2b8gJJt5zn1eKj3YjZILaSRLETr3ZeVgngnOTYMU1IeZwP/6RzWZSMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ew5JHnGu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598DD606A31D;
	Wed, 28 Oct 2026 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ew5JHnGu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9E11F01825;
	Wed, 28 Oct 2026 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213314;
	bh=LxJ3Mn6z+IVSw4rIhmOUV1lvt46zYYUUH+3RFjY3BQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ew5JHnGuYdOq6AJ6iOc0OxC1OYIoPENVW5o9B1pO3iznwuQA5OK+7h0T9OJ5Tst0q
	 QbFeg0RechBJPVOXze06iWf+cLNWKoUh6UrTea86FgCB7zkqcQybYgd0IB3zo/qhTg
	 3gsfcPzj10djIab0uRBMEb7xPM+wapXs9MoaE81M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0462/1887] net/smc: protect clcsock lifetime in smc_getname
Date: Wed, 28 Oct 2026 17:42:38 +0100
Message-ID: <20261028170509.748001179@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit 64a6b36b0e1855288080bc5f89769f27d6dc03c8 upstream.

smc_getname() dereferences smc->clcsock without holding
clcsock_release_lock. Link-group termination can release the CLC socket
through smc_close_active_abort() while the SMC socket is still open,
for example after shutdown(SHUT_WR).

A getsockname() caller can load smc->clcsock, then the termination worker
can clear the pointer and call sock_release() before the caller accesses
clcsock->ops or invokes getname(). This causes a use-after-free; if the
worker clears the pointer before the load, it causes a NULL dereference.
The syscall's file reference keeps the SMC socket alive but does not
prevent asynchronous release of its CLC socket.

KASAN reported the following with test-only timing instrumentation:

  BUG: KASAN: slab-use-after-free in smc_getname+0x19e/0x1b0
  Read of size 8 at addr ffff888109abb4e0 by task poc/103
  Call Trace:
   smc_getname+0x19e/0x1b0
   do_getsockname+0xe5/0x170
   __sys_getsockname+0x8c/0x100

  Allocated by task 95:
   sock_alloc_inode+0x1e/0x280
   sock_alloc+0x3d/0x240
   __sock_create+0x7e/0x430
   smc_create+0x121/0x240

  Freed by task 0:
   kmem_cache_free+0xcc/0x340
   rcu_core+0x50a/0x1850

  Last potentially related work creation:
   evict+0x446/0x6c0
   smc_clcsock_release+0xa8/0xd0
   smc_close_active_abort+0x26a/0x3a0
   __smc_lgr_terminate.part.0+0x137/0x2e0

Hold clcsock_release_lock across the pointer check and the getname()
callback to serialize with smc_clcsock_release(). Return -EBADF if the
CLC socket has already been released, preserving the existing peer
state check and the callback's return value otherwise.

Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Link: https://patch.msgid.link/20261008084444.787449-1-nicoyip.dev@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2677,6 +2677,7 @@ static int smc_getname(struct socket *so
 		       int peer)
 {
 	struct smc_sock *smc;
+	int rc = -EBADF;
 
 	if (peer && (sock->sk->sk_state != SMC_ACTIVE) &&
 	    (sock->sk->sk_state != SMC_APPCLOSEWAIT1))
@@ -2684,7 +2685,11 @@ static int smc_getname(struct socket *so
 
 	smc = smc_sk(sock->sk);
 
-	return smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_lock(&smc->clcsock_release_lock);
+	if (smc->clcsock)
+		rc = smc->clcsock->ops->getname(smc->clcsock, addr, peer);
+	mutex_unlock(&smc->clcsock_release_lock);
+	return rc;
 }
 
 static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)


