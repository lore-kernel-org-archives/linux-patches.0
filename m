Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015513;
	b=BQNqMxbV9ccuRBZvybiPLe+YT9q9NdQgs9AsgNd4mEn0LlFrHiNpTUAskoAozgcNYz6p
	 2NFxxWKyN8ysFjK/7PBurrG25IcaZV41AQfclUdelaoi61ujhikyByTCBpIg4h8Bu0TBf
	 KNq9tgGAs6gVoP/wIpq0jLsJQqiwXOzYyIxCQX6K65cMAZNLy6IGmVsHzml/9YpNsKC0K
	 F/o0u2F6vw1EUnURQ4MTnSB4fSXjZ+qhDDHQIW7Z7ifYUgWeC50uAVShG9lvF587rw9rK
	 kHPrw6Z2L2bKVRpRTXxN5PjcfkKA6Dhwc87kgDLfl10NyWcXhlLkCvnlba0d6JOJa0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bGX1Kd7krEvJtHvELeqEznr7IW9BX2XiDZ4IxvGJLa0=;
	b=WPszPYeNJiHlyJ+4SPcMoS9y1dU5Br6K3SHjCyTwcDEHaOEssUb+D8wZS68F9Dxz3/aN
	 mxdFwuW+fbudCe99TVqsDBAHu1QVfiIMQEZX7Pb2/ZVQC7xsozBQ0jC/9ac9l32/PeQHO
	 hHQLj7q52k5gr4wXF+nIYCXINrwhOT/OBSantBOOlxn8kHyLSCHxaFz8pDtsrfUGPvRqS
	 9WUOjgaFABBvzqGH2NOlPrd/oXt45MaI++i2h5ZfJ4tu7mv81FoJYvYzJtAI8mjOZuOz6
	 pAiLx7N4TnSl+XjTvFElBHiG1GF1KPEOLYq4hZjHnNwxWtyxK118uQ8vmqgDmmzivng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f98ayGZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBDB606A32C;
	Wed, 18 Nov 2026 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f98ayGZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7261F000C9;
	Wed, 18 Nov 2026 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015513;
	bh=bGX1Kd7krEvJtHvELeqEznr7IW9BX2XiDZ4IxvGJLa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f98ayGZO0MK97d3m1RnxUrldDAg1M4FvrYjIVuqR3xUstT8RZa9+nQCsbAxbBV8aq
	 h37tSkHixsxKt9ZZxC3UJjgB7RzNMRxygy8cesDplvz1Ys5V3Gm3tJ52B7GwOFCIS6
	 7lqvRIrlpLsm6SnOr7W6LRQhgND+exBXNqr1br+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0163/2651] sched: Switch rq->next_class in proxy_reset_donor()
Date: Wed, 18 Nov 2026 15:23:23 +0100
Message-ID: <20261118150253.720417150@linuxfoundation.org>
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

From: John Stultz <jstultz@google.com>

[ Upstream commit 1f880513859336b1d4f9731d3a67d22d0b3b6aad ]

Similar to commit 04f80f8b12a0 ("sched: Switch rq->next_class on
proxy_resched_idle()"), we should also set the rq->next_class
when we call proxy_reset_donor().

Fixes: f13beb010e4a ("sched: Have try_to_wake_up() handle return-migration for PROXY_WAKING case")
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260807035232.1881495-6-jstultz@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c23a190e7de3..174b6b2331744 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3773,6 +3773,7 @@ static inline void proxy_reset_donor(struct rq *rq)
 	WARN_ON_ONCE(rq->donor == rq->curr);
 
 	put_prev_set_next_task(rq, rq->donor, rq->curr);
+	rq->next_class = rq->curr->sched_class;
 	rq_set_donor(rq, rq->curr);
 	zap_balance_callbacks(rq);
 	resched_curr(rq);
-- 
2.53.0



