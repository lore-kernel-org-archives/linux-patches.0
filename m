Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682B622301;
	Thu, 16 Jul 2026 14:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212104; cv=none; b=XVqhC/4afiehXkka1/4rvMeF45c15GyCxNAZGV06xKIzDjhLkZxZkwFRtmIFUVHQ52UfjAAV/6zaPjYkmeEItZR3RBMoYb7GpVztdloR1fpgCRlBhdzWoGX+XJTynwbOgAL8rhZeGQsBVdqQSj0JizgcBzrzf5mB69g6xiOKCL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212104; c=relaxed/simple;
	bh=bA5kCONB4H5yOEx+ChDbZQi9IGXb8cXcFceHg7NwZzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NI7FvuUcMfsnVMbGz/KrbJLT6KtLT1XHDWGMP+AwMh06MgqQlAmtaeq0o10n6PDKdgigaeBP8jrsowP36xvWXNNfYrmBWvsGUCItHcjPHA/r3CSSC3A+kGDya8IjcmEO+m0whgKhuycYt1NgL1XnASwo5KZSTaDzIyMAod2cUGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hQvdPCZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hQvdPCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB32F1F00A3A;
	Thu, 16 Jul 2026 14:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212102;
	bh=SjXcIgg3oNPIfRffvr5neWhUBWTWFneFRy7Lf2+j6vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hQvdPCZGjQ4bDvQoR4NUrGmgi6tL8H3G45ymiO5eupBKuCJIx1jbuIDcMSAqSSel
	 WKgCNYrCadoVTtCLYGIXXXiJ3rrGPcvKxVcEE/mBWnk/eq7BLhpOPWLvRQfAWmG6I3
	 FSWfJswET/TjQykdfgnDzPSnI93AoOHzMz5r9H6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	SeongJae Park <sj@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.12 201/349] tools/mm/slabinfo: fix total_objects attribute name
Date: Thu, 16 Jul 2026 15:32:15 +0200
Message-ID: <20260716133037.868230566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit 892a7864730775c3dbee2a39e9ead4fa8d4256e7 upstream.

SLUB exports the total_objects sysfs attribute, but slabinfo tries to read
objects_total. As a result, the lookup fails and the field remains zero.

Use the correct attribute name and rename the corresponding structure
member to match.

Fixes: 205ab99dd103 ("slub: Update statistics handling for variable order slabs")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Link: https://patch.msgid.link/96556748872BB47E+20260612071359.649946-1-chenyichong@uniontech.com
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/mm/slabinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -33,7 +33,7 @@ struct slabinfo {
 	unsigned int hwcache_align, object_size, objs_per_slab;
 	unsigned int sanity_checks, slab_size, store_user, trace;
 	int order, poison, reclaim_account, red_zone;
-	unsigned long partial, objects, slabs, objects_partial, objects_total;
+	unsigned long partial, objects, slabs, objects_partial, total_objects;
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
 	unsigned long free_frozen, free_add_partial, free_remove_partial;
@@ -1256,7 +1256,7 @@ static void read_slab_dir(void)
 			slab->object_size = get_obj("object_size");
 			slab->objects = get_obj("objects");
 			slab->objects_partial = get_obj("objects_partial");
-			slab->objects_total = get_obj("objects_total");
+			slab->total_objects = get_obj("total_objects");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
 			slab->partial = get_obj("partial");


