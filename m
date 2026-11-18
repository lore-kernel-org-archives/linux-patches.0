Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021220;
	b=0szoQuY+JrNUJF52Vf6D8lqNH+6bjT5K0NKzOESg+fECZVqyCL2FTD3RFXVyjGQTYpPt
	 J7EAgeIpndjq7jALW1tydEqC778dv8tscGALAhzQGvTdC9f7zep0hK7gBPtPRv6RgYoqP
	 NyXzosxb2L19khJ9x8zIltG7ivP2XRErDHLOQZqp9aUY6Qw192c4rYkpTgwA46mVvLiVt
	 2uD+JUM0UMc1dgqYI1z9jQ2Frjlfimzws5ebKBw/bfa87VYDBnupGSacjQr0qj7scijXw
	 WObuHK4B2uD6jsiZvwck+1TtCMD94YecoFPvaPXr8691k+qQYor9T51mcgwJUjtNarQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eQPbqGvZtxeyPCd76vJcFREQwiM6oh/wVS4+bfdvEUo=;
	b=c7rtztqKrUjpTOrUSBc9ftBoQUS3KdkQ/Wlyr0iiJa0HDD2i/hoYXG6BVfqYhVUkcSov
	 cAUiOS93klFLrHpfdUo8GrxkrhSAlF7rV5tn+p5+6WowENkOBBFLXyiD9B6zURDqy7n0S
	 CkKGjdM19/41FUy/yeeRnFURET1GXKkWGNrG1BuwQ8atdapOWjPKleZchcIBvQERw3ue7
	 eVjqgbXjNMUqeE2km+FQIqG8E0KBk8cHGQrx9V1T7/QIfkNlsgQgrbN1kIEQGoNfMh01U
	 DIFRdvVFUcb6P9AeLPscWRCaO+C9JZcYNDrmWNYtOj7O414cSKdZCxGkJ8eNcYm6qhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsBeYl8W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7D9606A330;
	Wed, 18 Nov 2026 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsBeYl8W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488A91F000C4;
	Wed, 18 Nov 2026 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021219;
	bh=eQPbqGvZtxeyPCd76vJcFREQwiM6oh/wVS4+bfdvEUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsBeYl8WX6VOGo3TLzioHOND80fz8SQ1DNIylo8avaZNHUJ6/xKw/PNzIP9I3DrxA
	 nddjz/CcLKKqgQ3ec8s0NbzDOvVvzGJwDgyvenjisquPBHB0xeohOq33rlXM5kXYQL
	 S8im8wp6eNygApenxbJxe87eWdFhQ4ZNzKYNUcl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Mahe Tardy <mahe.tardy@gmail.com>
Subject: [PATCH 7.3 2188/2651] bpf: Fix ksock build with BPF_LSM=y and SECURITY_NETWORK=n
Date: Wed, 18 Nov 2026 15:57:08 +0100
Message-ID: <20261118150404.546166450@linuxfoundation.org>
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

[ Upstream commit a81bd9262cde4b002b95e652453ce5b815c79a62 ]

bpf_ksock.c references bpf_lsm_socket_sendmsg() whenever
CONFIG_BPF_LSM=y, but the socket LSM hooks, and with them the BPF LSM
socket_sendmsg hook, only exist with CONFIG_SECURITY_NETWORK=y. Without
it resolve_btfids warns:

  WARN: resolve_btfids: unresolved symbol bpf_lsm_socket_sendmsg

and since commit 201a454df948 ("resolve_btfids: Fix the --fatal_warnings
exit status") that fails the build with CONFIG_WERROR=y.

Only reference the hook with CONFIG_SECURITY_NETWORK=y, and use
BTF_ID_UNUSED otherwise. The ID stays zero, as it was when unresolved,
so bpf_ksock_kfunc_filter() keeps allowing LSM programs: none can be
attached to socket_sendmsg without CONFIG_SECURITY_NETWORK.

Fixes: 7ae4eb14c5f9 ("bpf: Add ksock kfuncs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Mahe Tardy <mahe.tardy@gmail.com>
Link: https://patch.msgid.link/20261019211006.2574350-4-sashal@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_ksock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/bpf_ksock.c b/net/core/bpf_ksock.c
index e9943aeeadd32..6fbbd5745d649 100644
--- a/net/core/bpf_ksock.c
+++ b/net/core/bpf_ksock.c
@@ -274,7 +274,12 @@ BTF_ID_FLAGS(func, bpf_ksock_send, KF_SLEEPABLE)
 BTF_KFUNCS_END(ksock_kfunc_btf_ids)
 
 #ifdef CONFIG_BPF_LSM
-BTF_ID_LIST_SINGLE(bpf_lsm_socket_sendmsg_id, func, bpf_lsm_socket_sendmsg)
+BTF_ID_LIST(bpf_lsm_socket_sendmsg_id)
+#ifdef CONFIG_SECURITY_NETWORK
+BTF_ID(func, bpf_lsm_socket_sendmsg)
+#else
+BTF_ID_UNUSED
+#endif
 #endif
 
 static int bpf_ksock_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
-- 
2.53.0



