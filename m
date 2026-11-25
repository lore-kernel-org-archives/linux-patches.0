Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618667;
	b=QNOLjUH2sIbAyHG62soAU+J62wwwpzL1GFz81OFKOjo5QoygaNLUkJYxTVu5muK8Q891
	 ooPhMABAxp/cVQuSEhhE/FxhGoemdi9XFYpDs8iRqVNhrBt+VaZM5+KSetU9ALLehMTMp
	 Zsw5AMm1Q2vUwapkScHF0og6QEybAE2TIJ/gfqgKRv9bxlHPocjQEwGfkq1CvIa6iN8N8
	 LcdBgAO2kQ7YaLP8pGXfSaun9Jdt8KMAILROQG1GtQlRAAIz3l6Vt/3ZBUtJhU1kxRDGE
	 r2r8MW1UiHEjRSzIchLxUt/TTQfg6qfAaFSodfhGFJ9xi6QMHy/IvT5vCg3m6xEJ2uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8DLByqVArwPTotz5GydWEBEaFWX8tcNCa8Pr4hx3qI=;
	b=qLM2G9Kp058e4TXaF4vZwPba04TRyi22uLnwBLCHpVUJbrxox+GVshfJUShCXfTvhJmJ
	 LQTm6vlOHJOVELcyU+ZvrVKHJkGj1Xyp+zWX5TWLmg3n/CCmS1teg/Nl/D64G9NkFe8f7
	 Ja8fh98QkSZrMM9qgZHA9PiKp9vg7sLSZYIqoX2PaAuguUhzjHo4Ab3iLHI8Wa/P70/bQ
	 opDlSwysM7SvHIQqSNz9psFt8omWFcTJZX2suA/HmxTqMIy29Dv+gHTtAwO5feJcSOXu+
	 HGpxA9/986NOgBWlKvJ89+zipHzzEc7Wxm/dSyRMW4P0WBpt1jRk8Q77i8PlsPPRz2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8AQnMcR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397FC606A31E;
	Wed, 25 Nov 2026 14:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8AQnMcR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D491F000C4;
	Wed, 25 Nov 2026 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618667;
	bh=Q8DLByqVArwPTotz5GydWEBEaFWX8tcNCa8Pr4hx3qI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8AQnMcR9/X2cq52Q2yw8hiviMHgb4CKewnzbYhZsBPWlj724vYT0WSYnRb9VCIxI
	 Kpx3wBlPTY5k1nFrVuRyyP1rPUCcdwZmFwrKCppEj6dDQ1M+6fcvxBH+hL5e1cb2W6
	 2W5wfyZKhyVkDE7Uyl6VJ4PiqXpK9MlxPg1/GaVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0349/1005] tcp: bound snd_cwnd_clamp to TCP_MAX_SND_CWND
Date: Wed, 25 Nov 2026 15:28:07 +0100
Message-ID: <20261125143829.909221431@linuxfoundation.org>
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

[ Upstream commit 475ff14ba558bb8857bca878f1d593784ccc4f0f ]

snd_cwnd has no practical upper bound: snd_cwnd_clamp defaults to ~0,
and RTAX_INITCWND, a locked RTAX_CWND metric, TCP_BPF_IW and
TCP_BPF_SNDCWND_CLAMP accept any positive value.

Congestion control modules do u32 arithmetic on cwnd that assumes
much smaller values. For instance, ssthresh() handlers compute:

  CUBIC, BIC, ROCCET:  cwnd * (BICTCP_BETA_SCALE + beta), up to 2047
  DCTCP:               cwnd * dctcp_alpha, up to 1024
  CDG, NV, CUBIC, ...: cwnd * beta, below 1024

With a large initcwnd route or TCP_BPF_IW, cwnd is set directly to
such values, and the next RTO or recovery calls ->ssthresh() with it.
The product then wraps: DCTCP with cwnd = 2^24 and alpha = 1024 gets
ssthresh == cwnd, and CUBIC computes a wrong ssthresh and Wmax.
CUBIC bictcp_update() also expects cwnd below about one million packets.

The paths that can grow cwnd by large amounts (tcp_slow_start(),
tcp_cong_avoid_ai(), bbr_set_cwnd() and tcp_init_cwnd()) already
bound it by snd_cwnd_clamp, so give snd_cwnd_clamp a finite default
of 2^20 packets, and cap the metric and BPF paths that set it or set
cwnd directly.

2^20 packets do not limit real flows: with the maximum window scale
of 14, a peer can not advertise more than 65535 << 14 bytes (~1GB),
which is less than 2^20 packets for any MSS of 1024 bytes or more.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261030111528.2850082-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h      | 9 +++++++++
 net/core/filter.c      | 3 ++-
 net/ipv4/tcp.c         | 2 +-
 net/ipv4/tcp_metrics.c | 3 ++-
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4416cdf9bf30e..00c2bcd5cac2d 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1514,6 +1514,15 @@ static inline unsigned int tcp_packets_in_flight(const struct tcp_sock *tp)
 
 #define TCP_INFINITE_SSTHRESH	0x7fffffff
 
+/* Default and maximum snd_cwnd_clamp, in packets.
+ * A peer can not advertise more than 65535 << 14 bytes, so a larger
+ * cwnd is useless with any MSS of 1024 bytes or more.
+ * Congestion control modules multiply cwnd by u32 factors up to 2047
+ * (cwnd * (BICTCP_BETA_SCALE + beta) in CUBIC), and CUBIC's
+ * bictcp_update() expects cwnd to stay below about one million packets.
+ */
+#define TCP_MAX_SND_CWND	(1U << 20)
+
 static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
 {
 	return tp->snd_cwnd;
diff --git a/net/core/filter.c b/net/core/filter.c
index 7129e7c920a64..3cce0ddd3192e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5652,11 +5652,12 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
 	case TCP_BPF_IW:
 		if (val <= 0 || tp->data_segs_out > tp->syn_data)
 			return -EINVAL;
-		tcp_snd_cwnd_set(tp, val);
+		tcp_snd_cwnd_set(tp, min_t(u32, val, tp->snd_cwnd_clamp));
 		break;
 	case TCP_BPF_SNDCWND_CLAMP:
 		if (val <= 0)
 			return -EINVAL;
+		val = min_t(u32, val, TCP_MAX_SND_CWND);
 		tp->snd_cwnd_clamp = val;
 		WRITE_ONCE(tp->snd_ssthresh, val);
 		break;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 73d5b7c8e3c78..49eccd16776f8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -455,7 +455,7 @@ void tcp_init_sock(struct sock *sk)
 	 * initialization of these values.
 	 */
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
-	tp->snd_cwnd_clamp = ~0;
+	tp->snd_cwnd_clamp = TCP_MAX_SND_CWND;
 	tp->mss_cache = TCP_MSS_DEFAULT;
 
 	tp->reordering = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering);
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index d58f99c67d4dc..ae551546422fe 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -495,7 +495,8 @@ void tcp_init_metrics(struct sock *sk)
 	}
 
 	if (tcp_metric_locked(tm, TCP_METRIC_CWND))
-		tp->snd_cwnd_clamp = tcp_metric_get(tm, TCP_METRIC_CWND);
+		tp->snd_cwnd_clamp = min(tcp_metric_get(tm, TCP_METRIC_CWND),
+					 TCP_MAX_SND_CWND);
 
 	val = READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) ?
 	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
-- 
2.53.0



