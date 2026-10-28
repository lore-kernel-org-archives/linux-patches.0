Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217395;
	b=LejiCR7DS0VXe4TpN/wvfZjAZFFxIgHro73Lh66YTaQGu5wtCcDoJ7XimBDPnXce/GKm
	 VmJ12Z6Xhy6fyZgjLXckFooP/rqfM7r0zAMa+5qAsoxVVJDz3loNmANK3AxxHNcPsvix0
	 Ukzlq04WnCp7DmPjuwlqmHKtZNdTxkeKriVtAMDiMLEa39fArvWdiz2nKKl8s+IUxpZJ8
	 Ym8qscwlN8fDfQZ0bBK0MW1HlGScc+DKgbeHjmAzQiGFsFGidK3CnZ+7ySCIv0/2Isug+
	 gd/TjU8D7obtNaieMmShQ2M39Ym9aIyjkz/vvKdFN5C70wITZEOox7a0s2GZuABFshw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KmTUAGXOzoCHx3TuBtr6U3sEbnrH8fjIoByELk3I++Q=;
	b=GANJUjOexjZcZ3cSCmb1THt5J/Q46MmtSUnsgNN4v0rckmySmpXeYUEZ9pHSo78ZVPni
	 152Nq1cy6WW9trug8NU0uCBb0eqsokvrXAeyNJNWMgE8FOXccbOx1ZRwG+bFDcgn7KDMp
	 GZiUzLqJmLKTANmC615jAZjJrz04T7BHmPyJXsYKuZJkv0fMYEkOvjSDcrce0UIC7x63h
	 ITdD+Iw4J/silAzS9+W48KnpxOmJcYC74c2qGsGGmGhnfEty8e1LkAGUi4S5LzGhJQs9t
	 NaRW8QEhtSyYK7lZxEFDwAHR8Ra1iBo9KomwUpVZiJ7eCtNZe8PXWXn+mWnevEwRMOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6wnP4Uq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3CD606A31D;
	Wed, 28 Oct 2026 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6wnP4Uq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0D81F01825;
	Wed, 28 Oct 2026 19:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217394;
	bh=KmTUAGXOzoCHx3TuBtr6U3sEbnrH8fjIoByELk3I++Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6wnP4Uq7k5GX8C/5bx+Jg4y0p3h7cqlmY/N+5TRTc0WbT9JZPvCo6gMq1ALFwsfP
	 TzIPR0o2eSaM4RsEJsZdqXDX3DNntz084BdvkwPaV+ir7vjnd/NuRp3bYPVXbM/gzD
	 5aLI2+QePSZ9ZXqIbuGhiU+XIGf8KzUhJpPbqWQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1882/1887] inet: control sockets should not use current thread task_frag
Date: Wed, 28 Oct 2026 18:06:18 +0100
Message-ID: <20261028170542.283866853@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1ac88557447088ccd15eb2f2520ce46d463c8e0b ]

Because ICMP handlers run from softirq contexts,
they must not use current thread task_frag.

Previously, all sockets allocated by inet_ctl_sock_create()
would use the per-socket page fragment, with no chance of
recursion.

Fixes: 98123866fcf3 ("Treewide: Stop corrupting socket's task_frag")
Reported-by: syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Link: https://lore.kernel.org/r/20230103192736.454149-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index a09b90552cf6e..73881ce0ca561 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1700,6 +1700,7 @@ int inet_ctl_sock_create(struct sock **sk, unsigned short family,
 	if (rc == 0) {
 		*sk = sock->sk;
 		(*sk)->sk_allocation = GFP_ATOMIC;
+		(*sk)->sk_use_task_frag = false;
 		/*
 		 * Unhash it so that IP input processing does not even see it,
 		 * we do not wish this socket to see incoming packets.
-- 
2.53.0



