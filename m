Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CDC35C6A8;
	Tue, 21 Jul 2026 21:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668656; cv=none; b=pv5eEeg3Tqpn0ei8FKFhUZjwuDI97S+214LxXDRUlV3d5rCNmAsH9dAJIyqPKufSPZzabhYFPh8eyai2NnAViUom2mYM3oS6cznFsqOgzl0E7LOQHAngkkU7wzGu7CzHVV9pQA88+51RhyPGok5hObmpQGmgqfO4YY1m8JpKnM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668656; c=relaxed/simple;
	bh=/Ok36K006yFeO8GkgrC1pmjeNQ0NKL58fdLkDFcH74U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6HRZfZkwjGaAg+pNGP62dwY4QQJCKMxnFDBPBIFoKvw7cpBA0WNtdF970kjP4vGPby2KA2pYgJ44sw6fmAiEBaxRX+Vfc+DqKnqg83wWI7OtG4mNB3p5tZWcgNPy64OYq3ERqAbBNDNIdvjS4Fjp/XruLFTMridHopyBplZC7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGv5/sAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGv5/sAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800AD1F000E9;
	Tue, 21 Jul 2026 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668655;
	bh=ZsKRFaLZP4pNz1ovgluGkMHo+33ZuElvHsjMZXlgM1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGv5/sAMQEH8ZzNtE8M/YE+Nb3ZQpm91cNl/Vf47F07atCUxHNsRIANNXnP8QlCV0
	 42+pKTJ4qpM8fVcs9hcHSSGX82K9IgoSXrXAO0DlryNU5kTNTjq0vEN5Hk+ow1bIt0
	 DoGzLDt0XWdZruZJgZ95VAZ4CwYgAKuXRKSqkUt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	SeongJae Park <sj@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0258/1067] tools/mm/slabinfo: fix total_objects attribute name
Date: Tue, 21 Jul 2026 17:14:19 +0200
Message-ID: <20260721152430.369003060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 892a7864730775c3dbee2a39e9ead4fa8d4256e7 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/vm/slabinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/vm/slabinfo.c b/tools/vm/slabinfo.c
index 0fffaeedee7672..d26a44e3e68470 100644
--- a/tools/vm/slabinfo.c
+++ b/tools/vm/slabinfo.c
@@ -33,7 +33,7 @@ struct slabinfo {
 	unsigned int hwcache_align, object_size, objs_per_slab;
 	unsigned int sanity_checks, slab_size, store_user, trace;
 	int order, poison, reclaim_account, red_zone;
-	unsigned long partial, objects, slabs, objects_partial, objects_total;
+	unsigned long partial, objects, slabs, objects_partial, total_objects;
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
 	unsigned long free_frozen, free_add_partial, free_remove_partial;
@@ -1254,7 +1254,7 @@ static void read_slab_dir(void)
 			slab->object_size = get_obj("object_size");
 			slab->objects = get_obj("objects");
 			slab->objects_partial = get_obj("objects_partial");
-			slab->objects_total = get_obj("objects_total");
+			slab->total_objects = get_obj("total_objects");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
 			slab->partial = get_obj("partial");
-- 
2.53.0



