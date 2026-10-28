Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211004;
	b=s3pcbt+EApVqrxQCkBDJdr13xt5DtqVWuQtO6SXv++E9r4MZYK3QrEaAABH4Rymy/VAd
	 P4Lyi30oOcTeXpieRpRjsDTiPTShe24h8iO16wcT6DlINanlRTLnc/fFDb2htqvOdNMwa
	 o5PygyQwHbaXYwzxvi+CsoQpCIb+/j2ix3t+hQyVEt3s6ggJyph62mG1HBgvn+MpHhgE/
	 +HATpCKP1fQsNSyjo1Yij6/3pki73gQRXICCFOrvqgTOx4tx70v6bmV09gazJ0Yv+16LR
	 G8KyW+9JJOWCCrXrgSvG8t02SDOUQcZHb9HXnl4lCMKt1aSrv4qORDsUiSO8dJ+hiaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yd93KY7ShrqYot29vcw/7lG7h94+Ai8FIjyLgRysnJw=;
	b=rfcib0T3RP3iF5hjU+Csa945TiKYkzmNCkLBJp6pM3RaGJW8JbuRbi+tB6mo8H9HZmL9
	 dcPbz5sUq8q4vIk9wMdlmvOkVTbY7xfFN2IrUdZkAIbv4sv0s+326Lvoa+y3So+Hqn8hp
	 QiaLoJblmubRFAxgCVfibbyPOqRtSnGOXAh8yf+oF7Ggln9XWxOVzgMtJfuebdxDl8MwN
	 v7fuk5nHxAZXl/tvoVStkFHe9WxfgRPwB/dY8XzokhlKzXij7jzaoEDLlKQOi6Lc6fPEL
	 eL1YJ8/Rzcx+Ya8SATNrlpaLFjk3KyAiM7XZwlI0CZTe7M1IoI7D6/u+3xMGsq4D3nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZZIv/Rm3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BE4606A31E;
	Wed, 28 Oct 2026 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZIv/Rm3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E8E1F01825;
	Wed, 28 Oct 2026 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211004;
	bh=yd93KY7ShrqYot29vcw/7lG7h94+Ai8FIjyLgRysnJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZIv/Rm30QzzaMHUk2gKEFLuSL6i/qwrSuWTuJQZBv23kEX7KkB395cOx7fYaxXqW
	 VtNUN42XYG9xuze3YxIgcXtX/RscvMQEKkGw5dq7O/x5yd+dIoFfz+cDNhB//bmguL
	 u98XovMqcToigBn4hwV4d84xMoMV88QdaSvnRpPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/571] net/sched: sch_codel: match the no-drop threshold to the packet size
Date: Wed, 28 Oct 2026 17:55:27 +0100
Message-ID: <20261028170012.283723627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 54518e0e827f4ca9229ae657022c60bf60f5c1bf ]

commit 6439461f1618 ("net/sched: sch_codel: clamp default mtu to avoid
disabling CoDel") clamped q->params.mtu to [256, 1 << 20]. The value is
the CoDel no-drop threshold (codel_impl.h "*backlog <= params->mtu"), so
on a link whose maximum transmitted packet size is below 256 the floor
extends CoDel's minimum-backlog exemption beyond one packet and delays
drop or mark eligibility by several small packets.

Keep the upper bound that guards the original overflow (psched_mtu()
wrapping to ~2 GiB on a huge-MTU device) but drop the 256 floor, so the
threshold tracks the real device packet size.

Conditions to recreate the bug: attach a codel qdisc on a link whose
MTU plus hard_header_len is below 256 (e.g. a CAN interface). At that
MTU the no-drop threshold must equal the device MTU plus its
hard-header length; before this patch it was forced to 256.
Requires CAP_NET_ADMIN in a user namespace.

Fixes: 6439461f1618 ("net/sched: sch_codel: clamp default mtu to avoid disabling CoDel")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260819143136.57350-1-jhs@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-34MS.v1.20260925165535@mojatatu.com.2
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_codel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 9e4e9b1a7ed88..31f601beb0f0d 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -231,7 +231,7 @@ static int codel_init(struct Qdisc *sch, struct nlattr *opt,
 	codel_params_init(&q->params);
 	codel_vars_init(&q->vars);
 	codel_stats_init(&q->stats);
-	q->params.mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
+	q->params.mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), 1 << 20);
 
 	if (opt) {
 		int err = codel_change(sch, opt, extack);
-- 
2.53.0



