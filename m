Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060656;
	b=ihpi1KlvOEO33EjkeR9vTuBC1TYJKZdrrSYbbSqIwcBIGNulmREQb9UeLMTnoBBRRy/8
	 XjbrkBKMptnTc/jKVUlSXMkiY6Ka4chFsvy8vvzoSpX50wS/D6kCahNjsA2UnbkoI3IGl
	 f7KRhOjbwyb+eFO6pDbmWffxTzKPkDvz4SBMHJ5fEC1fyi+EbX+G9eJYJf/HnoL9Md5v/
	 6gi6hO088bRupICfzqAIOt1IWzbQEcp2pO/kAcWoRKNRERag9OHx9rFzbP0ITivxPEgag
	 FuWd78kPzTyAS9MLdilVQ47YZKq/89F7aFxg8sCSfEjXl7KpgqPDIrWM5dMzofPEjNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PTVsxBVkRG8GDDw+xoWJfXsOvwXvtYJ4GYpbbA7egcM=;
	b=EpZd1QyzVKls18mfd5uJmadgnUyBLjB4sraSQ+/t6IeHjILdqQ04mID5IN6lAvPUZk6w
	 YH2nJyHODYHY3I8tw8vXf4iXZW+XyME85GoBewDicPMcFZK1v6lnN9x/BTQuc9RCvfQPu
	 LqlzdZtS3GFY+UtF4hY1Xtyen41gxEMmoQ/u6C4QvqaMOdQFLcVuG5s+wkOTeksd1BASZ
	 62KNej3KWz9dHwv9OmS/pQGJ6u6k+jJCaQxuZWYzDLyT2vALvo7EtLldy80PkBX4OyYXn
	 QkCPb7Me6KiOtKkbCQz9tT/Y091SEDK587oOCFL9bniMDW+5D+uveZdMX4Z1E0EzraA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfhfEu4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2AA606A325;
	Thu, 19 Nov 2026 03:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfhfEu4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2811F000C4;
	Thu, 19 Nov 2026 03:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060656;
	bh=PTVsxBVkRG8GDDw+xoWJfXsOvwXvtYJ4GYpbbA7egcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfhfEu4yOTkVqnpsph0e4RXxXPWgAcx7XNTxaRkroV1us1mgZI88SPh3y4bT7Q2Pl
	 dcYVvQngTEQqNQcVu20d0ps+hyp0BoLm0S5SVrPn+FEcwfqlm7dc6TZtAHAsVQc8uw
	 FJaOz0T3U8Sr9SXblssDqN4yKW8Yu+GB7gb6vI3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1276/1848] kconfig: remove unneeded symbol_empty variable
Date: Wed, 18 Nov 2026 15:55:14 +0100
Message-ID: <20261118150013.035995171@linuxfoundation.org>
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
index 1a99c6046db2b..d4a8ab6ce0520 100644
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
 
@@ -349,7 +343,7 @@ void sym_calc_value(struct symbol *sym)
 	case S_INT:
 	case S_HEX:
 	case S_STRING:
-		newval = symbol_empty.curr;
+		newval.val = "";
 		break;
 	case S_BOOLEAN:
 	case S_TRISTATE:
@@ -700,13 +694,12 @@ const char *sym_get_string_default(struct symbol *sym)
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



