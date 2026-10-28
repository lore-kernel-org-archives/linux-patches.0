Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207892;
	b=EbyRF4eFZhCVgIx84Eq4pzpeq+nMY/4csAFBVtVT8/Q9eSA5EAGrcDxyZmjafZ5Y+hom
	 Mak+hVBRSogHllWrZ1LmfI+SWUbSdF6eUsQUol8KaBP8OqIBPG+d64Cu4Z8DV6yumiJVR
	 Q1QvDxctgZ9ONNBIBYTboG4eGgh3Gv+DyFV+DNAufW6pJCKkhdGY325ILFkTySCVROenV
	 huX5MhDDzkvvvuxJV2IYPXA5Cf2xzv1kTEmCDnHUMjkDPo3Qn9dtq9dTS6nqFaWkclnVx
	 riLMUd0fN1m1W1Qy6KEirB0rjMamipY6G1iM/PCb4d9/SIyKu89jy+MSKjYryHs2eKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Da58GtyiEdl0Qfz3xhcwQga5/SYjZyuCvo3Q11LS8q0=;
	b=Raao6rNTJBjLKO9IKH3XCBFW91GeqKj5npdnPFOSTjVTtilP/TIVQKUAsT+Ud4BK6IDw
	 kmDANcIiNptKOJGovGAntl3Smj6Yo817GgTDgpqlhP1iwQvYsKd9eRQCSBnOqQjCqKVZn
	 8Ek4ppU3A1ScOHgQuC1g8GiIRjAJQpk3/PlwlbVkNhgDTl2zzgFgnwN8rY43T6ldmkwlc
	 Ak5huf4zF3bXR3Jxzh+RnaMIKZj4ePjoD28FnfCwkiwcbLpOhf9n7N32juzhbLqWx0hsb
	 SxBCLvyDVQ5jKK3V7GXXrf+PYbTvvaNytGgGpH/hvqQESolz4wIkZQGqLtfZm7390rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSVcgiSH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F89C60A3803;
	Wed, 28 Oct 2026 17:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSVcgiSH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912C71F031E1;
	Wed, 28 Oct 2026 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207892;
	bh=Da58GtyiEdl0Qfz3xhcwQga5/SYjZyuCvo3Q11LS8q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSVcgiSHC7/HSCd+sadhBvQDeYL06bRbDzcTcfpYBziJEx79bPj7qSv7mq86pLIS8
	 Uj4wpKVWLc8u+RUCuqYAkSVQZHkdGqYS8hdYBWnL02QrfD3AGXCYZEWbAC3dYqiwF8
	 G2E9eV8MhNcw/AEb2tRwFwIRd3tqaUQFBIxikJp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/247] net: call getsockopt_iter if available
Date: Wed, 28 Oct 2026 17:58:56 +0100
Message-ID: <20261028165950.554102374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 5bd0dec150f56b6307d599132dcb7c01007bbecc upstream.

Update do_sock_getsockopt() to use the new getsockopt_iter callback
when available. Add do_sock_getsockopt_iter() helper that:

1. Reads optlen from user/kernel space
2. Initializes a sockopt_t with the appropriate iov_iter (kvec for
   kernel, ubuf for user buffers) and sets opt.optlen
3. Calls the protocol's getsockopt_iter callback
4. Writes opt.optlen back to user/kernel space

The optlen is always written back, even on failure. Some protocols
(e.g. CAN raw) return -ERANGE and set optlen to the required buffer
size so userspace knows how much to allocate.

The callback is responsible for setting opt.optlen to indicate the
returned data size.

Important to say that  iov_out does not need to be copied back in
do_sock_getsockopt().

When optval is not kernel (the userspace path), sockptr_to_sockopt()
sets up opt->iter_out as a ITER_DEST ubuf iterator pointing directly at
the userspace buffer (optval.user). So when getsockopt_iter
implementations call copy_to_iter(..., &opt->iter_out), the data is
written directly to userspace — no intermediate kernel buffer is
involved.

When optval.is_kernel is true (the in-kernel path, e.g. from io_uring),
the kvec points at the already-provided kernel buffer (optval.kernel),
so the data lands in the caller's buffer directly via the kvec-backed
iterator.

In both cases the iterator writes to the final destination in-place at
protocol callback. There's nothing to copy back — only optlen needs to
be written back.

Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260408-getsockopt-v3-2-061bb9cb355d@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 723bc3a1ba5cd..b8d662e193103 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -77,6 +77,7 @@
 #include <linux/mount.h>
 #include <linux/pseudo_fs.h>
 #include <linux/security.h>
+#include <linux/uio.h>
 #include <linux/syscalls.h>
 #include <linux/compat.h>
 #include <linux/kmod.h>
@@ -2345,11 +2346,45 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 							 int optname));
 
+/*
+ * Initialize a sockopt_t from sockptr optval/optlen, setting up iov_iter
+ * for both input and output directions.
+ * It is important to remember that both iov points to the same data, but,
+ * .iter_in is read-only and .iter_out is write-only by the protocol callbacks
+ */
+static int sockptr_to_sockopt(sockopt_t *opt, sockptr_t optval,
+			      sockptr_t optlen, struct kvec *kvec)
+{
+	int koptlen;
+
+	if (copy_from_sockptr(&koptlen, optlen, sizeof(int)))
+		return -EFAULT;
+
+	if (koptlen < 0)
+		return -EINVAL;
+
+	if (optval.is_kernel) {
+		kvec->iov_base = optval.kernel;
+		kvec->iov_len = koptlen;
+		iov_iter_kvec(&opt->iter_out, ITER_DEST, kvec, 1, koptlen);
+		iov_iter_kvec(&opt->iter_in, ITER_SOURCE, kvec, 1, koptlen);
+	} else {
+		iov_iter_ubuf(&opt->iter_out, ITER_DEST, optval.user, koptlen);
+		iov_iter_ubuf(&opt->iter_in, ITER_SOURCE, optval.user,
+			      koptlen);
+	}
+	opt->optlen = koptlen;
+
+	return 0;
+}
+
 int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, sockptr_t optlen)
 {
 	int max_optlen __maybe_unused = 0;
 	const struct proto_ops *ops;
+	struct kvec kvec;
+	sockopt_t opt;
 	int err;
 
 	err = security_socket_getsockopt(sock, level, optname);
@@ -2362,15 +2397,28 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
 	ops = READ_ONCE(sock->ops);
 	if (level == SOL_SOCKET) {
 		err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
-	} else if (unlikely(!ops->getsockopt)) {
-		err = -EOPNOTSUPP;
-	} else {
+	} else if (ops->getsockopt_iter) {
+		err = sockptr_to_sockopt(&opt, optval, optlen, &kvec);
+		if (err)
+			return err;
+
+		err = ops->getsockopt_iter(sock, level, optname, &opt);
+
+		/* Always write back optlen, even on failure. Some protocols
+		 * (e.g. CAN raw) return -ERANGE and set optlen to the
+		 * required buffer size so userspace can discover it.
+		 */
+		if (copy_to_sockptr(optlen, &opt.optlen, sizeof(int)))
+			return -EFAULT;
+	} else if (ops->getsockopt) {
 		if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
 			      "Invalid argument type"))
 			return -EOPNOTSUPP;
 
 		err = ops->getsockopt(sock, level, optname, optval.user,
 				      optlen.user);
+	} else {
+		err = -EOPNOTSUPP;
 	}
 
 	if (!compat)
-- 
2.53.0



