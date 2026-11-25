Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619643;
	b=GvRDragzIVRqNZZjoYpkJrYWpW3Br0wU5jNBdnSzhykXpqQQ0L06LqazyHxfSM8A7+a9
	 Q9eU/+3t8S8ln7o0bKEYEmHyfu9g598DPUCJtf1phzNyVrLZkYq9KBVIMOVFIHrVB+gMc
	 +yGAGoVo5uVmoXDtWi8tlmIbgo/rfoYwFuy1nw8ALrbPb+LKn+OTh/yi/Lb/XW8zZRYBZ
	 vH8B4ttpE51eZ14t3SmS2vV7svlP1jHAfV4HFzt84ZxEGoiPN5Jq9GGPr7ExMgrOwV4qQ
	 vY/lOKS48T+A5aogEA8Lr5ZVTWWlxhGqYN3LgbF7Y3eALgziiqY7aonIKXbACDIva3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oKnUcN9FyWPypaAlyqJ2AoVbayPW0vmwSL7azxMS7VM=;
	b=fvnR9KLkdRFUELjraKKa6yZkQF8sIRe0a+Aga7478vOea1QbQGiqiwvZQ8lttk6Dbw4P
	 Jl+cREfU8DaLxvTQJjPdp7n/22bAESgouQcbvUAQ0TEFmCxzht4OgDCRX0TERnQJh/YuK
	 GuRfzUpgdtSEpPwivzbnkFZfBXkS9PR9LwuKChX06r98CSfWWXtkef2oT449rzuo/+Ifa
	 LEaFAs7iweWsoVwduwWD1nosc3pQe22bJoacORhUH3hnNfJ08QsGzVc1ezUr9iR0JW4gm
	 Ctz/1I6TRWsljSbqeKOsNVZxqLvZbPQO6Go/yW1tmKAzFp9PD8l60UW/Z3rnryfBbuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wA0VqgYE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4479C606A31E;
	Wed, 25 Nov 2026 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wA0VqgYE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 948D41F000C6;
	Wed, 25 Nov 2026 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619643;
	bh=oKnUcN9FyWPypaAlyqJ2AoVbayPW0vmwSL7azxMS7VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wA0VqgYEWnimUJuT+WGRA5VrYon6GADR1IsX6EY+rArSKjmxE0mXzDGhMIQi2zNSb
	 gxs0x6VrcKQV2IApAfsFz2ZQrBW6JWb8/8KYQyG6LWrFOaLZVCsn53gzZuA2Sf+wyu
	 EIqpuhKRlTv7Rqn8GpQi9GUxZxZ0cDrjWW+5OH+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0646/1005] mptcp: reject DATA_ACKs against a reversed send interval
Date: Wed, 25 Nov 2026 15:33:04 +0100
Message-ID: <20261125143836.883975694@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

commit d75e5cd72995ec2fa77ec77a593cea28e2490ff1 upstream.

ack_update_msk() samples snd_nxt before taking the data lock, but reads
snd_una after taking it. Concurrent transmission and ACK processing can
therefore leave the sampled upper bound behind snd_una. Active-open
completion also exposes a reversed interval when it initializes snd_una
to IDSN + 1 while the socket-owned state synchronization is deferred.

A peer-supplied 64-bit Data ACK half a sequence space away can pass both
wraparound comparisons against such an interval. The resulting snd_una
can make __mptcp_retrans() inflate a fragment's already_sent field. Later
ACKs can then underflow data_len and cause out-of-bounds page fragments
to be passed to TCP.

Read snd_nxt after acquiring the data lock and reject reversed intervals
before checking the received Data ACK. This keeps the interval shorter
than half the sequence space, so the existing upper-bound check cannot
accept an advance beyond snd_nxt. Preserve the existing handling of old
ACKs and keep the transmit fields under their existing socket locking.

Cc: stable@vger.kernel.org
Fixes: 7439d687b79c ("mptcp: avoid a few atomic ops in the rx path")
Fixes: 3f83d8a77eee ("mptcp: fix more tx path fields initialization")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261104130747.1045741-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1122,9 +1122,9 @@ static void ack_update_msk(struct mptcp_
 			   struct sock *ssk,
 			   struct mptcp_options_received *mp_opt)
 {
-	u64 new_wnd_end, new_snd_una, snd_nxt = READ_ONCE(msk->snd_nxt);
+	u64 new_wnd_end, new_snd_una, old_snd_una;
 	struct sock *sk = (struct sock *)msk;
-	u64 old_snd_una;
+	u64 snd_nxt;
 
 	mptcp_data_lock(sk);
 
@@ -1133,10 +1133,14 @@ static void ack_update_msk(struct mptcp_
 	 * more dangerous than missing an ack
 	 */
 	old_snd_una = msk->snd_una;
+	snd_nxt = READ_ONCE(msk->snd_nxt);
 	new_snd_una = mptcp_expand_seq(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
-	/* ACK for data not even sent yet? Ignore.*/
-	if (unlikely(after64(new_snd_una, snd_nxt)))
+	/* The active-open state sync can defer the snd_nxt update. Do not
+	 * accept an ACK against a reversed interval, or beyond snd_nxt.
+	 */
+	if (unlikely(before64(snd_nxt, old_snd_una) ||
+		     after64(new_snd_una, snd_nxt)))
 		new_snd_una = old_snd_una;
 
 	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;


