Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029737;
	b=hQF0sCspTZmUW73QfJYkjKHWxJzZku0CnA5d/e+Ig2/pO5q6AEsptA3R3KlEJNowS5zZ
	 V0XRZpvJjqoCTvA/6SFx7JFKV2jrDE3zSglXW5hYvGu8qpJs8B1HPx4VKbEScxq8znzEK
	 +f05tPk3oVrKB0A9zpffIth7OhMTvdegh/HznVuUWDenKcPkDsHOWZ6krQLNb275Nwkly
	 4LwEmXI9wxB47j6OmuWSQowsvOZw4LV7vo3Eb2Qj/eLe1qzbdn1mUSvY43zKK5Dx76o/l
	 w+9MiX2Qu58CvNbpZzlkL2UyZeTYmSCmrIDDxQ1I1A8nHnJklPklRKSJoHUa6NsTHpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+NiAfUluoIF2cRZchVwy9LKeN2vOEs8g43DaTpBWt0=;
	b=ksEB3SdHj9/Zl8UTWOjK0lMTDdrPVn+pLWnlQXNrNhhZHFf98pCdaoPgNrpFt7angWWR
	 COytpxAcdl5r8skzB2i4+yjr+4G3y0w9JIIaeJQVyvU6H4lmLqH4dKz6K0kzjevTZ7+Xb
	 hmcZTtB2MOLw8TlQseKIUbjrgfKDWdIQMIOMXIz/FxgPFnjfr0yapNMAiQLjriUIrG8GV
	 ijFtyG2IHNT3yIN6MYWwefbNs22S//9ibX2qf5NS1Ys1LhyoTJYAMa7u2if6SvWipVOt4
	 lOfc5G8smwUHMw1Og21j6FVeZF0eK8AQVvPbvkQBFW1Lrbbktt3vd1+YGLdVLyTCjng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ws8vIPeT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7A8606A320;
	Wed, 18 Nov 2026 19:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ws8vIPeT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A951F000C6;
	Wed, 18 Nov 2026 19:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029737;
	bh=v+NiAfUluoIF2cRZchVwy9LKeN2vOEs8g43DaTpBWt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ws8vIPeTmpL+d+NkoOWFTxP4ymmS1yb4CuUV6O5eGeGv2elZgiddTmVW5CzElbzVf
	 svT2C3w1rfKvxZLJgSM3S4pywjb+gwZjQwMscE42z7fmc00b18SB2XPm6Gs3i/9Mf5
	 kFLyVLpJT8lyjGAtjlTyVw0Gza6KiZ1Z2KnPWK5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Julian Braha <julianbraha@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0455/1756] kconfig: fix extra output from savedefconfig on out-of-range defaults
Date: Wed, 18 Nov 2026 15:43:02 +0100
Message-ID: <20261118150026.896782258@linuxfoundation.org>
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit dbe1ae2304a3b02c3bf6ae82895ff232a29f3fee ]

The Kconfig interpreter currently allows defaults that are outside of the
range bounds.

In these cases, the 'sym_validate_range' function will adjust the default
value to the nearest range bound. For example, see this example:

  config A
    int
    range 1 2
    default 16

Here, since the default value of 16 is greater than the bounds, the
effective default value gets adjusted down to the upper bound, 2.

However, 'savedefconfig' writes non-default values, and without being
aware of the automatic adjustment to the range bound, it would write: A=2

This limitation is also documented in a comment: "The following fails to
handle the situation where a default value is further limited by the valid
range."

To resolve this, let's factor out the default-range adjustment logic from
the existing 'sym_validate_range' function into its own
'sym_get_near_range_bound' function for 'savedefconfig' to use too, so
that it compares against the effective value.

Adds tests, accordingly.

Fixes: 7cf3d73b4360 ("kconfig: add savedefconfig")
Assisted-by: Codex:gpt-5.6-sol
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/lkml/CAMuHMdVyUAA3L4mUkSjmnuE3cvj-+N8z-Bhxsh1wa-FQWc=fjw@mail.gmail.com/
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260830221129.2668354-1-julianbraha@gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/symbol.c                      | 39 ++++++++----
 .../kconfig/tests/savedefconfig_range/Kconfig | 60 +++++++++++++++++++
 .../tests/savedefconfig_range/__init__.py     |  8 +++
 .../kconfig/tests/savedefconfig_range/config  |  7 +++
 .../savedefconfig_range/expected_defconfig    |  0
 5 files changed, 102 insertions(+), 12 deletions(-)
 create mode 100644 scripts/kconfig/tests/savedefconfig_range/Kconfig
 create mode 100644 scripts/kconfig/tests/savedefconfig_range/__init__.py
 create mode 100644 scripts/kconfig/tests/savedefconfig_range/config
 create mode 100644 scripts/kconfig/tests/savedefconfig_range/expected_defconfig

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 453721e66c4eb..3aadd9a97a1dd 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -145,7 +145,12 @@ static long long sym_get_range_val(struct symbol *sym, int base)
 	return strtoll(sym->curr.val, NULL, base);
 }
 
-static void sym_validate_range(struct symbol *sym)
+/*
+ * Return the nearest range bound for an out-of-range default value.
+ * Return NULL if the value is valid or the symbol has no active range.
+ */
+static struct symbol *sym_get_near_range_bound(struct symbol *sym,
+					  const char *value)
 {
 	struct property *prop;
 	struct symbol *range_sym;
@@ -160,21 +165,31 @@ static void sym_validate_range(struct symbol *sym)
 		base = 16;
 		break;
 	default:
-		return;
+		return NULL;
 	}
 	prop = sym_get_range_prop(sym);
 	if (!prop)
-		return;
-	val = strtoll(sym->curr.val, NULL, base);
+		return NULL;
+	val = strtoll(value, NULL, base);
 	range_sym = prop->expr->left.sym;
 	val2 = sym_get_range_val(range_sym, base);
 	if (val >= val2) {
 		range_sym = prop->expr->right.sym;
 		val2 = sym_get_range_val(range_sym, base);
 		if (val <= val2)
-			return;
+			return NULL;
 	}
-	sym->curr.val = range_sym->curr.val;
+
+	return range_sym;
+}
+
+static void sym_validate_range(struct symbol *sym)
+{
+	struct symbol *range_sym;
+
+	range_sym = sym_get_near_range_bound(sym, sym->curr.val);
+	if (range_sym)
+		sym->curr.val = range_sym->curr.val;
 }
 
 static void sym_set_changed(struct symbol *sym)
@@ -778,7 +793,7 @@ bool sym_set_string_value(struct symbol *sym, const char *newval)
 const char *sym_get_string_default(struct symbol *sym)
 {
 	struct property *prop;
-	struct symbol *ds;
+	struct symbol *ds, *range_sym;
 	const char *str = "";
 	tristate val;
 
@@ -796,11 +811,6 @@ const char *sym_get_string_default(struct symbol *sym)
 			val = EXPR_AND(expr_calc_value(prop->expr), prop->visible.tri);
 			break;
 		default:
-			/*
-			 * The following fails to handle the situation
-			 * where a default value is further limited by
-			 * the valid range.
-			 */
 			ds = prop_get_symbol(prop);
 			if (ds != NULL) {
 				sym_calc_value(ds);
@@ -844,6 +854,11 @@ const char *sym_get_string_default(struct symbol *sym)
 	default:
 		break;
 	}
+
+	range_sym = sym_get_near_range_bound(sym, str);
+	if (range_sym)
+		str = range_sym->curr.val;
+
 	return str;
 }
 
diff --git a/scripts/kconfig/tests/savedefconfig_range/Kconfig b/scripts/kconfig/tests/savedefconfig_range/Kconfig
new file mode 100644
index 0000000000000..fd59d9082ed5b
--- /dev/null
+++ b/scripts/kconfig/tests/savedefconfig_range/Kconfig
@@ -0,0 +1,60 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Static default and range values
+
+config INT_DEFAULT_ABOVE_RANGE
+	int
+	range 1 1
+	default 16
+
+config INT_DEFAULT_BELOW_RANGE
+	int
+	range 4 8
+	default 2
+
+# Default and range values determined by other options
+
+config RANGE_UPPER_BOUND
+	int
+	default 3
+
+config INT_DYNAMIC_RANGE
+	int
+	range 0 RANGE_UPPER_BOUND
+	default 4
+
+# Hex
+
+config HEX_DEFAULT_ABOVE_RANGE
+	hex
+	range 0x10 0x20
+	default 0x40
+
+# Implicit default value of 0
+
+config INT_IMPLICIT_DEFAULT_ZERO
+	int
+	range 1 4
+
+# Conditional range
+
+config USE_FIRST_RANGE
+	bool
+	default y
+
+config INT_CONDITIONAL_RANGE
+	int
+	range 1 2 if USE_FIRST_RANGE
+	range 3 4 if !USE_FIRST_RANGE
+	default 3
+
+# Conditional default
+
+config USE_DEFAULT
+	bool
+	default y
+
+config INT_CONDITIONAL_DEFAULT
+	int
+	range 1 2
+	default 3 if USE_DEFAULT
diff --git a/scripts/kconfig/tests/savedefconfig_range/__init__.py b/scripts/kconfig/tests/savedefconfig_range/__init__.py
new file mode 100644
index 0000000000000..961454be732c2
--- /dev/null
+++ b/scripts/kconfig/tests/savedefconfig_range/__init__.py
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+"""Test savedefconfig with numerical defaults outside of ranges."""
+
+
+def test(conf):
+    assert conf._run_conf('--savedefconfig=defconfig', dot_config='config',
+                          out_file='defconfig') == 0
+    assert conf.config_matches('expected_defconfig')
diff --git a/scripts/kconfig/tests/savedefconfig_range/config b/scripts/kconfig/tests/savedefconfig_range/config
new file mode 100644
index 0000000000000..d939cfe5fd349
--- /dev/null
+++ b/scripts/kconfig/tests/savedefconfig_range/config
@@ -0,0 +1,7 @@
+CONFIG_INT_DEFAULT_ABOVE_RANGE=1
+CONFIG_INT_DEFAULT_BELOW_RANGE=4
+CONFIG_INT_DYNAMIC_RANGE=3
+CONFIG_HEX_DEFAULT_ABOVE_RANGE=0x20
+CONFIG_INT_IMPLICIT_DEFAULT_ZERO=1
+CONFIG_INT_CONDITIONAL_RANGE=2
+CONFIG_INT_CONDITIONAL_DEFAULT=2
diff --git a/scripts/kconfig/tests/savedefconfig_range/expected_defconfig b/scripts/kconfig/tests/savedefconfig_range/expected_defconfig
new file mode 100644
index 0000000000000..e69de29bb2d1d
-- 
2.53.0



