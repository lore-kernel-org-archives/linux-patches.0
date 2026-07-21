Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1577746D0A1;
	Tue, 21 Jul 2026 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656914; cv=none; b=M96rEAtXF4pufHFDdrBgPCFRaf41uevvs6TXfGoOnpk6fvdcy8K+jGGzKnDVutE+FPQQUGysN5YRBdxbcfEVzHB0yjm2RLFq6YPHrW85jRdqV6VK5LN1xhL91nlvJZgUvSszoSSMwiJ3fPIBPKv2UWsk/0JJEJZcEIJfyscs5O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656914; c=relaxed/simple;
	bh=LEOitH82q8kVwm7kzZZtjRYe89RsH0AZn69CMNdkJLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VblXTbRTmwvzDnG6kCjTRz7mbQm1gj91mGR8SabWWEKYdJqMwtyEA+PYuMLXSZb1k+HKiBKe5nrvm2gNbRmrJt7VHZXFdQ6eZLKDIBL/FchCkjEsfTNpBOWJVbO8WKo5KNo0DjUU0GR4dZJUCyCWw5N0NcN0cX0zhfsqA5OWP7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6uVAWlA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6uVAWlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E681F00A3F;
	Tue, 21 Jul 2026 18:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656913;
	bh=C8sbuaEyxXRl8zoZWBx3age9vCLGbJkKhowbAMjmsA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6uVAWlA+VKiMZeRpzq1Q71JluBV3RiP3sx6XTQWcEstS/eL8+AxEbTpNSzkSbfi0
	 DBSdU7Jqemw9RF8TRL+506LRg6O9TvPUlr5AapLpA8uFjpMwkpPrJEKAJn4SUgs1ka
	 VG9t5IUcG7/H0bQlbDO3Ae94Xut+Llo/DuygV5hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0567/1611] eventpoll: rename ep_remove_safe() back to ep_remove()
Date: Tue, 21 Jul 2026 17:11:23 +0200
Message-ID: <20260721152528.133240833@linuxfoundation.org>
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

[ Upstream commit 0bade234723e40e4937be912e105785d6a51464e ]

The current name is just confusing and doesn't clarify anything.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-4-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 0c4aefe3c2d0 ("eventpoll: Fix epoll_wait() report false negative")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e9e6938f7184ae..399e9487eabbe9 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -910,7 +910,7 @@ static bool ep_remove_epi(struct eventpoll *ep, struct epitem *epi)
 /*
  * ep_remove variant for callers owing an additional reference to the ep
  */
-static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
+static void ep_remove(struct eventpoll *ep, struct epitem *epi)
 {
 	struct file *file __free(fput) = NULL;
 
@@ -961,7 +961,7 @@ static void ep_clear_and_put(struct eventpoll *ep)
 
 	/*
 	 * Walks through the whole tree and try to free each "struct epitem".
-	 * Note that ep_remove_safe() will not remove the epitem in case of a
+	 * Note that ep_remove() will not remove the epitem in case of a
 	 * racing eventpoll_release_file(); the latter will do the removal.
 	 * At this point we are sure no poll callbacks will be lingering around.
 	 * Since we still own a reference to the eventpoll struct, the loop can't
@@ -970,7 +970,7 @@ static void ep_clear_and_put(struct eventpoll *ep)
 	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = next) {
 		next = rb_next(rbp);
 		epi = rb_entry(rbp, struct epitem, rbn);
-		ep_remove_safe(ep, epi);
+		ep_remove(ep, epi);
 		cond_resched();
 	}
 
@@ -1635,21 +1635,21 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 		mutex_unlock(&tep->mtx);
 
 	/*
-	 * ep_remove_safe() calls in the later error paths can't lead to
+	 * ep_remove() calls in the later error paths can't lead to
 	 * ep_free() as the ep file itself still holds an ep reference.
 	 */
 	ep_get(ep);
 
 	/* now check if we've created too many backpaths */
 	if (unlikely(full_check && reverse_path_check())) {
-		ep_remove_safe(ep, epi);
+		ep_remove(ep, epi);
 		return -EINVAL;
 	}
 
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error) {
-			ep_remove_safe(ep, epi);
+			ep_remove(ep, epi);
 			return error;
 		}
 	}
@@ -1673,7 +1673,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
 	 * high memory pressure.
 	 */
 	if (unlikely(!epq.epi)) {
-		ep_remove_safe(ep, epi);
+		ep_remove(ep, epi);
 		return -ENOMEM;
 	}
 
@@ -2380,7 +2380,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 			 * The eventpoll itself is still alive: the refcount
 			 * can't go to zero here.
 			 */
-			ep_remove_safe(ep, epi);
+			ep_remove(ep, epi);
 			error = 0;
 		} else {
 			error = -ENOENT;
-- 
2.53.0



