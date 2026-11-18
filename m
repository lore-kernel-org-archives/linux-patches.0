Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030126;
	b=sa2NvvoAMD7g2lyabfPFLUSQOphyj+XLR5aP4iZW9YiLk0R7dTff1Ah5IaVqEIGqHWUG
	 nemUSGDT7F1yo+fX+XE8fXMREtZr1O9xsoWYYAom4F41uCD9MGovn0KUM7wSfK718bnwZ
	 t1tSuAxM2qBqGsEJmFetcZnwZBSpBbnyj/l86q52x/Nm5crJZhGRiNbxfNpsONUZFXAOD
	 iWSsZBmxY9CQ5wwPzP0eLfeTpfDr1goiXXN5iCmccU2Yt3QWUBcw3OIpu1LMqwx9o6bDv
	 BguoBis409VNeiO3eaSVJUPw8lX1O7yJxnOsKkIf6P+gpqjcw4plNPZJDK8sYF3+d6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1NAdFSOplqR2QWexSPQIX4KXbE0In9VfeUeVazmqwlQ=;
	b=oOrxVrsk13780isgmW6RjnHKGoFh976LMBvhNhLtpZxAQ1NLxHLcHe/hlkyiCwUh8ced
	 VHDrTApnBfifVMVDNnfqERgaiiXoPZJYxxQsBBP4HmAY3yAopJcftJ44TvjHQEn25Ox0H
	 zD/TaLLHdA9Mxid9NDlBEXLO+0YNsz7P1k5yFpu0xfDvbpKk5RhG6GcSmlwBttadyszbS
	 KRHV/6GRvrS8y9LM7/GMNsZHHvhHnHm33IQONAVry6SK9TBIrMQjiKU21VkuA02SO6ZRv
	 pZzxw86eWj4QjxbcK9tOqM9dbtGXS4zlKs9KZpgGm8UwyMDH9+qgxQV5sctoLVF0L/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvrSf6Le;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C424260A2629;
	Wed, 18 Nov 2026 19:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvrSf6Le
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FE01F000CE;
	Wed, 18 Nov 2026 19:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030126;
	bh=1NAdFSOplqR2QWexSPQIX4KXbE0In9VfeUeVazmqwlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvrSf6Le3XHdNAVNir92soQDJtTL8LUPNhBnfWE3CR6NfUrGPDWSDmYRyJOZKNxqB
	 GT0PYVSqjslic9to3DbNkFYEUWAEn//VXUigSmfRAQrrqSvFtisqqFqd2uaz5kX6mB
	 yjo0B99gmEUr/pPc6UWQ0YZiAV6n/vIbAkvyJikM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0593/1756] perf annotate-data: Resolve type DIEs in the debug file they came from
Date: Wed, 18 Nov 2026 15:45:20 +0100
Message-ID: <20261118150032.601984170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 976abedca09ef..b8d06ed52be25 100644
--- a/tools/perf/util/annotate-data.c
+++ b/tools/perf/util/annotate-data.c
@@ -591,6 +591,8 @@ struct global_var_entry {
 	u64 start;
 	u64 end;
 	u64 die_offset;
+	int die_tag;
+	bool from_alt;	/* die_offset is relative to the alt (dwz) file */
 };
 
 static int global_var_cmp(const void *_key, const struct rb_node *node)
@@ -628,7 +630,7 @@ static struct global_var_entry *global_var__find(struct data_loc_info *dloc, u64
 }
 
 static bool global_var__add(struct data_loc_info *dloc, u64 addr,
-			    const char *name, Dwarf_Die *type_die)
+			    const char *name, Dwarf_Die *type_die, bool from_alt)
 {
 	struct dso *dso = map__dso(dloc->ms->map);
 	struct global_var_entry *gvar;
@@ -650,6 +652,8 @@ static bool global_var__add(struct data_loc_info *dloc, u64 addr,
 	gvar->start = addr;
 	gvar->end = addr + size;
 	gvar->die_offset = dwarf_dieoffset(type_die);
+	gvar->die_tag = dwarf_tag(type_die);
+	gvar->from_alt = from_alt;
 
 	rb_add(&gvar->node, dso__global_vars(dso), global_var_less);
 	return true;
@@ -724,7 +728,8 @@ static void global_var__collect(struct data_loc_info *dloc)
 			if (pos->reg != -1)
 				continue;
 
-			if (!dwarf_offdie(dwarf, pos->die_off, &type_die))
+			if (!die_get_type_die(dwarf, pos->die_off, pos->die_tag,
+					      pos->from_alt, &type_die))
 				continue;
 
 			if (!get_global_var_info(dloc, pos->addr, &var_name,
@@ -734,7 +739,8 @@ static void global_var__collect(struct data_loc_info *dloc)
 			if (var_offset != 0)
 				continue;
 
-			global_var__add(dloc, pos->addr, var_name, &type_die);
+			global_var__add(dloc, pos->addr, var_name, &type_die,
+					pos->from_alt);
 		}
 
 		delete_var_types(var_types);
@@ -759,7 +765,8 @@ bool get_global_var_type(Dwarf_Die *cu_die, struct data_loc_info *dloc,
 
 	gvar = global_var__find(dloc, var_addr);
 	if (gvar) {
-		if (!dwarf_offdie(dloc->di->dbg, gvar->die_offset, type_die))
+		if (!die_get_type_die(dloc->di->dbg, gvar->die_offset,
+				      gvar->die_tag, gvar->from_alt, type_die))
 			return false;
 
 		*var_offset = var_addr - gvar->start;
@@ -790,7 +797,8 @@ bool get_global_var_type(Dwarf_Die *cu_die, struct data_loc_info *dloc,
 
 ok:
 	/* The address should point to the start of the variable */
-	global_var__add(dloc, var_addr - *var_offset, var_name, type_die);
+	global_var__add(dloc, var_addr - *var_offset, var_name, type_die,
+			!die_same_file(cu_die, type_die));
 	return true;
 }
 
@@ -827,7 +835,8 @@ static void update_var_state(struct type_state *state, struct data_loc_info *dlo
 		if (var->addr != addr)
 			continue;
 		/* Get the type DIE using the offset */
-		if (!dwarf_offdie(dloc->di->dbg, var->die_off, &mem_die))
+		if (!die_get_type_die(dloc->di->dbg, var->die_off,
+				      var->die_tag, var->from_alt, &mem_die))
 			continue;
 
 		if (var->reg == DWARF_REG_FB || var->reg == fbreg) {
-- 
2.53.0



