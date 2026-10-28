Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214955;
	b=4peJ3QB7rOa3TTCTC/Ne9UnFJZmDOJ1YQ5M3YcCSq30XoXi4H93bbyCZvWK9oDKkMirZ
	 wPWrhvJfCUm5GbcX1XPRRPaj2nQT/1X+wzr3+tM4PCwtLqD3tIep5TBmHnlbVyvk5dt5c
	 wHn968PGbvmGSDw3KCWrPqXVM6NokdNsk3eCZ/X998VOitLgUcKIKT9bFJhTpviWq8JOM
	 3YaMony5WrRiETaGNVGXjGB9uedKHlRl9WroHGBUIwUGsUQxbELrYngkyWGoveqk/lQCC
	 Sr52xnevy9c/m0aWZLxS7yHTx4mOvkFc8iKR3s3UMIY8is1vWDpwsMA5IYmzZSoJ9nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=paPiWGu4yBg33XwHHLuIIC3FiO0BQFQXmxF4g9PaG0k=;
	b=p//UQ/+ZpnH1XwjfOV4DgoBh95/GpQM0+lvXfZ2PrDxZYg6DrKgV620rKGyKZ9drHjCe
	 i/Rsqg8qTX9SGJC+YSjAqtMJmHwfpg6zhHnof3e0EezECJGKmwltzZhcPritLnTL3JUO2
	 dJQnvdnJ+9M9PuP/MPP8Ymzw7d2Gp9Gr984l1aouARSF+OgWuO2wL73psPfMC2z1t4zU/
	 u+CbmEiLrJNqKLGGg37tkcpiEkrjp28pvZy5K6A21uHn6nOFxhn+iwx/0NmbUE0bLFt5W
	 vAaJxND/YsZkoHknSvpPvO41tmCTZBXSF3+C8XPgbQczBSv5XditFnRsAGmz8WdMdBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFRNxR4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113F460A2607;
	Wed, 28 Oct 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFRNxR4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A91F01829;
	Wed, 28 Oct 2026 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214954;
	bh=paPiWGu4yBg33XwHHLuIIC3FiO0BQFQXmxF4g9PaG0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFRNxR4yyd3YUm2/85Mi/WbMg4XmjF7pYOySApF8R0gzbWl6drMhPLB43SE+Qysxx
	 SJe3MKaHbt4p7nYoCuPTRf5mFNqnHguZD6IoWkQZMhmXlBvOJ3026qipTEKgcYnyHZ
	 i6Um89L81iyS6eywLuRtVAs8ksKdGQ+MntrdoYZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0998/1887] kcm: fix zero-frag skb in frag_list on partial sendmsg error
Date: Wed, 28 Oct 2026 17:51:34 +0100
Message-ID: <20261028170522.125555136@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit ca220141fa8ebae09765a242076b2b77338106b0 ]

Syzkaller reported a warning in kcm_write_msgs() when processing a
message with a zero-fragment skb in the frag_list.

When kcm_sendmsg() fills MAX_SKB_FRAGS fragments in the current skb,
it allocates a new skb (tskb) and links it into the frag_list before
copying data. If the copy subsequently fails (e.g. -EFAULT from
user memory), tskb remains in the frag_list with zero fragments:

  head skb (msg being assembled, NOT yet in sk_write_queue)
  +-----------+
  | frags[17] |  (MAX_SKB_FRAGS, all filled with data)
  | frag_list-+--> tskb
  +-----------+    +----------+
                   | frags[0] |  (empty! copy failed before filling)
                   +----------+

For SOCK_SEQPACKET with partial data already copied, the error path
saves this message via partial_message for later completion. For
SOCK_SEQPACKET, sock_write_iter() automatically sets MSG_EOR, so a
subsequent zero-length write(fd, NULL, 0) completes the message and
queues it to sk_write_queue. kcm_write_msgs() then walks the
frag_list and hits:

  WARN_ON(!skb_shinfo(skb)->nr_frags)

TCP has a similar pattern where skbs are enqueued before data copy
and cleaned up on failure via tcp_remove_empty_skb(). KCM was
missing the equivalent cleanup.

Fix this by tracking the predecessor skb (frag_prev) when allocating
a new frag_list entry. On error, if the tail skb has zero frags,
use frag_prev to unlink and free it in O(1) without walking the
singly-linked frag_list. frag_prev is safe to dereference because
the entire message chain is only held locally (or in kcm->seq_skb)
and is not added to sk_write_queue until MSG_EOR, so the send path
cannot free it underneath us.

Also change the WARN_ON to WARN_ON_ONCE to avoid flooding the log
if the condition is somehow hit repeatedly.

There are currently no KCM selftests in the kernel tree; a simple
reproducer is available at [1].

[1] https://gist.github.com/mrpre/a94d431c757e8d6f168f4dd1a3749daa

Reported-by: syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000269a1405a12fdc77@google.com/T/
Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260219014256.370092-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/kcm/kcmsock.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index ab7629cee1bd0..7778a444ccb10 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -634,7 +634,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 		sent = 0;
 
 do_frag_list:
-		if (WARN_ON(!skb_shinfo(skb)->nr_frags)) {
+		if (WARN_ON_ONCE(!skb_shinfo(skb)->nr_frags)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -908,7 +908,7 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	struct sk_buff *skb = NULL, *head = NULL;
+	struct sk_buff *skb = NULL, *head = NULL, *frag_prev = NULL;
 	size_t copy, copied = 0;
 	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 	int eor = (sock->type == SOCK_DGRAM) ?
@@ -983,6 +983,7 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 				else
 					skb->next = tskb;
 
+				frag_prev = skb;
 				skb = tskb;
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 				continue;
@@ -1070,6 +1071,22 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 out_error:
 	kcm_push(kcm);
 
+	/* When MAX_SKB_FRAGS was reached, a new skb was allocated and
+	 * linked into the frag_list before data copy. If the copy
+	 * subsequently failed, this skb has zero frags. Remove it from
+	 * the frag_list to prevent kcm_write_msgs from later hitting
+	 * WARN_ON(!skb_shinfo(skb)->nr_frags).
+	 */
+	if (frag_prev && !skb_shinfo(skb)->nr_frags) {
+		if (head == frag_prev)
+			skb_shinfo(head)->frag_list = NULL;
+		else
+			frag_prev->next = NULL;
+		kfree_skb(skb);
+		/* Update skb as it may be saved in partial_message via goto */
+		skb = frag_prev;
+	}
+
 	if (sock->type == SOCK_SEQPACKET) {
 		/* Wrote some bytes before encountering an
 		 * error, return partial success.
-- 
2.53.0



