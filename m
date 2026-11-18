Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055146;
	b=0wRpIR8odgJ0SPHLih/3i3IjJg5hGv17sgEeStFos0ia76XTmWtpvKWt+UsQqhsoHFvK
	 /oC6IeREpqkJS6Dw6uhFy/L15zaQNeXCtqUy3j+uhdQcJgVWR7wFUfDwbSJkfWm8Q7vNH
	 pOfWGRicjwTXan/h3v05RpHTQy9N5vUbSzJ0eIYF+I3TG8DVA6BgrLYyR3rofBrL1lZDr
	 V330lF6Mf6LpfQBF10dXaE8tjrWnAkZUb8U0zdv2GV1sNLNOUhx5eMSzHEDDdFRZ2g6uy
	 mGRVzo3l51PQfkbdlb3CugILkluP7WsDta/xvGmq34sL2Jc/y4AuLb83KzhLDcNwssg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3L36loyeliEL5hQGwKnOqMKhtMtow3fuyKGKZAjLBKg=;
	b=NMRIE4zZ2PhGGEMcAMmrHHDzzQSixluZ/EC2o5FQEMIHTEbxOpUS9wwYVb87iGJ0tCSA
	 ioB5eGlMB89mu7Uq3/GDw0nAIuqCwW20bKAwQIS5tJsdmh9iV5XG0KMdkSwHaWz5XMQpc
	 oVTjuoLIjsRNsEj3eOGNUgpPL9zJmRo/XI9Ejr9lX/KcsoZlmhCi5ThLIbciM9t9cJ2c9
	 hKPgonT4ebNIOCFayxpBktHsgyfjQ75rpk9VoP6vEXHJzIXH50TfOldurRRJ42S87ZkeG
	 sqkh044UbIZDHAYS/b/gP3GMQrr7OmS+mw1WEYT7BUAeBVBzr6ZaZ/zLUMi8zcQsWCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWRhqa7j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9963B606A31C;
	Thu, 19 Nov 2026 02:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWRhqa7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED28D1F000C4;
	Thu, 19 Nov 2026 02:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055146;
	bh=3L36loyeliEL5hQGwKnOqMKhtMtow3fuyKGKZAjLBKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWRhqa7j5zy2IB1foBgxl9C3OpHp+7YGm1yeP/3ZmHoO/CKH96elaFsV+BponXv8I
	 GQHM/ZzslEIEAIHqDR16V2Jr9j58m4ix74mHb8Ogv3GtVpKhagbHjwueyX2L2e8g67
	 Z1biILX36tpSH+Iml7z/Gk2Xsh8RMS0t4Xkw+J0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1527/2214] kconfig: remove unneeded symbol_empty variable
Date: Wed, 18 Nov 2026 15:53:23 +0100
Message-ID: <20261118150113.284325485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 4e244c10eab345a735c5052688e4a55bddce5bf7 ]

This is used only for initializing other variables.

Use the empty string "" directly.

Please note newval.tri is unused for S_INT/HEX/STRING.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: dbe1ae2304a3 ("kconfig: fix extra output from savedefconfig on out-of-range defaults")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/symbol.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index d1e9c06456ae6..b978f1d09fba1 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -32,12 +32,6 @@ struct symbol symbol_no = {
 	.flags = SYMBOL_CONST|SYMBOL_VALID,
 };
 
-static struct symbol symbol_empty = {
-	.name = "",
-	.curr = { "", no },
-	.flags = SYMBOL_VALID,
-};
-
 struct symbol *modules_sym;
 static tristate modules_val;
 static int sym_warnings;
@@ -359,7 +353,7 @@ void sym_calc_value(struct symbol *sym)
 	case S_INT:
 	case S_HEX:
 	case S_STRING:
-		newval = symbol_empty.curr;
+		newval.val = "";
 		break;
 	case S_BOOLEAN:
 	case S_TRISTATE:
@@ -710,13 +704,12 @@ const char *sym_get_string_default(struct symbol *sym)
 {
 	struct property *prop;
 	struct symbol *ds;
-	const char *str;
+	const char *str = "";
 	tristate val;
 
 	sym_calc_visibility(sym);
 	sym_calc_value(modules_sym);
 	val = symbol_no.curr.tri;
-	str = symbol_empty.curr.val;
 
 	/* If symbol has a default value look it up */
 	prop = sym_get_default_prop(sym);
-- 
2.53.0



