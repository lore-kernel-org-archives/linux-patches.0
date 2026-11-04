Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831001;
	b=L4NsaRtyJWYV1whmAR8ATWiS1atMDk9Bs+YWvVa37XAsWfoq3dPWvjnQz7tJdbAiM03L
	 XirJ50fsTrHIUgGch0DvnJD+cld+Rg8MmD1fZN6/zBsFwtLsW3kxOIRmX6Tb4vKJgK/fo
	 qJlWvR0l4P50C93nMl6Uii7ABnG/hSQqe0lbi5qmhYK/04VCqctyCNilsH0yuARpb+yFB
	 x8YLAq9fIBxNLWuQMjK+ZVezs9vEmPSi69dfU40GFvTLjxTHwcrREUMPFZGgfHxm0euag
	 u0ofXaIE+BULLjz6PVukj9jMEl9jqoT1iD7Qc9O607wTjApzrGZ2UytojXXz3K56C7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S42+gDDAL1fa7RxJ1EPz82cI42v1IoJaE1xh0wCW1Uc=;
	b=GBlsdbU90gQ3bFS0yHcQ3WQe6al9r0OQ4J5VSYq+F5X9fXdYEP51ifmBRekq17fiwppI
	 JssCVeDLqd0UTsgIilVlUpIIL/oonLhvLfZrHY+8oiKt+V+J2yxHqKovFqWuBarfV+G8V
	 eDXd7blEz9lDnprU9Vf3y3OR3Ozy0Sf+QclYxfuOEHKLtenYYtu4s5I9IZelql45u2Ost
	 BTh2JO9reOQigeWDt5AuPemCwKkeXQsUKAS2xtPTg2pvq1XgsXsywKI4r67YaxOQE9+7b
	 Ul49Dxsvbc9vNyFquGa62xo7zovy1EvqRcye87D0YA/kRvOG3zXF+sc2wrvnt5G0ASw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1w5PK3CQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ADD606AB06;
	Wed,  4 Nov 2026 22:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1w5PK3CQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906BB1F00A02;
	Wed,  4 Nov 2026 22:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831000;
	bh=S42+gDDAL1fa7RxJ1EPz82cI42v1IoJaE1xh0wCW1Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1w5PK3CQhW3/GEcbik9aRT/jmEch49P/5TvN0yDufwj9l51ufuZSzExuiactWpfq6
	 Ntc8963Xs/HhJEHx2Govdge2vLcoN1SDUQ8WA54jhMs6nM2HVzM7KGrMYoyks6q5ql
	 VdKOrR0yfa4SpeeWhxuEkaZtfQ2IsPMhDHlwqinE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0449/1005] sched_ext/scx_flatcg: expire cached hweights on weight changes
Date: Wed,  4 Nov 2026 16:03:02 -0500
Message-ID: <20261104211056.630818546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 94c20e1fb334c2082b443c4470a86ad982f67282 ]

fcg_cgroup_set_weight() updates cgc->weight and the parent's
child_weight_sum but doesn't bump hweight_gen, so the hweights cached by
cgrp_refresh_hweight() stay stale until some task activation bumps the
generation. For cgroups whose tasks never go through a 0->n runnable
transition (e.g. persistently busy ones), a cpu.weight change never
propagates to scheduling at all.

Bump hweight_gen on weight changes so the next refresh recomputes with
the new weight.

Verified on a flatcg VM: a live cpu.weight 100->800 change on a busy
cgroup leaves HWT update at 0 and the distribution unchanged; with it,
hweight_gen increments and the refresh recomputes.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_flatcg.bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/sched_ext/scx_flatcg.bpf.c b/tools/sched_ext/scx_flatcg.bpf.c
index d1fc6cb8206c0..3f01441731b7e 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -605,6 +605,9 @@ void BPF_STRUCT_OPS(fcg_cgroup_set_weight, struct cgroup *cgrp, u32 weight)
 		pcgc->child_weight_sum += (s64)weight - cgc->weight;
 	cgc->weight = weight;
 	bpf_spin_unlock(&cgv_tree_lock);
+
+	/* expire cached hweights so the new weight propagates */
+	__sync_fetch_and_add(&hweight_gen, 1);
 }
 
 static bool try_pick_next_cgroup(u64 *cgidp)
-- 
2.53.0



