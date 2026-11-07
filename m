Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063872;
	b=4VfUiCJASSDhV+MN10kalNddTCxIbMF9YUpsUhFgjnX7Cxsp4achyxv7wzbnbGqLuoMl
	 wt9V7/zfWDaVtU2+EMfrdj18WHLnwjJJcSebiPtgwGd2vzTwzYkR2RA0VBmRDXb/YvcIK
	 MOEm+AkwmMjl+oYqzlMAtG49us4/n7D/7+3fXNnEDZ7PkAKa4bPanvd84oUfpPdTEit1Q
	 Vj0ZsJ5WEpSxRckMA5bSIKaoqAZH9HdK5JwBG1miP0u4Hj2w1eXuCUQ4kalbZAW+PKoR8
	 E9TBHWuFxnFQplbvmSpfxtjh8fdB652PBCOYH4gEMP2EJicNz7U0Ex7jHkIkWOvw6EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t7Oj16P58EMROd+3XXy7QZFiJAZgpnHLxdUWcs7xfNE=;
	b=CEdwd6sZoSb9wTX0qROSByONr4MatLeOHN2FJTo4Hlr5I7n1790SrR9wRGdUrUCE4qfc
	 dqmPtvriY9DVPF710o89DwA5ebu/zdOjWcyukfMWSNINpgIH2482n/VWZyd+Cc9LLixmD
	 B5oqBYeBUwKHRCLb6UV/DE7C7AO+b6sZ9T3VMiwP81NSpzj/knkRafHFreSe9MtGEhz7f
	 eIyRFou2a2IHzTYYakYCLYugeFhgPhsBc2ys+7uc7wi5hY3U8Qr1AfUlgX8e4tECxpchV
	 UA2wdcB26e4Q5+xMQUmvO3zFVxOt+up6sgOV9vmANnYvjDyJDe+PeA4lkEViNDDEJ6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlTf9OYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53E606E8D7;
	Sat,  7 Nov 2026 15:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlTf9OYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC92E1F008A2;
	Sat,  7 Nov 2026 15:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063872;
	bh=t7Oj16P58EMROd+3XXy7QZFiJAZgpnHLxdUWcs7xfNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlTf9OYpJNdGBciTELFQdm/xzPVxKRqJcXb6PmO6L1s3vuXEkQe4C2WNjSt44SPjU
	 hrz5MnC/1FRuA+/8yXw6dybSZNjPGFE56JJKunjeiMlyASC72AksmMqWwSa2x505h5
	 GS/1umS2ISLmPMfLQIXBTpyW9mjDtYgyqO7DENGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0076/1257] fs_pin: publish pins with RCU list helpers
Date: Sat,  7 Nov 2026 08:39:32 -0500
Message-ID: <20261107134941.481703884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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



