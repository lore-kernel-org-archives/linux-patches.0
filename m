Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704147;
	b=4+Ef2c+I3yffYfnJa59ol6wWpJlp9LN3nbsobcX3LwpwPKi9TRZQ1bdXNWzUSaYeIdKi
	 JU8uACE3vTrz7T4JdGdV5wK5/ENujwdr3WaLXKpsqmU25RmD7UxC7JNi8xx9f+e/Q9EJF
	 lDx5Nz6z5sX5gx05AuX4uKdp+/ZuHiPNLv3IenJvhPLj9DV0ck2/kpowCnmCz7r+vH0OU
	 wUZR44rzIzYM3d/0Y+awp0h85vVwA0PgZrDfocoIeYMXOMq0TDV/3GUSQR5HHNqnOl8k0
	 wOB/Iukkb0mhdO3Vh2fjFRdxj1zDIGn+qWm3fEe+6XuNCTYDDwUCaXYMGQiB7G6/maw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WB9qGBnamxVSfXobjg10nVP2ycR6iNDAom/ysMhO3lE=;
	b=yA5xx0ulncGkKY9S4dWYcQL+/9NQzL9wCH9FFxD7HhJfI+hRdAAJKyNsptOIofBsAn9C
	 Yz+3USmcVG22pDmICf1SmC0I9cUUl735wzg3Nt295+Xb+YowX2oPHPVsk+1no8Poa+Vmy
	 dSZxSK0aCyiclyZdJ7P7JY6n40Q7lDpGYoJDx9JUMljTfkbiGVqGNBl0n6NxKVnP1s62i
	 zIPylLn9prPLpppUqWT7i1wnsNvwjiquNCASpc4KYki2H9ILt6eWcvZYKhrfle/J5gnwA
	 dth/XZJTeY6WnVGFy6ILMjXjCWoEFr4pP5pfvVEv7sNZpnhTAPzdOSO5dEPmHDXiVvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jtJBNJ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCF9606A31C;
	Thu, 26 Nov 2026 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jtJBNJ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74571F000C4;
	Thu, 26 Nov 2026 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704147;
	bh=WB9qGBnamxVSfXobjg10nVP2ycR6iNDAom/ysMhO3lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jtJBNJ1VrDofdWBFeD46qtXhV+7/YkoQWaPCd78fVPY8On58h8GuhGi31Q1T1bLO
	 a88iQbU0HcnzSmWc9gZArtFfwtd1AKZf5cKUiCmHXMUp3dUJRGUJH7FI3y/j/1/9YK
	 4t8QBqjP13WnBMmW4ZRS0IMRBclDTF91wA6B3dDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Vignone <gio@octane.security>,
	Shubham Antil <shubham@octane.security>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/265] xfrm: zero-initialise km_event in the replay-notify path
Date: Thu, 26 Nov 2026 15:35:52 +0100
Message-ID: <20261126143606.619262970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubham Antil <shubham@octane.security>

[ Upstream commit e35a12dffd5da67b6ca12bd23eebdd0570592205 ]

xfrm_replay_notify(), xfrm_replay_notify_bmp() and
xfrm_replay_notify_esn() declare a struct km_event on the stack and
initialise only its .event and .data.aevent fields, leaving .seq and
.portid uninitialised. build_aevent() then builds the XFRM_MSG_NEWAE
message with those fields:

  nlmsg_put(skb, c->portid, c->seq, ...)

so the netlink header of a replay event carries uninitialised stack
values rather than defined ones. This was confirmed at runtime rather
than by inspection alone: the .seq and .portid carried in that header
hold values that nothing in the replay path assigns.

The request-driven paths set these header fields from the requester
(xfrm_get_ae() / xfrm_new_ae()); only the kernel-originated replay path
leaves them unset. Zero-initialise the event so the header fields are 0,
the correct value for a kernel-originated notification.

Fixes: f8cd54884e67 ("[IPSEC]: Sync series - core changes")
Reported-by: Giovanni Vignone <gio@octane.security>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Shubham Antil <shubham@octane.security>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_replay.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index aedc61ceadb30..1e8e23dded617 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -37,7 +37,7 @@ EXPORT_SYMBOL(xfrm_replay_seqhi);
 ;
 static void xfrm_replay_notify(struct xfrm_state *x, int event)
 {
-	struct km_event c;
+	struct km_event c = {};
 	/* we send notify messages in case
 	 *  1. we updated on of the sequence numbers, and the seqno difference
 	 *     is at least x->replay_maxdiff, in this case we also update the
@@ -278,7 +278,7 @@ static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq)
 
 static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
 {
-	struct km_event c;
+	struct km_event c = {};
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 	struct xfrm_replay_state_esn *preplay_esn = x->preplay_esn;
 
@@ -330,7 +330,7 @@ static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
 static void xfrm_replay_notify_esn(struct xfrm_state *x, int event)
 {
 	u32 seq_diff, oseq_diff;
-	struct km_event c;
+	struct km_event c = {};
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 	struct xfrm_replay_state_esn *preplay_esn = x->preplay_esn;
 
-- 
2.53.0



