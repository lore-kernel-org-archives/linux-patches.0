Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212351;
	b=kOZLJgJ4RtvMGQH1wujcds0fznNPl4RQ4jhK7sHBVeq8URsFb+Gvki/nizfmSiaerq46
	 I2urOS+11eHWZxnRon+6KtmZ+3I77lfNNQ88zNJ6Xgy/y6AKTCwq3ZgjyWp58IMm/2Ge5
	 euqp57eSANTD3hHUG3SREe0Pe/ZkXJxaSIEAzUEiIsWHPLxG+1cy8KlYJ6NsZ9tyH2jQA
	 RS+h+Vp8NhvUvgw5X+O2oUJ0mOXd4phnsQXLv2EJuvDi11O0ScZuuuFF+5XZKSQ350cGf
	 gV21QGQIeqhabwULLAoJJDk9qpdb+UoQDVNDgGXbE+yd1x/sbnUWkZ4WC6LXRknJs/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tFHJM7RGbkNRco4eZ31h2lc7Q5D5VmhmKxPVHr3B2oM=;
	b=lIIL6Njn3CDA2EvN826QU1vqrrK8dJ1/I/eKgaTQWLOT8fnyFNQbo9J63mgtei28KLPX
	 glfQXjQCesZvWlKtTEVCF2oYgoOFMyReyOX1v9pvyNh/z71iX4+cN9XfE7lGjXobU71RC
	 /U4AUdzGOMQIloWqnZz3lDKTp+H2X79j1jcR8FBiJewyY1RGjDFNKHF1qG87jbskLlPN4
	 P5NqBYGxP+x41g2BydCY0fEgwUjqISBUqBMriFyL5fCOjAsOkITqeoPRgLaauYi816He1
	 LT2VOQ7TeI/nCiZEPstRfZNugcq8Janf4sxQ48qUZ+gBB2Ix6+syN/p3U6AEEgFtXcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zv2sokv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50DD606A330;
	Wed, 28 Oct 2026 18:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zv2sokv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116641F01829;
	Wed, 28 Oct 2026 18:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212350;
	bh=tFHJM7RGbkNRco4eZ31h2lc7Q5D5VmhmKxPVHr3B2oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zv2sokv+MdH02kf14ps6t8DZsxUn6yjp6esWPXoFyDWkJencyvTnLMico0Ehxdun3
	 0gP9mLiSnTfXBhysStf9hdkIZZqiKXgU40GHkFyO9XHNuo5voLu0psfcLLFfncIgRN
	 EszPRNKrnCABglQ35+OJtIlY5sJN96T1Z1zh1tnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0124/1887] sock: add sock_kmemdup helper
Date: Wed, 28 Oct 2026 17:37:00 +0100
Message-ID: <20261028170502.060239256@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 456cc675b6d4cadd4872a477d8976ff56eef4b6f ]

This patch adds the sock version of kmemdup() helper, named sock_kmemdup(),
to duplicate the input "src" memory block using the socket's option memory
buffer.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/f828077394c7d1f3560123497348b438c875b510.1740735165.git.tanggeliang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  2 ++
 net/core/sock.c    | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9fe621f985740..d195cddb8559b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1977,6 +1977,8 @@ static inline struct sk_buff *sock_alloc_send_skb(struct sock *sk,
 }
 
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
+void *sock_kmemdup(struct sock *sk, const void *src,
+		   int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
 void sk_send_sigurg(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 899ddf069940f..8593dc1b33eb3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2670,6 +2670,22 @@ void *sock_kmalloc(struct sock *sk, int size, gfp_t priority)
 }
 EXPORT_SYMBOL(sock_kmalloc);
 
+/*
+ * Duplicate the input "src" memory block using the socket's
+ * option memory buffer.
+ */
+void *sock_kmemdup(struct sock *sk, const void *src,
+		   int size, gfp_t priority)
+{
+	void *mem;
+
+	mem = sock_kmalloc(sk, size, priority);
+	if (mem)
+		memcpy(mem, src, size);
+	return mem;
+}
+EXPORT_SYMBOL(sock_kmemdup);
+
 /* Free an option memory block. Note, we actually want the inline
  * here as this allows gcc to detect the nullify and fold away the
  * condition entirely.
-- 
2.53.0



