Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015451;
	b=PHNH+Dg7LAtPZ6rzWb03tbM6PaMFWrkFtGyz5XQWLqwiKLDLPc+xgt/IBewj/IvL6HFm
	 NMWbU9rx4Ntnf1lDK6TA09ELvGquFVnO6mijESqKchw9nUyqpDGeMlb3rZGHYztngOby7
	 FoORQsSNyF3w1vcvQYBZrmEblTqhmcrbY2KAM9kDPYK3WuRyllNWAh6sQMzEjTMDFzvV/
	 SxB+vKAOW7iwmC34vgmOiBzTDQ2GDo/hGSqEca9oWohU51MxUUXnJFymPKwDgTYTrbXU/
	 f7lf8NFH/vIUFCa7ciSc7IorFXRREbkC/M7gaXNr4b7DL/Ma+nQqsjPH1RdBlma03Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1o5X/clf3lcpTF/wfsRG1ghs8FEKKTBCqf4w2o0JB4=;
	b=1fy57uc9oTWtm9aUKgFOfxPN/KrGchwNnDp177Cp3V2aUPElc7dEfj02q1qjCaZjZcgp
	 yFaTYTwU3xu4COjfG6kgAwaqcZC0X+EGHtlaxX0paXUPwYbnVT/SGKMTaqQqtPk/d4t+3
	 xvg+bh9u5hkkBMm7P6nLXJL7czkF2DxDDeQ3sugsIeQbSNyejJ5VnBbXLsjwYjfEkmHaO
	 9xlx0zlPlczKrQidBeMxax00Vbg8VGB8Wn1wSVlX4wodzZmKANSYBF8h3Lh4dFONyXS8v
	 gABrCb46AqXAZQ8dSu0rU3rHq4NYz08AqXas6k0ukPIYL7UW+WBcP3eexBeyHP1Fdrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mF7q/ob9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B363960A2627;
	Wed, 18 Nov 2026 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mF7q/ob9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38751F000C9;
	Wed, 18 Nov 2026 15:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015451;
	bh=U1o5X/clf3lcpTF/wfsRG1ghs8FEKKTBCqf4w2o0JB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mF7q/ob9nsEFdXofRX/OZnybB5HMUVmFyWZnEZ5KcrhpWxLwWENEOm3M3x2gomoci
	 FlYXWnoXK1JcE8SCmzal0gdMdKWJQOLLchNNPGu9pXrVpUgXIJkJ6lUAqOjmjiZoGX
	 MQ2k3fkr6fiYT03+mmi0V52vq8sE+DI3wp88keTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0161/2651] sched/core: Dont steal a proxy-exec donor
Date: Wed, 18 Nov 2026 15:23:21 +0100
Message-ID: <20261118150253.649557349@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit 3dd95f077371f5def65a91c4bb13bd574a62bc3a ]

try_steal_cookie() avoids stealing src->core_pick and src->curr before
moving a task with the same cookie via move_queued_task_locked().

With proxy-exec, src->donor is the current scheduling context and may
differ from src->curr. Stealing it migrates a task that the source rq
still treats as current, leaving src's scheduler state for that task
stale. For CFS this means cfs_rq->curr points at the stolen entity,
and the next pick on the source rq hits the WARN_ON_ONCE in
put_prev_entity().

Commit 7de9d4f94638 ("sched: Start blocked_on chain processing in
find_proxy_task()") tweaked the fair class logic so that the donor task
isn't migrated away while we're running the proxy. Do it similarly for
try_steal_cookie() and skip src->donor as well.

Fixes: 7de9d4f94638 ("sched: Start blocked_on chain processing in find_proxy_task()")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260807035232.1881495-3-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1754d9f95f2cf..f4166e36a8f9e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6517,7 +6517,7 @@ static bool try_steal_cookie(int this, int that)
 		return false;
 
 	do {
-		if (p == src->core_pick || p == src->curr)
+		if (p == src->core_pick || p == src->curr || p == src->donor)
 			goto next;
 
 		if (!is_cpu_allowed(p, this))
-- 
2.53.0



