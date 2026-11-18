Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017388;
	b=YYBBg2n5nZSdDaBSn9foIbJADGWPc5F1E3oFtDvJ/6C2965Vuq6UfjDJnlVD9q0XA5p2
	 XU6JENzXqwz4r4ppHTA+D+2MSN78nQiazp+i0d9NdExsVxibGw07iGZARh9tz0mAF5bsV
	 d8ALjMvUA0tSGvBMtMIkaNuD2aCg48oIvjEiq++OSbJx9V/oi+dTUDEk7opXxZ0nG8IJL
	 4toqfhz8Zm/5h65yA739O+3pr5y81qNdmEm3Z/ownuijQZdOUuB8aUwi+K4C5+XJLE3Hl
	 S+HlZlu6XoxjxW7z4l86LHKxDiZ4YinwC4huypinRJyaqoXsdDO7JPrrQgxynMmEI4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ky2Us8OEXjMHOlZ7rbYP1DmBla66Kicv09EG7sbdIjI=;
	b=Kdim0EgSbn4Zq6xQRRt/jkr+OJo1t/zyqGoHaBqd5Lv9lIpFuqR+O+ja0y7JvliCvaRP
	 /AP9UVb/9PhiMBOa6KnpqtotThLMvHCfBXhGl7dXnB+auVTdcnB+//wEeVvbWvcKbwOTs
	 ZgZzGfy57yLEcg3RWGe8dFcJKABzKO6DLaBR8RLAw3Wj50SHYZNlJoor3bHaCYGACWBQQ
	 MdOP3hmKDhz/IYo4RBGpMImIqv6v3gm/jup2gVlGj6icg+rvr5zixCut4Qbk+r88GKAF4
	 7J+v4X5qlnoJEHSF+MW/HHQ4buGzUUpay9wHjXObyB//IDsj4rtUEyweJQtn0rkClkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTevgdrC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62A7606A330;
	Wed, 18 Nov 2026 15:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTevgdrC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FF21F000C7;
	Wed, 18 Nov 2026 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017388;
	bh=Ky2Us8OEXjMHOlZ7rbYP1DmBla66Kicv09EG7sbdIjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTevgdrC3XzSNVKKxBkDm28wbwToc4HCgxZaoQk+bmlznp+muOjoHP8a4W8JD5oRO
	 P3+susN0t8MdKX5N/ky4MkwTNBSpOsuftu2tLZADaCL2TpMX6BNY3fulY5qgsE96oz
	 8lvyUEr5ny4ndO1LEvhhMbZdhDkcDEO3gYQRKNC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0865/2651] perf annotate-data: Resolve type DIEs in the debug file they came from
Date: Wed, 18 Nov 2026 15:35:05 +0100
Message-ID: <20261118150318.997111678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 4e4c587640823..d6f3d1b55f6d6 100644
--- a/tools/perf/util/annotate-data.c
+++ b/tools/perf/util/annotate-data.c
@@ -645,6 +645,8 @@ struct global_var_entry {
 	u64 start;
 	u64 end;
 	u64 die_offset;
+	int die_tag;
+	bool from_alt;	/* die_offset is relative to the alt (dwz) file */
 };
 
 static int global_var_cmp(const void *_key, const struct rb_node *node)
@@ -682,7 +684,7 @@ static struct global_var_entry *global_var__find(struct data_loc_info *dloc, u64
 }
 
 static bool global_var__add(struct data_loc_info *dloc, u64 addr,
-			    const char *name, Dwarf_Die *type_die)
+			    const char *name, Dwarf_Die *type_die, bool from_alt)
 {
 	struct dso *dso = map__dso(dloc->ms->map);
 	struct global_var_entry *gvar;
@@ -704,6 +706,8 @@ static bool global_var__add(struct data_loc_info *dloc, u64 addr,
 	gvar->start = addr;
 	gvar->end = addr + size;
 	gvar->die_offset = dwarf_dieoffset(type_die);
+	gvar->die_tag = dwarf_tag(type_die);
+	gvar->from_alt = from_alt;
 
 	rb_add(&gvar->node, dso__global_vars(dso), global_var_less);
 	return true;
@@ -778,12 +782,14 @@ static void global_var__collect(struct data_loc_info *dloc)
 			if (pos->reg != -1)
 				continue;
 
-			if (!dwarf_offdie(dwarf, pos->die_off, &type_die))
+			if (!die_get_type_die(dwarf, pos->die_off, pos->die_tag,
+					      pos->from_alt, &type_die))
 				continue;
 
 			get_global_var_info(dloc, pos->addr, &var_name, &var_offset);
 
-			global_var__add(dloc, pos->addr, var_name, &type_die);
+			global_var__add(dloc, pos->addr, var_name, &type_die,
+					pos->from_alt);
 		}
 
 		delete_var_types(var_types);
@@ -808,7 +814,8 @@ bool get_global_var_type(Dwarf_Die *cu_die, struct data_loc_info *dloc,
 
 	gvar = global_var__find(dloc, var_addr);
 	if (gvar) {
-		if (!dwarf_offdie(dloc->di->dbg, gvar->die_offset, type_die))
+		if (!die_get_type_die(dloc->di->dbg, gvar->die_offset,
+				      gvar->die_tag, gvar->from_alt, type_die))
 			return false;
 
 		*var_offset = var_addr - gvar->start;
@@ -838,7 +845,8 @@ bool get_global_var_type(Dwarf_Die *cu_die, struct data_loc_info *dloc,
 
 ok:
 	/* The address should point to the start of the variable */
-	global_var__add(dloc, var_addr - *var_offset, var_name, type_die);
+	global_var__add(dloc, var_addr - *var_offset, var_name, type_die,
+			!die_same_file(cu_die, type_die));
 	return true;
 }
 
@@ -893,7 +901,8 @@ static void update_var_state(struct type_state *state, struct data_loc_info *dlo
 				continue;
 		}
 		/* Get the type DIE using the offset */
-		if (!dwarf_offdie(dloc->di->dbg, var->die_off, &mem_die))
+		if (!die_get_type_die(dloc->di->dbg, var->die_off,
+				      var->die_tag, var->from_alt, &mem_die))
 			continue;
 
 		if (var->reg == DWARF_REG_FB || var->reg == fbreg || var->reg == state->stack_reg) {
-- 
2.53.0



