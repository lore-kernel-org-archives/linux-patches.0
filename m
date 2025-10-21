Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD859274B2A;
	Tue, 21 Oct 2025 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076386; cv=none; b=oUu3eNxTL2l2XaG6UyTZpJi8idU9qCcdsEsSsEn6Y+WTE/wmc4cbP2hLMT0UlfPPku6sJ3u+GvGwd0Kqbec8xgiKBzMkDJ0KmS1jIljViw7eITW8PQDN3kN0VKmQJaXiWSwTE+nxamlWcHvrmQASsXyg5/F1CxFOi2xPG1wdtoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076386; c=relaxed/simple;
	bh=ALMSmygY5WLndd/HytDf7LXS/kgVfHOKdcY4NsWlpwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+hf/GzVZtLXB4f7jzQE5VPHg8neAtNrGmPiLFSQ40Hn6HYde8dKGhNvUD1pV23kWLonaulW9PkIerdrgRjUVoRZfYgfUH2rp1EvX30VgaBx0YteT5zlmELkWiZ//8c4+rMThzgXgvLlSqSwEImSzlSWTTZoMThjzp+qhemv3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqI2hGU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqI2hGU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1407FC4CEF5;
	Tue, 21 Oct 2025 19:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076386;
	bh=ALMSmygY5WLndd/HytDf7LXS/kgVfHOKdcY4NsWlpwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqI2hGU1yXWdw6rPFs4wlK9WC+usWBUzih0BX6KQ00xotQFIkV4gi10JEBMxF/+oY
	 6vqCZ2spVQ9UCC+z7Fysd0kSUmIA7sPMdE/of/By2vj1d4FOOXBURzXcofgLOTnsoB
	 /wKbwADPbf0QHtYoj38BwvwJDWPxgKR9Lz90u92k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Xiaojia <huangxiaojia2@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/105] epoll: Remove ep_scan_ready_list() in comments
Date: Tue, 21 Oct 2025 21:50:28 +0200
Message-ID: <20251021195021.949558008@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Xiaojia <huangxiaojia2@huawei.com>

[ Upstream commit e6f7958042a7b1dc9a4dfc19fca74217bc0c4865 ]

Since commit 443f1a042233 ("lift the calls of ep_send_events_proc()
into the callers"), ep_scan_ready_list() has been removed.
But there are still several in comments. All of them should
be replaced with other caller functions.

Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
Link: https://lore.kernel.org/r/20240206014353.4191262-1-huangxiaojia2@huawei.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0c43094f8cc9 ("eventpoll: Replace rwlock with spinlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -206,7 +206,7 @@ struct eventpoll {
 	 */
 	struct epitem *ovflist;
 
-	/* wakeup_source used when ep_scan_ready_list is running */
+	/* wakeup_source used when ep_send_events or __ep_eventpoll_poll is running */
 	struct wakeup_source *ws;
 
 	/* The user that created the eventpoll descriptor */
@@ -1190,7 +1190,7 @@ static inline bool chain_epi_lockless(st
  * This callback takes a read lock in order not to contend with concurrent
  * events from another file descriptor, thus all modifications to ->rdllist
  * or ->ovflist are lockless.  Read lock is paired with the write lock from
- * ep_scan_ready_list(), which stops all list modifications and guarantees
+ * ep_start/done_scan(), which stops all list modifications and guarantees
  * that lists state is seen correctly.
  *
  * Another thing worth to mention is that ep_poll_callback() can be called
@@ -1792,7 +1792,7 @@ static int ep_send_events(struct eventpo
 			 * availability. At this point, no one can insert
 			 * into ep->rdllist besides us. The epoll_ctl()
 			 * callers are locked out by
-			 * ep_scan_ready_list() holding "mtx" and the
+			 * ep_send_events() holding "mtx" and the
 			 * poll callback will queue them in ep->ovflist.
 			 */
 			list_add_tail(&epi->rdllink, &ep->rdllist);
@@ -1945,7 +1945,7 @@ static int ep_poll(struct eventpoll *ep,
 		__set_current_state(TASK_INTERRUPTIBLE);
 
 		/*
-		 * Do the final check under the lock. ep_scan_ready_list()
+		 * Do the final check under the lock. ep_start/done_scan()
 		 * plays with two lists (->rdllist and ->ovflist) and there
 		 * is always a race when both lists are empty for short
 		 * period of time although events are pending, so lock is


