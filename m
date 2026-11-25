Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622177;
	b=CedzZQgSDB33/+0wIfbAMN4jIgByKQYiKZnu1uhhJpch26dQi59t2pN8zix/yB76BD4i
	 UaYoLH4iQijQPilTmCAzPkWhGUWGbbClDb5+0iKU2tRh6lyBxvzD5zPwi9rqyI+8LZK7d
	 P8uS3QhOjYOfQtyeW2SHOhWvO7Cnjv9OHHjSH+0h/9Ocxz9rdpROIRdUspXVhyTZ0ajzB
	 yC73CMl0SqeyPHAMedvf+G2vVhvBM+AkcYBkXp7Uik1eRmYypfw7uKC2HAQmBEfw5aF0T
	 8wGs3d5NhEORbFD0o2TO3jJ7ElnHi06HEICU/LXr50sJTgwCYb+Fp8Zx4w9nes+sPew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZGEO9UA+BgytRj+n2yzi7F/7EuuKBX2IzqYx226cAvc=;
	b=gEGbi+Oskdq3pVyqhsEWwcZBNISDN6XWmd0FELDybR4UpizQYpUUHfu/rzdoKJZH45zF
	 FUGJx0G5615iGFYAeH4SI/rNWPOSSpZi3iyBOuMS5bY2SwFK9U0yKSYEp0gAXo6RQdQyv
	 mPw7Vdxk1AhcxOW2lzL5ntAe3psAnt52ZjB31ovBOcsb5n+CPqFAuM+c46LhUY2LV/H1c
	 zjK3Xm8BJUAyjpcTLJEFlFFwciU9AJkVT0fiP+lwxMPteOg01hA2+zoGzKQV048pXHSoR
	 uAu9b+/xUlZcLYLeKMFeueqsFr0wTDu6zGACZIPQh/XCUa0O0l9+Fhws+w41qzF935A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/Wn8ETg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBB606A337;
	Wed, 25 Nov 2026 15:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/Wn8ETg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8717B1F00A03;
	Wed, 25 Nov 2026 15:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622177;
	bh=ZGEO9UA+BgytRj+n2yzi7F/7EuuKBX2IzqYx226cAvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/Wn8ETgKKw5osXKg5sUasWcbVrRIEmBJbJmtwFAAUpwfbyEuhkJTnIDg8TLn5PoC
	 oAmYvujxEF4eRRfSt+bqrzB5leL4xKl+JD+NO3wWjxbYNr6qJGOboEEBX/CLfLBTrB
	 W/fGfNU13Qoe8zCAOv4ha5iTjWz7zVIMguKk2VI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kavitha Daula <kavi@edera.dev>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 446/990] xen/grant-table: annotate on-stack work in gnttab_unmap_refs_sync()
Date: Wed, 25 Nov 2026 15:30:13 +0100
Message-ID: <20261125143832.540645570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kavitha Daula <kavi@edera.dev>

[ Upstream commit 704f812cdab8bbf30987653c1c76c0d2c1e135e7 ]

Both callers of gnttab_unmap_refs_sync(), free_persistent_gnts() and
xen_blkbk_unmap_purged_grants() in blkback, keep their struct
gntab_unmap_queue_data on the stack. gnttab_unmap_refs_async() sets up
the delayed work inside it with INIT_DELAYED_WORK(), so with
CONFIG_DEBUG_OBJECTS_WORK and CONFIG_DEBUG_OBJECTS_TIMERS every
persistent grant teardown warns twice, once for the work and once for
its timer:

  [  104.366085] ODEBUG: object ffffc9004020fad8 is on stack ffffc9004020c000, but NOT annotated.
  [  104.371551] WARNING: CPU: 1 PID: 48 at lib/debugobjects.c:672 lookup_object_or_alloc.part.0+0x12b/0x1f0
  Call Trace:
   <TASK>
   __debug_object_init+0xfe/0x1a0
   debug_object_init+0x38/0x50
   __init_work+0x28/0x30
   gnttab_unmap_refs_async+0x18/0xa0
   gnttab_unmap_refs_sync+0x61/0x90
   free_persistent_gnts+0x179/0x280
   xen_blkbk_free_caches+0x16/0x30
   xen_blkif_disconnect+0xfa/0x2d0
   frontend_changed+0x90/0x680
   xenbus_otherend_changed+0x80/0xb0
   frontend_changed+0x14/0x20
   xenwatch_thread+0x96/0x1a0
   kthread+0x11d/0x250
   ret_from_fork+0x29f/0x2d0
   ret_from_fork_asm+0x1a/0x30
   </TASK>

gnttab_unmap_refs_sync() waits for the unmap to complete before it
returns, so the work never outlives the caller's frame. Initialise it
with INIT_DELAYED_WORK_ONSTACK() when the item is on the stack and
destroy it before returning. The function is exported, so an item that
is not on the stack keeps INIT_DELAYED_WORK().

Fixes: b44166cd46e2 ("xen/grant: introduce func gnttab_unmap_refs_sync()")
Signed-off-by: Kavitha Daula <kavi@edera.dev>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20261105000137.82224-1-kavithadaula@Kavithas-MacBook-Pro.local>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-table.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 478d2ad725ac6..261020f6b7776 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -38,6 +38,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/sched/task_stack.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
@@ -1360,12 +1361,21 @@ static void unmap_refs_callback(int result,
 int gnttab_unmap_refs_sync(struct gntab_unmap_queue_data *item)
 {
 	struct unmap_refs_callback_data data;
+	bool on_stack = object_is_on_stack(item);
 
 	init_completion(&data.completion);
 	item->data = &data;
 	item->done = &unmap_refs_callback;
-	gnttab_unmap_refs_async(item);
+	/* blkback keeps @item, and so its retry work, on the stack. */
+	if (on_stack)
+		INIT_DELAYED_WORK_ONSTACK(&item->gnttab_work, gnttab_unmap_work);
+	else
+		INIT_DELAYED_WORK(&item->gnttab_work, gnttab_unmap_work);
+	item->age = 0;
+	__gnttab_unmap_refs_async(item);
 	wait_for_completion(&data.completion);
+	if (on_stack)
+		destroy_delayed_work_on_stack(&item->gnttab_work);
 
 	return data.result;
 }
-- 
2.53.0



