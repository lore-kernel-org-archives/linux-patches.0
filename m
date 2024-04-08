Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FE779F0;
	Mon,  8 Apr 2024 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584142; cv=none; b=OLmM97QHnE7+BGzyJ0ul8qytN0r9C8fDrF+8cbjk6DuLvq3bqBXZA7kwZBpxJoCPJRV26S7nKz8NpIanJmnqIoR3JcBp5Ay/Fg3aUa+rd7I0YMD3d5raNKUmuQxqK/5acDrSsnqdFD5pZi+Q5ARxqqUD7CCnZsn1p655FmtpjXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584142; c=relaxed/simple;
	bh=8CTYqTaHRJ+b5HLlqg5A9KtcYFKwmbnoyiBQ7f40fUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsEwdVe9RSYQMQY35lB0+CVxK1zbWHBO0dsRgjasOVCtlhuhcQeLTn+tvFSAv2kOmoc0MxstHokWuLD68AKik83dA3079owzlPy0hJIb6Ko1MS4yShiSUL9h6B/0q3sxsDXpl03K7GtNgKblp6QciiHDpQpsSE80KVYvKP0uYV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHISUCPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHISUCPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B29FC433C7;
	Mon,  8 Apr 2024 13:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584141;
	bh=8CTYqTaHRJ+b5HLlqg5A9KtcYFKwmbnoyiBQ7f40fUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHISUCPQ8eC1GsVjZgZpJEzkXPz3KtW4Kyx4M0AQHFgkbLULWeCY62Hvh2DAtXCIU
	 lTxCvxHtWkqNQ7+SaH91XwLbM0pGV5cYkkjaV4F3DeFyEnTxSC+jX5Hhhh7uikwpUP
	 NeLOrd2r9MhlOaYXWYSY7m4KCNIZY6CoM+Qh0SMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Gao <gaoxin@cdjrlc.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 340/690] fsnotify: Fix comment typo
Date: Mon,  8 Apr 2024 14:53:26 +0200
Message-ID: <20240408125411.934495687@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Gao <gaoxin@cdjrlc.com>

[ Upstream commit feee1ce45a5666bbdb08c5bb2f5f394047b1915b ]

The double `if' is duplicated in line 104, remove one.

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220722194639.18545-1-gaoxin@cdjrlc.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/notify/fsnotify.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 8687562df2e37..7974e91ffe134 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -100,7 +100,7 @@ void fsnotify_sb_delete(struct super_block *sb)
  * Given an inode, first check if we care what happens to our children.  Inotify
  * and dnotify both tell their parents about events.  If we care about any event
  * on a child we run all of our children and set a dentry flag saying that the
- * parent cares.  Thus when an event happens on a child it can quickly tell if
+ * parent cares.  Thus when an event happens on a child it can quickly tell
  * if there is a need to find a parent and send the event to the parent.
  */
 void __fsnotify_update_child_dentry_flags(struct inode *inode)
-- 
2.43.0



