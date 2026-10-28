Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212353;
	b=O2bkNJzop3m+X+4CFA5NGv0uRSZQvqB0e1JR0b7PiNw+GjsA1HqEPPtcwxM1N2cwYWEt
	 RrjeZPgc8F858LR9AjsjOGfgbPXBDkEuC37RDjqhK/FzUlDSK9qAiNe+QBmTzW+SU3z8Q
	 /qwZG1tQh5oUh+hLgTIyQGIzp9fOTbwEU4dby/PN9Me1ZtkZvEs6YCNss7QZNAmDYpOTC
	 gEMgFAFPkodFy2FV3xkoNaQR1OXakCYMkyiOAnIGRCEfgCn5J1sgOHnyut+lydK4qVrvi
	 6tC5M12bEOOpgpz01fU7OvcfAHxuvLwYPSpRHH3gyGxY+rrL1yLjU5Dw7e/6AEHiXkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9XvsesQVuk7RN7YoV9CqUJTRLlkJtQX5FzqGHsBBN5A=;
	b=eQT0lH9JckQ6QbY4x21g/m1+O93fnpTfwgb9IFbX6FcqV1Tm/mOa5DCPsoDPOhZfTzc+
	 Bad97tVxfd45nqMsildOnHdiJSFJipMqL70jvsI8b0L35flTSZ/a+pJmd0sSAZX6mZ7Wd
	 KklZNHCampNMVWBxka+gJgExbTUdF9DXuOrNqASXNn9wyUcdwtKe88tjoPXdTJyc8B7En
	 e35IOrekOJMPYLTKbX/PAwNBzC4RUQzaZfKjXWENvOFEVri6I7EhCtxMYGZgWeFueFCeA
	 Qea6awvi2ivNUO/ibUHyuP9jHP0qJdbwUqxGKGrhQwxMSNemMFmdjcgrLgF580HaD4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMn9B9ax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB6F606A320;
	Wed, 28 Oct 2026 18:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JMn9B9ax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE2B1F01828;
	Wed, 28 Oct 2026 18:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212353;
	bh=9XvsesQVuk7RN7YoV9CqUJTRLlkJtQX5FzqGHsBBN5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JMn9B9axGfU5ElIp1OaQJa1aeTz/eW3e/MOv3BLGWsn4d0O7ykHlFsLvz/9hduDBc
	 GH95/R0zHmCZnLOmqn1ViMkiAPTR+l0AVIIqMD0bcojcAXMF2Zu6tcYy3jaBA8K46/
	 XtCeozbl4dIYp1oKv78ANAsstXn+c0FJfAPh3HEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0125/1887] mptcp: use sock_kmemdup for address entry
Date: Wed, 28 Oct 2026 17:37:01 +0100
Message-ID: <20261028170502.082412457@linuxfoundation.org>
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

[ Upstream commit 52f83c0b5f857dbe24f66fc9a7f035523e9ffbc9 ]

Instead of using sock_kmalloc() to allocate an address
entry "e" and then immediately duplicate the input "entry"
to it, the newly added sock_kmemdup() helper can be used in
mptcp_userspace_pm_append_new_local_addr() to simplify the code.

More importantly, the code "*e = *entry;" that assigns "entry"
to "e" is not easy to implemented in BPF if we use the same code
to implement an append_new_local_addr() helper of a BFP path
manager. This patch avoids this type of memory assignment
operation.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/3e5a307aed213038a87e44ff93b5793229b16279.1740735165.git.tanggeliang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index e203b7f878a90..1bc270276db46 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -70,13 +70,12 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		/* Memory for the entry is allocated from the
 		 * sock option buffer.
 		 */
-		e = sock_kmalloc(sk, sizeof(*e), GFP_ATOMIC);
+		e = sock_kmemdup(sk, entry, sizeof(*entry), GFP_ATOMIC);
 		if (!e) {
 			ret = -ENOMEM;
 			goto append_err;
 		}
 
-		*e = *entry;
 		if (!e->addr.id && needs_id)
 			e->addr.id = find_next_zero_bit(id_bitmap,
 							MPTCP_PM_MAX_ADDR_ID + 1,
-- 
2.53.0



