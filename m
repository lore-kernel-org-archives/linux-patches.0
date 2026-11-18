Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022655;
	b=H7w3fDhVU5xKyYF8o4Qci+jZHT0a8ZzHIyILbhpAjW5ltlXZe9a4KEBUUAL+U1HLOUxg
	 Z2VbmxzDy06cV8BeD5l9OsF4BNchhC3fsZpQPXGGVb1oJt2VI0v2InRJLoTVQAq7GJJvA
	 p8DvKWGLG1d+cSiSgaTjBwv4/g0Y9kQut7fA00VgE7Ki/0THWawLrQ/g9aF9zVuC8tMy6
	 4li560/4Ga91Z7ki/yJvwKNaQBBW7EAC/l6cTqDwDzKBJHBzRCqVbHVlcJOLBdHvCHA5k
	 53mSgpd00OeNUtPNmyTXTMx4E1+5EPDtTozz1ScKlaaI7jehKRqoU4/5s+YwwJB7WCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cvWyviqn9Q+AL98YLPykP8dCe92qz2MJzL5G5PTCVH8=;
	b=dYwT2PIU0yVjbAO92muJFUkqj98JdDNoAPWV6xB0FKMpSykXBhqiNuYjrrVDJGsqf5Nv
	 ADgeCQZHHb9IQcIcnMjR200EFODuEPP/ClTbRShGp0GG3RDHxokX+E56EY4jmTaKIHmNs
	 gGG0h0KBGXJjCXFlzUwh9dBHAsR2IYDColbuxhnHfh3188+S0jsB0u7c0hzDva3p6ufbd
	 t9fOgvtb5S1Y6cupndPV+OlmdfMaKpwZTDE2Cd5xtMgWe9tfcH3ARjn0GPTJjUytYNEXa
	 oLLGUx8usjZXFwcXmdaWMEMY865A24unYAnfkKBAiATR5aNcXKULdaiOlj9zLffs9+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmWxCP10;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87396606A334;
	Wed, 18 Nov 2026 17:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UmWxCP10
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4B21F000C4;
	Wed, 18 Nov 2026 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022655;
	bh=cvWyviqn9Q+AL98YLPykP8dCe92qz2MJzL5G5PTCVH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmWxCP10l1huuIUHt4XnO/F216MYwKdU5ud0aWFqQnjDc5UcT8Uix/1Q2z3BbSQ2e
	 uS9gsydOiqIIjKuxaicK1zUPhBEvDVSE0th+62o7aRpMtit6eueJ9BCtgs4xg6dxxH
	 lZiFs3ib2lNSrKCknrCnrjK7RT8jR+XVKIV2JqRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0088/2151] sched: Re-arrange the {EN,DE}QUEUE flags
Date: Wed, 18 Nov 2026 15:30:23 +0100
Message-ID: <20261118150125.006433943@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 376f8963bbda5fee838eb1823b07562368104024 ]

Ensure the matched flags are in the low word while the unmatched flags
go into the second word.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Stable-dep-of: c282051fc2ca ("sched/fair: Clear throttle state when leaving the fair class")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/sched.h | 45 +++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 0f29def72877b..2e0604b3a337f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2377,27 +2377,30 @@ extern const u32		sched_prio_to_wmult[40];
  *
  */
 
-#define DEQUEUE_SLEEP		0x01 /* Matches ENQUEUE_WAKEUP */
-#define DEQUEUE_SAVE		0x02 /* Matches ENQUEUE_RESTORE */
-#define DEQUEUE_MOVE		0x04 /* Matches ENQUEUE_MOVE */
-#define DEQUEUE_NOCLOCK		0x08 /* Matches ENQUEUE_NOCLOCK */
-#define DEQUEUE_SPECIAL		0x10
-#define DEQUEUE_MIGRATING	0x100 /* Matches ENQUEUE_MIGRATING */
-#define DEQUEUE_DELAYED		0x200 /* Matches ENQUEUE_DELAYED */
-#define DEQUEUE_THROTTLE	0x800
-
-#define ENQUEUE_WAKEUP		0x01
-#define ENQUEUE_RESTORE		0x02
-#define ENQUEUE_MOVE		0x04
-#define ENQUEUE_NOCLOCK		0x08
-
-#define ENQUEUE_HEAD		0x10
-#define ENQUEUE_REPLENISH	0x20
-#define ENQUEUE_MIGRATED	0x40
-#define ENQUEUE_INITIAL		0x80
-#define ENQUEUE_MIGRATING	0x100
-#define ENQUEUE_DELAYED		0x200
-#define ENQUEUE_RQ_SELECTED	0x400
+#define DEQUEUE_SLEEP		0x0001 /* Matches ENQUEUE_WAKEUP */
+#define DEQUEUE_SAVE		0x0002 /* Matches ENQUEUE_RESTORE */
+#define DEQUEUE_MOVE		0x0004 /* Matches ENQUEUE_MOVE */
+#define DEQUEUE_NOCLOCK		0x0008 /* Matches ENQUEUE_NOCLOCK */
+
+#define DEQUEUE_MIGRATING	0x0010 /* Matches ENQUEUE_MIGRATING */
+#define DEQUEUE_DELAYED		0x0020 /* Matches ENQUEUE_DELAYED */
+
+#define DEQUEUE_SPECIAL		0x00010000
+#define DEQUEUE_THROTTLE	0x00020000
+
+#define ENQUEUE_WAKEUP		0x0001
+#define ENQUEUE_RESTORE		0x0002
+#define ENQUEUE_MOVE		0x0004
+#define ENQUEUE_NOCLOCK		0x0008
+
+#define ENQUEUE_MIGRATING	0x0010
+#define ENQUEUE_DELAYED		0x0020
+
+#define ENQUEUE_HEAD		0x00010000
+#define ENQUEUE_REPLENISH	0x00020000
+#define ENQUEUE_MIGRATED	0x00040000
+#define ENQUEUE_INITIAL		0x00080000
+#define ENQUEUE_RQ_SELECTED	0x00100000
 
 #define RETRY_TASK		((void *)-1UL)
 
-- 
2.53.0



