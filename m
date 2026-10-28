Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213246;
	b=HHNSlPe2p2g9IUL9Jh6t4gra486DmhtmIHaQXKgvivJilOJdqSZZFeRP+xCll+e+PFL0
	 PIsbeXXJBT4ZYjyVPmyl1eq9Rb4mFVnI9QWfC7CtvrHd+Ov/PgE13g2r4U3HKbxeegZkP
	 +Khjv5MOvyb3Y73yM7PUl1Nwe0+/ZBxxM0sb9zX3k3k0zSZ0M/hbd8vOX1mO+SlVyInDW
	 ai3/+IuPYCQU32rDppadVkAuB7HyBVwwhxew6aBn0LAaNcemXPtm7f8A3EQ1Ge39kIeiU
	 jJVvnQ4NrgXZQEtPT3Z9leS8ffrzcxaJI5sM/L8mFxapXWmcD7EBPxvPuuA9ri/1i7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=swfGptWG5z7AgOzFbe5UZPtwcl+CaclDS7vaXTdqe9w=;
	b=VKJKUBOIyEpk0l5JwbcjjUYKCusXA2M/XonJPu1vX+HOvwzanmGaVreS4x9k+DnsnEZA
	 iLDEObbUOcUj+4EFYXrAdr3s5Fhj6djpr0p/PP3KZxBt29LzwwauKS4CF3ET0fYVPYHWQ
	 qhMPJX8GjAwFrm9pPtNa6r2bU8KhlZHefvrTqWidKy5+FgBZ2FLHeX8l/dYfrv0gEXYPj
	 Ju3awM7m9Ndk6bCEercGFuk4IYukSJI992wMzZn0g34AeRmR9L82kykVmbPbS5M2D3w2W
	 z/xbRs9HynYaOQUWlHqapsXiI+FfN5fK9sE33y9KgXqUY6IcGirEUqgbNlmB71ASYSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jm5uqTnq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE1606A31C;
	Wed, 28 Oct 2026 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jm5uqTnq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3C31F01825;
	Wed, 28 Oct 2026 18:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213245;
	bh=swfGptWG5z7AgOzFbe5UZPtwcl+CaclDS7vaXTdqe9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jm5uqTnq5TAbjKtKQxlZ/nUCIxZx4+LQdgS4etOf4t78W25BBQXSsMeuM3qn/eETY
	 ECv6FiGA6zC3EKQ6vaVk5xr5xapxItUcuo6UujySfyDk+nDwP5OaWdh4bGmxJ9anNz
	 3Suq16BOQhbcQMP/rW7HfNEoDjUbGpxxQsnuVVB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.1 0394/1887] wifi: mac80211: shut down RX BA session timer on teardown
Date: Wed, 28 Oct 2026 17:41:30 +0100
Message-ID: <20261028170508.200653585@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit e588e83e5c7a0f6d7a77dbbb58927c8c8cfd598e ]

Tearing down an RX BA session can leave the session timer queued on a
freed tid_rx. Later timer-wheel processing and the timer callback itself
then run against freed memory.

An RX BAR handler can dereference tid_rx under RCU before teardown
unpublishes it and stay in its read-side critical section while teardown
deletes the session timer. The stale handler can then rearm the timer
after timer_delete_sync() returns and before the RCU callback frees
tid_rx.

Use timer_shutdown_sync() so rearm attempts become ineffective once
teardown starts. Keep reorder_timer unchanged: teardown marks the session
removed under reorder_lock and its release path checks that state before
rearming. session_timer has no equivalent guard because
ieee80211_rx_h_ctrl() rearms it before taking reorder_lock.

Fixes: a87f736d942c ("mac80211: use RCU for RX aggregation")
Cc: stable@kernel.org # 5.15+
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: Adapted the timer_delete_sync() replacement to the existing del_timer_sync() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/agg-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 9414d3bbd65f6..acb295bdb71cb 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -103,7 +103,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	if (!tid_rx)
 		return;
 
-	del_timer_sync(&tid_rx->session_timer);
+	timer_shutdown_sync(&tid_rx->session_timer);
 
 	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
 	spin_lock_bh(&tid_rx->reorder_lock);
-- 
2.53.0



