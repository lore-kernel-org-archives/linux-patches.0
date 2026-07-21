Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A2146D556;
	Tue, 21 Jul 2026 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649237; cv=none; b=NCn3YL/aGbspDlqr1m/Fi1mhhLwrcqoHd9hjPAWvCuC/Z56OxeBsT7etg5c8uI5juQ497uveXh8vyNahNA8Hkk0CrgZicrbdpjZEd2v9wU60y3WAZMJqILbjQ5KK8ju5+wwxZ2v9rZBa/HFUEMwy/ZurLjfSbGKQULyfrEVGOiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649237; c=relaxed/simple;
	bh=kopsl1rKMldrYKcRYE/pqpgWaK1LcVu27qwVF1rp/A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uxGRpm5f9WwUe+puiJuzzC1daP6aelu7DQokwR92Auz4AMD5nXhMQCWxupK6LwAUgeU32tGLIkQzHjiHLCmoruHmIB7m2kahpED1DxGRDLM12piYTnw/h6SEcJjSeEcx1ateZL7/csNbdr0OCH7FCznLx5IXZLxatepdsiDUjUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lejlhHOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lejlhHOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B7D1F000E9;
	Tue, 21 Jul 2026 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649236;
	bh=N9HsJbVAalP/R5Sn9oZMi/lRCEbPbNHJFc+5f4xduUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lejlhHOn4qMxlSNiUfbz+PpN6eV/4qBqj6OtUGO0t6/oo2oSAqbOa42WGd6luGESN
	 LZJArLus4hTzhzzwhPp3PdGbpTaifvjgQOP7kSk/VGPjuVsHSoL/clo4EmF/oeh61j
	 JTgrGqeLm/PUxK8XfSxM2dBFva2WRzokIZHXhcls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0459/2077] eventpoll: rename attach_epitem() to ep_attach_file()
Date: Tue, 21 Jul 2026 17:02:12 +0200
Message-ID: <20260721152603.616860797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index a3090b446af102..556049d0da3fbb 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1526,7 +1526,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 	wakeup_source_unregister(ws);
 }
 
-static int attach_epitem(struct file *file, struct epitem *epi)
+static int ep_attach_file(struct file *file, struct epitem *epi)
 {
 	struct epitems_head *to_free = NULL;
 	struct hlist_head *head = NULL;
@@ -1597,7 +1597,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
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



