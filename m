Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213962;
	b=OkoeFgqPiY81EgpnRL4Pl2XdRF3jtTK0aFez1KnqCpm9/dizeUeKvc4VDEcuW9Tdx1lf
	 3bjRxW1tFt6tW2amAzYjJhKrrAMKgZoONnvLOB4vxCnbUR7nZq2sqSJMTMGrm6Nq4Fnjs
	 8OdWEOam2/0B7gYAMYxMsVC4nwexmQyk+4edslU0suL9UBs/Y3/N8o16l5lmhxtsRW2Ku
	 hLimxcUtCDU/jgoxY4pCjJ1KzM5OkcQdWz0rMDYdAKyw2kbLVaJusaQUpNGt/nSt3SzXe
	 3i5TueeEcpUM9EBR+GUdgVrbSe5ZM47mzn2Yxf0PfSq5sOqkFaiGeyr7kJ3ipzcJV9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c017aujLePOSPbdyd5IV5q+CRxi9rNrpm4Rn5SmzVic=;
	b=qedXCURRRIEEG++E1rHRZuQHB6+05V/Gsl61BTErgvzIN5v6EIaWuvsf/g90LPBnJRwI
	 OsxitPIi+71Mz3UFUFqnMRNSq2Aym2xYVahtQ0mumaIZh5/ZW4gac1Z2kJu+T1qcr1LG+
	 e6CONQnsGnuDtJVQia+KYXPtTF1cAODy+v87Fv2uT+LBfjGKGyVa/ADbcBzjKawtp+1OL
	 2JV+eoyeRAMiojaX4THIQc8T1aMcV/T7PIE27hapZBO+k4ML8ZctGiXSJ3ao+oVwCN1Ki
	 e958IqPdOmUzKiZMOs/PFUwCQL3F+yFiQVyrEuxUo/Dw7og5ETLJpqbtlWc77xEvJWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUPot6ML;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830D2606A31C;
	Wed, 28 Oct 2026 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xUPot6ML
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AE31F01825;
	Wed, 28 Oct 2026 18:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213962;
	bh=c017aujLePOSPbdyd5IV5q+CRxi9rNrpm4Rn5SmzVic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUPot6MLcCCQxwp1akefoPTr7++RrUjp79m80xCJaZ+atNoSff0OU22nGzQZZbn0K
	 akMLnkBW+//3XhM1Tg4o7CtrB96x8WLUEht27mZ+PkVdytR1pPYqd5rLyhPWsyimkc
	 NMIOh9SX2+lY/MgASze48aHOIO95UnLJuDNkltWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Cong Wang <cong.wang@bytedance.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0691/1887] bpf: Add sk_is_inet and IS_ICSK check in tls_sw_has_ctx_tx/rx
Date: Wed, 28 Oct 2026 17:46:27 +0100
Message-ID: <20261028170515.136575554@linuxfoundation.org>
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

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 44d0469f79bd3d0b3433732877358df7dc6b17b1 ]

As the introduction of the support for vsock and unix sockets in sockmap,
tls_sw_has_ctx_tx/rx cannot presume the socket passed in must be IS_ICSK.
vsock and af_unix sockets have vsock_sock and unix_sock instead of
inet_connection_sock. For these sockets, tls_get_ctx may return an invalid
pointer and cause page fault in function tls_sw_ctx_rx.

BUG: unable to handle page fault for address: 0000000000040030
Workqueue: vsock-loopback vsock_loopback_work
RIP: 0010:sk_psock_strp_data_ready+0x23/0x60
Call Trace:
 ? __die+0x81/0xc3
 ? no_context+0x194/0x350
 ? do_page_fault+0x30/0x110
 ? async_page_fault+0x3e/0x50
 ? sk_psock_strp_data_ready+0x23/0x60
 virtio_transport_recv_pkt+0x750/0x800
 ? update_load_avg+0x7e/0x620
 vsock_loopback_work+0xd0/0x100
 process_one_work+0x1a7/0x360
 worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 kthread+0x112/0x130
 ? __kthread_cancel_work+0x40/0x40
 ret_from_fork+0x1f/0x40

v2:
  - Add IS_ICSK check
v3:
  - Update the commits in Fixes

Fixes: 634f1a7110b4 ("vsock: support sockmap")
Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20241106003742.399240-1-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tls.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index b5856a28070da..cd0dfa25c591e 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -405,8 +405,12 @@ tls_offload_ctx_tx(const struct tls_context *tls_ctx)
 
 static inline bool tls_sw_has_ctx_tx(const struct sock *sk)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_context *ctx;
+
+	if (!sk_is_inet(sk) || !inet_sk(sk)->is_icsk)
+		return false;
 
+	ctx = tls_get_ctx(sk);
 	if (!ctx)
 		return false;
 	return !!tls_sw_ctx_tx(ctx);
@@ -414,8 +418,12 @@ static inline bool tls_sw_has_ctx_tx(const struct sock *sk)
 
 static inline bool tls_sw_has_ctx_rx(const struct sock *sk)
 {
-	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_context *ctx;
+
+	if (!sk_is_inet(sk) || !inet_sk(sk)->is_icsk)
+		return false;
 
+	ctx = tls_get_ctx(sk);
 	if (!ctx)
 		return false;
 	return !!tls_sw_ctx_rx(ctx);
-- 
2.53.0



