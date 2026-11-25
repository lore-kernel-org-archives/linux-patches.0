Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619301;
	b=b4TT0z/jX4IP0O+5Qe3G3s1q7HeO9+TNaJqJghAoYqm5qUSu2EB0YqATfHAvkFLTNjD5
	 wW3lmT9YTHn6QK/uXz7/BmQVGN0jAHqc14lQEtpo0hq171wCv5Ttz8JWhLFDq5thy1eKS
	 vcRkeG/EkC1nlvi2cxJHMjUY/itwE2ztVm0YJEOdyOPmjz+vH2b7fBMryOhXmxtzZyaTg
	 SsO41Jzy5pd0bIdlqFAAuAyo9YkCLAr5tedU+VHvGNeZmpe4WVouIz+3Tz9+NCTCJr5Df
	 lZuBL06k2uce4+4tc/rRIYzx8T4OU3jfovDrUXUdrDPkW/3wfNQR3bL9vHbGAZYO87w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVsI10rr0ClvP0SOeT+FXkotcQDnIHu7KxkmcBY/tl8=;
	b=OFox7VnNFepN4zuc5Ts2z+tWigymYbFuG2qbHnLLbRjw6nUc5hJ+swmjQfSoMCGmR5Yf
	 dLPOhkVYKJBAHa0dP5TEI5QsiLtxsVYYpVPRl4nnlV18mEZexzYqLOMzQI3jVlzCg2Rs7
	 dZ4zRPvASNeu0J7mlSVIf1SKH8R4tNLyCXw/ZluwS0DrM5JyijyHwhE88hE/6kuK8m7D+
	 YNXK1IDq1B0Z1SeYUzULF4xyd6fDlxU9EaGjeVy10oOigV73xi5fcKGpTLfdsWaSgnF8g
	 XYlKZ8UunxB3IMeaIyo81icLepON8CZtzbD0yZuRuSWkSJE4g0x/RXD5n0Jt+RezBxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdUt2p7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6B8606A321;
	Wed, 25 Nov 2026 15:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdUt2p7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9EF1F000D2;
	Wed, 25 Nov 2026 15:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619301;
	bh=oVsI10rr0ClvP0SOeT+FXkotcQDnIHu7KxkmcBY/tl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdUt2p7rwwgq/Xq5aEt8f/CQd1FOu5NHiLutp4ybJLQDrCxXDWz2RldnlPNprVVhH
	 c7gm0BiVhAZkrTJzKTZsMbRHV3uw9VqOvk7gNcLitljXgrEXMHMTzuDN1xdDPHZuEn
	 bDpCUPwMBdY8uoupCPftmiUEp7XAxq4ItBlFtYNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0508/1005] tcp: do not resurrect a former listener with SO_ATTACH_REUSEPORT_[CE]BPF
Date: Wed, 25 Nov 2026 15:30:46 +0100
Message-ID: <20261125143833.644863008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 8c011697f76abf3b2302718a7a1c50e36d849f28 ]

After listen() + shutdown(), a TCP socket is moved to the closed
section of its reuseport group, while TCP_NEW_SYN_RECV requests
can still reference it as rsk_listener.

If SO_ATTACH_REUSEPORT_[CE]BPF is then used on this socket,
reuseport_attach_prog() calls reuseport_alloc(), which resurrects
it into the listening section of a new group, even though the
socket is still in TCP_CLOSE.

After close(), the socket stays in that group and the pending
requests keep it allocated. When the final ACK arrives,
reuseport_migrate_sock() can select this dead socket and
inet_csk_clone_lock() clones it. With a ULP like espintcp installed
while in TCP_CLOSE, the child inherits icsk_ulp_data and sk_destruct
after tcp_cleanup_ulp() cleared icsk_ulp_ops, leading to a
use-after-free in espintcp_destruct().

As done in commit 8cc3aef0cb19 ("tcp: Do not allow buggy transitions
between ehash and lhash2."), deny this transition instead of adding
checks to the fast path.

Only an unhashed former listener is affected. Applications can still
attach a reuseport prog to a socket that never listened, or to a
listener (including one that called listen() again after shutdown()).

Fixes: 333bb73f620e ("tcp: Keep TCP_CLOSE sockets in the reuseport group.")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261106084300.2029567-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_reuseport.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index fccbdd0430b05..b9e5648fa4c51 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -6,6 +6,7 @@
  * selecting the socket index from the array of available sockets.
  */
 
+#include <net/inet_connection_sock.h>
 #include <net/ip.h>
 #include <net/sock_reuseport.h>
 #include <linux/bpf.h>
@@ -692,6 +693,14 @@ int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
 		if (!sk->sk_reuseport)
 			return -EINVAL;
 
+		/* Do not put a shutdown()ed TCP listener back into the
+		 * listening section of a reuseport group while it is in
+		 * TCP_CLOSE: requests can still migrate to it.
+		 */
+		if (sk_is_tcp(sk) &&
+		    inet_csk(sk)->unhashed_state == TCP_LISTEN)
+			return -EINVAL;
+
 		err = reuseport_alloc(sk, false);
 		if (err)
 			return err;
-- 
2.53.0



