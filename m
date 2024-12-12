Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E7513792B;
	Thu, 12 Dec 2024 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019555; cv=none; b=TpRrrylgdu4WaSlzVwo09GaS5/3+Jlh54qLCs1FtP/Mz9Zelp0MzJpkDqqflI+oXVLZ5VdmrFbsxsSJIhqXO5dVXKjEaWKiDipxXTq5TG/LIClFW2OeA2NL9y4JdVKo5SXqZ9q5IMs6chN31XSPaVSf0BSSB1m2R/a+OYxuLj0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019555; c=relaxed/simple;
	bh=L7bD2CyaR4PE6DyL3RW0IdVFNsKJBjjWh2tt27qDsvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lij5P6eCGeaqrcD90V9HxVKJnXYlz7XPiR2K/VWa4FI4BzHs5i594lkaHHHdJb/tnkP5QBXMcV5uwTnWwSG/ZgiXC1u/ffcJCMCEqyW++7oux45DBup7AvTFxdBfeKcj4JGhsBTWmQSuiIYwHuyCi4CcQkOHsr1+msljUgae028=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T30aR1RH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T30aR1RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380E8C4CED0;
	Thu, 12 Dec 2024 16:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019555;
	bh=L7bD2CyaR4PE6DyL3RW0IdVFNsKJBjjWh2tt27qDsvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T30aR1RHo3szCqBG7KamZiOxOUvDXFR5g5200Yjk/nk5vBGCWs0CKl+ex+rzX3f9i
	 RStb9+yu3UcAfz9/AVO117fd1pVWTjeZfsyAchaxDJOvJAy0G+H69AN93SveOxPeIn
	 xRxFwWwmuUJSXb08x2Rbpviy2J6OQETSZKkcYb2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
	Cristiano Giuffrida <c.giuffrida@vu.nl>,
	"Bos, H.J." <h.j.bos@vu.nl>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Baoquan He <bhe@redhat.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Yan Zhen <yanzhen@vivo.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/772] fs/proc/kcore.c: fix coccinelle reported ERROR instances
Date: Thu, 12 Dec 2024 15:53:03 +0100
Message-ID: <20241212144359.741866826@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirsad Todorovac <mtodorovac69@gmail.com>

[ Upstream commit 82e33f249f1126cf3c5f39a31b850d485ac33bc3 ]

Coccinelle complains about the nested reuse of the pointer `iter' with
different pointer type:

./fs/proc/kcore.c:515:26-30: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:534:23-27: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:550:40-44: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:568:27-31: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:581:28-32: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:599:27-31: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:607:38-42: ERROR: invalid reference to the index variable of the iterator on line 499
./fs/proc/kcore.c:614:26-30: ERROR: invalid reference to the index variable of the iterator on line 499

Replacing `struct kcore_list *iter' with `struct kcore_list *tmp' doesn't change the
scope and the functionality is the same and coccinelle seems happy.

NOTE: There was an issue with using `struct kcore_list *pos' as the nested iterator.
      The build did not work!

[akpm@linux-foundation.org: s/tmp/pos/]
Link: https://lkml.kernel.org/r/20241029054651.86356-2-mtodorovac69@gmail.com
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20220331223700.902556-1-jakobkoschel@gmail.com
Fixes: 04d168c6d42d ("fs/proc/kcore.c: remove check of list iterator against head past the loop body")
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Yan Zhen <yanzhen@vivo.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/kcore.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index a2d430549012f..92c7259adfd98 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -496,13 +496,13 @@ read_kcore_iter(struct kiocb *iocb, struct iov_iter *iter)
 		 * the previous entry, search for a matching entry.
 		 */
 		if (!m || start < m->addr || start >= m->addr + m->size) {
-			struct kcore_list *iter;
+			struct kcore_list *pos;
 
 			m = NULL;
-			list_for_each_entry(iter, &kclist_head, list) {
-				if (start >= iter->addr &&
-				    start < iter->addr + iter->size) {
-					m = iter;
+			list_for_each_entry(pos, &kclist_head, list) {
+				if (start >= pos->addr &&
+				    start < pos->addr + pos->size) {
+					m = pos;
 					break;
 				}
 			}
-- 
2.43.0



