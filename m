Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619179;
	b=WKulZhH0mlDXAihGcmzou6VvtYVy3zyI0PBg7HmB146TNOEoUadlQ4mHjNn1rYxZH7Zv
	 RGGIPrtVSN3r+5taibC3nHcqMl3TDIBHjfrhwKLTqHEY2IwOqZPuN2um2X6v44l4AsoKT
	 Zl5okYyigDFqp+VVb4DLsULjIKrMIkVRSeT2VRg7qZNpJ7DKw5R/LP0xryGdhxAiQ6BHf
	 JVg8p5v2pWeFP7zhNClNOakQYWWpHG8rxhIpuRkqZlup4F5EbgUmG4R1kp2wwv05ItpxR
	 +GlupeH0Q5vl9Rrfh87CkkANb1SOIugxJ8tw6XGfWJbY1vfoHPpgPC+7VxY8BBuP5Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n8WfNdETjBCU0ACrU91c61/3BbbaGdGc9O+rIF1GnJc=;
	b=b3i8AEYEVUeqHj0aC7ADRpmqOxMi9Fw87KLE51QTp5UQuRhCCC/b6eWt1msu5GCrhwWu
	 KyQ+m58McXL75YVNnYazhHUK9OPyeJ0ZkIgKoIIHi7MqsiP7R/+L0wEoiJ16ilfeSp71L
	 A/Y8Di2UNEquU+bU7tAQNkW+pAjbdm7wV7GmXfBhc2bNnwx4A0O+TET7O97GKJrk0w1Km
	 dyX6xaX1dgQmYwavpaN9yZ4hTnHzCWZ6minTwe3HMvqxQLuQ7qqUMB/uvuv3Uqqwk4msc
	 ZUeVl+5mdBSIQShp+GU4dn7F4JAvjDCdo723sdSZ/pVai5nKUf7ejBCtVLDw7FmUlgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnL9WAhU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF93C606A321;
	Wed, 25 Nov 2026 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnL9WAhU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34DE1F000C0;
	Wed, 25 Nov 2026 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619179;
	bh=n8WfNdETjBCU0ACrU91c61/3BbbaGdGc9O+rIF1GnJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnL9WAhUNTI79EqofHSf/LuL6OBoSnS7c2Su2dCga+tMjSzPabZyu6Jgd8Rf2Hmxw
	 7UxPzfdkCIFrZDtvTdgApGBUPAg3JWGVGonwxCrgo6LT3Vj9dNf52oRRZnOC5B00UL
	 /53IlmxBJmHZUEQdHIjUWcGR7XL0I8H/88ACQ5rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kavitha Daula <kavi@edera.dev>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0516/1005] xen/grant-table: annotate on-stack work in gnttab_unmap_refs_sync()
Date: Wed, 25 Nov 2026 15:30:54 +0100
Message-ID: <20261125143833.833119067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 076c1b0ab87fd..11c2ef1cc86eb 100644
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
@@ -1361,12 +1362,21 @@ static void unmap_refs_callback(int result,
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



