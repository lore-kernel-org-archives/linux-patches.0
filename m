Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062208;
	b=lRjIifgb2k/cHY42taJ8AyF9dNtlPQy5FZ/UEa1F4ICdsElqQQpgMmAc/0J61H9Yd4V+
	 R+q/UBL3lprZpmU0Kt2NxwIWHbhaJUCUrWYUwqbVibU5y7dL7pnOC/OHUkHv+A/Nvf6Lu
	 wcsETPR5U6FP4C7ep8JO8oxvGg9QiSW8obR0wIH6MoUc8Ilx37tn0vsxYoRBstuZIaNJx
	 1HcL1DtTVmSUmwNjf7tq6y+hMVVhVg7hmxlfDuuB6J8jZGJwsVrUY22Auvm03mPopqTvk
	 KU3Z8rsXxWurypf7T3SDlZim0sNjl8dP55fIB8saTMO8L2tVBG+m+MPyl1zDermQ+dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CXUc58WZN9YsKJBOVanB/IKz5eQmEqwTGzFkjXWnA9I=;
	b=ubn8/cKQ1EYTF0+cYPVfm0gqbTwhvjlqSUB3fvmTDinvO1+gTsZVd/pO/J9acQnMnhxq
	 V0u1Efl5dylqphdO92bpuwFx5VIyW7sxHrbXMuL/zPl/YJYcMT8EYx+EbDP6irnnIcZUC
	 o6n7fiymJy6U9SspmcpFUYvJ1he4FvYBitYQhORAyGpMaXzGGrPq7yKiYm006EJ6oylG4
	 VcnsC/sO6zvLdS10eDCble2z981AcUb5YGNcaGQmJaZZuJPz6tpA/1/UJsJTqwMTDIy1N
	 i3A10sofvvJbH6NkL/bFBw3RzVyYZub3nTNWXPCIf7GbetA+g4SaoMe4by/JxVpOxJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HZjutKhG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05382606A320;
	Thu, 19 Nov 2026 04:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HZjutKhG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5314E1F000C5;
	Thu, 19 Nov 2026 04:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062207;
	bh=CXUc58WZN9YsKJBOVanB/IKz5eQmEqwTGzFkjXWnA9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZjutKhGXYaDry307XnPMbtkmyLtQCev0eOc9SL2QRbXoZVbgf1+aBtDyoyo8cYOL
	 0vzMCQIm4JnduClyZuR7/dxztNR+0l945ZoZooK+wPRQcTcZFjGkDb4CmvnfhaiPOh
	 JwovElO4pWRnvgfNq/JDJOc3LK5wVtbQ21eSFwYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 1829/1848] kconfig: initialize sym->curr.tri to no for all symbol types again
Date: Wed, 18 Nov 2026 16:04:27 +0100
Message-ID: <20261118150036.216972409@linuxfoundation.org>
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
@@ -354,6 +354,8 @@ void sym_calc_value(struct symbol *sym)
 
 	oldval = sym->curr;
 
+	newval.tri = no;
+
 	switch (sym->type) {
 	case S_INT:
 		newval.val = "0";
@@ -366,7 +368,7 @@ void sym_calc_value(struct symbol *sym)
 		break;
 	case S_BOOLEAN:
 	case S_TRISTATE:
-		newval = symbol_no.curr;
+		newval.val = "n";
 		break;
 	default:
 		sym->curr.val = sym->name;


