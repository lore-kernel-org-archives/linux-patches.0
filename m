Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060821;
	b=d7VFV9dkjxk7gDrMukXOfURVjRCDJ78uPbDmQv/HdBMbavyGv/1RSQArlPBNkG902SDM
	 hIJ8OLzbaw0VxJQjglTOu8YfSOFAWZkjlFsZ+L4Yk/zFJD3yx7kDKFFCbNMxi0W77LkGt
	 iAcV1bvvy3TFO1d4AFWNE5U8a9OyXELWLj1mKPNUUEnEUh/+ilkFreN2QDiRJd8YA1dSJ
	 GtzPIGeN3AbwnPYOh0v+fYziWeWkAKZBBc4OwJXoJaHvO4us77KCjGqlNK5Gzf8KP+06j
	 eWSNEXQbu9gh4pj+/rkqNgOXnfrtYqTtkUaQIflaR3mAxIwKYIr9GjIb9eEXpyft8dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zr+R3dHbKH1fRr9CBI9KUpnBnwq1xUi47GPYlkXOBGs=;
	b=w0R7d5DYTiKMuVqaPhmd/K1Ou8HGRUlk0h1KUhQmAV/PYBc3P2KM6Ir4tLH9ADEDnakL
	 54J0dAJRphDa2c04E1a8ac5cCPe63/nVSz/4EGGPcUfxcYcT4k7zTLQ4wELcjhKcC8l3v
	 7CxV5Pt6izup9x2phz7NELzKHoFia1EZ4e43HcvvjJCFW2hPQ0j8/6PtO4cva3XuAxpRn
	 oADlf59jfW3SRZYoRIzh8JiApHB3OW6S3FXkgJE6ceAamqkUl7Jn1ms//15Ck0n6Sf484
	 XRZPng3Yv2L0i9BRn/d6J7ftgQb26XVOrL3VlnAILG/lXMiSnPOIAJxfgK1ox85deLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5D+tNXC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF34D606A331;
	Thu, 19 Nov 2026 04:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P5D+tNXC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1B81F000C4;
	Thu, 19 Nov 2026 04:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060821;
	bh=Zr+R3dHbKH1fRr9CBI9KUpnBnwq1xUi47GPYlkXOBGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5D+tNXCEV6Y3PPVl2+EU6yxsAB2RuYn6tqIGYsdSagz7qM//fb/blS87n8X8MEtV
	 WwxH1R25d4jlJK9bbNkNecE53QJUGIByK7/6tiaAz0u4a/TC+sab3/TGLYw++HFs7M
	 YMTH47eQQ/KW3R7By+fbagEu481+7HjICVBovkdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1337/1848] kconfig: move conf_rewrite_mod_or_yes() to conf.c
Date: Wed, 18 Nov 2026 15:56:15 +0100
Message-ID: <20261118150015.688099480@linuxfoundation.org>
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

[ Upstream commit 15e68d09458f1b417f3129674b89ff91a1070f15 ]

This function is only used in conf.c.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: 9f01cd3a3243 ("kconfig: warn about malformed KCONFIG_PROBABILITY values")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c     | 15 +++++++++++++++
 scripts/kconfig/confdata.c | 15 ---------------
 scripts/kconfig/lkc.h      |  1 -
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 05901b749fb3d..820660804cc87 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -113,6 +113,21 @@ static void set_randconfig_seed(void)
 	srand(seed);
 }
 
+static void conf_rewrite_mod_or_yes(enum conf_def_mode mode)
+{
+	struct symbol *sym;
+	int i;
+	tristate old_val = (mode == def_y2m) ? yes : mod;
+	tristate new_val = (mode == def_y2m) ? mod : yes;
+
+	for_all_symbols(i, sym) {
+		if (sym_get_type(sym) == S_TRISTATE &&
+		    sym->def[S_DEF_USER].tri == old_val)
+			sym->def[S_DEF_USER].tri = new_val;
+	}
+	sym_clear_all_valid();
+}
+
 static int conf_askvalue(struct symbol *sym, const char *def)
 {
 	enum symbol_type type = sym_get_type(sym);
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 9457ff03cf67e..884dabd94a13a 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1344,18 +1344,3 @@ bool conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	return has_changed;
 }
-
-void conf_rewrite_mod_or_yes(enum conf_def_mode mode)
-{
-	struct symbol *sym;
-	int i;
-	tristate old_val = (mode == def_y2m) ? yes : mod;
-	tristate new_val = (mode == def_y2m) ? mod : yes;
-
-	for_all_symbols(i, sym) {
-		if (sym_get_type(sym) == S_TRISTATE &&
-		    sym->def[S_DEF_USER].tri == old_val)
-			sym->def[S_DEF_USER].tri = new_val;
-	}
-	sym_clear_all_valid();
-}
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 4f708a8724c36..8f554ca39140d 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -54,7 +54,6 @@ const char *conf_get_configname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
 bool conf_set_all_new_symbols(enum conf_def_mode mode);
-void conf_rewrite_mod_or_yes(enum conf_def_mode mode);
 void set_all_choice_values(struct symbol *csym);
 
 /* confdata.c and expr.c */
-- 
2.53.0



