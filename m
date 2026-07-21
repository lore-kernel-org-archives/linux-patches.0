Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA6E35DA40;
	Tue, 21 Jul 2026 19:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662343; cv=none; b=KMCMwF58FJpMIvUZdokjnBgiHAMhbVo5ikRJbkltm6z6LWrnpxk60vP0svLfqFB7MdEOq3xoYz8JhibCuKY5cex9wxleW4pPro2u0d7Yd3udzBhQ5qv1MapecNa7dvBx4qeWSOsqpV85TopYk3EOoej+JgaVjQ4ESyCnzMYj7UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662343; c=relaxed/simple;
	bh=LCaeQfkyQEWzJklz/SvMSrS0F2zXyB3uuTm3MuxMOWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amE+9oW6gNeddPtU0Jup2fNaPVxRmjtOyfdKUbjfZWGRcGmt0z7OjsHNiLY4kT4QATk77EK/AC4cmcNZ9LCYHcD2LH3cfVvKvyqDsX9rZ9o9PoMsK3hXfb00eqRX3zQMy2ofFzDrR0J3jux1FJZowFo+2AoRVkpa7sz2zFCRuCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBPuoxXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBPuoxXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50DE1F000E9;
	Tue, 21 Jul 2026 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662341;
	bh=4n+4+AOWg4Q1iQcpRt8GF5hMCSDVwmVlFLUBfUFq8H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBPuoxXOHhwnbrj4bCUTbIiHS2rJbVIjzcRMVa7trxnQ70Nba7LKzPwlYNtOf2Y3j
	 DmUPBGCgq+BNQo6AdMxhExRa36NdE4pTx5IP1KW+U9izrG/GWG6FlMhAZr5VHrbUu2
	 9mLoFRdMWLyIdkXZSgHqKmLaK9QzpfwJvsBjvEMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0406/1276] eventpoll: rename attach_epitem() to ep_attach_file()
Date: Tue, 21 Jul 2026 17:14:09 +0200
Message-ID: <20260721152455.183877419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6a3f1a494bc91d7976cf0d2b200bb3f1a22eef64 ]

ep_remove_file() tears down the f_ep linkage that attach_epitem()
establishes, so the pair should look like one. Rename to
ep_attach_file() for the "ep_*" + subject symmetry and to match the
naming used elsewhere in the file (ep_insert, ep_modify, ep_remove,
ep_remove_file, ep_remove_epi, ep_unregister_pollwait).

Pure rename; no functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260424-work-epoll-rework-v1-8-249ed00a20f3@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 0c4aefe3c2d0 ("eventpoll: Fix epoll_wait() report false negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index b92cc8a1161ef2..8fdcae75e039ed 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1640,7 +1640,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 	wakeup_source_unregister(ws);
 }
 
-static int attach_epitem(struct file *file, struct epitem *epi)
+static int ep_attach_file(struct file *file, struct epitem *epi)
 {
 	struct epitems_head *to_free = NULL;
 	struct hlist_head *head = NULL;
@@ -1711,7 +1711,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	if (tep)
 		mutex_lock_nested(&tep->mtx, 1);
 	/* Add the current item to the list of active epoll hook for this file */
-	if (unlikely(attach_epitem(tfile, epi) < 0)) {
+	if (unlikely(ep_attach_file(tfile, epi) < 0)) {
 		if (tep)
 			mutex_unlock(&tep->mtx);
 		kmem_cache_free(epi_cache, epi);
-- 
2.53.0



