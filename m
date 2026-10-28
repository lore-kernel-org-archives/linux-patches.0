Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208582;
	b=b2mrGyyUqCgpM3ysPKFSUFZ7uQPhF5dvIRNW2bzXIk6bqG0WmBdmP3ISDZtnfFYKfWbZ
	 x55kCXDtg+w2iHTeWn5m2mIj20By+rtK13kTt5ZZxhizV7/a5kmK+HtTXz7pK3sCTaRzq
	 QO5XcDHJqPr6PMV4YiIOtUdznWb0sj9Rgzxz9QXGWw1ikkAXnbTlYvjGlmyrsEonVFX/D
	 IK5UONfPIJYoIV7q3q2cQUvSWdi4xCFC5qULb1FarhVAsfNe2YbfUE18y1kq6e5HvSHFE
	 3lnvzlbJ6UTZSsgHGMpxnUfTo1BbcF2yM7mSfOPa19vcJtReFLkINPv3p9ZwDCsbmyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cWpmIF34JbqySdyKN8Pv16QgILQu9pgkvU2om5w1sh4=;
	b=q3SsI+m3XqSF1cmJrFiKSA0BJefeBsfaidB5jHtGKglc/udTJN+REBqnVvNYrsM62oDd
	 eNzzow8u9Y3JwVP2Mt7Iw03fL8crVbwEfci7RUjGvc8c8VEwLr26gr+2n5c48Fl8Q3Jyf
	 d0/HsU8/HVZXPm5/cbZYxAeDv9B4fHXrZt/4TnkTrLvWn1+s9tC64Ya/72M23AIexyEml
	 K1DYCbwGcL9HuATsCNW9SNIe+LCNCVnA01kVCMSieHE38C92NgnB5jEDcSIzHAyGTiL4D
	 2zgRIQYrVEXq3b9jRaUEAUfJoOSJ+AtC1VlDBoGGLa/sEIUdbVEtnOpSQAEIqrAzN/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIwspCq7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5357B606A31A;
	Wed, 28 Oct 2026 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PIwspCq7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D571F01825;
	Wed, 28 Oct 2026 17:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208581;
	bh=cWpmIF34JbqySdyKN8Pv16QgILQu9pgkvU2om5w1sh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIwspCq7arxnZ2X0uUYbTzQFTCx3vxGRz+OOGPU7Zb/NI+myTYS4J0t4YrGXU/3dh
	 2YXUff6RsssIqsUFAOoI8uoyJQP8w0eStP78R9yzSStKrQhRa3y9FH18Y+zbJkAS2l
	 lYi5ikNc4P7utQMoyZIljAcXYBMNQHm+ya/4jZnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/516] net/sched: sch_codel: match the no-drop threshold to the packet size
Date: Wed, 28 Oct 2026 17:55:22 +0100
Message-ID: <20261028170007.533409714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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



