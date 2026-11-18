Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035785;
	b=5k6WzbYdMCvHSeC1jyrVLoqMFClcXs/5MlA5uBQ6XfFoFVeyIP00C78li6fUy8/24wYW
	 iTaWQl028nBIpzD3JRRljC8CgTOvUENFcD8h7W2li07CBxxfBXkc4zPBcgyShGPuznuDV
	 BBJlg+Hm7+kaV6AGjucvnhJHYtIgoAOxTvPhCD15dVuNYiIB68H+oquKRXxsUqhH2BrcK
	 vEPjBCQ2F3eJEomimY+JrRz1rs03n3RRVg/W0Lg3JySVise+rND06LxjDCKgLHp6e2Jc5
	 XlezhXlLT5ehN6+6gqADMLfCdlzutOeI3ZltWMyuTOwL346SxStto+/uAtVx86jGEPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4DYcSedflhB0icFRzHnOnYcncILU3YIBg9FHnZpuQfo=;
	b=r1yuRqhltDyTwJItXyFhkjRld2L/rwUClFC7Lh0fnxzK+xixiyv4xEdnXsftbfOiC3W9
	 /I4VekYPUd7PPtYJ7Eq3W3af/atxfIOnY5HiepEFV02kFTsu4grHW9COVeCe5uBsgNVZu
	 RbhDr/yotzUu9fXEAT+EuS49khctm88IINQAl3+3mPs0TgWTS0Auwu4yQbogh3oFsouFL
	 /fAJkMOzf3Hg+MDXY5JvmlJYLlnIs+11P7TYdLac3bWFFyNR7GwxkwDtkfPB621esFP1y
	 x7OSzlrFo1hUBSjSuTRvY1oXz/8Q4ayqppq/diR1oM8vpnxL+1I9QDqoOEukXdXmvCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtyxTRxc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BAE606A31C;
	Wed, 18 Nov 2026 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UtyxTRxc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFED1F000C4;
	Wed, 18 Nov 2026 21:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035784;
	bh=4DYcSedflhB0icFRzHnOnYcncILU3YIBg9FHnZpuQfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UtyxTRxcNgk4QnRoQldOCUmt536j55IO4CUT/nvbTBP8/9zUwZrOMRQGU0B8/S9tb
	 xtsOViiWacWBqofjwjvu4C6EYUXCAx1rIy3eF+ObtSVCnOyyThw4Fhr+eKanZYsIl2
	 KZw6VYWkU0cxKwAwRP3jLo6DskPWmfSHj6tVktC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0825/3318] fs_pin: publish pins with RCU list helpers
Date: Wed, 18 Nov 2026 15:24:07 +0100
Message-ID: <20261118150343.829330008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8d01d6b4c17c406f37a9b6edac93dfb858af30d0 ]

pin_insert() initializes a pin before adding it under pin_lock.  The kill
paths read the list heads under RCU without taking that lock.  Plain hlist
insertion does not publish the earlier initialization to those readers.

KCSAN weak-memory checking reported acct_on() callback initialization
racing with pin_kill() after the superblock-list publication.  The
corresponding LKMM model permits the stale read with plain publication;
the RCU release/acquire pair forbids it.

Use the RCU hlist add and dereference helpers for both pin lists.

Fixes: 2798d4ce6160 ("acct: get rid of acct_lock for acct->count")
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260903002100.34822-1-kmehltretter@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_pin.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/fs_pin.c b/fs/fs_pin.c
index 47ef3c71ce907..1a508f2167e0a 100644
--- a/fs/fs_pin.c
+++ b/fs/fs_pin.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/fs.h>
+#include <linux/rculist.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include "internal.h"
@@ -22,8 +23,8 @@ void pin_remove(struct fs_pin *pin)
 void pin_insert(struct fs_pin *pin, struct vfsmount *m)
 {
 	spin_lock(&pin_lock);
-	hlist_add_head(&pin->s_list, &m->mnt_sb->s_pins);
-	hlist_add_head(&pin->m_list, &real_mount(m)->mnt_pins);
+	hlist_add_head_rcu(&pin->s_list, &m->mnt_sb->s_pins);
+	hlist_add_head_rcu(&pin->m_list, &real_mount(m)->mnt_pins);
 	spin_unlock(&pin_lock);
 }
 
@@ -73,7 +74,7 @@ void mnt_pin_kill(struct mount *m)
 	while (1) {
 		struct hlist_node *p;
 		rcu_read_lock();
-		p = READ_ONCE(m->mnt_pins.first);
+		p = rcu_dereference(hlist_first_rcu(&m->mnt_pins));
 		if (!p) {
 			rcu_read_unlock();
 			break;
@@ -87,7 +88,7 @@ void group_pin_kill(struct hlist_head *p)
 	while (1) {
 		struct hlist_node *q;
 		rcu_read_lock();
-		q = READ_ONCE(p->first);
+		q = rcu_dereference(hlist_first_rcu(p));
 		if (!q) {
 			rcu_read_unlock();
 			break;
-- 
2.53.0



