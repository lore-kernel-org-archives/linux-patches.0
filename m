Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057045;
	b=rMuTVNwTotXOAIhLvCuGUS5WXch77Aki2wKUNLessxx+bIEaXbXWfZHga+fRYW0aGOLt
	 xTuL2b+XyVuMKFlhDqzKEf2a1zPLZQ5YCThY9HThjHZGwp1nBfspvWQdewrcy8m0parqQ
	 ebz1j9QnCbECvSNyoeODBSOQU6ixVGFvv3vLpm41vzHRylIkapLP1AkYbXy64cL9W45AW
	 thSV4qtsMGfTw7JDyRIagHZB4qMqy0l111fJ3S8ygYWeTVr/m+wBB5zxxKyfvNjJLiOYB
	 CHTMI9fJ7L6gns7utW6z/Uc7PM1c0GBADB2D8hjYZcUDaw3+y3xsxGLaV4jFeymVbbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pYtaur6VB39ENXSY+y9FtyN2GWCRSYpW7NWKBQHF/7c=;
	b=ievi3MHTq6AX44Vqy4BXCk1kFy1yui91AwBvj8x/6KitYfioV7xS+NIcKF3tZ7VqNXJ3
	 fpAIS2b2tdHh2mszXeayuKVxJmvLKQDmvZrNhDgthUbfQJuB5YaBvklqqE03Sx6uPbHZw
	 HlnIf3WpB2iWwKWs55aGZJqPaFyGqc8HwOoYlw9zmmHgkGxIHjvHsuQQEjInKsvzNkGR2
	 h+wlmx8yQkCFBPCP1MpjWQ9fm6zPFjPkEN1Uc36CDVDtW+VVWRMx8M8u33Y1cCgpzANI/
	 gCPaJzXQyPRaYM+Hvb1fxMb6AuMAY5BzGBtE/ckSszhq0NxPu0ZThFwegVWa4BgnXUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5wGBuRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085D8606A320;
	Thu, 19 Nov 2026 02:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5wGBuRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552EE1F000C6;
	Thu, 19 Nov 2026 02:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057044;
	bh=pYtaur6VB39ENXSY+y9FtyN2GWCRSYpW7NWKBQHF/7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5wGBuRGq6eISFZW7BrmWVds0nvFopkrHhs/D5oOle/Ba/Qoj+iZzu0kI5UmNWseA
	 fETHOoWT1x5C3hqOrj9S59qOGEvph6pN2ryBi/Uo2rg7Pykz2tL+9k6R8aEpUT8Oiy
	 mN6ZklKFTdOAZlBMynwPqbucckHC91ivjKAeMWo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 2203/2214] kconfig: initialize sym->curr.tri to no for all symbol types again
Date: Wed, 18 Nov 2026 16:04:39 +0100
Message-ID: <20261118150138.410346066@linuxfoundation.org>
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

commit bfef491df67022c56aab3b831044f8d259f9441f upstream.

Geert Uytterhoeven reported that commit 4e244c10eab3 ("kconfig: remove
unneeded symbol_empty variable") changed the default value of
CONFIG_LOG_CPU_MAX_BUF_SHIFT from 12 to 0.

As it turned out, this is an undefined behavior because sym_calc_value()
stopped setting the sym->curr.tri field for 'int', 'hex', and 'string'
symbols.

This commit restores the original behavior, where 'int', 'hex', 'string'
symbols are interpreted as false if used in boolean contexts.

CONFIG_LOG_CPU_MAX_BUF_SHIFT will default to 12 again, irrespective
of CONFIG_BASE_SMALL. Presumably, this is not the intended behavior,
as already reported [1], but this is another issue that should be
addressed by a separate patch.

[1]: https://lore.kernel.org/all/f6856be8-54b7-0fa0-1d17-39632bf29ada@oracle.com/

Fixes: 4e244c10eab3 ("kconfig: remove unneeded symbol_empty variable")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Closes: https://lore.kernel.org/all/CAMuHMdWm6u1wX7efZQf=2XUAHascps76YQac6rdnQGhc8nop_Q@mail.gmail.com/
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kconfig/symbol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -364,6 +364,8 @@ void sym_calc_value(struct symbol *sym)
 
 	oldval = sym->curr;
 
+	newval.tri = no;
+
 	switch (sym->type) {
 	case S_INT:
 		newval.val = "0";
@@ -376,7 +378,7 @@ void sym_calc_value(struct symbol *sym)
 		break;
 	case S_BOOLEAN:
 	case S_TRISTATE:
-		newval = symbol_no.curr;
+		newval.val = "n";
 		break;
 	default:
 		sym->curr.val = sym->name;


