Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B5E19644F;
	Thu,  6 Jun 2024 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682970; cv=none; b=Lgo4vlboRJPiqUKQDlb+bsIZaUwTOr0fLRLAz40p+Cj3dvvKBl0aEPg6a2PZ8v84T/YzcqXwadv4Ik/2DZtb3zvDtNEVSVS7DJ0B8Z04bT4wYOCHC8AKVNgyIsapcbJZI5lvK2bRv118ktVERMlVyvBLv3RhP+BuGe1mDfqSzUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682970; c=relaxed/simple;
	bh=50Nmvw6Nc8D9HBEKaEesQHEJDxIF6CD5GzOlgFTDq5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeAEnKc2IlB/TfVza/UcyytWFK9PdD19FzJsnSUr4u51MVvBlwO+YKCWVWC2jrqAChuSmhP+gjf2K4bP81bTzOqZIJxK3krim2o33YEWf7vTJocIl+2oYSxaF7PyOIAsg3rHXSsPjtPblLkVKUzsGoiR6V0oQr/dpDeeTHUL5c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASgVGf23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASgVGf23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76468C2BD10;
	Thu,  6 Jun 2024 14:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682970;
	bh=50Nmvw6Nc8D9HBEKaEesQHEJDxIF6CD5GzOlgFTDq5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASgVGf23RXjYELKAEmnmJp23pbLIUFymHFctMypyBTQylWNsueIeICQWE1X8Srjcf
	 Lv++4T8hkF0te0pYzGJ/oQZrOIHEpkRkpoJdoA6gygJHJKm+K4qopPqI7SQqf2XkYQ
	 ji/R1111hs5jLvNPVeIQyB2q+qYkyAM8EGzQeFq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 102/374] perf dwarf-aux: Add die_collect_vars()
Date: Thu,  6 Jun 2024 16:01:21 +0200
Message-ID: <20240606131655.332457142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 932dcc2c39aedf54ef291bc0b4129a54f5fe1e84 ]

The die_collect_vars() is to find all variable information in the scope
including function parameters.  The struct die_var_type is to save the
type of the variable with the location (reg and offset) as well as where
it's defined in the code (addr).

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20240319055115.4063940-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: c9d492378fae ("perf dwarf-aux: Fix build with HAVE_DWARF_CFI_SUPPORT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 118 +++++++++++++++++++++++++++---------
 tools/perf/util/dwarf-aux.h |  17 ++++++
 2 files changed, 107 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index f7f7171539d3c..ff1874ae0832e 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1136,6 +1136,40 @@ int die_get_varname(Dwarf_Die *vr_die, struct strbuf *buf)
 	return ret < 0 ? ret : strbuf_addf(buf, "\t%s", dwarf_diename(vr_die));
 }
 
+#if defined(HAVE_DWARF_GETLOCATIONS_SUPPORT) || defined(HAVE_DWARF_CFI_SUPPORT)
+static int reg_from_dwarf_op(Dwarf_Op *op)
+{
+	switch (op->atom) {
+	case DW_OP_reg0 ... DW_OP_reg31:
+		return op->atom - DW_OP_reg0;
+	case DW_OP_breg0 ... DW_OP_breg31:
+		return op->atom - DW_OP_breg0;
+	case DW_OP_regx:
+	case DW_OP_bregx:
+		return op->number;
+	default:
+		break;
+	}
+	return -1;
+}
+
+static int offset_from_dwarf_op(Dwarf_Op *op)
+{
+	switch (op->atom) {
+	case DW_OP_reg0 ... DW_OP_reg31:
+	case DW_OP_regx:
+		return 0;
+	case DW_OP_breg0 ... DW_OP_breg31:
+		return op->number;
+	case DW_OP_bregx:
+		return op->number2;
+	default:
+		break;
+	}
+	return -1;
+}
+#endif /* HAVE_DWARF_GETLOCATIONS_SUPPORT || HAVE_DWARF_CFI_SUPPORT */
+
 #ifdef HAVE_DWARF_GETLOCATIONS_SUPPORT
 /**
  * die_get_var_innermost_scope - Get innermost scope range of given variable DIE
@@ -1493,41 +1527,69 @@ Dwarf_Die *die_find_variable_by_addr(Dwarf_Die *sc_die, Dwarf_Addr pc,
 		*offset = data.offset;
 	return result;
 }
-#endif /* HAVE_DWARF_GETLOCATIONS_SUPPORT */
 
-#ifdef HAVE_DWARF_CFI_SUPPORT
-static int reg_from_dwarf_op(Dwarf_Op *op)
+static int __die_collect_vars_cb(Dwarf_Die *die_mem, void *arg)
 {
-	switch (op->atom) {
-	case DW_OP_reg0 ... DW_OP_reg31:
-		return op->atom - DW_OP_reg0;
-	case DW_OP_breg0 ... DW_OP_breg31:
-		return op->atom - DW_OP_breg0;
-	case DW_OP_regx:
-	case DW_OP_bregx:
-		return op->number;
-	default:
-		break;
-	}
-	return -1;
+	struct die_var_type **var_types = arg;
+	Dwarf_Die type_die;
+	int tag = dwarf_tag(die_mem);
+	Dwarf_Attribute attr;
+	Dwarf_Addr base, start, end;
+	Dwarf_Op *ops;
+	size_t nops;
+	struct die_var_type *vt;
+
+	if (tag != DW_TAG_variable && tag != DW_TAG_formal_parameter)
+		return DIE_FIND_CB_SIBLING;
+
+	if (dwarf_attr(die_mem, DW_AT_location, &attr) == NULL)
+		return DIE_FIND_CB_SIBLING;
+
+	/*
+	 * Only collect the first location as it can reconstruct the
+	 * remaining state by following the instructions.
+	 * start = 0 means it covers the whole range.
+	 */
+	if (dwarf_getlocations(&attr, 0, &base, &start, &end, &ops, &nops) <= 0)
+		return DIE_FIND_CB_SIBLING;
+
+	if (die_get_real_type(die_mem, &type_die) == NULL)
+		return DIE_FIND_CB_SIBLING;
+
+	vt = malloc(sizeof(*vt));
+	if (vt == NULL)
+		return DIE_FIND_CB_END;
+
+	vt->die_off = dwarf_dieoffset(&type_die);
+	vt->addr = start;
+	vt->reg = reg_from_dwarf_op(ops);
+	vt->offset = offset_from_dwarf_op(ops);
+	vt->next = *var_types;
+	*var_types = vt;
+
+	return DIE_FIND_CB_SIBLING;
 }
 
-static int offset_from_dwarf_op(Dwarf_Op *op)
+/**
+ * die_collect_vars - Save all variables and parameters
+ * @sc_die: a scope DIE
+ * @var_types: a pointer to save the resulting list
+ *
+ * Save all variables and parameters in the @sc_die and save them to @var_types.
+ * The @var_types is a singly-linked list containing type and location info.
+ * Actual type can be retrieved using dwarf_offdie() with 'die_off' later.
+ *
+ * Callers should free @var_types.
+ */
+void die_collect_vars(Dwarf_Die *sc_die, struct die_var_type **var_types)
 {
-	switch (op->atom) {
-	case DW_OP_reg0 ... DW_OP_reg31:
-	case DW_OP_regx:
-		return 0;
-	case DW_OP_breg0 ... DW_OP_breg31:
-		return op->number;
-	case DW_OP_bregx:
-		return op->number2;
-	default:
-		break;
-	}
-	return -1;
+	Dwarf_Die die_mem;
+
+	die_find_child(sc_die, __die_collect_vars_cb, (void *)var_types, &die_mem);
 }
+#endif /* HAVE_DWARF_GETLOCATIONS_SUPPORT */
 
+#ifdef HAVE_DWARF_CFI_SUPPORT
 /**
  * die_get_cfa - Get frame base information
  * @dwarf: a Dwarf info
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 85dd527ae1f70..efafd3a1f5b6f 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -135,6 +135,15 @@ void die_skip_prologue(Dwarf_Die *sp_die, Dwarf_Die *cu_die,
 /* Get the list of including scopes */
 int die_get_scopes(Dwarf_Die *cu_die, Dwarf_Addr pc, Dwarf_Die **scopes);
 
+/* Variable type information */
+struct die_var_type {
+	struct die_var_type *next;
+	u64 die_off;
+	u64 addr;
+	int reg;
+	int offset;
+};
+
 #ifdef HAVE_DWARF_GETLOCATIONS_SUPPORT
 
 /* Get byte offset range of given variable DIE */
@@ -150,6 +159,9 @@ Dwarf_Die *die_find_variable_by_addr(Dwarf_Die *sc_die, Dwarf_Addr pc,
 				     Dwarf_Addr addr, Dwarf_Die *die_mem,
 				     int *offset);
 
+/* Save all variables and parameters in this scope */
+void die_collect_vars(Dwarf_Die *sc_die, struct die_var_type **var_types);
+
 #else /*  HAVE_DWARF_GETLOCATIONS_SUPPORT */
 
 static inline int die_get_var_range(Dwarf_Die *sp_die __maybe_unused,
@@ -178,6 +190,11 @@ static inline Dwarf_Die *die_find_variable_by_addr(Dwarf_Die *sc_die __maybe_unu
 	return NULL;
 }
 
+static inline void die_collect_vars(Dwarf_Die *sc_die __maybe_unused,
+				    struct die_var_type **var_types __maybe_unused)
+{
+}
+
 #endif /* HAVE_DWARF_GETLOCATIONS_SUPPORT */
 
 #ifdef HAVE_DWARF_CFI_SUPPORT
-- 
2.43.0



