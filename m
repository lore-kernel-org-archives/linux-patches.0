Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215859;
	b=MtE5FNHG/G6iqKTfO/b0iXWqe4I3l44lK1tb1KNT75FiffIlFU5aWqwIC7CAgBce0IGn
	 fTjuL8bETmYI9sVleMND6dl4riyaY2psjIX9aKDDXToL/d3799kbzYwtlmsiMK+tNr085
	 FOsQTX/52M6g5G/74zMr5YzLoWmalybBpK1AGZIZmNrNcFF0jQa/dm+tMq2KKYLwZ8znX
	 ca4CBsZ+eRJVnWZqhkggGLFrE339WQd/oF6Ur6h85OQ6meAGxOCWrEdPHtcMIcnxTt6dp
	 +VhLW3P+NcBPxBIp9IXHq9JdZVBW/9Ey8udF4yMLtYYQ+rd5OtXjtIEOAQZlSsMuXPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pKBMm/arIJbNxhxLOpoAT67fVgeZ2n3nNT7BpdccUNA=;
	b=rJaDjw6+OY6t83mqPbTlsEXHZl6P81JWMTwGaoHkhARMJ8/4m/Awm+3v17NN1g3sJORS
	 T7+9y0TZwdUSGQ5k7fpHW7k2VE7XIH5MWLbIX/tMSDc4m+ZhsXlGCB4e2KZn0hm60z3SP
	 pPyviXZKm4DFPPr3X4jz95ZAS0Dknu6gwzqgA4abxTXqVHWZ6t4IiGDFIuWwgJ6hkRueE
	 LYCrBGDKXM5lyYSaEtvX+n9VC1xA/e8q008pFKzBihHFWp0PZyp8lfXqWiDRWi/jJ4EKm
	 W62Qd7is9Ddw9eOIpjK5IDXHe3bgCDQcQp9BJFV7RGIMeR5eUQ5IUPRkFbZsJ52H2+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jG0e+tnK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6197606A31A;
	Wed, 28 Oct 2026 19:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jG0e+tnK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233131F01825;
	Wed, 28 Oct 2026 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215858;
	bh=pKBMm/arIJbNxhxLOpoAT67fVgeZ2n3nNT7BpdccUNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jG0e+tnKFN+dTP/epruf+POIu3RdoBjgmtNlsxZEyvbspOJfr1nbhv8P60fu9rd8H
	 SBIJhTG9RRL/CRDvTSRGc88Q/BlQ/WvsIhMj7MEd+iyZPr4vaSuf3kJJ/20TI9M9I7
	 j1H5FILyCTnEg3FBHqNMhuYX92Xs5moWEg68l+xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yong Wang <edragain@163.com>,
	Ren Wei <weir@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1356/1887] tcp: clamp route advmss to TCP_MIN_MSS
Date: Wed, 28 Oct 2026 17:57:32 +0100
Message-ID: <20261028170530.300363291@linuxfoundation.org>
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

From: Yong Wang <edragain@163.com>

[ Upstream commit 870a9e42ecc6fe1b8c25d87af043cb0d9c178fe1 ]

tcp_select_initial_window() assumes that callers never pass an MSS
smaller than 1, but route-derived advmss values can violate that
assumption.

A too-small explicit RTAX_ADVMSS is one way to get there, but it is not
the only one. The same divide-by-zero can also be reached through the
"default advmss" path when RTAX_ADVMSS is left at 0 and the effective
advmss is later driven down by route MTU and min_adv_mss.

Introduce a tcp_dst_advmss() helper that clamps route advmss to
TCP_MIN_MSS before TCP consumes it, and use it in the TCP paths that
derive advmss from dst metrics. This keeps the effective MSS from
dropping to zero before tcp_select_initial_window() rounds the receive
window.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Yong Wang <edragain@163.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Link: https://patch.msgid.link/251eaf8277fa7c66364c9815c5da01662d269181.1787074852.git.edragain@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h        | 5 +++++
 net/ipv4/tcp_ipv4.c      | 2 +-
 net/ipv4/tcp_minisocks.c | 2 +-
 net/ipv4/tcp_output.c    | 6 +++---
 net/ipv6/tcp_ipv6.c      | 2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4161bd71fb50f..ff8025ff25a4e 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1483,6 +1483,11 @@ static inline int tcp_full_space(const struct sock *sk)
 	return tcp_win_from_space(sk, READ_ONCE(sk->sk_rcvbuf));
 }
 
+static inline u32 tcp_dst_advmss(const struct dst_entry *dst)
+{
+	return max_t(u32, dst_metric_advmss(dst), TCP_MIN_MSS);
+}
+
 static inline void __tcp_adjust_rcv_ssthresh(struct sock *sk, u32 new_ssthresh)
 {
 	int unused_mem = sk_unused_reserved_mem(sk);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index e68f84c08e1c1..0e6d03af09e5b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1572,7 +1572,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst_mtu(dst));
-	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
+	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 675f3c412c443..7ccb6f67c6dd9 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -378,7 +378,7 @@ void tcp_openreq_init_rwin(struct request_sock *req,
 	u32 rcv_wnd;
 	int mss;
 
-	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	mss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 	window_clamp = READ_ONCE(tp->window_clamp);
 	/* Set this up on the first call only */
 	req->rsk_window_clamp = window_clamp ? : dst_metric(dst, RTAX_WINDOW);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 39f25b886678c..9e1d20f105b98 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -125,7 +125,7 @@ static __u16 tcp_advertise_mss(struct sock *sk)
 	int mss = tp->advmss;
 
 	if (dst) {
-		unsigned int metric = dst_metric_advmss(dst);
+		unsigned int metric = tcp_dst_advmss(dst);
 
 		if (metric < mss) {
 			mss = metric;
@@ -3639,7 +3639,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	}
 	skb_dst_set(skb, dst);
 
-	mss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	mss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 
 	memset(&opts, 0, sizeof(opts));
 	now = tcp_clock_ns();
@@ -3756,7 +3756,7 @@ static void tcp_connect_init(struct sock *sk)
 
 	if (!tp->window_clamp)
 		tp->window_clamp = dst_metric(dst, RTAX_WINDOW);
-	tp->advmss = tcp_mss_clamp(tp, dst_metric_advmss(dst));
+	tp->advmss = tcp_mss_clamp(tp, tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(sk);
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8503070683d17..62ed0886af74b 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1335,7 +1335,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	tcp_ca_openreq_child(newsk, dst);
 
 	tcp_sync_mss(newsk, dst_mtu(dst));
-	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
+	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), tcp_dst_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
 
-- 
2.53.0



