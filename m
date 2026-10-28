Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213010;
	b=I/3Alxh8UptZvOCSUQkiPvMiXhbTSa8B4HO7+S19OOdYqGGbqFC78hwgKZyDXKyLf1qL
	 9lxCNFxI9iLqf8bD/imIb9lN0OS98/0pqf8V8+AdVd/KFxfKpBMWup1DDIi0NZv5B24L9
	 5SohPGhjzBkFCXxLHY52n2yRCfRAB87iFHLrsOR3oL6brd+IKnTkvRKc0sdirze4vBWzr
	 pyMEwt7ks5cVcYUPe1oZaWGb1kpwwrLYZ8NS6CRj2ot3Ce0/P1xwRgQIn5ao5sLdO+fAJ
	 zVersIRBobSdo0hCa2J/h7GCwbCdoXLGbVPxKMXmAP/aAJx6ZKJJTMU7tLbmVkVdyjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PLfTgGloLZ8V2bOdzytaTa53vj5DZ+xI00ShqLfxF5w=;
	b=DO6UYfs3yMjgZHhxA8aItlnV6jN/y/Ng/FYSgrGeG8NeHT+2ab4CNDPVgqTEgjXhTeb/
	 nBxAhLERQrkgLzuv6JTHLaOKTzkQjnZbQJJLBkmlRnWHSrrdwFdmWgQxRFJExeVTpSKd6
	 542sS23c96RUABIb2HH4f3bR1f3/XH+e4tlVqQyW6GXc8i7/Ubl0k6ECp+gHJB+JKGU+P
	 BzBTvgsaSEk7nwK0/EkxDcbGeGNFUzosNHcUHJXQ0fV1QKwMopKE4l8z/DIVInKyP00KP
	 1GjkzTnDE/Zr3viy5nbEGza+HuQGacwIAC/dKZO+Nk+QKBaxaNNLRQeS6ufflIKPHHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLDac6zV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5A6606A31C;
	Wed, 28 Oct 2026 18:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LLDac6zV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5BD1F01825;
	Wed, 28 Oct 2026 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213010;
	bh=PLfTgGloLZ8V2bOdzytaTa53vj5DZ+xI00ShqLfxF5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LLDac6zVJJwMjbRrgAS43ZpsDIlLqHCZQMm27MKT0yUIvJPEuvkTCQhy5Z4uWdW4h
	 bWyJdGWnJfbrF67qxKErCra/ozTZcv4kkNKXC/8PmyPQvbgWBS9YNnK9CMCbRkPZAy
	 vrsT0oFtjRfE+k0hHx3IGkUB+2mSgw4TkcE0DWdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0356/1887] mptcp: prevent race between disconnect() and rtx
Date: Wed, 28 Oct 2026 17:40:52 +0100
Message-ID: <20261028170507.332999326@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 85c580b0d8590520ae00a15c29e9fb9c99427a3e ]

Sashiko noted that the two event can race, leading to inconsistent
status. Prevent the race using the synchronous timer stop operation.

Cc: stable@vger.kernel.org
Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-6-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Use TCP_RTO_MIN for msk->timer_ival instead of
  icsk->icsk_rto_min, as ea4eb2adb0d3 ("mptcp: honour configured
  min/max RTO in retransmit paths") is not in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 593d196dfa8bb..5d6dff88bf209 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3269,6 +3269,7 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
+	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	/* We are on the fastopen error path. We can't call straight into the
@@ -3281,8 +3282,13 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	mptcp_check_listen_stop(sk);
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	mptcp_stop_rtx_timer(sk);
-	mptcp_stop_tout_timer(sk);
+	/* The later subflow close can not kick again the tout timer,
+	 * as the msk is already in closed status.
+	 */
+	msk->timer_ival = TCP_RTO_MIN;
+	sk_stop_timer_sync(sk, &sk->mptcp_retransmit_timer);
+	icsk->icsk_mtup.probe_timestamp = 0;
+	sk_stop_timer_sync(sk, &icsk->mptcp_tout_timer);
 
 	if (mptcp_sk(sk)->token)
 		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
-- 
2.53.0



