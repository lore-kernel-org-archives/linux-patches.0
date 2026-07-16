Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696343F0774;
	Thu, 16 Jul 2026 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210992; cv=none; b=phQhfcN4dRT6hCp80rHoKYRNJZGVpCPFCFu4d9MHbxigCgA+LoCWaw0xgBR1mjEfpQvURD/V3KWPM0kievlwziIOeYGl9bEB4vmuG0FGtgHoUmMvCmZLBOciREHcF4oZt8q2YxZmX4jbVlzYpBdMg7ZVVyDpxn4bw1lkyRFyS+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210992; c=relaxed/simple;
	bh=Gp0gh/hjN1V+S/mQUdalVH6fPop1xZi44hpWbNKV2Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgbVYoOFoECzGnAP9hIn1AEdZtADn82AgRKfkaQQ3FvOyf8fBogGtaq9DepktoozDgpw9+QBOsNnLvBZwJIZxrmIWKSQheY+YTNB/ltYw+iJSss/7HIZ/otvypyom7piPCAmUyhxLzQWA4+joqQ9IXR3NCtPAKeVWUSlgzhEQH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8hQ+etx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8hQ+etx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE051F00A3D;
	Thu, 16 Jul 2026 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210991;
	bh=to8oDTRmKkwFRwdRdJQJa4P27uDCm3zFJpPxLVp9GQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8hQ+etxO0SP0+rXTB1zJqovnSzFpQ2yvvFX+pHRGJ4ZW2LQYkF6k8tnoXXSX3VNH
	 HjM9eLCATs1b1j0gXD1TT/40/XGur83S0e1GPKvP9w7IT4+Bp3AJTDm/qNM/AHyTYl
	 N+BHYnTJ1AsYSUe9IFaNfhMDo2Y9KWpNX3MjXmA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	SeongJae Park <sj@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 258/480] tools/mm/slabinfo: fix total_objects attribute name
Date: Thu, 16 Jul 2026 15:30:05 +0200
Message-ID: <20260716133050.397875884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1263,7 +1263,7 @@ static void read_slab_dir(void)
 			slab->object_size = get_obj("object_size");
 			slab->objects = get_obj("objects");
 			slab->objects_partial = get_obj("objects_partial");
-			slab->objects_total = get_obj("objects_total");
+			slab->total_objects = get_obj("total_objects");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
 			slab->partial = get_obj("partial");


