Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050834;
	b=i62B7x25veSLXo0slrK7sXakaQPZWCO2FObimlz9FgKpGdCsqs0K9HRe4Q/lqtseFR4L
	 0+un0Dw2eWpTNAYgiM23OVqOBILnKnkaXshuy6GTsl8MRI/zJpRq4HOFUtbubBPGebUbC
	 1nmVXzMm/9UhE3v1QWGXs+dzNhF4e8U34O6kbaHysBWVCYnXs9I7zHkd24YrJcS/dqwK+
	 A/ilE5PaFp06l+LhfyFt48Y7v7Q0PDMuFaCjyXMC64+2D2rNGBfSVWiIwIBdhl7sAOJj2
	 MSUtwNKhKbsSHXD5L2HmpOkxpAJedQTvMp40pjpN/OUCaWpcLxe+Yo6/MtayhuQG1XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t0aVPzy4WffQkEo86QDTqukfy1/peEEdGYIrJMC8KOc=;
	b=iKZFLTdY8gAEULhlQufca75ncgu6E4NjOGqalTOHRs6TeZ3ilzfp1H+AmDTy+kvITu8M
	 4h7H4APtamaadSD9WgFTeCyfwzYDcVJfGEJmymEGkf8RJcbVB/h8JZYMT6WPjf1XIaLBG
	 28egGE/yu8T02tH5eFWArZVDBcI7Fvs6njs3wGgv0b4f7gnnknkMrxR8cyHWInYgGjWsC
	 CclctiMka729IZShLZFotVkdfK/JV6lbhIc1I3OhZv7tg+UiCqmJrY8DNyYFEOQeSuuhv
	 MHRJHu5l5qfO0GXmn7r7Uo1mhD1YjCsu7oHgug9zWxPhWC9Dl2u7unRM4QAdP34fWPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgbmD9aF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E55606A31C;
	Thu, 19 Nov 2026 01:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgbmD9aF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100CC1F000C4;
	Thu, 19 Nov 2026 01:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050834;
	bh=t0aVPzy4WffQkEo86QDTqukfy1/peEEdGYIrJMC8KOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgbmD9aF7z358Pf7bDDtFfs7DGP6wIdZO5AjbTSPKhIHqtahhdtnNQiayf+bUE1V3
	 5m+nusdTMGUEjth0n5igAH69bc4vqSzBMdZnmsQ6WbIaNhY7s4clgA3/NhAVPiD2ti
	 Wn7s17mO80uXlxKEB9W+uhmqk8AdOlNpOXMqesbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1 2850/2857] kconfig: initialize sym->curr.tri to no for all symbol types again
Date: Wed, 18 Nov 2026 16:04:44 +0100
Message-ID: <20261118150344.202128544@linuxfoundation.org>
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


