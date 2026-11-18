Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060824;
	b=SNwJFC5uau0dUlmMKjUvEQsJ7h/vg3Y5IRbinC+O0n3VmnAcWz2o0ncmBH9XFo8j1bun
	 wHvP27xFIU8z20HBLs1w9Ev//Cg7RjNEO5q7/VFhL8xyiUWFyaX3qEEqSWfJELLN9DLVB
	 vKvZppApzRrApcdSMbsp+EJyCD7xxxUPEn60iuNvZ65zH9Bsh6WsRBEkUcvddDt1Ytd42
	 eE43NtDUlQSu/ATtHOjX+10Jr4fjNXm7R7O1jzTKYD9CqlQPr1iLbeZnWRX+DPF4xnhJ2
	 2RVeeA0eYgRZdUY/hS9qcwuMHFedPv3xWHqKk0ANTdEyu9igy/60xNC45HbmYl3WhkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8O6OOPPx9ipqno5BRDbCVin80IVb0Yn2CkliOm+2a3U=;
	b=SQFoJzLW5E4/r21iIUEuOosUEL7/QTOKKP0LrMs56S0462AxMDByXh4RjzQE35ir6AjJ
	 c8aTEjZ0t8X8A9GamgZA6kD+MD4upBuyHqqAcFrX26btW/Dyp1mWhuVUP6a3+HD2VcG1T
	 W6IzO10PBDktHDwSe9pPVHMl/KQaIlpw66siKOAU3Kll3r8LZkxO+i7nYm7Z+BwPIH4y8
	 0g/LbRgJ7j2A+VrhRATshdzKY03xsnE/IFNEw7FOMV4UV9QJwTx6qZJQkNYv7dYcmLtM/
	 3EiVewPF0C0u6GBbANflXlAQIx/3dP+0jnG88dnrv5k5g/VCHiFNxDy0t9bFNPoXfkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxMyc+0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4179606A330;
	Thu, 19 Nov 2026 04:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uxMyc+0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F341C1F000C4;
	Thu, 19 Nov 2026 04:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060824;
	bh=8O6OOPPx9ipqno5BRDbCVin80IVb0Yn2CkliOm+2a3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxMyc+0mjjPWuR84xfEfaNTRkAXBwqKsbE0Jk7UEvyAy0ODnaimLvwIBhK8hcqux4
	 ygtwhAgNHuwYTOAfVttrM7PQArGT3SJ3W89DDHapAaxwTkTL4zl2KpKSHzrllnqhT6
	 VMvXrWYupkY/MkF0IKF1AzvSmH0iE2uVvMuq8PDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1338/1848] kconfig: move conf_set_all_new_symbols() to conf.c
Date: Wed, 18 Nov 2026 15:56:16 +0100
Message-ID: <20261118150015.724743996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 98f8475c78697f6c1155f93d3a346d9027deb5aa ]

This function is only used in conf.c. Move it there together with the
randomize_choice_values() helper.

Define 'enum conf_def_mode' locally in conf.c as well.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: 9f01cd3a3243 ("kconfig: warn about malformed KCONFIG_PROBABILITY values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c     | 193 +++++++++++++++++++++++++++++++++++++
 scripts/kconfig/confdata.c | 176 ---------------------------------
 scripts/kconfig/lkc.h      |  11 ---
 3 files changed, 193 insertions(+), 187 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 820660804cc87..289ed6f8f047b 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -113,6 +113,199 @@ static void set_randconfig_seed(void)
 	srand(seed);
 }
 
+static bool randomize_choice_values(struct symbol *csym)
+{
+	struct property *prop;
+	struct symbol *sym;
+	struct expr *e;
+	int cnt, def;
+
+	/*
+	 * If choice is mod then we may have more items selected
+	 * and if no then no-one.
+	 * In both cases stop.
+	 */
+	if (csym->curr.tri != yes)
+		return false;
+
+	prop = sym_get_choice_prop(csym);
+
+	/* count entries in choice block */
+	cnt = 0;
+	expr_list_for_each_sym(prop->expr, e, sym)
+		cnt++;
+
+	/*
+	 * find a random value and set it to yes,
+	 * set the rest to no so we have only one set
+	 */
+	def = rand() % cnt;
+
+	cnt = 0;
+	expr_list_for_each_sym(prop->expr, e, sym) {
+		if (def == cnt++) {
+			sym->def[S_DEF_USER].tri = yes;
+			csym->def[S_DEF_USER].val = sym;
+		} else {
+			sym->def[S_DEF_USER].tri = no;
+		}
+		sym->flags |= SYMBOL_DEF_USER;
+		/* clear VALID to get value calculated */
+		sym->flags &= ~SYMBOL_VALID;
+	}
+	csym->flags |= SYMBOL_DEF_USER;
+	/* clear VALID to get value calculated */
+	csym->flags &= ~SYMBOL_VALID;
+
+	return true;
+}
+
+enum conf_def_mode {
+	def_default,
+	def_yes,
+	def_mod,
+	def_y2m,
+	def_m2y,
+	def_no,
+	def_random
+};
+
+static bool conf_set_all_new_symbols(enum conf_def_mode mode)
+{
+	struct symbol *sym, *csym;
+	int i, cnt;
+	/*
+	 * can't go as the default in switch-case below, otherwise gcc whines
+	 * about -Wmaybe-uninitialized
+	 */
+	int pby = 50; /* probability of bool     = y */
+	int pty = 33; /* probability of tristate = y */
+	int ptm = 33; /* probability of tristate = m */
+	bool has_changed = false;
+
+	if (mode == def_random) {
+		int n, p[3];
+		char *env = getenv("KCONFIG_PROBABILITY");
+
+		n = 0;
+		while (env && *env) {
+			char *endp;
+			int tmp = strtol(env, &endp, 10);
+
+			if (tmp >= 0 && tmp <= 100) {
+				p[n++] = tmp;
+			} else {
+				errno = ERANGE;
+				perror("KCONFIG_PROBABILITY");
+				exit(1);
+			}
+			env = (*endp == ':') ? endp + 1 : endp;
+			if (n >= 3)
+				break;
+		}
+		switch (n) {
+		case 1:
+			pby = p[0];
+			ptm = pby / 2;
+			pty = pby - ptm;
+			break;
+		case 2:
+			pty = p[0];
+			ptm = p[1];
+			pby = pty + ptm;
+			break;
+		case 3:
+			pby = p[0];
+			pty = p[1];
+			ptm = p[2];
+			break;
+		}
+
+		if (pty + ptm > 100) {
+			errno = ERANGE;
+			perror("KCONFIG_PROBABILITY");
+			exit(1);
+		}
+	}
+
+	for_all_symbols(i, sym) {
+		if (sym_has_value(sym) || sym->flags & SYMBOL_VALID)
+			continue;
+		switch (sym_get_type(sym)) {
+		case S_BOOLEAN:
+		case S_TRISTATE:
+			has_changed = true;
+			switch (mode) {
+			case def_yes:
+				sym->def[S_DEF_USER].tri = yes;
+				break;
+			case def_mod:
+				sym->def[S_DEF_USER].tri = mod;
+				break;
+			case def_no:
+				if (sym->flags & SYMBOL_ALLNOCONFIG_Y)
+					sym->def[S_DEF_USER].tri = yes;
+				else
+					sym->def[S_DEF_USER].tri = no;
+				break;
+			case def_random:
+				sym->def[S_DEF_USER].tri = no;
+				cnt = rand() % 100;
+				if (sym->type == S_TRISTATE) {
+					if (cnt < pty)
+						sym->def[S_DEF_USER].tri = yes;
+					else if (cnt < pty + ptm)
+						sym->def[S_DEF_USER].tri = mod;
+				} else if (cnt < pby)
+					sym->def[S_DEF_USER].tri = yes;
+				break;
+			default:
+				continue;
+			}
+			if (!(sym_is_choice(sym) && mode == def_random))
+				sym->flags |= SYMBOL_DEF_USER;
+			break;
+		default:
+			break;
+		}
+
+	}
+
+	sym_clear_all_valid();
+
+	/*
+	 * We have different type of choice blocks.
+	 * If curr.tri equals to mod then we can select several
+	 * choice symbols in one block.
+	 * In this case we do nothing.
+	 * If curr.tri equals yes then only one symbol can be
+	 * selected in a choice block and we set it to yes,
+	 * and the rest to no.
+	 */
+	if (mode != def_random) {
+		for_all_symbols(i, csym) {
+			if ((sym_is_choice(csym) && !sym_has_value(csym)) ||
+			    sym_is_choice_value(csym))
+				csym->flags |= SYMBOL_NEED_SET_CHOICE_VALUES;
+		}
+	}
+
+	for_all_symbols(i, csym) {
+		if (sym_has_value(csym) || !sym_is_choice(csym))
+			continue;
+
+		sym_calc_value(csym);
+		if (mode == def_random)
+			has_changed |= randomize_choice_values(csym);
+		else {
+			set_all_choice_values(csym);
+			has_changed = true;
+		}
+	}
+
+	return has_changed;
+}
+
 static void conf_rewrite_mod_or_yes(enum conf_def_mode mode)
 {
 	struct symbol *sym;
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 884dabd94a13a..6fe87c6162ee0 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1149,54 +1149,6 @@ void conf_set_changed_callback(void (*fn)(void))
 	conf_changed_callback = fn;
 }
 
-static bool randomize_choice_values(struct symbol *csym)
-{
-	struct property *prop;
-	struct symbol *sym;
-	struct expr *e;
-	int cnt, def;
-
-	/*
-	 * If choice is mod then we may have more items selected
-	 * and if no then no-one.
-	 * In both cases stop.
-	 */
-	if (csym->curr.tri != yes)
-		return false;
-
-	prop = sym_get_choice_prop(csym);
-
-	/* count entries in choice block */
-	cnt = 0;
-	expr_list_for_each_sym(prop->expr, e, sym)
-		cnt++;
-
-	/*
-	 * find a random value and set it to yes,
-	 * set the rest to no so we have only one set
-	 */
-	def = (rand() % cnt);
-
-	cnt = 0;
-	expr_list_for_each_sym(prop->expr, e, sym) {
-		if (def == cnt++) {
-			sym->def[S_DEF_USER].tri = yes;
-			csym->def[S_DEF_USER].val = sym;
-		}
-		else {
-			sym->def[S_DEF_USER].tri = no;
-		}
-		sym->flags |= SYMBOL_DEF_USER;
-		/* clear VALID to get value calculated */
-		sym->flags &= ~SYMBOL_VALID;
-	}
-	csym->flags |= SYMBOL_DEF_USER;
-	/* clear VALID to get value calculated */
-	csym->flags &= ~(SYMBOL_VALID);
-
-	return true;
-}
-
 void set_all_choice_values(struct symbol *csym)
 {
 	struct property *prop;
@@ -1216,131 +1168,3 @@ void set_all_choice_values(struct symbol *csym)
 	/* clear VALID to get value calculated */
 	csym->flags &= ~(SYMBOL_VALID | SYMBOL_NEED_SET_CHOICE_VALUES);
 }
-
-bool conf_set_all_new_symbols(enum conf_def_mode mode)
-{
-	struct symbol *sym, *csym;
-	int i, cnt, pby, pty, ptm;	/* pby: probability of bool     = y
-					 * pty: probability of tristate = y
-					 * ptm: probability of tristate = m
-					 */
-
-	pby = 50; pty = ptm = 33; /* can't go as the default in switch-case
-				   * below, otherwise gcc whines about
-				   * -Wmaybe-uninitialized */
-	if (mode == def_random) {
-		int n, p[3];
-		char *env = getenv("KCONFIG_PROBABILITY");
-		n = 0;
-		while( env && *env ) {
-			char *endp;
-			int tmp = strtol( env, &endp, 10 );
-			if( tmp >= 0 && tmp <= 100 ) {
-				p[n++] = tmp;
-			} else {
-				errno = ERANGE;
-				perror( "KCONFIG_PROBABILITY" );
-				exit( 1 );
-			}
-			env = (*endp == ':') ? endp+1 : endp;
-			if( n >=3 ) {
-				break;
-			}
-		}
-		switch( n ) {
-		case 1:
-			pby = p[0]; ptm = pby/2; pty = pby-ptm;
-			break;
-		case 2:
-			pty = p[0]; ptm = p[1]; pby = pty + ptm;
-			break;
-		case 3:
-			pby = p[0]; pty = p[1]; ptm = p[2];
-			break;
-		}
-
-		if( pty+ptm > 100 ) {
-			errno = ERANGE;
-			perror( "KCONFIG_PROBABILITY" );
-			exit( 1 );
-		}
-	}
-	bool has_changed = false;
-
-	for_all_symbols(i, sym) {
-		if (sym_has_value(sym) || (sym->flags & SYMBOL_VALID))
-			continue;
-		switch (sym_get_type(sym)) {
-		case S_BOOLEAN:
-		case S_TRISTATE:
-			has_changed = true;
-			switch (mode) {
-			case def_yes:
-				sym->def[S_DEF_USER].tri = yes;
-				break;
-			case def_mod:
-				sym->def[S_DEF_USER].tri = mod;
-				break;
-			case def_no:
-				if (sym->flags & SYMBOL_ALLNOCONFIG_Y)
-					sym->def[S_DEF_USER].tri = yes;
-				else
-					sym->def[S_DEF_USER].tri = no;
-				break;
-			case def_random:
-				sym->def[S_DEF_USER].tri = no;
-				cnt = rand() % 100;
-				if (sym->type == S_TRISTATE) {
-					if (cnt < pty)
-						sym->def[S_DEF_USER].tri = yes;
-					else if (cnt < (pty+ptm))
-						sym->def[S_DEF_USER].tri = mod;
-				} else if (cnt < pby)
-					sym->def[S_DEF_USER].tri = yes;
-				break;
-			default:
-				continue;
-			}
-			if (!(sym_is_choice(sym) && mode == def_random))
-				sym->flags |= SYMBOL_DEF_USER;
-			break;
-		default:
-			break;
-		}
-
-	}
-
-	sym_clear_all_valid();
-
-	/*
-	 * We have different type of choice blocks.
-	 * If curr.tri equals to mod then we can select several
-	 * choice symbols in one block.
-	 * In this case we do nothing.
-	 * If curr.tri equals yes then only one symbol can be
-	 * selected in a choice block and we set it to yes,
-	 * and the rest to no.
-	 */
-	if (mode != def_random) {
-		for_all_symbols(i, csym) {
-			if ((sym_is_choice(csym) && !sym_has_value(csym)) ||
-			    sym_is_choice_value(csym))
-				csym->flags |= SYMBOL_NEED_SET_CHOICE_VALUES;
-		}
-	}
-
-	for_all_symbols(i, csym) {
-		if (sym_has_value(csym) || !sym_is_choice(csym))
-			continue;
-
-		sym_calc_value(csym);
-		if (mode == def_random)
-			has_changed |= randomize_choice_values(csym);
-		else {
-			set_all_choice_values(csym);
-			has_changed = true;
-		}
-	}
-
-	return has_changed;
-}
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 8f554ca39140d..b8ad65037ae34 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -30,16 +30,6 @@ static inline const char *CONFIG_prefix(void)
 #undef CONFIG_
 #define CONFIG_ CONFIG_prefix()
 
-enum conf_def_mode {
-	def_default,
-	def_yes,
-	def_mod,
-	def_y2m,
-	def_m2y,
-	def_no,
-	def_random
-};
-
 extern int yylineno;
 void zconfdump(FILE *out);
 void zconf_starthelp(void);
@@ -53,7 +43,6 @@ const char *zconf_curname(void);
 const char *conf_get_configname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
-bool conf_set_all_new_symbols(enum conf_def_mode mode);
 void set_all_choice_values(struct symbol *csym);
 
 /* confdata.c and expr.c */
-- 
2.53.0



