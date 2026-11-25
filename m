Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619125;
	b=d+fFYeR4OJvibH3Vft3cfItHjQpd+U2jyJbuTUXYBStTSXgsd41wLdCtTn6Sd+NDs9KJ
	 56IdOHIstNhspjBas5MkfFbPvxaQakBO9Ik94Uv20UQRQHpLRx0428jsvAOxf4nNPHM+G
	 5i4tNxtuG5f+YSyAA2gyrUqlQmHqyZw13jKZs8GJJ3/6ijval2zqNfWcH0v4BG213RUuV
	 zylQZ7BNxcfMQyiKHV8i5NfhhcNY7KrSkSM3oo36UvjDuzemycMO4OJv1dUlN7V1TzJVj
	 7gAxAo8NN1kxs4eGSqSGhGApcfCiUxz9oKeUhBpqzinlXFd+VKbgpr4tc8nfkJsRkQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ez73w0UWUdn9/0P30k0Xubl+sVSjduNsthY6iB3JnNE=;
	b=S2Dc34OxBbgTEkjP73vNnMeSW2YypOMkAfMYYPMlQLnl+hxWD9dhWfePD6OqfXfqSm/l
	 r1fv2PE43a87m2jOSh0pbUfKRp/eAhFW1sg+i2JxXn58juuhzCGq+UJy68WKDL0L74EAv
	 Ntr1hdA6mv8MGC1ahNRRAZwLGgZcaQJ9D/xoyuXhROKQXr5WSPVDXnCLhTB5oSXBlRkR7
	 oJp21b6wHYkVxcO1toYgH6Eh82CDkvdFn1GVU5aCxeMco4AihQA1ZE631IlTucQF9dkK4
	 Hm2zN7ixvwjuwiNrTwQCqFOBQrfbLKbPtb318N69Y0nm3EdF28K4xId6DRiMxUGxeUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjvNA1VM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD5C606A329;
	Wed, 25 Nov 2026 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zjvNA1VM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AAF1F000ED;
	Wed, 25 Nov 2026 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619125;
	bh=ez73w0UWUdn9/0P30k0Xubl+sVSjduNsthY6iB3JnNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjvNA1VMAGkdwMsNpkpMgIlYa2TqakeRY7Vxx7VI9dFETetC8wbbWX85tZWgQz7FL
	 H1tyuXDx9zATE42Zi0r721q/JGjMnFwZurkumsVfTHx0K/NEKZV8yl70PKMDUL/Pxt
	 JWeNZNjKFBxUFOr8+/1Fbc2t2EJxGhp0QHkCuajs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Chris Mason <mason@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0496/1005] net: skbuff: uncharge trimmed zerocopy frags on error
Date: Wed, 25 Nov 2026 15:30:34 +0100
Message-ID: <20261125143833.363768463@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 8b67debdfbf6b370312ebec5c9e0a1c39b5c7733 ]

__zerocopy_sg_from_iter() accounts for the frags that it adds even when
it returns an error: it adds the growth of skb->truesize to
sk_wmem_queued and, unless the skb is pure zerocopy, charges it to the
socket.

On error, skb_zerocopy_iter_stream() cannot free the skb, as it may hold
data from an earlier send. It trims the new frags, but leaves
skb->truesize and their accounting in place.

Repeated failed sends to the same skb accumulate this stale accounting.
This can inflate TCP memory accounting past tcp_mem, and can wrap
skb->truesize, leading to a use-after-free of the socket.

Undo the accounting after the trim. If the trim fails, the frags and
their accounting remain. The trim only fails if the skb is cloned,
which is not expected for the unsent skb at the TCP write queue tail.

The issue was found by an LLM.

Fixes: 52267790ef52 ("sock: add MSG_ZEROCOPY")
Reported-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Chris Mason <mason@kernel.org>
[willemb: revised commit message]
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261105223512.3647504-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b24a949bd546e..892ab589ad396 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1922,6 +1922,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 			     struct ubuf_info *uarg,
 			     struct net_devmem_dmabuf_binding *binding)
 {
+	unsigned int orig_truesize = skb->truesize;
 	int err, orig_len = skb->len;
 
 	if (uarg->ops->link_skb) {
@@ -1942,12 +1943,18 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len,
 				      binding);
 	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
+		u32 delta_truesize = skb->truesize - orig_truesize;
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
 		iov_iter_revert(&msg->msg_iter, skb->len - orig_len);
 		skb->sk = sk;
-		___pskb_trim(skb, orig_len);
+		if (!___pskb_trim(skb, orig_len)) {
+			skb->truesize -= delta_truesize;
+			sk_wmem_queued_add(sk, -delta_truesize);
+			if (!skb_zcopy_pure(skb))
+				sk_mem_uncharge(sk, delta_truesize);
+		}
 		skb->sk = save_sk;
 		return err;
 	}
-- 
2.53.0



