Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039871;
	b=CEBgluBBuNX663wsQPWqGvG7gZpDPsYJ/jE1Ut72+7N3vLnX5n4oC1sY23juLpOb8hy4
	 LwvDrVuDsDMdjNtJuEiPwYhHOXxoqrhIi3Fbt7U44AteZ/kHxA/86HchFvxmzwLIXM0RC
	 t7AKYbRFd49s0nCjLtscSmURyFe+0ywpc4+wu8AjSYAh0YoPd181Nq1JAeLCt12IdlcwS
	 bpxJhsgSrllKGvOFkndjRmCm/JyDlgwb13LgrRQUIN80qrLz1yj+tkOnMGOvCs7/SLe+G
	 8kWzirWhpdmAUG0Xc1aFFjDINxYvzek4w6Tz+AqVGNbRdDZQf3ejSHhuFx/tU7e3hqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HDyRjg/uWTn2X4FB6Nh155+qplbtLVk51htgrkEa+KI=;
	b=e1WfpisIOqdi5QGCrfan4OmckfxAOj7t0SeBPOAglIUas+PeGHlfFNNH5QmbM6KItrWq
	 JKJcEmF1+xCViOyoQ0HfPVcPIM5gJYRebY54326KpK6FmF5L6S84gK6uEsLhsQcmPyzL7
	 ws2hMUCvttDCHJInoz9I019z+SbB8ye1gXY4lTsg1Ba9fg3m8vzoP895DIEal64tSY9o5
	 i+qZEat/MFPZelpwc73zJw0HEpsZZR1t3nl6g9lf80I/7g9XQwrkqloc9wou7x4uxeWCb
	 lQ3G/Nccfz3u54+x8w+Js6JTSerdz3j111FhcmbS8F/Ii7TrefiXLvtrG4j512nkq5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECgUXLHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08281606A31C;
	Wed, 18 Nov 2026 22:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ECgUXLHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F811F000C4;
	Wed, 18 Nov 2026 22:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039870;
	bh=HDyRjg/uWTn2X4FB6Nh155+qplbtLVk51htgrkEa+KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECgUXLHIYSo7yWjxLpvKVk1FIwyh1B2pcblNXG27+1AkpH0q/ZQB0IV49cvqdwMI3
	 FRFJRvQ/VM0ibato9kgH6Q04J8Oliw9WR+MGztXKk1g4/l75UNFU1xlUsNAbGxpXjk
	 imQPrJ0mUNzmC9Dq1hw5Ecf99z+I+uJL75uEmlqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2255/3318] kconfig: remove unneeded symbol_empty variable
Date: Wed, 18 Nov 2026 15:47:57 +0100
Message-ID: <20261118150429.476892933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



