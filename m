Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01A11A0AE5;
	Thu,  6 Jun 2024 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683638; cv=none; b=qW0Xdp0CARABx7+apyfrVIVnTd13PmkM/fTzXs7GEWxwvV6D6nFu5wy/b1tK2SHl3i4GuDmpAf6NIhdqbTq5XEfZ673V2YzcBBFHRBQ3MGrvBKUNf1pQuWymdu8T4H8Hl3+Ua2XnDQYxTLrV6/XKw4lWwk3yl7T6HLvskr0i0/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683638; c=relaxed/simple;
	bh=nNRlQO91yGlFvoK6mIiJouVA1zBToiSrNZPjIYkiGJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgWpav1HUity+0riI166/E1MtiI+4FohdBs2DibJ+O8CjqnZigSBCsCK8pLZ6U7BgQ83vw5EcAjis6LRNlJowFnsPIsBfKATE0d24YCS3pSHpOBW9qqSdEAyw7y9GBRDpHXqS96lcbJCEZQ8vSTk6wkgIyUO5PXq8dksfqUqtlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djYQUuhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djYQUuhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B03C2BD10;
	Thu,  6 Jun 2024 14:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683638;
	bh=nNRlQO91yGlFvoK6mIiJouVA1zBToiSrNZPjIYkiGJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djYQUuhHAMpn6hifVRQkrVQThzYGmGclh0dgWhBHcm9IFlDSxG267nc/wou7NFqCu
	 L9Oz07rnjEMoJ1MUB1crxxvX5n7eHL4MxTPLOQ2PKton3lUyq0FjQrtz5d9abh1IZ3
	 78WeXe6EMfRlCL+/5I6oBatSw9dtOTJD6eaKMIJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Athira Jajeev <atrajeev@linux.vnet.ibm.com>,
	Changbin Du <changbin.du@huawei.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	German Gomez <german.gomez@arm.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Li Dong <lidong@vivo.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Ming Wang <wangming01@loongson.cn>,
	Nick Terrell <terrelln@fb.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Wenyu Liu <liuwenyu7@huawei.com>,
	Yang Jihong <yangjihong1@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 510/744] perf maps: Move symbol maps functions to maps.c
Date: Thu,  6 Jun 2024 16:03:02 +0200
Message-ID: <20240606131748.812807040@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0f6ab6a3fb7e380a1277f8288f315724ed517114 ]

Move the find and certain other symbol maps__* functions to maps.c for
better abstraction.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Jajeev <atrajeev@linux.vnet.ibm.com>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Dmitrii Dolgov <9erthalion6@gmail.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Guilherme Amadio <amadio@gentoo.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Li Dong <lidong@vivo.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Ming Wang <wangming01@loongson.cn>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Wenyu Liu <liuwenyu7@huawei.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20231127220902.1315692-14-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 25626e19ae6d ("perf symbols: Fix ownership of string in dso__load_vmlinux()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c   | 238 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/maps.h   |  12 ++
 tools/perf/util/symbol.c | 248 ---------------------------------------
 tools/perf/util/symbol.h |   1 -
 4 files changed, 250 insertions(+), 249 deletions(-)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 233438c95b531..9a011aed4b754 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -475,3 +475,241 @@ struct map_rb_node *map_rb_node__next(struct map_rb_node *node)
 
 	return rb_entry(next, struct map_rb_node, rb_node);
 }
+
+static int map__strcmp(const void *a, const void *b)
+{
+	const struct map *map_a = *(const struct map **)a;
+	const struct map *map_b = *(const struct map **)b;
+	const struct dso *dso_a = map__dso(map_a);
+	const struct dso *dso_b = map__dso(map_b);
+	int ret = strcmp(dso_a->short_name, dso_b->short_name);
+
+	if (ret == 0 && map_a != map_b) {
+		/*
+		 * Ensure distinct but name equal maps have an order in part to
+		 * aid reference counting.
+		 */
+		ret = (int)map__start(map_a) - (int)map__start(map_b);
+		if (ret == 0)
+			ret = (int)((intptr_t)map_a - (intptr_t)map_b);
+	}
+
+	return ret;
+}
+
+static int map__strcmp_name(const void *name, const void *b)
+{
+	const struct dso *dso = map__dso(*(const struct map **)b);
+
+	return strcmp(name, dso->short_name);
+}
+
+void __maps__sort_by_name(struct maps *maps)
+{
+	qsort(maps__maps_by_name(maps), maps__nr_maps(maps), sizeof(struct map *), map__strcmp);
+}
+
+static int map__groups__sort_by_name_from_rbtree(struct maps *maps)
+{
+	struct map_rb_node *rb_node;
+	struct map **maps_by_name = realloc(maps__maps_by_name(maps),
+					    maps__nr_maps(maps) * sizeof(struct map *));
+	int i = 0;
+
+	if (maps_by_name == NULL)
+		return -1;
+
+	up_read(maps__lock(maps));
+	down_write(maps__lock(maps));
+
+	RC_CHK_ACCESS(maps)->maps_by_name = maps_by_name;
+	RC_CHK_ACCESS(maps)->nr_maps_allocated = maps__nr_maps(maps);
+
+	maps__for_each_entry(maps, rb_node)
+		maps_by_name[i++] = map__get(rb_node->map);
+
+	__maps__sort_by_name(maps);
+
+	up_write(maps__lock(maps));
+	down_read(maps__lock(maps));
+
+	return 0;
+}
+
+static struct map *__maps__find_by_name(struct maps *maps, const char *name)
+{
+	struct map **mapp;
+
+	if (maps__maps_by_name(maps) == NULL &&
+	    map__groups__sort_by_name_from_rbtree(maps))
+		return NULL;
+
+	mapp = bsearch(name, maps__maps_by_name(maps), maps__nr_maps(maps),
+		       sizeof(*mapp), map__strcmp_name);
+	if (mapp)
+		return *mapp;
+	return NULL;
+}
+
+struct map *maps__find_by_name(struct maps *maps, const char *name)
+{
+	struct map_rb_node *rb_node;
+	struct map *map;
+
+	down_read(maps__lock(maps));
+
+
+	if (RC_CHK_ACCESS(maps)->last_search_by_name) {
+		const struct dso *dso = map__dso(RC_CHK_ACCESS(maps)->last_search_by_name);
+
+		if (strcmp(dso->short_name, name) == 0) {
+			map = RC_CHK_ACCESS(maps)->last_search_by_name;
+			goto out_unlock;
+		}
+	}
+	/*
+	 * If we have maps->maps_by_name, then the name isn't in the rbtree,
+	 * as maps->maps_by_name mirrors the rbtree when lookups by name are
+	 * made.
+	 */
+	map = __maps__find_by_name(maps, name);
+	if (map || maps__maps_by_name(maps) != NULL)
+		goto out_unlock;
+
+	/* Fallback to traversing the rbtree... */
+	maps__for_each_entry(maps, rb_node) {
+		struct dso *dso;
+
+		map = rb_node->map;
+		dso = map__dso(map);
+		if (strcmp(dso->short_name, name) == 0) {
+			RC_CHK_ACCESS(maps)->last_search_by_name = map;
+			goto out_unlock;
+		}
+	}
+	map = NULL;
+
+out_unlock:
+	up_read(maps__lock(maps));
+	return map;
+}
+
+void maps__fixup_end(struct maps *maps)
+{
+	struct map_rb_node *prev = NULL, *curr;
+
+	down_write(maps__lock(maps));
+
+	maps__for_each_entry(maps, curr) {
+		if (prev != NULL && !map__end(prev->map))
+			map__set_end(prev->map, map__start(curr->map));
+
+		prev = curr;
+	}
+
+	/*
+	 * We still haven't the actual symbols, so guess the
+	 * last map final address.
+	 */
+	if (curr && !map__end(curr->map))
+		map__set_end(curr->map, ~0ULL);
+
+	up_write(maps__lock(maps));
+}
+
+/*
+ * Merges map into maps by splitting the new map within the existing map
+ * regions.
+ */
+int maps__merge_in(struct maps *kmaps, struct map *new_map)
+{
+	struct map_rb_node *rb_node;
+	LIST_HEAD(merged);
+	int err = 0;
+
+	maps__for_each_entry(kmaps, rb_node) {
+		struct map *old_map = rb_node->map;
+
+		/* no overload with this one */
+		if (map__end(new_map) < map__start(old_map) ||
+		    map__start(new_map) >= map__end(old_map))
+			continue;
+
+		if (map__start(new_map) < map__start(old_map)) {
+			/*
+			 * |new......
+			 *       |old....
+			 */
+			if (map__end(new_map) < map__end(old_map)) {
+				/*
+				 * |new......|     -> |new..|
+				 *       |old....| ->       |old....|
+				 */
+				map__set_end(new_map, map__start(old_map));
+			} else {
+				/*
+				 * |new.............| -> |new..|       |new..|
+				 *       |old....|    ->       |old....|
+				 */
+				struct map_list_node *m = map_list_node__new();
+
+				if (!m) {
+					err = -ENOMEM;
+					goto out;
+				}
+
+				m->map = map__clone(new_map);
+				if (!m->map) {
+					free(m);
+					err = -ENOMEM;
+					goto out;
+				}
+
+				map__set_end(m->map, map__start(old_map));
+				list_add_tail(&m->node, &merged);
+				map__add_pgoff(new_map, map__end(old_map) - map__start(new_map));
+				map__set_start(new_map, map__end(old_map));
+			}
+		} else {
+			/*
+			 *      |new......
+			 * |old....
+			 */
+			if (map__end(new_map) < map__end(old_map)) {
+				/*
+				 *      |new..|   -> x
+				 * |old.........| -> |old.........|
+				 */
+				map__put(new_map);
+				new_map = NULL;
+				break;
+			} else {
+				/*
+				 *      |new......| ->         |new...|
+				 * |old....|        -> |old....|
+				 */
+				map__add_pgoff(new_map, map__end(old_map) - map__start(new_map));
+				map__set_start(new_map, map__end(old_map));
+			}
+		}
+	}
+
+out:
+	while (!list_empty(&merged)) {
+		struct map_list_node *old_node;
+
+		old_node = list_entry(merged.next, struct map_list_node, node);
+		list_del_init(&old_node->node);
+		if (!err)
+			err = maps__insert(kmaps, old_node->map);
+		map__put(old_node->map);
+		free(old_node);
+	}
+
+	if (new_map) {
+		if (!err)
+			err = maps__insert(kmaps, new_map);
+		map__put(new_map);
+	}
+	return err;
+}
diff --git a/tools/perf/util/maps.h b/tools/perf/util/maps.h
index 83144e0645ed4..a689149be8c43 100644
--- a/tools/perf/util/maps.h
+++ b/tools/perf/util/maps.h
@@ -21,6 +21,16 @@ struct map_rb_node {
 	struct map *map;
 };
 
+struct map_list_node {
+	struct list_head node;
+	struct map *map;
+};
+
+static inline struct map_list_node *map_list_node__new(void)
+{
+	return malloc(sizeof(struct map_list_node));
+}
+
 struct map_rb_node *maps__first(struct maps *maps);
 struct map_rb_node *map_rb_node__next(struct map_rb_node *node);
 struct map_rb_node *maps__find_node(struct maps *maps, struct map *map);
@@ -133,4 +143,6 @@ int maps__merge_in(struct maps *kmaps, struct map *new_map);
 
 void __maps__sort_by_name(struct maps *maps);
 
+void maps__fixup_end(struct maps *maps);
+
 #endif // __PERF_MAPS_H
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3f36675b7c8ff..1976af974a371 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -48,11 +48,6 @@ static bool symbol__is_idle(const char *name);
 int vmlinux_path__nr_entries;
 char **vmlinux_path;
 
-struct map_list_node {
-	struct list_head node;
-	struct map *map;
-};
-
 struct symbol_conf symbol_conf = {
 	.nanosecs		= false,
 	.use_modules		= true,
@@ -90,11 +85,6 @@ static enum dso_binary_type binary_type_symtab[] = {
 
 #define DSO_BINARY_TYPE__SYMTAB_CNT ARRAY_SIZE(binary_type_symtab)
 
-static struct map_list_node *map_list_node__new(void)
-{
-	return malloc(sizeof(struct map_list_node));
-}
-
 static bool symbol_type__filter(char symbol_type)
 {
 	symbol_type = toupper(symbol_type);
@@ -271,29 +261,6 @@ void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms)
 		curr->end = roundup(curr->start, 4096) + 4096;
 }
 
-void maps__fixup_end(struct maps *maps)
-{
-	struct map_rb_node *prev = NULL, *curr;
-
-	down_write(maps__lock(maps));
-
-	maps__for_each_entry(maps, curr) {
-		if (prev != NULL && !map__end(prev->map))
-			map__set_end(prev->map, map__start(curr->map));
-
-		prev = curr;
-	}
-
-	/*
-	 * We still haven't the actual symbols, so guess the
-	 * last map final address.
-	 */
-	if (curr && !map__end(curr->map))
-		map__set_end(curr->map, ~0ULL);
-
-	up_write(maps__lock(maps));
-}
-
 struct symbol *symbol__new(u64 start, u64 len, u8 binding, u8 type, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
@@ -1271,103 +1238,6 @@ static int kcore_mapfn(u64 start, u64 len, u64 pgoff, void *data)
 	return 0;
 }
 
-/*
- * Merges map into maps by splitting the new map within the existing map
- * regions.
- */
-int maps__merge_in(struct maps *kmaps, struct map *new_map)
-{
-	struct map_rb_node *rb_node;
-	LIST_HEAD(merged);
-	int err = 0;
-
-	maps__for_each_entry(kmaps, rb_node) {
-		struct map *old_map = rb_node->map;
-
-		/* no overload with this one */
-		if (map__end(new_map) < map__start(old_map) ||
-		    map__start(new_map) >= map__end(old_map))
-			continue;
-
-		if (map__start(new_map) < map__start(old_map)) {
-			/*
-			 * |new......
-			 *       |old....
-			 */
-			if (map__end(new_map) < map__end(old_map)) {
-				/*
-				 * |new......|     -> |new..|
-				 *       |old....| ->       |old....|
-				 */
-				map__set_end(new_map, map__start(old_map));
-			} else {
-				/*
-				 * |new.............| -> |new..|       |new..|
-				 *       |old....|    ->       |old....|
-				 */
-				struct map_list_node *m = map_list_node__new();
-
-				if (!m) {
-					err = -ENOMEM;
-					goto out;
-				}
-
-				m->map = map__clone(new_map);
-				if (!m->map) {
-					free(m);
-					err = -ENOMEM;
-					goto out;
-				}
-
-				map__set_end(m->map, map__start(old_map));
-				list_add_tail(&m->node, &merged);
-				map__add_pgoff(new_map, map__end(old_map) - map__start(new_map));
-				map__set_start(new_map, map__end(old_map));
-			}
-		} else {
-			/*
-			 *      |new......
-			 * |old....
-			 */
-			if (map__end(new_map) < map__end(old_map)) {
-				/*
-				 *      |new..|   -> x
-				 * |old.........| -> |old.........|
-				 */
-				map__put(new_map);
-				new_map = NULL;
-				break;
-			} else {
-				/*
-				 *      |new......| ->         |new...|
-				 * |old....|        -> |old....|
-				 */
-				map__add_pgoff(new_map, map__end(old_map) - map__start(new_map));
-				map__set_start(new_map, map__end(old_map));
-			}
-		}
-	}
-
-out:
-	while (!list_empty(&merged)) {
-		struct map_list_node *old_node;
-
-		old_node = list_entry(merged.next, struct map_list_node, node);
-		list_del_init(&old_node->node);
-		if (!err)
-			err = maps__insert(kmaps, old_node->map);
-		map__put(old_node->map);
-		free(old_node);
-	}
-
-	if (new_map) {
-		if (!err)
-			err = maps__insert(kmaps, new_map);
-		map__put(new_map);
-	}
-	return err;
-}
-
 static int dso__load_kcore(struct dso *dso, struct map *map,
 			   const char *kallsyms_filename)
 {
@@ -2065,124 +1935,6 @@ int dso__load(struct dso *dso, struct map *map)
 	return ret;
 }
 
-static int map__strcmp(const void *a, const void *b)
-{
-	const struct map *map_a = *(const struct map **)a;
-	const struct map *map_b = *(const struct map **)b;
-	const struct dso *dso_a = map__dso(map_a);
-	const struct dso *dso_b = map__dso(map_b);
-	int ret = strcmp(dso_a->short_name, dso_b->short_name);
-
-	if (ret == 0 && map_a != map_b) {
-		/*
-		 * Ensure distinct but name equal maps have an order in part to
-		 * aid reference counting.
-		 */
-		ret = (int)map__start(map_a) - (int)map__start(map_b);
-		if (ret == 0)
-			ret = (int)((intptr_t)map_a - (intptr_t)map_b);
-	}
-
-	return ret;
-}
-
-static int map__strcmp_name(const void *name, const void *b)
-{
-	const struct dso *dso = map__dso(*(const struct map **)b);
-
-	return strcmp(name, dso->short_name);
-}
-
-void __maps__sort_by_name(struct maps *maps)
-{
-	qsort(maps__maps_by_name(maps), maps__nr_maps(maps), sizeof(struct map *), map__strcmp);
-}
-
-static int map__groups__sort_by_name_from_rbtree(struct maps *maps)
-{
-	struct map_rb_node *rb_node;
-	struct map **maps_by_name = realloc(maps__maps_by_name(maps),
-					    maps__nr_maps(maps) * sizeof(struct map *));
-	int i = 0;
-
-	if (maps_by_name == NULL)
-		return -1;
-
-	up_read(maps__lock(maps));
-	down_write(maps__lock(maps));
-
-	RC_CHK_ACCESS(maps)->maps_by_name = maps_by_name;
-	RC_CHK_ACCESS(maps)->nr_maps_allocated = maps__nr_maps(maps);
-
-	maps__for_each_entry(maps, rb_node)
-		maps_by_name[i++] = map__get(rb_node->map);
-
-	__maps__sort_by_name(maps);
-
-	up_write(maps__lock(maps));
-	down_read(maps__lock(maps));
-
-	return 0;
-}
-
-static struct map *__maps__find_by_name(struct maps *maps, const char *name)
-{
-	struct map **mapp;
-
-	if (maps__maps_by_name(maps) == NULL &&
-	    map__groups__sort_by_name_from_rbtree(maps))
-		return NULL;
-
-	mapp = bsearch(name, maps__maps_by_name(maps), maps__nr_maps(maps),
-		       sizeof(*mapp), map__strcmp_name);
-	if (mapp)
-		return *mapp;
-	return NULL;
-}
-
-struct map *maps__find_by_name(struct maps *maps, const char *name)
-{
-	struct map_rb_node *rb_node;
-	struct map *map;
-
-	down_read(maps__lock(maps));
-
-
-	if (RC_CHK_ACCESS(maps)->last_search_by_name) {
-		const struct dso *dso = map__dso(RC_CHK_ACCESS(maps)->last_search_by_name);
-
-		if (strcmp(dso->short_name, name) == 0) {
-			map = RC_CHK_ACCESS(maps)->last_search_by_name;
-			goto out_unlock;
-		}
-	}
-	/*
-	 * If we have maps->maps_by_name, then the name isn't in the rbtree,
-	 * as maps->maps_by_name mirrors the rbtree when lookups by name are
-	 * made.
-	 */
-	map = __maps__find_by_name(maps, name);
-	if (map || maps__maps_by_name(maps) != NULL)
-		goto out_unlock;
-
-	/* Fallback to traversing the rbtree... */
-	maps__for_each_entry(maps, rb_node) {
-		struct dso *dso;
-
-		map = rb_node->map;
-		dso = map__dso(map);
-		if (strcmp(dso->short_name, name) == 0) {
-			RC_CHK_ACCESS(maps)->last_search_by_name = map;
-			goto out_unlock;
-		}
-	}
-	map = NULL;
-
-out_unlock:
-	up_read(maps__lock(maps));
-	return map;
-}
-
 int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, bool vmlinux_allocated)
 {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index af87c46b3f89e..071837ddce2ac 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -189,7 +189,6 @@ void __symbols__insert(struct rb_root_cached *symbols, struct symbol *sym,
 void symbols__insert(struct rb_root_cached *symbols, struct symbol *sym);
 void symbols__fixup_duplicate(struct rb_root_cached *symbols);
 void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms);
-void maps__fixup_end(struct maps *maps);
 
 typedef int (*mapfn_t)(u64 start, u64 len, u64 pgoff, void *data);
 int file__read_maps(int fd, bool exe, mapfn_t mapfn, void *data,
-- 
2.43.0



