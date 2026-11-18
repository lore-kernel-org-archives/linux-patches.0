Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022950;
	b=43ePbeE0WqswNbPcXnl4o2cTBvVEoKPvvNwuKz261gPkYddjSiA06bqUju4mjdo/eYAl
	 iwYGTMmQRRSJAuysoqCx/n9vK5qaCjk/LUmuNij+0M3PAiKg/GON+W89fkNzbZf+BKoqZ
	 FRX3tMTfm8/lcZ09GMcCBAEGbrcxIb5pZlPdCokgrxjgFPma76MSyDaSWG78Gqei/2NE0
	 x39/0Kd0GKqiXqb/9sY+kMj3IPmCA4P9jNaVQWt8WV3F9Whtr02rEkCTd9aSCjbXk7xMH
	 hphglS4nog//+VRZqzlYhixN2pfXpHBW3j5HM9yoD6Je1qZuDVByn73zXV6COVc7daA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6R2Np5fAByRmNmqrPxjiSKFAafkF0iSU1IIBRLhOX+I=;
	b=Qg6qX9waN8Xs1+WdgsqPHTdZdprsNyZIOoEKVtmZj7IQx2JpXwHMeNRkBAKKei5l+ZJA
	 V6i1MA7eU8A119Upwcc9pEblphC1YsZa5KsOwauOq2yhi2YbOAfQ2clIMUISwA/yskl+U
	 IA1x0VgrnzFoelN78LvZVgeO7X2STxKBI6+lM+VX8d79H7SFckhesBWtTM6z3yiLLQZKA
	 IEtQOvfrPftXwR2jZWhoTSAMn3rPm/NXMieX1I17dyvjgxujdDqZoGLLk0tx9nkYZ3J24
	 Ou7y5BeY90u5Q5MwZCj7rn05k4IQHjsc2JLvS7nrHy0XiDzFBReQVvBcEAnG0U1sXvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qesRa0vF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A89606B3D7;
	Wed, 18 Nov 2026 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qesRa0vF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E781F000C6;
	Wed, 18 Nov 2026 17:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022950;
	bh=6R2Np5fAByRmNmqrPxjiSKFAafkF0iSU1IIBRLhOX+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qesRa0vF9SzH1oVq5Yv6ujgRaPLx4UfR1+NTcckmF0V21wnyuw+FbITlwu38OEheK
	 69s9UlKVChXK9wscFr/BWKH7aWwVdptYPuC8luDHOsJsyXUOPFLqwEYEDGJkW/5mnl
	 xlCYEuNeSI9/ZXyJfU39gMNrsWt1I5xG2ubllpJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0196/2151] sched_ext/scx_flatcg: Make cgv_node_less() wraparound-safe
Date: Wed, 18 Nov 2026 15:32:11 +0100
Message-ID: <20261118150128.917992251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit bf2f23dc5a36237c0d4738966829e5cbde973c8a ]

cgv_node_less() compares cvtimes with a plain <, which misorders once
cvtime wraps: the wrapped node lands at the front of the tree while
the unwrapped ones get stuck behind it. Each CPU picking a cgroup
charges it a full slice, making wrap occur earlier than a naive
estimate might suggest.

Use time_before() instead. cgrp_cap_budget() bounds the lag behind
cvtime_now, while the lead is bounded by the slice charge plus pending
cvtime_delta on re-insertion, so the cyclic ordering assumptions of
time_before() hold.

Fixes: a4103eacc2ab ("sched_ext: Add a cgroup scheduler which uses flattened hierarchy")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/r/3f1ce004-e259-4e72-a5f7-14a5050053bd@linux.dev
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_flatcg.bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_flatcg.bpf.c b/tools/sched_ext/scx_flatcg.bpf.c
index 3f01441731b7e..a33c6467d7855 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -144,7 +144,7 @@ static bool cgv_node_less(struct bpf_rb_node *a, const struct bpf_rb_node *b)
 	cgc_a = container_of(a, struct cgv_node, rb_node);
 	cgc_b = container_of(b, struct cgv_node, rb_node);
 
-	return cgc_a->cvtime < cgc_b->cvtime;
+	return time_before(cgc_a->cvtime, cgc_b->cvtime);
 }
 
 static struct fcg_cpu_ctx *find_cpu_ctx(void)
-- 
2.53.0



