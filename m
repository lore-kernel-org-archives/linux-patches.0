Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617648;
	b=FizykebNM23cNglo2PAGq9qAiSaUst8BpZ/39wXC1Gkrn17HKomuTDCJTecyMlrpx7sj
	 0yDObjxT72XiInt+cl2p5yCvl2S1Sukt+5sp2sDNl3kzuZU0QShdfZqHTvd4++x++wjHK
	 XL28gxHTc7AuTVDZk3JLlVLFRfkxx6lwzgizSYIhhkg44vuEDfOxdPIimkEHSJY0vpkU+
	 EVRRxg9becV+mdo/ZjN/g+832pwCt5hjav5sulonPxDOGyCC5oqi2l6+nT8U5jLrqSYUA
	 lrjbF67g9xDbGpLMoOA/rwRWzIfjLxlNP6LtEC1/YVUOnsgyccM8iUks71UmtaVhiIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fQyaTxLNyPR72pOCQmjN/dWUCCxdWkpNW4R9T+vb0pc=;
	b=v/f0lYg3uf64ICUTgC1VplB5Q2+2Em3qMU89dirvwTE5eo6jj6lMfWypCd4A7mGUDAoC
	 9diL48m+KbOfRqSuFkXaXIMBmYiofjwjbTXmP5CQluGrcKg+BkulvaGam46DrO76+DTcm
	 JOrCzJHrhqRXSvkpMCMo1bdp/koogqYvMvSa0xqtEaUuspfFGPWfZKU02GW2y8xUR0kv8
	 0IOPlz1NVvpypwThkdtinxTAsn0nXm/xM4VdQP47KutohA21ECrqSPb8l4O84HNvTQgGH
	 0LgB0dnZGC+F8eOxdmZRZcF5qtODTLCCWQz6J2xFv6AcGhn+qU2K2/yWiELTxc6EWKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qBxe/ZRp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BDA606A6A7;
	Wed, 25 Nov 2026 14:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qBxe/ZRp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E681F000C6;
	Wed, 25 Nov 2026 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617647;
	bh=fQyaTxLNyPR72pOCQmjN/dWUCCxdWkpNW4R9T+vb0pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBxe/ZRp+QF21oO2aL1t3PyqQ59fHnjXxfjW9kuweEHDDFgv87r6ECt595eBgPmtF
	 8mbAoQ0mKVXnEupVKjyb7lVgpnGOq5zdzFDlAyTB+oMJyNlUMwP2JcjHAtuWzIg/BO
	 reAMC+IT0xOQJVmpFbfSLG2XjMcs3Uq8RkVW8YpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Vignone <gio@octane.security>,
	Shubham Antil <shubham@octane.security>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0032/1005] xfrm: zero-initialise km_event in the replay-notify path
Date: Wed, 25 Nov 2026 15:22:50 +0100
Message-ID: <20261125143822.489715000@linuxfoundation.org>
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



