Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060653;
	b=UrOcYwUNXKYup1grmmHxjx50wzSDUPwq2kKRIqvpmwWBVXJyav5/+mIrhuHeuwtPZWgj
	 4NewRNpXkKyfDEGOLEGUYUu+RNlMjOaKDJ+hcIczStPdSVVhxkvSKaLwYCf+MXAfEUBGr
	 1VkSohbiXT6oChyRA8+OCRaf1a+jg4WtGcVfLYJODvUgUxN7BRSmQwHVweOAQeXelPFcI
	 pwd3//G5egQWGLbOdFrT2/gNvOCsUx2f6J4JfEwpqIzvo2kCoJsURtBu4bvvpcH9OGhTY
	 XKDhR2DJ65llo/8OKmJNUpLBQnDG2WNcQDlG+7WX2QYEEEPxSsF3m+E1qbPmZBMZOXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IG/mnIWZsfIHfnUarOTtgBBvDDLiTraaQYtU0CJdtHE=;
	b=SnNGoApNPsgxTXi1NEePZ8wYucUhemX1J+n6qEZvDiMDIScnD8X7JrqDfXWlNP9X0UVl
	 6hoYd0Ta5k/1gvqMyoohfS+KorB0h+31RmnT49FySlgt4MrzEUeTwfDMsHpMdrQQl3/hd
	 vnx/Fd13ERo/DvJjjE/pyKZjELo9oGbpsf7VJcD1No6HyHL8dRuGwIOHEhSFm4xJ3iVc0
	 /eIXxHG+QGkccK+2mdxga44DZah1a1wRoHJiD90JYuWBZW9/YNFjyNboQ+ZDZRhYOG6z+
	 mG5Gt47Wz6lBDXjArVpbHRPLuvahZzoDeLP043a2PPVF8YDE2bQ+nxzwpP/e6d7zpJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELz6V4N7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905CE606A320;
	Thu, 19 Nov 2026 03:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELz6V4N7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984471F000C4;
	Thu, 19 Nov 2026 03:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060653;
	bh=IG/mnIWZsfIHfnUarOTtgBBvDDLiTraaQYtU0CJdtHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELz6V4N7mtQk3u6vEWKlPv/Az+q/BnPBX3SV+P4NoSww7f0fsG0k0cuaY1pb09gNq
	 TMUQQhNuO5vhbxPyWnus+LIpSVoYlJloUtMrPVw7tiKisR/1EW3if+L3DQ5xTbQci3
	 nhPNXZo3IibSpfNm2gARNwTUgSZlJ+0xlLbdKaDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1275/1848] kconfig: change defconfig_list option to environment variable
Date: Wed, 18 Nov 2026 15:55:13 +0100
Message-ID: <20261118150012.998753461@linuxfoundation.org>
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

[ Upstream commit b75b0a819af9f78fc395b189cddd40f590194d20 ]

"defconfig_list" is a weird option that defines a static symbol that
declares the list of base config files in case the .config does not
exist yet.

This is quite different from other normal symbols; we just abused the
"string" type and the "default" properties to list out the input files.
They must be fixed values since these are searched for and loaded in
the parse stage.

It is an ugly hack, and should not exist in the first place. Providing
this feature as an environment variable is a saner approach.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: dbe1ae2304a3 ("kconfig: fix extra output from savedefconfig on out-of-range defaults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/kbuild/kconfig-language.rst |  5 ---
 Documentation/kbuild/kconfig.rst          |  8 +++++
 init/Kconfig                              |  9 ------
 scripts/kconfig/Makefile                  | 10 ++++++
 scripts/kconfig/confdata.c                | 38 +++++++++++++++++------
 scripts/kconfig/expr.h                    |  1 -
 scripts/kconfig/lexer.l                   |  1 -
 scripts/kconfig/lkc.h                     |  1 -
 scripts/kconfig/menu.c                    |  9 ------
 scripts/kconfig/parser.y                  |  6 ----
 scripts/kconfig/symbol.c                  |  1 -
 scripts/kconfig/tests/conftest.py         |  4 +++
 12 files changed, 50 insertions(+), 43 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.rst b/Documentation/kbuild/kconfig-language.rst
index 1cf1aebdd6cdf..4157b324c851e 100644
--- a/Documentation/kbuild/kconfig-language.rst
+++ b/Documentation/kbuild/kconfig-language.rst
@@ -229,11 +229,6 @@ applicable everywhere (see syntax).
   which can modify the behaviour of the menu entry and its config
   symbol. These options are currently possible:
 
-  - "defconfig_list"
-    This declares a list of default entries which can be used when
-    looking for the default configuration (which is used when the main
-    .config doesn't exists yet.)
-
   - "modules"
     This declares the symbol to be used as the MODULES symbol, which
     enables the third modular state for all config symbols.
diff --git a/Documentation/kbuild/kconfig.rst b/Documentation/kbuild/kconfig.rst
index dce6801d66c9b..5967c79c3baa7 100644
--- a/Documentation/kbuild/kconfig.rst
+++ b/Documentation/kbuild/kconfig.rst
@@ -41,6 +41,14 @@ KCONFIG_CONFIG
 This environment variable can be used to specify a default kernel config
 file name to override the default name of ".config".
 
+KCONFIG_DEFCONFIG_LIST
+----------------------
+
+This environment variable specifies a list of config files which can be used
+as a base configuration in case the .config does not exist yet. Entries in
+the list are separated with whitespaces to each other, and the first one
+that exists is used.
+
 KCONFIG_OVERWRITECONFIG
 -----------------------
 If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
diff --git a/init/Kconfig b/init/Kconfig
index a6a4eaec73c88..19f21182da05c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1,13 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config DEFCONFIG_LIST
-	string
-	depends on !UML
-	option defconfig_list
-	default "/lib/modules/$(shell,uname -r)/.config"
-	default "/etc/kernel-config"
-	default "/boot/config-$(shell,uname -r)"
-	default "arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG)"
-
 config CC_VERSION_TEXT
 	string
 	default "$(CC_VERSION_TEXT)"
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index e46df0a2d4f9d..20c0facd2d23c 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -16,6 +16,16 @@ ifeq ($(quiet),silent_)
 silent := -s
 endif
 
+export KCONFIG_DEFCONFIG_LIST :=
+ifneq ($(SRCARCH),um)
+kernel-release := $(shell uname -r)
+KCONFIG_DEFCONFIG_LIST := \
+	/lib/modules/$(kernel-release)/.config \
+	/etc/kernel-config \
+	/boot/config-$(kernel-release) \
+	arch/$(SRCARCH)/configs/$(KBUILD_DEFCONFIG)
+endif
+
 # We need this, in case the user has it in its environment
 unexport CONFIG_
 
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 867b06c6d2797..9457ff03cf67e 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -359,28 +359,46 @@ int conf_read_simple(const char *name, int def)
 	if (name) {
 		in = zconf_fopen(name);
 	} else {
-		struct property *prop;
+		char *env;
 
 		name = conf_get_configname();
 		in = zconf_fopen(name);
 		if (in)
 			goto load;
 		sym_add_change_count(1);
-		if (!sym_defconfig_list)
+
+		env = getenv("KCONFIG_DEFCONFIG_LIST");
+		if (!env)
 			return 1;
 
-		for_all_defaults(sym_defconfig_list, prop) {
-			if (expr_calc_value(prop->visible.expr) == no ||
-			    prop->expr->type != E_SYMBOL)
-				continue;
-			sym_calc_value(prop->expr->left.sym);
-			name = sym_get_string_value(prop->expr->left.sym);
-			in = zconf_fopen(name);
+		while (1) {
+			bool is_last;
+
+			while (isspace(*env))
+				env++;
+
+			if (!*env)
+				break;
+
+			p = env;
+			while (*p && !isspace(*p))
+				p++;
+
+			is_last = (*p == '\0');
+
+			*p = '\0';
+
+			in = zconf_fopen(env);
 			if (in) {
 				conf_message("using defaults found in %s",
-					 name);
+					     env);
 				goto load;
 			}
+
+			if (is_last)
+				break;
+
+			env = p + 1;
 		}
 	}
 	if (!in)
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 385a47daa3643..a2d73ebab554d 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -289,7 +289,6 @@ struct file *lookup_file(const char *name);
 
 extern struct symbol symbol_yes, symbol_no, symbol_mod;
 extern struct symbol *modules_sym;
-extern struct symbol *sym_defconfig_list;
 extern int cdebug;
 struct expr *expr_alloc_symbol(struct symbol *sym);
 struct expr *expr_alloc_one(enum expr_type type, struct expr *ce);
diff --git a/scripts/kconfig/lexer.l b/scripts/kconfig/lexer.l
index 72e5e9ac52bb4..ea65b7d980993 100644
--- a/scripts/kconfig/lexer.l
+++ b/scripts/kconfig/lexer.l
@@ -100,7 +100,6 @@ n	[A-Za-z0-9_-]
 "def_bool"		return T_DEF_BOOL;
 "def_tristate"		return T_DEF_TRISTATE;
 "default"		return T_DEFAULT;
-"defconfig_list"	return T_DEFCONFIG_LIST;
 "depends"		return T_DEPENDS;
 "endchoice"		return T_ENDCHOICE;
 "endif"			return T_ENDIF;
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 8454649b17bd5..4f708a8724c36 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -104,7 +104,6 @@ struct property *menu_add_prompt(enum prop_type type, char *prompt, struct expr
 void menu_add_expr(enum prop_type type, struct expr *expr, struct expr *dep);
 void menu_add_symbol(enum prop_type type, struct symbol *sym, struct expr *dep);
 void menu_add_option_modules(void);
-void menu_add_option_defconfig_list(void);
 void menu_add_option_allnoconfig_y(void);
 void menu_finalize(struct menu *parent);
 void menu_set_type(int type);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index e5ad6313cfa1d..bfd863f1512ca 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -219,15 +219,6 @@ void menu_add_option_modules(void)
 	modules_sym = current_entry->sym;
 }
 
-void menu_add_option_defconfig_list(void)
-{
-	if (!sym_defconfig_list)
-		sym_defconfig_list = current_entry->sym;
-	else if (sym_defconfig_list != current_entry->sym)
-		zconf_error("trying to redefine defconfig symbol");
-	sym_defconfig_list->flags |= SYMBOL_NO_WRITE;
-}
-
 void menu_add_option_allnoconfig_y(void)
 {
 	current_entry->sym->flags |= SYMBOL_ALLNOCONFIG_Y;
diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
index 190f1117f35a2..f11d8382e9e68 100644
--- a/scripts/kconfig/parser.y
+++ b/scripts/kconfig/parser.y
@@ -53,7 +53,6 @@ static struct menu *current_menu, *current_entry;
 %token T_COMMENT
 %token T_CONFIG
 %token T_DEFAULT
-%token T_DEFCONFIG_LIST
 %token T_DEF_BOOL
 %token T_DEF_TRISTATE
 %token T_DEPENDS
@@ -223,11 +222,6 @@ config_option: T_OPTION T_MODULES T_EOL
 	menu_add_option_modules();
 };
 
-config_option: T_OPTION T_DEFCONFIG_LIST T_EOL
-{
-	menu_add_option_defconfig_list();
-};
-
 config_option: T_OPTION T_ALLNOCONFIG_Y T_EOL
 {
 	menu_add_option_allnoconfig_y();
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index ff4c5d314b4d7..1a99c6046db2b 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -38,7 +38,6 @@ static struct symbol symbol_empty = {
 	.flags = SYMBOL_VALID,
 };
 
-struct symbol *sym_defconfig_list;
 struct symbol *modules_sym;
 static tristate modules_val;
 
diff --git a/scripts/kconfig/tests/conftest.py b/scripts/kconfig/tests/conftest.py
index 0345ef6e32739..af8774a5697c8 100644
--- a/scripts/kconfig/tests/conftest.py
+++ b/scripts/kconfig/tests/conftest.py
@@ -53,6 +53,10 @@ class Conf:
         # Override 'srctree' environment to make the test as the top directory
         extra_env['srctree'] = self._test_dir
 
+        # Clear KCONFIG_DEFCONFIG_LIST to keep unit tests from being affected
+        # by the user's environment.
+        extra_env['KCONFIG_DEFCONFIG_LIST'] = ''
+
         # Run Kconfig in a temporary directory.
         # This directory is automatically removed when done.
         with tempfile.TemporaryDirectory() as temp_dir:
-- 
2.53.0



