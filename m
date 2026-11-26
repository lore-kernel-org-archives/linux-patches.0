Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704919;
	b=rbrd4ufpDryZzF/924Whos5esVBq7qPibCaat0BcprDaK3kjiTIuDTpV2RVtEHDIDhZ4
	 /1Z+FjSeb3DOxUrXlCJP+zFB2hlB54rkp4/NHR0r44CJoBSBjjWkmgKIQkMnpgymHw8/g
	 soH6vZUCa8kWx65mbc7MfS/s+jFtksaJPmmTUIBz1A1mFl2dTOyS53neaUPaC3BztDIFO
	 /ZX7ckZ/9XAboHzjTldhsmsga41OjKuiZlb/r8b3QyNBpAKzxQV5ZTaCj4n0DYBK3Vw2E
	 lV8eqNXP44o7DFv9VAlm05qq/QRSoEinVfB1N27y/6F+dQpY0uL5VVLvlBg13Mmhx7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5FE/d25LaX4+vkTB3pfXH2WdBDsHjt/8dxxQ58zMDc8=;
	b=1FgFtIGhCJyM/K0YbRF5eraf3r5b/HSCndTmiWFNN6QB5M4c0htsAepHQNd2552hgqbr
	 hPtqjaz8+H1C6paw7UjrFXeBwcZ8kQ6vycvLl0wgIS9duSfi+7TNDve2AkJuE70Gav4LZ
	 KkedZg1gYbSOvOabydp03bc07bZmgh2PhZkT68pk5d2GAOSuUZpfOhIzxxp9au+lSQ7cN
	 D0BV9urfhc9roNb4efskehiZaIndLyfz8/ymgkVemqWopfOnyuFUjajRR87goyX3Me/W5
	 6NABcm8FJf88hmIRwGBU1xcK1P4GeWwsPbQSGumuLQTKW0Ym2HjaiVWKwpjdttwqAOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGNWYic0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05853606A31E;
	Thu, 26 Nov 2026 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGNWYic0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6BD1F000C0;
	Thu, 26 Nov 2026 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704918;
	bh=5FE/d25LaX4+vkTB3pfXH2WdBDsHjt/8dxxQ58zMDc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGNWYic0K4ZPaWPGtz3tw5I2u5LqNtrss3AmTiJK4z+Or14nH8Do7uOreqMr4M46E
	 0xaPuhMiwRVQoVQNcP051KLjOb0OhKTaULHYC/sSy5SWPsoQF8jKNfbOg1Gm3FwpHV
	 A/fN3mRyg2ZdM7jlOuuHSVqwvW6IYzedpa/DaPog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Vignone <gio@octane.security>,
	Shubham Antil <shubham@octane.security>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/319] xfrm: zero-initialise km_event in the replay-notify path
Date: Thu, 26 Nov 2026 15:36:28 +0100
Message-ID: <20261126144007.197718434@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6f6a18dc375b7..9937d0e61b7d7 100644
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



