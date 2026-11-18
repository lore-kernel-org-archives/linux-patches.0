Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044977;
	b=lQYaUWsyMS8w4i6+pvKS56G7HRnxlLIqsFpgygD2A8AsyRllTr+XT1aGFciIrky6egt5
	 3ZCX1Om0tm6cQAljHIqDXyBMqnSLQjQakcUePuHxYtXUYOWtFRAMwQF3MWyRoMKf9TwLu
	 fZrAgySA99zFaGdArHgW9R8Z9NfVLVNwBXcqZ+76sQpz1+8Dw5F9L7tPS2sHi6ziPfVVI
	 Wgfn8v+ySCR29643vZ9bk1RjwdTufcfLjo4Ko9AqmOjy5mTsAmZWK8uyRbmw6zKO3I4eq
	 fkczuiYiGU/yl8v505RXx+BnScTk99B3gJZHAzdDUoud6Z9WTOApuN2kB5FfxsxpDVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ff5QEESrrYtgGELk0EPOyU5TddLwyhw8Apk4bNiQy8=;
	b=frC/np8we12tuvm3mqcPc/3us3v7bumI+0sGiDgAgwcfcg2rKoGCE72O7sqNP84orKk9
	 kB3KcTWNWucj5i3GbtuGRmq9Jd+fNdwgJvmiJcUKc1b2yPTHmbzKG/QgHw8D8Wt/UfoIW
	 Zf8WTigAV9XVekakDva+UslPnBOtFceHyugfCXqEgnHtMBEIj0wCaD0XYaGeCk3yAU5+z
	 OUk+isJeW2DsjvHcOunBrSogIEftp8H6SrYS7EN/woLPEzISkRYBI04tQFsynjmu5kJx3
	 Kf6z3ViE6LAo3o47tKwM8Z7bVJ80T+I0hxuegKX3aY141VjPc4FsbTt7OmhtF7izOqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4zs6Tai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162A1606A320;
	Wed, 18 Nov 2026 23:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a4zs6Tai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2743F1F000C4;
	Wed, 18 Nov 2026 23:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044976;
	bh=6ff5QEESrrYtgGELk0EPOyU5TddLwyhw8Apk4bNiQy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4zs6Tai/01ASZVsI+FEvCG9QbeWm6y9C3zp0q7qkEcpvLCCFILOZu8tCvMOF3noh
	 All/vjbareHsCv1gAp6KWt4S11YYIwbx1vUcfVAha6E0OHHD+Z3eOtnuWlYy8Ndni/
	 Pv8PpyHZJC6G8xGRpodk8/2j1Nz5IJ+/WyOptdfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0732/2857] fs_pin: publish pins with RCU list helpers
Date: Wed, 18 Nov 2026 15:29:26 +0100
Message-ID: <20261118150227.906371985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



