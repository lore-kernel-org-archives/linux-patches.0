Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9358D1C6AB;
	Mon,  4 Mar 2024 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589319; cv=none; b=M8x7kRAdkJh38ckkdwxKtQJ/b0rJcHqM8pKoXiAQdWOmEUxJW4YpdQwtfWdOTrg70mKdlyrL6AZ7GAdPmwUAZfswGnUwLlwXphtRqjen2Um7MUeKgNXsBpjHmmPf/fG2g4IdDbT6rxhchhUPUG0AHzJwLXys69f9d3SP23NU2gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589319; c=relaxed/simple;
	bh=CUXFRVnxq1WWOGPzEh5D5kMSTT/btEWHR6xpkPzJTkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Olgn7WWkpOnbnad3TDI7MPzyZKVcXMT2i31lWITRYVMFfzf9WwpQLT7tzEl525hDYe3Q+Pj6WzZnDrv606vQXrbhOBwSoxNDbpGljdkJ8bXDYAY3rDbnXqZw9kKZqpDEaqOdp114jyCaKH0qJpTmZ6NaxguU0XU2QFhV26hORHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/0Y8V2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/0Y8V2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264C5C433F1;
	Mon,  4 Mar 2024 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589319;
	bh=CUXFRVnxq1WWOGPzEh5D5kMSTT/btEWHR6xpkPzJTkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/0Y8V2Y8Z4SmRM2/cUO1OpyBjJjAgYI7Um6+QqNen3x/8N/oNrwrwUsYM/lCjtBN
	 Yl8GX6S/8zegK33zso0fYSIxgaezwwLbYFWsD2N/V86BrfEhhEnOI72YYtuLUmO7Al
	 OpO2laKE174yWVOcbX/42YwrR2ZYVY6FlWuth0MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.15 63/84] mptcp: rename timer related helper to less confusing names
Date: Mon,  4 Mar 2024 21:24:36 +0000
Message-ID: <20240304211544.486431553@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit f6909dc1c1f4452879278128012da6c76bc186a5 upstream.

The msk socket uses to different timeout to track close related
events and retransmissions. The existing helpers do not indicate
clearly which timer they actually touch, making the related code
quite confusing.

Change the existing helpers name to avoid such confusion. No
functional change intended.

This patch is linked to the next one ("mptcp: fix dangling connection
hang-up"). The two patches are supposed to be backported together.

Cc: stable@vger.kernel.org # v5.11+
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -330,7 +330,7 @@ drop:
 	return false;
 }
 
-static void mptcp_stop_timer(struct sock *sk)
+static void mptcp_stop_rtx_timer(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
@@ -830,12 +830,12 @@ static void mptcp_flush_join_list(struct
 	mptcp_sockopt_sync_all(msk);
 }
 
-static bool mptcp_timer_pending(struct sock *sk)
+static bool mptcp_rtx_timer_pending(struct sock *sk)
 {
 	return timer_pending(&inet_csk(sk)->icsk_retransmit_timer);
 }
 
-static void mptcp_reset_timer(struct sock *sk)
+static void mptcp_reset_rtx_timer(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	unsigned long tout;
@@ -1145,10 +1145,10 @@ out:
 		__mptcp_mem_reclaim_partial(sk);
 
 	if (snd_una == READ_ONCE(msk->snd_nxt) && !msk->recovery) {
-		if (mptcp_timer_pending(sk) && !mptcp_data_fin_enabled(msk))
-			mptcp_stop_timer(sk);
+		if (mptcp_rtx_timer_pending(sk) && !mptcp_data_fin_enabled(msk))
+			mptcp_stop_rtx_timer(sk);
 	} else {
-		mptcp_reset_timer(sk);
+		mptcp_reset_rtx_timer(sk);
 	}
 }
 
@@ -1640,8 +1640,8 @@ void __mptcp_push_pending(struct sock *s
 
 out:
 	/* ensure the rtx timer is running */
-	if (!mptcp_timer_pending(sk))
-		mptcp_reset_timer(sk);
+	if (!mptcp_rtx_timer_pending(sk))
+		mptcp_reset_rtx_timer(sk);
 	if (copied)
 		mptcp_check_send_data_fin(sk);
 }
@@ -1700,8 +1700,8 @@ out:
 	if (copied) {
 		tcp_push(ssk, 0, info.mss_now, tcp_sk(ssk)->nonagle,
 			 info.size_goal);
-		if (!mptcp_timer_pending(sk))
-			mptcp_reset_timer(sk);
+		if (!mptcp_rtx_timer_pending(sk))
+			mptcp_reset_rtx_timer(sk);
 
 		if (msk->snd_data_fin_enable &&
 		    msk->snd_nxt + 1 == msk->write_seq)
@@ -2173,7 +2173,7 @@ static void mptcp_retransmit_timer(struc
 	sock_put(sk);
 }
 
-static void mptcp_timeout_timer(struct timer_list *t)
+static void mptcp_tout_timer(struct timer_list *t)
 {
 	struct sock *sk = from_timer(sk, t, sk_timer);
 
@@ -2465,8 +2465,8 @@ static void __mptcp_retrans(struct sock
 	release_sock(ssk);
 
 reset_timer:
-	if (!mptcp_timer_pending(sk))
-		mptcp_reset_timer(sk);
+	if (!mptcp_rtx_timer_pending(sk))
+		mptcp_reset_rtx_timer(sk);
 }
 
 static void mptcp_worker(struct work_struct *work)
@@ -2543,7 +2543,7 @@ static int __mptcp_init_sock(struct sock
 
 	/* re-use the csk retrans timer for MPTCP-level retrans */
 	timer_setup(&msk->sk.icsk_retransmit_timer, mptcp_retransmit_timer, 0);
-	timer_setup(&sk->sk_timer, mptcp_timeout_timer, 0);
+	timer_setup(&sk->sk_timer, mptcp_tout_timer, 0);
 
 	return 0;
 }
@@ -2629,8 +2629,8 @@ void mptcp_subflow_shutdown(struct sock
 		} else {
 			pr_debug("Sending DATA_FIN on subflow %p", ssk);
 			tcp_send_ack(ssk);
-			if (!mptcp_timer_pending(sk))
-				mptcp_reset_timer(sk);
+			if (!mptcp_rtx_timer_pending(sk))
+				mptcp_reset_rtx_timer(sk);
 		}
 		break;
 	}


