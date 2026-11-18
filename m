Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052140;
	b=T0Yg2WKKTpsP9HNYQqPAH7zL43SMUwM70fbu+3eAK+CftvlPopXUHKeMKG/tUU2Y+HPp
	 5MUPH3zB8KDTQt1fvbML4iGfv+YV+Q0ZfEWsDGoY3HSNS+cjCKrUk5YCwZq9/H/8S+yRi
	 AaOXHJwaieSiRZ9plGqFbWylUwav+yhmr/ZkilxnaE+HD2KEOE8fWX8PhyLfvLmSDcNzb
	 QVTpRkvNyXdJ+bXz/nWdxKTUEm++LllGbiYa+cx7PH8BGR6ILkwY9RAjLfPK7DIdJS1aF
	 ShThDYBBtZIdVnFf2J6xefJKAuFHWZ7qjdfI1r4fSaAEqDtQbAn1lt+kJmUUoEjaTdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cbM6dmqIfHlo8mW4fnv9HaM8VEi/P5AEUyQViVJBXYE=;
	b=QsTbczV1gKnvYrqrVWNvbiGpugSmlgS7+B3QizOcdGc5CjuJOcSHqbRzBj25ErLcvAHM
	 jLpSaq8eBkibIFckL4pnCP62bkstmwZ8sT8VjRUZeraOVZ5KWKL+DZ+E2FddDUeEe+lZ9
	 LUDoj8re+i5G899B7G9M5n2kJAx6d+du4IcPBvH05lismhFirzuCRW+z1UCdlMQTHKM4E
	 wigQLrYxKGx7oWpbJOh4zda8ZR9w6VX/3xLhyY8+tNmOPrNWtE5R1v+kfffHa8LcDv7F1
	 JKA2ZlO4nTlcigthS0eUkGYfwVCGTIG0RuWYDJju4RquOM9xRICQcnosAM/bECFc+dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GipLVxVD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDE4606A31C;
	Thu, 19 Nov 2026 01:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GipLVxVD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B981F000C4;
	Thu, 19 Nov 2026 01:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052140;
	bh=cbM6dmqIfHlo8mW4fnv9HaM8VEi/P5AEUyQViVJBXYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GipLVxVD9boMG8ery1WgzCoxixLfsMXwk20i65XhomR+cYXk39QBDRcUkXjEdW/IO
	 /cCIlX30IvBsuyfKoV6/l7gl1ZMRnh6xuP8V+oI5GAcxGh9ko1wMUIOrCqTF8vt2CB
	 lSV6vSY3ZDafPeTTKGybZa352Y0hBLSbmPrBsAO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0456/2214] fs_pin: publish pins with RCU list helpers
Date: Wed, 18 Nov 2026 15:35:32 +0100
Message-ID: <20261118150029.425052935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



