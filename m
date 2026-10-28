Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212678;
	b=b+RyKYpfcX2eGGodh3cVX0ghYQ30xPDzzrdZXP/sfjIDw8X2t9YQemBVgDZhqS8g6cJ3
	 MCo38YcpH5HBSbXGiesXPF21+Thjkz6fw0OvGYgz6hLFJ83flOvYATJN758HFnsvOc+Yj
	 V2HfzwgGwMr8ZgB3dnTO4DdFtRVT+2H29ISvzBqZO32eE0pIBzI8BEpVQYxfHwDV4i9T3
	 Yt03S03uc3UsKPyS4MOaEZhKp7rGEzOCSXwMqsuLVuw5VHimzJ4AaW6Hdkqx5DJDcJC1J
	 11BIPBNqOdusWp7qygb1Qzw7S2pWu5dsND91gjEo/kQcs+shcNYviStQQOSxfW+Xumg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fuAsOZ88uMU8Fnidw6LaubNSpoJ/Qh0wWyR0iCYJMCw=;
	b=p8xatL1ji6zyHNu4db18reOsHWrMpDxnsuDri2SYZf9YanZ3KIi/b7IilKQGur2Znjy8
	 QqdflTawTZPUhZhKJYWqeZP07ie1w4GY9oWllXIrY2fRqJYCXt12L+8sc70gA8GoWe7BR
	 mH9K6yeEpRUBZbz3cqFLDSyWNE+Cj+CpFbkYS+B8jhNQOahHfyFnE2dnNSpGDLMT4V0Qr
	 FhcN/I4uTy2meV94dt1uRqw56yqVYM2iBsN4ZY1jrsH6XjjYeXhoZh1B0dhpaBnVtQlYe
	 o6Ud6+xNso4O5PDgn/kNhvCaQR4gzVzRpb+EUQ4XxORFk+4sFHkMpc4oPoU94kOzNnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYFKDPkM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC423606A320;
	Wed, 28 Oct 2026 18:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYFKDPkM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4969E1F01825;
	Wed, 28 Oct 2026 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212677;
	bh=fuAsOZ88uMU8Fnidw6LaubNSpoJ/Qh0wWyR0iCYJMCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYFKDPkMGQNwyGv0IA0UI8wO00SRPbp3Ah5kvOmg+cMgT4wAWwHhz/Ki4ARDyZ994
	 NNyh8GD6B3UgEkqSHQ9ix0Ey30m18drgLZrPSwVOeyZPS8JZ+T9IeMLStzc1zGZR4B
	 OZpT5GbXlKXmf5NBTGNlhH2UOEX9f8m+2BMeIXBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sashiko (nipa)" <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0237/1887] net/sched: fq_codel: match the no-drop threshold to the packet size
Date: Wed, 28 Oct 2026 17:38:53 +0100
Message-ID: <20261028170504.624811423@linuxfoundation.org>
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

[ Upstream commit d031465acc362866f27e4f8f79cfecf1037fe2e5 ]

commit d9ebd8f9aa8b ("net/sched: fq_codel: clamp default quantum and mtu")
clamped both q->quantum and q->cparams.mtu to [256, FQ_CODEL_QUANTUM_MAX].
The two fields mean different things: quantum is a DRR credit that wants
the 256 floor, but cparams.mtu is the CoDel no-drop threshold
(codel_impl.h "*backlog <= params->mtu"). On a link whose maximum
transmitted packet size is below 256, the floor extends CoDel's
minimum-backlog exemption beyond one packet and delays drop or mark
eligibility by several small packets.

Split the clamp. quantum keeps [256, FQ_CODEL_QUANTUM_MAX]; cparams.mtu
tracks psched_mtu() (the device MTU plus its hard-header length) with
only the upper bound that guards the original overflow (psched_mtu()
wrapping to ~2 GiB on a huge-MTU device).

Conditions to recreate the bug: attach an fq_codel qdisc on a link
whose MTU plus hard_header_len is below 256 (e.g. a CAN interface). At
that MTU the no-drop threshold must equal the device MTU plus its
hard-header length; before this patch it was forced to 256.
Basic Testing done: with dev->mtu=100 and hard_header_len=14, a
return probe on fq_codel_init() observed cparams.mtu change from 256 to 114

Fixes: d9ebd8f9aa8b ("net/sched: fq_codel: clamp default quantum and mtu")
Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260819143136.57350-1-jhs@mojatatu.com
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/QDISC-34MS.v1.20260925165535@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index ac2f643dd8427..08cb94bf5950b 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -503,8 +503,8 @@ static int fq_codel_init(struct Qdisc *sch, struct nlattr *opt,
 	q->flows_cnt = 1024;
 	q->memory_limit = 32 << 20; /* 32 MBytes */
 	q->drop_batch_size = 64;
-	mtu = clamp_t(u32, psched_mtu(qdisc_dev(sch)), 256, FQ_CODEL_QUANTUM_MAX);
-	q->quantum = mtu;
+	mtu = min_t(u32, psched_mtu(qdisc_dev(sch)), FQ_CODEL_QUANTUM_MAX);
+	q->quantum = clamp_t(u32, mtu, 256, FQ_CODEL_QUANTUM_MAX);
 	INIT_LIST_HEAD(&q->new_flows);
 	INIT_LIST_HEAD(&q->old_flows);
 	codel_params_init(&q->cparams);
-- 
2.53.0



