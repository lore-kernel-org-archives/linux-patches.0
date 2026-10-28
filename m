Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212681;
	b=C4W37YppHGKhK6s9WihJvoHHs7y+WmrWze+12+9V0TT3zadcqnTr8r0qJraNSAviFInO
	 mizaqtLByqnng/rN4VR1waCf2UBsJ1lwyOd2PdNe6jE5yQeWp5VGtelFwkZVyrqU5rs5X
	 h5191zEPK1Nrp5/7JWJGFThn6Qrev1P/F72ikGkJp+17tlN2+SQJn8ltpwyhJw+vXh8Qd
	 qlqst1rk6n12Zw48Tc3nfmZJ7vESSEhRq/KVJOGT+ay2qZGJYblrtNIiYKRL0JEyFmUqR
	 mX5t8PF9qKAlYw4tJYjTFIRjEDBZFtAiNal5JlRztm+49JssgwqVwuxro+86BCqAmDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vK1fUGCq978zt4HOSonDSRxmC0u3DxBf9jLPq96ng8M=;
	b=PqSvwSwi5iSZ+yzjY6l909OTzT0hTBrTv8Mi4I7v6dvVly45dSFGLlySu3Ucmz2xMsfn
	 m3zc6jlmudTjcoHCigcrXtdoZ5yFT6dQ3NgbxI5f5PGdFGCbWQzZZ4m0j6JtekSDRpCdb
	 9kzh+FALkEmOeFqPH1YSbZqT9FVvDEbuWz+UpfXh7sa1QGqn7cltag9rlkNyw2jNF8z0F
	 YUF4CKVopEqOuHZxyWht2Q4Mihep7GMbusUvKe+F2Tjrkr7IFeYtn2Unh+v8hJy8BoKlk
	 89WWGs43iTY1z404T9mn0ePhkj1s7z/4oRDiLfemPpvmhdwAKQT6kgeZ1c1Nw5Q63QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cs994xpN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90D3606A32C;
	Wed, 28 Oct 2026 18:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cs994xpN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237671F01825;
	Wed, 28 Oct 2026 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212680;
	bh=vK1fUGCq978zt4HOSonDSRxmC0u3DxBf9jLPq96ng8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cs994xpNxYWWnVk8nfYTNdlndgk1xXwFjnQcS0CWinGNeq/RGgSdHkPOsN11l9DDP
	 Dip9GxZXjcrDd0m4DWiy74Eg+9ld4kHeynz/Fdu9UKQweBpk30e8XywMa9VwuOTJUw
	 4awJKe9Tb+SNRDiGNK3Q0De/lUW/ycwI/Xs9Kicg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0238/1887] net/sched: sch_codel: match the no-drop threshold to the packet size
Date: Wed, 28 Oct 2026 17:38:54 +0100
Message-ID: <20261028170504.648949431@linuxfoundation.org>
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
index c05be1eeea566..1f30dc76d20c7 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -228,7 +228,7 @@ static int codel_init(struct Qdisc *sch, struct nlattr *opt,
 	codel_params_init(&q->params);
 	codel_vars_init(&q->vars);
 	codel_stats_init(&q->stats);
-	q->params.mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, 1 << 20);
+	q->params.mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), 1 << 20);
 
 	if (opt) {
 		int err = codel_change(sch, opt, extack);
-- 
2.53.0



