Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061916;
	b=u1cD+uZ6ny1hEYsTg+P+0bEQtYcvEoex8CjKX3gq+N+KjjEawQdml4fEsoi3IfYZl6b5
	 FcWZY38uJcWBRHWa6P1Y40SGCE+muds+Ma+TlBK3fkpN66yPUfNvreRBokzd6bHcF8eLc
	 TB3vLUTJFhSMR6RMV3isQX76drbwqqABOiY/BZDYcVWCmA+gJObGxbG1Mol0VLVsAcoBv
	 /8IjQeLHwJ1MqzqhQsjagiFrfChFiFJ+bptxmCP2v0tHGW8EKORHxNx9hZH2zLqvhzGGW
	 al8ou7AOSYsemvYnV5xPCFkYE32EPSm34hcBHquaZtMh3w05iQt96MzASduHzNRlM3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rzONzYErogGQkwVZuVCv9x1Ml6Yiey0OdZVSsA0yyTY=;
	b=2FeZZVQOY70IzQaWhnPixNU56OOETlM3BDG4EoFVwFvb+6LquLPcapTFzpLaL8V7TLy7
	 hpfx63OevOu6G0EybAKy0QZRE7FogMNGxC/FdMA/vUyMzNAWJJnBF/+HZryhJgY7cz42J
	 p4SNcFlutkOtPmUKGDtEAcl7U2VfkvJvRPj7ZD/aDJlMA4o+n5dgWTwDuNT3uZ/CYv+xb
	 5xfX/FmHxbB9ZU4wFLQLOVNuCVvAJ4coma7jFj8+YRr4XP2q7ykbrNAV6++iHNM0WbIKi
	 ZuDBhwZ7reuAXGtdFzC5z4cSO6UlrDUXr5drXGnK5FERlhbGMYsWc2uUa5cp2/rp2ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wjvtWuS/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD3E606A326;
	Sat,  7 Nov 2026 14:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjvtWuS/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1983F1F0089F;
	Sat,  7 Nov 2026 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061916;
	bh=rzONzYErogGQkwVZuVCv9x1Ml6Yiey0OdZVSsA0yyTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjvtWuS/nLQddqJx9RPwSHq+cOf0wHhZVMgXVU2V7uZw9NP77sjmQDK7J/7rqlbzI
	 YtvDqkz1lymXfznvVEznGI0wwiqiqgfLLo3fqkXW8lZ7d6pMEFf3Gr6Qza2y672/8l
	 0P2Tap3zMZokXgTwoaMu2AmCf/CO25vLmWXIvCP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0924/1536] fs_pin: publish pins with RCU list helpers
Date: Sat,  7 Nov 2026 08:49:00 -0500
Message-ID: <20261107135023.597556686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



