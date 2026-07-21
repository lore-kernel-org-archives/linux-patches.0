Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CE046D2CC;
	Tue, 21 Jul 2026 18:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659655; cv=none; b=R5VoQzbHSekeXGQgTEJTDy/QVbCGrKBEh8BctQbHHQXUWWfcx9DYyTCtJUzaT6P9WMYTdegQRdtBdzZnYRAjBQBoOPB/C5ARtom+UB/rA6nO6k7w5Ue33hYkKfGf2qQOwPHOf6qvTOjKMjS/EdyArlOpK6dqKKWqFAp4od8Z76w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659655; c=relaxed/simple;
	bh=0ZIjyHi5uxTih6eyUkskUNHKGw+OXXnA0sCt3pmQlyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/YDmK4E1WnKGp9eGRXJkf2j8ewD7nFrLa6FGxvpLQDEFddx1tI5JNORH7IJAFmV1OHzt4QvukETtp0XI5JhnF/4RrQlllOn5pCu+GAK7Gpg3sZ4Id7W9fsfDpRMGD+B7qy/l0L4bu9XDvKIQ5+/OeQeweYHAfAz+iqUFYfC+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvz2C5Bj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvz2C5Bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7F71F00A3A;
	Tue, 21 Jul 2026 18:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659653;
	bh=LvJgQK0MrHsg6qtf8MGl2Ens7MkkbCL4mUgc/IhMKas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvz2C5BjdvPg/FWcFm7GjpgfvBw3wbIrICGG29IyKgRFaTzpcynvWf6pyqbJDH429
	 YccW6h7r/igiW32AKi8uAqoEwJyx3f8DeZDvfXScstUDJ+N4M1ys0l49Oy4mdpp4HU
	 gcyoj+JGEWpdQY4GGAaXhEI532WQWjnbFT3yrG18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.18 1602/1611] pinctrl: airoha: fix pinctrl function mismatch issue
Date: Tue, 21 Jul 2026 17:28:38 +0200
Message-ID: <20260721152551.510089369@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

commit f2bd5a0f59d052d16749bccf637690e51947a5d6 upstream.

The blamed commit made the following changes:

-#define PINCTRL_FUNC_DESC(id)...
-		.desc = PINCTRL_PINFUNCTION(#id, ...
+#define PINCTRL_FUNC_DESC(id, table)...
+		.desc = PINCTRL_PINFUNCTION(#id, ...

-	PINCTRL_FUNC_DESC(pon)...
+	PINCTRL_FUNC_DESC("pon", pon)...

It's clear that the id of funcs doesn't match the definition.
Remove redundant #string from the definition to fix this issue:
pinctrl-airoha ...: invalid function mdio in map table

Fixes: 4043b0c45f85 ("pinctrl: airoha: generalize pins/group/function/confs handling")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Acked-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -35,7 +35,7 @@
 
 #define PINCTRL_FUNC_DESC(id, table)					\
 	{								\
-		.desc = PINCTRL_PINFUNCTION(#id, table##_groups,	\
+		.desc = PINCTRL_PINFUNCTION(id, table##_groups,	\
 					    ARRAY_SIZE(table##_groups)),\
 		.groups = table##_func_group,				\
 		.group_size = ARRAY_SIZE(table##_func_group),		\


