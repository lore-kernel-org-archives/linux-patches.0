Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015398;
	b=Tej/iC5yHeeYtodthfBJ7qIebsiTmPaPwAtu9w4thcnPWQzq9luFevlRBnwURVUPTOBU
	 LnP/YVLVmnY1bsB++6RI3It2+ibm+v2mebSE6a0HqmoExoljAnaelW5607OjTlMsUi/a4
	 qbaimpC+OwyMHMSyzmIBJwoCK8Ammwra7IunfHXKQfZ5DsTeJ25A5D3TRIj3vDN8y28Qs
	 rqc6aR/YlHUC5FcPqv+Ca2JE946x1ImMa/GjznGH9OWdT2zH6Cy8poJxBX0JdfOGVvneW
	 Bfl1DdV7cpUbmLmanmXBI376JfxrKQ6q+fpB6KXVD5OT8FBAszW9INxHdRnrDcDJUGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ldTDQCPUoJvosnctZucJIZpvKMOwcABtHtlLv76WIAw=;
	b=bE492JgeAvx3CUWy2ld5VmefG1PTZAuxOKSxcq5tflRfItmGQ+9Aj59X8zXADuNiFsWm
	 IgIEfVU/5k1KTZm0uLC2Sk7wSh43FBpaXJAqh/od1u3yPWqrb6Wt1WxZVqK2DN28REcGN
	 LABl3Px/bcPmYA9Ns07ApM9qy68vgs3PKzboEHdZHqJdKWPt1RImes7Eu2DUyuX/Qllqm
	 cGLRJYc2vqEDFUo9JVm83MLY5vrhJJ/sK8wQz4wuPrf4iYA/UTa1NNbxEiMxWcV4oaTSm
	 jJxSGDSAHcu2kCciQR8GaVhEODvI/HFGqZCej48hWFRJHP1R0r7XuYrSfOc0lghUxIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTVyop8R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D20B606A320;
	Wed, 18 Nov 2026 15:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CTVyop8R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8530C1F000C4;
	Wed, 18 Nov 2026 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015398;
	bh=ldTDQCPUoJvosnctZucJIZpvKMOwcABtHtlLv76WIAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CTVyop8RUAaAD2gAKGhDAHtKS7uzq7X0CPlEbqzGTdQfKxwawyLGMCcV3DNzcR3wr
	 gCfS9SS/YddXkWCqWpwUGluX+ZTbMu8YW6C6YzuOinG62hGww0naKYvcVUbYWyvw/8
	 +AJErjlcgoIuEu1lCcl2a5G4BI8fNyDeYs0UVWCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0157/2651] sched_ext/scx_flatcg: Make cgv_node_less() wraparound-safe
Date: Wed, 18 Nov 2026 15:23:17 +0100
Message-ID: <20261118150253.502275689@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 454ebb820c5eb..5e6abd0bccb32 100644
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



