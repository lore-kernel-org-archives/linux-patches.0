Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052959;
	b=je/7O2OIV04rUrMyV1zw3tlGZIpLLStR06afVcclmzkJ9IR5yhUKqqqQi5bLe9ISKDXy
	 mbzN1kwz+4EdqVlAaOelBl/Apm3DoISRNTAYuR3qLcn7twwOVYCoYVX0gBI0LiY/K/uGU
	 R+0WPbN3/AigiUg3U67P/j4DhnD6+UQHMvAiBdE/gaX7jKG6oAlU1mMddwM6xzt0/iwUH
	 mWb6Y0AfsjlVLoURdl8Iez2LvPan+HLLZQEeSVt/aJW4PL1xr4dq3BfRRjHZyeuZixFaO
	 CTgHcZrY4NBWI9Ec+iJEyRfg3T+VUpWbciegDm/kb6j8YLOnYxnr0HaS13scSAR67YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4MFJsh+9DI+9vZdHz2uK4cZR4G92nlB2y8oZIbdLYRo=;
	b=EhzvJvYsK9xcPDtWpAKSE9tlAqQ1iMAscLNKGIp41K9LQJjiMDAJzPaganYKBUOVJZHN
	 JUGgbmq9AukSY9n+xSvA95YSL5Zd4WO1mP2yJloKit7DZM8H6k4UYW24+IvmfZekrZS2A
	 6lCa5Dpc3L9VvwxSD3sGGtDmmKDqVmmpnvDVoEqKlPepo2T+6OjWnHloGlHLXxHnBCT9w
	 OXyeKR/nZlhX2152OwHtN3RUhmfYXHywrSQ+M5n41a7RZyeqti8Ak7OGujss+YHqRpZ+9
	 iSyBFiCBQrSb4pwsWhTcHx/rZNAkMOilRcPOsdy3nNJInhooKsC7XfxJTzK9Mq+IqHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWsNfizo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF0E606A32A;
	Thu, 19 Nov 2026 01:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OWsNfizo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093D81F000C4;
	Thu, 19 Nov 2026 01:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052959;
	bh=4MFJsh+9DI+9vZdHz2uK4cZR4G92nlB2y8oZIbdLYRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWsNfizoCcWzpRAtJuAMxr+ni/7QP+tTSn2x9bCJatLwvNW2Hxhouk4UKVUYw8tDh
	 0ikMm9Li+wQ0stwDAuwiKXV7kbT/GFgFXR23MMBeR3135QgGL3ATz9ikPXhK2MqM77
	 UAbNTvOyVySU4XT/JFrZYYiTN+Lko2sM2WhPSbMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0750/2214] tcp: fix reordering addition overflow in MTU probing
Date: Wed, 18 Nov 2026 15:40:26 +0100
Message-ID: <20261118150041.776958410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit c1df9c0c0536393de43310f84ca4f8b217271a00 ]

Commit efb8763d7bbb ("net: ipv4: bound TCP reordering sysctl writes and
MTU probe sizes") widened size_needed and the MSS multiplication, but
tp->reordering + 1 is still evaluated as u32. RTAX_REORDERING accepts
an unrestricted u32, and tcp_init_metrics() can install U32_MAX.

In that case the extra-data requirement becomes zero. A write queue
with probe_size - 1 data bytes and a FIN satisfies the sequence-space
check. The coalescing walk can pass the queue head to
tcp_skb_can_collapse(), and tcp_clone_payload() can produce an skb
whose advertised payload exceeds the data in its fragments. Local
delivery followed by TCP_ZEROCOPY_RECEIVE can then walk beyond the
fragment array. KASAN reports a slab-out-of-bounds read in
can_map_frag().

Cast reordering before incrementing it so the arithmetic handles the
entire u32 metric range. For U32_MAX, the required size exceeds the
32-bit queue and window limits, so the existing checks skip the probe.
The calculation is unchanged for all other reordering values.

Fixes: efb8763d7bbb ("net: ipv4: bound TCP reordering sysctl writes and MTU probe sizes")
Cc: stable@vger.kernel.org
Cc: Wyatt Feng <bronzed_45_vested@icloud.com>
Cc: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261028160226.2170244-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7ebd8c88d2ab3..caa8227789c3d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2370,7 +2370,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	mss_now = tcp_current_mss(sk);
 	probe_size = tcp_mtu_to_mss(sk, (icsk->icsk_mtup.search_high +
 				    icsk->icsk_mtup.search_low) >> 1);
-	size_needed = probe_size + (tp->reordering + 1) * (u64)tp->mss_cache;
+	size_needed = probe_size + ((u64)tp->reordering + 1) * tp->mss_cache;
 	interval = icsk->icsk_mtup.search_high - icsk->icsk_mtup.search_low;
 	/* When misfortune happens, we are reprobing actively,
 	 * and then reprobe timer has expired. We stick with current
-- 
2.53.0



