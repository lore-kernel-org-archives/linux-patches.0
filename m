Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018787;
	b=FAcJE4um95g9PrVls4toiXBzI15/COEpDmhLvFPZhRSdxgc64aQDzfSTR7CgcbeB8w4Y
	 NRqSF56y2+KvHLLFdnXCGm0+rvBDgj/OSqjYZ5uYdV83arpEg/8bHibSYc/TYsdIO2Sqb
	 uIDA5WFPP71XtVR7bndR80Cj4iSUn8GUbP0Y4LhL5V7FDGd311fwd9uEL/zy4t3/r3WiE
	 wANaPAPBkLm78LnHSWMjNRHkM96hWZXXMs2r4H5gVpcif4UfnjOro6hxpRELqefuOEf54
	 NUZj2hQircex49vzbSOgfXOxLc1kT59iyYLkyVShhFYrKBaNpB6hAPkbYBtj78tRYrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ksr+vC6FRRpcL7DDzFWHS7tbiDZQ6U7vySPp4VIwLJI=;
	b=I5wyvn0r+bwM1dgv2QD40S6UyJl4VUPtSQEXeHa0otkoGKz3/a/0HjbIIV3nM94KxaMD
	 XiczWe4FXZD5i5LxDikQEtANOxG2M3io+uwjs9mBsQFhJAH76RIGA8vRe4NXFGpg/TAtv
	 R8FfXWs4pp5dw9BcPDB9LrTdN0pN6wT0dM6WIkE81veCKkG/r8XtQ2l79uEA8nP2N1gE/
	 R1CZBh4Df59dnakU3G6OYDjnjjpuRcWj6JQKVBjkldCm+7nWaZ7izlDL4HpQtTddXdI07
	 e4D60wj/prFfoeIU2Z/RSiYssWOplqaszZMcuXDwrOgdxIqut8iLtTRb6twzVth+VmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qxxEG27H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8669A60A2604;
	Wed, 18 Nov 2026 16:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qxxEG27H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6C11F000C9;
	Wed, 18 Nov 2026 16:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018787;
	bh=ksr+vC6FRRpcL7DDzFWHS7tbiDZQ6U7vySPp4VIwLJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxxEG27HZF0oXohYT3QL/Dc90CVV3qI49zPvDUyAKoBwxIRzA1BIFdcvE/l4w99Ot
	 T2jIpXFfC7rFh7WA6P1PmX/K0kVrDxxvCRYsskaPPT9w9crNCnrHma8piybjTuv/yw
	 1u6MQmPnUxXAgcoxDQoeijBN6DuwClHbqA7UrWf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1365/2651] net: psp: drop psp assoc clear in sk_clone()
Date: Wed, 18 Nov 2026 15:43:25 +0100
Message-ID: <20261118150337.172691372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit c135ee9f4975f9f05465a5fe5eb0970b0a47c55d ]

Unwind the change from commit 1d2929d0850f ("net: psp: do not inherit
the Rx association on clone"), now that assoc state cannot exist on
listen sockets.

With commit 8cc3aef0cb19 ("tcp: Do not allow buggy transitions between
ehash and lhash2."), and the change in this series restricting PSP assoc
operations to established sockets, this state should be unreachable.

Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930-psp-defeat-v2-3-f266e7447129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 1108543f9fec5..5b7ee5c76dae6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2496,7 +2496,7 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
 #endif
 #if IS_ENABLED(CONFIG_INET_PSP)
-	RCU_INIT_POINTER(newsk->psp_assoc, NULL);
+	DEBUG_NET_WARN_ON_ONCE(rcu_access_pointer(sk->psp_assoc));
 #endif
 
 	/* SANITY */
-- 
2.53.0



