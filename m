Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621073;
	b=uIoyQ9V8B/DCxsezzbUogYXZWKBtbtGOFxr3RdRobIVRpLTfKZqgUvZE7MQcxTykdTxR
	 20MOs5m3KxRhqp+jSMXEzuI9zjBmiyVq8r6UcNYC+SkpKJlzdX9SBvwTCMzweGUOsAxuC
	 o29S6N1VxrRdR8DTlHvjSpcQ+VfMnTyuFhAzoKkdTPZpfeCsmn6cf92QgQitVuq49eOWu
	 fz054GuItgZWJqqHhF9sAXwLM7pwiY9AYOuVdwlaQwdQ1Iw/b3PeI04GBv6PWQw8CjKXP
	 mxsK6j93UOwyy9Vfsum2Wc03eYoPBMYPuL3p9d0foO83+U4aF7jNpKvKIWLwAMo8A0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QUgEyLvoRyGqc7Sqi1ek2xa2SGcxuks8EyPn8GmojYg=;
	b=oyl1o+w7gdVdGF6BzCkafahl5Rdt+CPMIclacC48d41bvOtw/3V2r9MZw/ty/MbKwbxt
	 aLyBQ+9fDbcfPzyEz6gF3ypj66tDVP6z49je8kdS96OsfQvMiarzIwL5S5hSaOW/1ptQB
	 +NkjdvWkqefWsRs/ljVSVsQoyeu9ziUu9KgGinCfJLCJ7HHNuftBEOtZSJLUnV+w2wOpX
	 /4jBu3JOa86bxngnMUwlpPFZByyQoLhPMMr2v/5bJZHqr1cXlLACuqu9M9WzwsRjcUX/E
	 VNUUiz7BIvLS3iAHOTDXvQBwAsxBiT7b5xP8deQz0niy1mq13VlQaVITspl+NqD9EmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gEYes68E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A6E606A326;
	Wed, 25 Nov 2026 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gEYes68E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF11E1F000C4;
	Wed, 25 Nov 2026 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621073;
	bh=QUgEyLvoRyGqc7Sqi1ek2xa2SGcxuks8EyPn8GmojYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEYes68EZOaxDXtEJOywo3I+mTUrdDspiLLO3ul2dJME1FZ8CvDQOEhN1xvUR5yqT
	 zt+YfTXQ0VQCUf+Ptp4dMdqKJurVtSSZ0IDDHp5ESk4E+U2RxOAbCEubzaaK6U3Qtv
	 0gZWcsH61y/fffkm0629jzRXARD4H2oYqSNdJn18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Vignone <gio@octane.security>,
	Shubham Antil <shubham@octane.security>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/990] xfrm: zero-initialise km_event in the replay-notify path
Date: Wed, 25 Nov 2026 15:23:54 +0100
Message-ID: <20261125143823.657999427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dbdf8a39dffee..9394953247ab9 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -40,7 +40,7 @@ static void xfrm_replay_notify_esn(struct xfrm_state *x, int event);
 
 void xfrm_replay_notify(struct xfrm_state *x, int event)
 {
-	struct km_event c;
+	struct km_event c = {};
 	/* we send notify messages in case
 	 *  1. we updated on of the sequence numbers, and the seqno difference
 	 *     is at least x->replay_maxdiff, in this case we also update the
@@ -304,7 +304,7 @@ static void xfrm_replay_advance_bmp(struct xfrm_state *x, __be32 net_seq)
 
 static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
 {
-	struct km_event c;
+	struct km_event c = {};
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 	struct xfrm_replay_state_esn *preplay_esn = x->preplay_esn;
 
@@ -356,7 +356,7 @@ static void xfrm_replay_notify_bmp(struct xfrm_state *x, int event)
 static void xfrm_replay_notify_esn(struct xfrm_state *x, int event)
 {
 	u32 seq_diff, oseq_diff;
-	struct km_event c;
+	struct km_event c = {};
 	struct xfrm_replay_state_esn *replay_esn = x->replay_esn;
 	struct xfrm_replay_state_esn *preplay_esn = x->preplay_esn;
 
-- 
2.53.0



