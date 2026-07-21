Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63572448D03;
	Tue, 21 Jul 2026 21:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668093; cv=none; b=E0+ItlDK8XgtlEesUH88IiiMnkRVv8dLt49YKyCLhMKHE6DMtpqFaan7NrDLuWuNaAWfhWw7FvEybY3o8SSTVcH4t+hsZXNvuhJiOQiTAJq52iNiCgZjRHv62PmDlUAt2Pd7lcD9bLjGav0wB4KUt1+dV4jQ7nTQTQ4a/Dbi/hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668093; c=relaxed/simple;
	bh=ygisRYkrN2IpHhW2zcqGKOSfmt8LI0YBL2hyjgKFbO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcmH9S7txFvv5IR/yCYTy4GAA/bwPNcTM6ZoFsWNxwMZ1apY0eqtRT9YvULXvd3HF2ZsG7sjoYqv4vgmiom7gsdv9wLGP5WS69CIoTdCfWz1UD6geoLAVjrZI8kitMW/w4rI7T/2fKRUkK0/eF3QNfw0HggOyagq6c7A6EvNXzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQThdzoY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQThdzoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FD21F000E9;
	Tue, 21 Jul 2026 21:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668092;
	bh=/ZG1OiIOfu222EzRmjho7D5wQnRSWQsng5pa8ahZA0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQThdzoY20b8+sV9PYD6kk5jN7EcP8Axm9Lqy1EqAmcln//xcud8shD5OuQfmsScg
	 MVAz4j2p02HuT8iv7UZGMPTFyMCpGbg5liwWs0FyupwEoZuJNQz1mCo9SXEcpLo3So
	 Bg567x1QQzW9EU1XvPEy4JkyE7g/xCjojdXsGiMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	carnil@debian.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Wentao Guan <guanwentao@uniontech.com>
Subject: [PATCH 6.1 0044/1067] eventpoll: rename ep_remove_safe() back to ep_remove()
Date: Tue, 21 Jul 2026 17:10:45 +0200
Message-ID: <20260721152425.544881301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 0bade234723e40e4937be912e105785d6a51464e ]

The current name is just confusing and doesn't clarify anything.

Link: https://patch.msgid.link/20260423-work-epoll-uaf-v1-4-2470f9eec0f5@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: a6dc643c6931 ("eventpoll: fix ep_remove struct eventpoll / struct file UAF")
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/eventpoll.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -771,7 +771,7 @@ static bool ep_remove_epi(struct eventpo
 /*
  * ep_remove variant for callers owing an additional reference to the ep
  */
-static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
+static void ep_remove(struct eventpoll *ep, struct epitem *epi)
 {
 	struct file *file = epi->ffd.file;
 
@@ -818,7 +818,7 @@ static void ep_clear_and_put(struct even
 
 	/*
 	 * Walks through the whole tree and try to free each "struct epitem".
-	 * Note that ep_remove_safe() will not remove the epitem in case of a
+	 * Note that ep_remove() will not remove the epitem in case of a
 	 * racing eventpoll_release_file(); the latter will do the removal.
 	 * At this point we are sure no poll callbacks will be lingering around.
 	 * Since we still own a reference to the eventpoll struct, the loop can't
@@ -827,7 +827,7 @@ static void ep_clear_and_put(struct even
 	for (rbp = rb_first_cached(&ep->rbr); rbp; rbp = next) {
 		next = rb_next(rbp);
 		epi = rb_entry(rbp, struct epitem, rbn);
-		ep_remove_safe(ep, epi);
+		ep_remove(ep, epi);
 		cond_resched();
 	}
 
@@ -1505,21 +1505,21 @@ static int ep_insert(struct eventpoll *e
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
@@ -1543,7 +1543,7 @@ static int ep_insert(struct eventpoll *e
 	 * high memory pressure.
 	 */
 	if (unlikely(!epq.epi)) {
-		ep_remove_safe(ep, epi);
+		ep_remove(ep, epi);
 		return -ENOMEM;
 	}
 
@@ -2222,7 +2222,7 @@ int do_epoll_ctl(int epfd, int op, int f
 			 * The eventpoll itself is still alive: the refcount
 			 * can't go to zero here.
 			 */
-			ep_remove_safe(ep, epi);
+			ep_remove(ep, epi);
 			error = 0;
 		} else {
 			error = -ENOENT;


