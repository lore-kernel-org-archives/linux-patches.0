Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029019;
	b=F64/zANBx/aPZ5A+Hsi6zfAVw0QK2X3/hIirINaoZysEePIjiMSpZi7gL62tBlYCrVRH
	 rIdfFGCpuOqLUaVlEIRlruIVffcNcyF5NqVwT7tHfOCJTADw64N55ZFq8D8wd4JKHUPFt
	 fAh8Cvkvm3EH88s1J3sEk7UtQhh8wAqwC9uB3zjTjk2phs00yO/Bktlt5ZEJ0+lhrik1i
	 HLmp+iMJbmZm98FGX4eiVsEy5uXkHUyxz3L/btHETUqI8doKr+N5mPzB5q9icjsGzOjS/
	 3LQowIu5KILgaBA8kbOLKSdKnS23VkNuKN2osv7seU076cql9TJSCdzlmqM+fflnrIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=47HMA9l0Zmi4KFNGh5EA3/IMFcYsmxf1s4/4zCEext4=;
	b=mFNQVhkf+sqCJbv6Rxsv60PS0jpeQ2nMpnyYS7274djWSDIFTxjmtyMD24bTL0INNQ6Z
	 /jaIxC1oajHJQaIW3lEVZ7FSwTAX62SrcOFQZ/jxyP7uyza6QZLq8EyitZc8ZZmSaOmZ3
	 w+dprNZYBf2MDav/RjZseBHg7+Bdqz10U7o9VM4Yfof6mMVq9wSLOFtxKq+x4ZonKpLd+
	 nRCtfT+yZbcE2dtt619Q2GW5Ms3FpoDngPR8It8Y8zFfacGyIDOghgX21UpqeoyUi4Cf5
	 8SC7XpqjotwMTDIwlVO7L9igRY5X9iHejnOUpdHmiu6XLT7JwbyNE4JaxJvQAGEd24Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSplncV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4DF606A325;
	Wed, 18 Nov 2026 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSplncV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430DB1F000C4;
	Wed, 18 Nov 2026 19:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029018;
	bh=47HMA9l0Zmi4KFNGh5EA3/IMFcYsmxf1s4/4zCEext4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSplncV1yerNAF4eKvaj3DnUSzSMpLNoQtyQRcIvf2vC0da0zmxeBFEgbJCtLlQ/g
	 xz3bzLyJAbpiayHmKlq00vjJHGwuQ5NVHOAePGKWuiEh+BBoz/AP76TE86Nx1kQa5R
	 eC074XEBkrtvjg9SKwzpbltdt6+Rfq+qzfFvcBWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0199/1756] sched_ext/scx_flatcg: Make cgv_node_less() wraparound-safe
Date: Wed, 18 Nov 2026 15:38:46 +0100
Message-ID: <20261118150016.303451964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index d9cd322210799..ee984a194ab85 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -149,7 +149,7 @@ static bool cgv_node_less(struct bpf_rb_node *a, const struct bpf_rb_node *b)
 	cgc_a = container_of(a, struct cgv_node, rb_node);
 	cgc_b = container_of(b, struct cgv_node, rb_node);
 
-	return cgc_a->cvtime < cgc_b->cvtime;
+	return time_before(cgc_a->cvtime, cgc_b->cvtime);
 }
 
 static struct fcg_cpu_ctx *find_cpu_ctx(void)
-- 
2.53.0



