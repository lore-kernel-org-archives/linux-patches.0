Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F820435A96;
	Tue, 21 Jul 2026 20:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665197; cv=none; b=eeqe4d3Lcs9V7DHh3ln3+S0qVVzOuoSQGtj2VkaIFE7yusK6MjMoNWngAYhOkLVUqILAqMETDnePwnZg6qfUZR6CL6ALZGRShw8uHO58AZE7gFe4BxieY+wn7eOTxwJXEe60paD+q6Ig3akoOS/OevkWf0Beo16Y6XwurZxzETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665197; c=relaxed/simple;
	bh=1Sw7STWr242BjfE8pN2qdzOrFW+2lSWQ5XKvTLMtvjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvuEkPRWma+7nsxFOZhHBxoyOOLnoopH+LbLyyZgLzvJ/RB+cqOvQ/0PWCZkhgNpfNPXH7T9VY8G+1/wYLczZYa/UvdeWKKHBzcaUmU4Ld6bgWCmkBPTV5hgSSFoLPjhCCFMhirxYCyDixG3dmD7dGAiRHh4C7MGoqHhIXwihxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxG0R99R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxG0R99R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA181F000E9;
	Tue, 21 Jul 2026 20:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665196;
	bh=7gj6aPQ/M5OFfe6gTBykKjx1p+1KAnFeVvTD87OmYzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxG0R99RZqxaQpyZnHlgfm0qI1nVnskfWUHwDbLv7MmoU5Tz13uNu3j41bRJ0udQm
	 FZ+WKG5L4NVhd14ioB46GVFA4K72LDkqSxgNEtPCeJo4ceH86e3t7b1AgAsRqb7KIZ
	 gdXfGlRpr1H5U67ssdYByAFCxJM682/p9GRGiRnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	SeongJae Park <sj@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.6 0212/1266] tools/mm/slabinfo: fix total_objects attribute name
Date: Tue, 21 Jul 2026 17:10:49 +0200
Message-ID: <20260721152446.560093803@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


