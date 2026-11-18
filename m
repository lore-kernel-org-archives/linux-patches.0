Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015482;
	b=07iI6MhWANX4VrfYP8Y9xPAZ827u/1qIKrI9yJowuOaO2ZJLrkwZanIlOJmxmZMdV+pF
	 K3772Gm2tVHzz7/Km7oIJ+42mkM4aTOpxwEruwtkLUqOSjT8Uj/1HcxM1z2dlKqxMbRdu
	 oAuanKDwbobP9RQMbFbzUs+XYBBSCrD6lSzQeMwiRhF1njUZdgHN1dxxpG0gZZMtdm3/m
	 Xzq1gtp0Wc+zv9mI0n5XMQQlG4Wb5QtFDIJWI0akLqU6qLJaPDNtdrkNOGwACVsYBZPz5
	 fSostz/j3PtWiwxesLEkRu5LKn4mvdKDCTxHZFTRf3ubvnF4gkE/m8Ubvim4y6IRYMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4HfkDw5EHoEkwyGVCm7et8gFUU2aYsBnCpEj3lTidnc=;
	b=XIR0Jn7GvpcXJDlXHJ+YlQ1glmFicRi4lWNOiwOdoZBINcCDzsto6iFGEDrC8wv0xCOh
	 XFfvv0BmimceMHT1ONb9cv2DdwB4oqa1LCpPMrFxgN3mnvpTxXMhzXdbkxa5vf4MpBkcq
	 jWQJgAFk2ipgUEsW/42ZSGj6apkRPcVz1RQlzqQcT5KQN9IONZojgCswUWsFST0CdGCqf
	 4t1h+TZ/kp3AA9UU0fYy9qiG6K6ZqCILTmmdqCKBcvo7vLphvNBA8MQmimCgWZG4sGUsA
	 hL/mPtYB1qEdeswmoWVIum22X2A66RdlTZCbJpnzKAHkHdG8QdRlXfG5fgIZvEZMLkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ERpvTY4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCEC606A32A;
	Wed, 18 Nov 2026 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ERpvTY4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767A91F000C4;
	Wed, 18 Nov 2026 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015482;
	bh=4HfkDw5EHoEkwyGVCm7et8gFUU2aYsBnCpEj3lTidnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERpvTY4KXtOwPKwyZUhH3fWhIcDnLLw7MvAgNMQwnSDxvNjVCa1YI8+kQZ8b1WUf2
	 bkpYRTzibnGaHcToz6QIKPmCdNxCaTSaf1YFM4KcqLxPHStW1AtOlPb5cWj4PGmxl0
	 attHyQ/J/kGQmrE5uDKY8+uQIdQUwhqDfJOXXqZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0162/2651] sched/core: Dont proxy-exec unmatched cookie lock owners
Date: Wed, 18 Nov 2026 15:23:22 +0100
Message-ID: <20261118150253.687169754@linuxfoundation.org>
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

[ Upstream commit 09351db90a28ee6a82dc873609edfde02da5415d ]

Core scheduling chooses a core-wide cookie before __schedule()
installs the next task. With proxy-exec enabled, that task becomes the
donor/scheduling context, and find_proxy_task() may then replace the
execution context with the runnable mutex owner. If its cookie differs
from the selected core cookie, running it would bypass core scheduling's
cookie selection.

When the final mutex owner found by find_proxy_task() does not match the
selected core cookie, stop proxying the donor. If the current execution
context is already in the blocked chain, fall back to idle like the
existing proxy-exec retry paths do. Otherwise deactivate the donor and
let __schedule() pick again. The mutex owner can be picked later under
its own cookie.

Fixes: 7de9d4f94638 ("sched: Start blocked_on chain processing in find_proxy_task()")
[jstultz: Added tweak to ensure we deactivate donor, not runnable owner]
Reported-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/10282ce9-f4ae-498f-9b57-f4e1e61fffbc@amd.com/
Link: https://patch.msgid.link/20260807035232.1881495-5-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f4166e36a8f9e..9c23a190e7de3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7051,6 +7051,14 @@ find_proxy_task(struct rq *rq, struct task_struct *donor, struct rq_flags *rf)
 		owner->blocked_donor = p;
 	}
 	WARN_ON_ONCE(owner && !owner->on_rq);
+
+	if (owner && !sched_cpu_cookie_match(rq, owner)) {
+		if (curr_in_chain)
+			return proxy_resched_idle(rq);
+		p = donor; /* Deactivate the donor, not the runnable owner */
+		clear_task_blocked_on(p, NULL);
+		goto deactivate;
+	}
 	return owner;
 
 deactivate:
-- 
2.53.0



