Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048353;
	b=P2do1xpS9MQwX0je/IpWqFfmI/h0Wvyh+LZM5ei3edRtAhhsJ0kXzGbXFhifR4K+5W2R
	 TubgK1G4fCbp7gtNAxV/+ygjIME2EN/nYoYkJb5lQ8rDQkIqWkZoJDN1vebqTi7m9lM78
	 PEdCgaq6Evhb9uA6Zb5ZPT28qcN/f+i9ODMK8Rxfz67iljFYAJx2dAv5tsgwIqCD6YVG+
	 0rFa6+qI8MRZa4Cge4J7yp9K7EZGYHeHVsz+qKKuEbY+eXVe23NXZIZjy+zhh7xB18DLt
	 BkweK2xx4LblnINfv1RMXPxe4tkbNSFA+Ztlj3X+CI0wPVfMrEvwC/U5TXV1qO/fiew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0wpDoxI4fDjZnNzPOrhb9w5L0SZLaSnXKwWs67jlNCg=;
	b=0ck1aglvZgBDlZDYifv7tZ202G7I9loV7Br5pBU77XV2g784IBHUQ7Tg3/2X9SWkvkYs
	 uWuJLg/dMEnwPdLRvN3eyad+D5J8rJqeTNODXX9jXr/3Nl2NJZq/4nhfk68YRCPj7eC7U
	 XsthpTs7M7SV7P0CWiqucc+TJMbYrwfuwQ2/wmZj/fRkrcmpQ1S/sVzGxjdLdZuKLqgJd
	 flxmt7p+5HA0Tdmtd/zWmO7Mieqx6+j+CiHL8wAPYlaZ4FHA0/b/uMjB8XW6ODMJvs93/
	 M4E2Wd1Frcg2ueaVSoCC/Wi1HUlElzV0Xwpop/nkSnpV5z6xGtIn9g7E+WwKaZbRdAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cY2vaMA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684FA606A325;
	Thu, 19 Nov 2026 00:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cY2vaMA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7001F000C4;
	Thu, 19 Nov 2026 00:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048353;
	bh=0wpDoxI4fDjZnNzPOrhb9w5L0SZLaSnXKwWs67jlNCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cY2vaMAa4bpQWiWxqqOiQxRupLQfqNWNShNMGYtK4y5OwwK9Ubjxip50aeMAwnSd
	 6RMGk/Kixp/cpWRzUTnA1ohZuBcexS+kpeoaeJ6NmBMSSJk6wHa8OuUWlm7eG9RJKq
	 BLiP3S+qsdWT+tpIArdefUIm1Yo7fUgA+kTsrN4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1964/2857] kconfig: remove unneeded symbol_empty variable
Date: Wed, 18 Nov 2026 15:49:58 +0100
Message-ID: <20261118150312.122181779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1c0306c9d74e2..dc8edb0ac5236 100644
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



