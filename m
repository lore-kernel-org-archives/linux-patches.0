Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78118405CA;
	Mon,  8 Jan 2024 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFOxD1fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95AFC433C9;
	Mon,  8 Jan 2024 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726883;
	bh=q+N5cQKbcfbunazYAJo+ANsgjyWfOMFD0TzR322OGeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFOxD1fVV96WnLlp2RusDDX50qnyhs05WfLUai22BR7L9wKubDxx04ccmSnP8EKKV
	 bqXQoHyXYSFXgfM2DQ55i+amiWbJLpkZDLfd5y2utSOym+ZRAakDqhHKW1M14rn+1R
	 6dAu2OGpafAprskRN+WeTZGDzLULmyM+rbwulEp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/124] net: constify sk_dst_get() and __sk_dst_get() argument
Date: Mon,  8 Jan 2024 16:08:54 +0100
Message-ID: <20240108150607.930156502@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5033f58d5feed1040eebeadb0c5efc95b8bf5720 ]

Both helpers only read fields from their socket argument.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1b7ca8f35dd60..70a771d964676 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2152,14 +2152,14 @@ static inline bool sk_rethink_txhash(struct sock *sk)
 }
 
 static inline struct dst_entry *
-__sk_dst_get(struct sock *sk)
+__sk_dst_get(const struct sock *sk)
 {
 	return rcu_dereference_check(sk->sk_dst_cache,
 				     lockdep_sock_is_held(sk));
 }
 
 static inline struct dst_entry *
-sk_dst_get(struct sock *sk)
+sk_dst_get(const struct sock *sk)
 {
 	struct dst_entry *dst;
 
-- 
2.43.0



