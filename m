Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B92F46D090;
	Tue, 21 Jul 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656919; cv=none; b=OfCshg4GAkMhI/XDfNCCcPAQS8C4BzF7bVXHG3nNiD7vN5cKeWipwy3w5vtYXdH+JmQlA3KOTEL5nD8U91QU+yCfnIaWwWonP6OdvSJVeLkvwA2yxZoQIN2BSZMTktNK7mhX5QUY68eRQhz8kyOj+cHowC5OQDebkV5BQ7HfAyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656919; c=relaxed/simple;
	bh=cHJsZtmOtO3DYtRbWHpbjz6fNCics30K2H4F1VUUAJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q82sY91GJu9ZA0rJiLzBvJ3xB7H7qwUwSrDntQRjVQydTccAtOVXQep5tIWyF1QQr3yYJUkMctvQvS9DBHaSqw/+P2FfK9S9SyVndi4E6uC5w9gRxxHixJvOwMjEOGpmiiIv4HVBtpXyll8HjkQBJKmzKfnqwNYJL5m/uxktqq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vXS1GjC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vXS1GjC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB70B1F00A3A;
	Tue, 21 Jul 2026 18:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656918;
	bh=ZZy0N2XqbWVGRmm3GP8y7XnDu7VKFZKq6Uq5HJLy7t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vXS1GjC0lpIPO4VfdRsi/2o1PzR2jw5DQH0cL6ETEhZVssd2qJRLQoslw7QK+at/
	 BkUxqtS/Rw8MP17xA9ob5mhyKA2QGHrOkEVbV3JYOn8YJGD15wvQ75sZHVo8V0rE8N
	 csbvKMovQZXc3yt86jBEdLNxGsTYZeFP+33iQ/co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0569/1611] eventpoll: rename attach_epitem() to ep_attach_file()
Date: Tue, 21 Jul 2026 17:11:25 +0200
Message-ID: <20260721152528.177641403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bcad90e1f48a04..c326577669ae4d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1669,7 +1669,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 	wakeup_source_unregister(ws);
 }
 
-static int attach_epitem(struct file *file, struct epitem *epi)
+static int ep_attach_file(struct file *file, struct epitem *epi)
 {
 	struct epitems_head *to_free = NULL;
 	struct hlist_head *head = NULL;
@@ -1740,7 +1740,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
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



