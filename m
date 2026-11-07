Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061097;
	b=OCsjYI11AdBLM2djITsudclH9KOvPUslBxgAL4ucdfZKXVSTJYuqe8TOdak1JIIiP+rY
	 DAvWWNRdl/nzG8zXmRnHLVY/sdgq+8OlIQgD+o+JTeOxk8sKOPjW9x2+qgDAH31DCGYM5
	 oFvKKnGNqX3k3Di7YLvlSNMNPiszV0lYW6eFGSpIAsAk6x2jayIC39UtFhRe+ZlZ4D5a2
	 C9KaAozXMvrqx6tScut/J8ei+4yhQWDgtpp74y22nZR14Tj/ehI6o088Jcy19WW1ulskH
	 Ch3otblABM2IpQhOksoEPeYK5YF6Y0rrSXGd1eE8FwCHrlArhJ79yi3GnT4FyIxo4ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qURZPpFr78LVU6wb5nyoX3EdNgA2OGoAGi4Z5TWWgs0=;
	b=cZi5npL4mW2wweinTuK66athUP4aJGLZYxPhMPArjCAtyezLb55TQbfnYSjmGOrHzc5c
	 KfOd+UzV4w2WmFnivn+Z4Lx5qmcPd4+sqy7rzG4uZAXTdaS5Rm+ceNetgMwXb1eQpjLSO
	 QgccLnLD5ZNDVuYzcahM8SsxJU1ji3lz7PCJx5A5MQ+d32PT+uulCNFwpmWtJDi79s3DX
	 AXN6LPzCgGzWBfP09w1HsFIUx57Rp2NN4WJ9ajeHnAukVUd3FNLOtQSKyTmwqAocCO3bL
	 KXNsMYutM8xXAfxJOsv14f/ZzNKn3n8pyq1G2SEhRiMi4cM5eRDvO9K6cvfDdstw35A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="acgJrvV/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B2C606D837;
	Sat,  7 Nov 2026 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=acgJrvV/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E541F008A1;
	Sat,  7 Nov 2026 14:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061097;
	bh=qURZPpFr78LVU6wb5nyoX3EdNgA2OGoAGi4Z5TWWgs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=acgJrvV/+A452Vqpddkbar1dx/YBz9KYOfuviDY9J7c0z+freeDl96B5iwc6Xd4Il
	 bb1Ydm8Mu34SQY5ayN9fm5Z0skl3DtA9/ATJ+UPHoRjw2sC/2WseArbuNB0HBFHUV9
	 DWOBEcBgD7g1CFtZW1ryA4n1GI/0AzHRcdakx3vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0378/1536] sched_ext/scx_flatcg: expire cached hweights on weight changes
Date: Sat,  7 Nov 2026 08:39:54 -0500
Message-ID: <20261107135008.245050605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 05e3b4495ac5c..d9cd322210799 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -606,6 +606,9 @@ void BPF_STRUCT_OPS(fcg_cgroup_set_weight, struct cgroup *cgrp, u32 weight)
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



