Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062425;
	b=XXUYPTzqnnpE0bVyfNOmYPpOW8H4rSLvDfqz90fIluNi+jixGSO/+kHVr8ZwHJtxZBlC
	 Wk59rjMBz5yhtmcOvCkXZyYHa401l+UHA3Fg1oaheNv/6cMzp82uwwBmAWahlHDWgL7dO
	 CjNGu3f7qTmrPGMrf6lm3sqoJjbMkTWog+y1m6yNjhoRpTddNVL0FMS/fJpAM1RSTmRkV
	 43b8ArNMvNs+6TXcBOOdhZKMrotRH7hB96VHRW3/Ktu2AsQG1aotYdUcKKMa6dAiAE0D4
	 FB8Lc3AADCN0yE9KcprX0VYBg2No8qOxAHrNX9sB9OJa8HVZ60cGMG2N73UTYjXuSJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0A7PqvCQTyFhiiiU0jKacmfXw/JBuN48MOqBYg4m5I=;
	b=LhaCN0EPxeTOinji687RcVk2KuVdBkAk1eLOw12uqZO0ZjjRcpkPgMayh/FD2VWO6TSo
	 njL+bA+Ck2iCocjju7m7JTYXwrBZwgk6RyWqK/pu1aS5hicMiHFtTeQYb+V+1tj3A6H7r
	 q9Ed8K7L9/Wu0Xo4B/QCw3CzlYWw97tCfHqlPYH7KtqAL3oaF+5s0fGau8ivD0M9tFMWn
	 yQM4y1nbsld5bblwLJj0GvgeqAHE78Ft3DJrQXv6ywynaEHTGG6Z8bVOmNIL07j4akiQQ
	 HatMlOo9m5+qtU1m8mwsXx/H2fpReYgNo/pcxmE9NggI/nZgj+oXhZdRia3AnjkL41Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B2IQTHH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6906760A261B;
	Sat,  7 Nov 2026 14:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B2IQTHH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180D61F0089F;
	Sat,  7 Nov 2026 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062425;
	bh=x0A7PqvCQTyFhiiiU0jKacmfXw/JBuN48MOqBYg4m5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2IQTHH/gZeCpsIKjmm2iIKHWeU1e/FhkLNs6M6XCooZv3b/Jitj7Z0pBRbKjH8hm
	 +7y58i0RYlnqOWaiEOzqulAK9QEm+aeoNs0bvjp4x0ghCUilPii4gAnjw5Z5MUcmOR
	 kduL0A3NGuHJeE/52iAFL/83fVsjk0TcouYyKAE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanye Yang <quanyeyang@proton.me>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1338/1536] mptcp: reset msk state on early connect failure
Date: Sat,  7 Nov 2026 08:55:54 -0500
Message-ID: <20261107135035.397502100@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 29afe67082b2d33ab2e90c56c337235d725f023f ]

mptcp_connect() can fall back before the subflow SYN is sent, for
example when the netns is in an MPTCP blackhole, token allocation fails,
or MD5SIG is in use. If the subsequent subflow connect() fails
immediately (EAFNOSUPPORT, ENETUNREACH, ...), __inet_stream_connect()
returns while the socket is still SS_UNCONNECTED and never calls
->disconnect(). This was reported by Clashiko [1].

The error path only dropped the token and moved the msk back to
TCP_CLOSE. MPTCP_FALLBACK_DONE, allow_subflows and
request_mptcp were left as after early fallback, so a later
connect() on the same fd stayed TCP-only.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/633 [1]
Fixes: 0235d075a592 ("mptcp: mark as fallback even early ones")
Cc: stable@vger.kernel.org
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-1-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 00997357d4bcb..ed41368392c95 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -4012,9 +4012,16 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 * subflow_finish_connect()
 	 */
 	if (unlikely(err)) {
-		/* avoid leaving a dangling token in an unconnected socket */
 		mptcp_token_destroy(msk);
 		mptcp_set_state(sk, TCP_CLOSE);
+
+		spin_lock_bh(&msk->fallback_lock);
+		msk->allow_subflows = true;
+		msk->allow_infinite_fallback = true;
+		clear_bit(MPTCP_FALLBACK_DONE, &msk->flags);
+		spin_unlock_bh(&msk->fallback_lock);
+
+		mptcp_subflow_ctx_reset(mptcp_subflow_ctx(ssk));
 		return err;
 	}
 
-- 
2.53.0



