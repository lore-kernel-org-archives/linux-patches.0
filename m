Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024491;
	b=v7puEzwTfCpzfyNUc/KffF1zn10XyHv/ns5g7TX69R6OkgkjKpSOr6ljpDVH+Dq6lg4V
	 Y/x0Avy1vGfVELAuSDLQdHmkqdqlDkP2YCRcnMfj1pASGC/ht7SrtK4x9TxvXWRu+UyiD
	 XMCa5kMiEayVlkAg1w/lo22VoouhkYb+Kv5SOuI6TIVRlngsot8ygFT5tp9xrUW3bgLqh
	 hG8+A++hThuuULTryIRxJuK7arBkhzRrl3M8lWQNUKd3W4IR+yNc5pTy10KbXooPUrgD5
	 jYAcUDCBPSq8MbmejkKSopEhIA/Vm1qIGz1Epf2n2utYyuWTFXIXf937MvxoGR0hT7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+XzDzLYuTdPXy8QPxN9rbFRU6GBwTrhQDL1njA3Rd0=;
	b=cjoq8VoZ3HsFS3LIqpTTgh/NdwQvvA6iQ43At5MlJfREliYnvccPtP3zmhJS2TRYGP70
	 9FEvEoDjiuts3V2YxJptGwErS4yC8gkIWTzhufNbio54b4v4phI2Gf05dTDhHemuFMWga
	 GpxmlKK62AZVfBmYOCE2KSPuTbD8DWldXGRnNyGisbtIC/IdeR9NNikJrARtiUI7FGiF0
	 m0KZW6KDl6F24+Zwy+Stz/k8+W04ZXx1g99i1O3VcHRSa75nY/wlJZIzg8y//o2/C7DaT
	 KBfK5EpDnO6ftKbb6Bfk9LDtZ5laK9aIEd4Kc/GFfZ5PicQwpm9ZQ3Tir/tn999NDAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="07Or5B/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA34A606A32C;
	Wed, 18 Nov 2026 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07Or5B/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B481F000C6;
	Wed, 18 Nov 2026 17:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024491;
	bh=e+XzDzLYuTdPXy8QPxN9rbFRU6GBwTrhQDL1njA3Rd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07Or5B/NkA8kQ23vNSmoXvm26vIpbiIC7pGDkfd/8RulWuM42Joz3XxYXW6TavKk5
	 7V2iQxG5sSP9HX1vUrJqYfxb7tBzndEudY7uoxuwaB2q9Q1o6BVUlocqcySh+4K2em
	 pW954WibQUSQ9PupYqVTNKCAH7NJt56LDwDCFPiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0745/2151] perf annotate-data: Resolve type DIEs in the debug file they came from
Date: Wed, 18 Nov 2026 15:41:20 +0100
Message-ID: <20261118150149.172218847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 14ca0a28de37849afdda6ffd4c9047f58d8906c2 ]

'perf report -s type' hangs burning CPU on the dwz compressed debug
info of libz.so.1 (zlib-ng): die_collect_vars() saves the
dwarf_dieoffset() of the type DIE, which is relative to the file it
lives in - the dwz alt file for the types shared by more than one CU -
and update_var_state() resolves that offset in the main debug file,
parsing whatever is at it, here a typedef whose DW_AT_type refers to
itself.

Record whether the type DIE came from the alt file and resolve the
offset with die_get_type_die() in that file, with no fallback.

Fixes: 06b2ce75386df04b ("perf annotate-data: Maintain variable type info")
Fixes: 55ee3d005d62279d ("perf annotate-data: Add a cache for global variable types")
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate-data.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/annotate-data.c b/tools/perf/util/annotate-data.c
index 687f381aeaec2..1023adad3ef82 100644
--- a/tools/perf/util/annotate-data.c
+++ b/tools/perf/util/annotate-data.c
@@ -625,6 +625,8 @@ struct global_var_entry {
 	u64 start;
 	u64 end;
 	u64 die_offset;
+	int die_tag;
+	bool from_alt;	/* die_offset is relative to the alt (dwz) file */
 };
 
 static int global_var_cmp(const void *_key, const struct rb_node *node)
@@ -662,7 +664,7 @@ static struct global_var_entry *global_var__find(struct data_loc_info *dloc, u64
 }
 
 static bool global_var__add(struct data_loc_info *dloc, u64 addr,
-			    const char *name, Dwarf_Die *type_die)
+			    const char *name, Dwarf_Die *type_die, bool from_alt)
 {
 	struct dso *dso = map__dso(dloc->ms->map);
 	struct global_var_entry *gvar;
@@ -684,6 +686,8 @@ static bool global_var__add(struct data_loc_info *dloc, u64 addr,
 	gvar->start = addr;
 	gvar->end = addr + size;
 	gvar->die_offset = dwarf_dieoffset(type_die);
+	gvar->die_tag = dwarf_tag(type_die);
+	gvar->from_alt = from_alt;
 
 	rb_add(&gvar->node, dso__global_vars(dso), global_var_less);
 	return true;
@@ -758,7 +762,8 @@ static void global_var__collect(struct data_loc_info *dloc)
 			if (pos->reg != -1)
 				continue;
 
-			if (!dwarf_offdie(dwarf, pos->die_off, &type_die))
+			if (!die_get_type_die(dwarf, pos->die_off, pos->die_tag,
+					      pos->from_alt, &type_die))
 				continue;
 
 			if (!get_global_var_info(dloc, pos->addr, &var_name,
@@ -768,7 +773,8 @@ static void global_var__collect(struct data_loc_info *dloc)
 			if (var_offset != 0)
 				continue;
 
-			global_var__add(dloc, pos->addr, var_name, &type_die);
+			global_var__add(dloc, pos->addr, var_name, &type_die,
+					pos->from_alt);
 		}
 
 		delete_var_types(var_types);
@@ -793,7 +799,8 @@ bool get_global_var_type(Dwarf_Die *cu_die, struct data_loc_info *dloc,
 
 	gvar = global_var__find(dloc, var_addr);
 	if (gvar) {
-		if (!dwarf_offdie(dloc->di->dbg, gvar->die_offset, type_die))
+		if (!die_get_type_die(dloc->di->dbg, gvar->die_offset,
+				      gvar->die_tag, gvar->from_alt, type_die))
 			return false;
 
 		*var_offset = var_addr - gvar->start;
@@ -824,7 +831,8 @@ bool get_global_var_type(Dwarf_Die *cu_die, struct data_loc_info *dloc,
 
 ok:
 	/* The address should point to the start of the variable */
-	global_var__add(dloc, var_addr - *var_offset, var_name, type_die);
+	global_var__add(dloc, var_addr - *var_offset, var_name, type_die,
+			!die_same_file(cu_die, type_die));
 	return true;
 }
 
@@ -861,7 +869,8 @@ static void update_var_state(struct type_state *state, struct data_loc_info *dlo
 		if (var->addr != addr)
 			continue;
 		/* Get the type DIE using the offset */
-		if (!dwarf_offdie(dloc->di->dbg, var->die_off, &mem_die))
+		if (!die_get_type_die(dloc->di->dbg, var->die_off,
+				      var->die_tag, var->from_alt, &mem_die))
 			continue;
 
 		if (var->reg == DWARF_REG_FB || var->reg == fbreg || var->reg == state->stack_reg) {
-- 
2.53.0



