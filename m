Received: from mx-relay90-hz2.antispameurope.com (mx-relay90-hz2.antispameurope.com [94.100.136.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329D42F6905
	for <patches@lists.linux.dev>; Tue,  3 Feb 2026 07:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=94.100.136.190
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770103987; cv=pass; b=PJ76GOrcgcA4s5JI3Mij3ENibxbNImqQkpuwRZlzZtb65T3ktKufV4MxtqimtQaOintUc9h4kXYvqWkssxt5M9XqHfIpieshP4cANTctIjTzzgMMd887+KRM8DgfQFKi02UxSwvMyjJLuiQPTJQYQsL/qgg6PvOzoIEfanBlPMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770103987; c=relaxed/simple;
	bh=zuH4THsSYfBakKP4hxzlDTsP6G2WOe/ZLl8davtu4us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kS7X3eh7vF/qwfmlJtXxNQNmCuKAjcwSEvtuKhMSOf0Ip2ug5RHd5nwhnBUgx+Iw53twotUW3eENG2hRKxbYFnlL3Bs30sow5NKzbjtQsaXUnNG1jE0oDnug1dFx0k6z0GTBhHAnaStF9MnKdnkf5b9vbtWgWm6KpwSuK2OtCk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ew.tq-group.com; spf=pass smtp.mailfrom=ew.tq-group.com; dkim=pass (2048-bit key) header.d=ew.tq-group.com header.i=@ew.tq-group.com header.b=Pd6+F2QQ; arc=pass smtp.client-ip=94.100.136.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ew.tq-group.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ew.tq-group.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ew.tq-group.com header.i=@ew.tq-group.com header.b="Pd6+F2QQ"
ARC-Authentication-Results: i=1; mx-gate90-hz2.hornetsecurity.com 1; spf=pass
 reason=mailfrom (ip=94.100.132.6, headerfrom=ew.tq-group.com)
 smtp.mailfrom=ew.tq-group.com smtp.helo=smtp-out02-hz1.hornetsecurity.com;
 dmarc=pass header.from=ew.tq-group.com orig.disposition=pass
ARC-Message-Signature: a=rsa-sha256;
 bh=CBcKy3LTsSOy9BG/CCe7lxWeFcFJWB1RT7k5pEE+1XM=; c=relaxed/relaxed;
 d=hornetsecurity.com; h=from:to:date:subject:mime-version:; i=1; s=hse1;
 t=1770103938;
 b=gwFtenyyfPLUWMzVNYKM54ddXnpa3tEF1vBVGIqnaQ6C2dgVJqatCfDktq3gyxfc+F9y9jpl
 FfysVYFczacQDJfZJpLYJMd4JSxiLDBHDI3MjCyl8Y3EQkwHZKpZmHBgdU63rqE2mMtMZzJjIoW
 1D5qLW0UTVLxLB/RLOGzaipJBlBfzVVFnia/7wp78WIoEPxo/32IOQI2Y3wXMNe1Cl8X4/9bBun
 T/3HeuzIees/e9vQAkKLqVT7ukwZWaUK990HsdqTvcD2jS7KCudo5bEEN8+XzNfcI7E9oHI8D9G
 kFtDdLl7jrn/kgQBgo0p/V+ZnUER4lPPOhSGg7EPaIaPw==
ARC-Seal: a=rsa-sha256; cv=none; d=hornetsecurity.com; i=1; s=hse1;
 t=1770103938;
 b=R2uMscAPO2rEdTFLF/pw6aqBMGqr/UJZPfFX2W71qKqAJCQ6lzryqfVksZvFdgKQ15wHN984
 gUbwn6heyzqXoRgd7pArSNjmxWYvJaP0fU2j9ngod235gfL3DHDJpzJjMiHY91bwL+YDulJl+V/
 0PrjrcpjZ5WhuMmGjGiVI+e0mJN++W73jTZ6uCD3/4fa4ZDXdQgVaKGbiA+PcNw+dus13pnr94X
 br0pMSmGGtwoQbLZFQ0IwhlnbneQBMjkWg5Jnbqw/zQZGU/E3ZZ1y+ZGjTmkRg3m5hqdE51dbii
 hu5ug0G1FtvViIFOTNZkTv8bssAInxs150juTgp/R7HNA==
Received: from he-nlb01-hz1.hornetsecurity.com ([94.100.132.6]) by mx-relay90-hz2.antispameurope.com;
 Tue, 03 Feb 2026 08:32:18 +0100
Received: from steina-w.localnet (host-82-135-125-110.customer.m-online.net [82.135.125.110])
	(Authenticated sender: alexander.stein@ew.tq-group.com)
	by smtp-out02-hz1.hornetsecurity.com (Postfix) with ESMTPSA id 8893A5A0712;
	Tue,  3 Feb 2026 08:32:03 +0100 (CET)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: Michael Turquette <mturquette@baylibre.com>,
 Stephen Boyd <sboyd@kernel.org>, Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, Mark Brown <broonie@kernel.org>,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Brian Masney <bmasney@redhat.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Chen-Yu Tsai <wenst@chromium.org>
Subject: Re: [PATCH] Revert "clk: Respect CLK_OPS_PARENT_ENABLE during recalc"
Date: Tue, 03 Feb 2026 08:32:03 +0100
Message-ID: <6238918.lOV4Wx5bFT@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20260203002439.1223213-1-sboyd@kernel.org>
References: <20260203002439.1223213-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-cloud-security-sender:alexander.stein@ew.tq-group.com
X-cloud-security-recipient:patches@lists.linux.dev
X-cloud-security-crypt: load encryption module
X-cloud-security-Mailarchiv: E-Mail archived for: alexander.stein@ew.tq-group.com
X-cloud-security-Mailarchivtype:outbound
X-cloud-security-Virusscan:CLEAN
X-cloud-security-disclaimer: This E-Mail was scanned by E-Mailservice on mx-relay90-hz2.antispameurope.com with 4f4wD41lpPzWt7Y
X-cloud-security-connect: he-nlb01-hz1.hornetsecurity.com[94.100.132.6], TLS=1, IP=94.100.132.6
X-cloud-security-Digest:93f5832a1b97e2a3191f725c02173acf
X-cloud-security:scantime:1.923
DKIM-Signature: a=rsa-sha256;
 bh=CBcKy3LTsSOy9BG/CCe7lxWeFcFJWB1RT7k5pEE+1XM=; c=relaxed/relaxed;
 d=ew.tq-group.com;
 h=content-type:mime-version:subject:from:to:message-id:date; s=hse1;
 t=1770103938; v=1;
 b=Pd6+F2QQX+9Z5DSgmOBu9TqjHexsJM7S+EfmtXnPph4dRzrTDx8jORAu6H8s/ItTRyqM3RhP
 2qjzIHuKKYxT4o/vzWKXXGhRrinKEzcGxZTiJlsBMpuXiegqYEcvso7QwgTN0L34iJDGo5kmGx2
 PK1SsAO9fCgWF7rDqVF+DFzocLefFOfMzYFBR+8XNT0zhJNW6R1rob8z7/jjwSUUp7jihD//tKY
 SLhI7kOsVuxmEbfGNKdoYGgJFXEF4BazFcblTQRJ7j9/wIOeEnWBfcAqkbaUaN1wO2wfSl6yDEI
 5dMwlykAPgrnTa7iV2wrlacpRX3UVoZZQ3volya8lB6vw==

Am Dienstag, 3. Februar 2026, 01:24:38 CET schrieb Stephen Boyd:
> This reverts commit 669917676e93fca5ea3c66fc9539830312bec58e.
> It's been shown to cause problems on i.MX and STM32 platforms
> where the board doesn't boot. In one case, a clk with
> CLK_IS_CRITICAL and CLK_OPS_PARENT_ENABLE is being registered
> causing the parent to be enabled, the rate recalculated, and then
> the parent is disabled causing the critical clk being registered
> to stop clocking.
>=20
> A fix for that would be to calculate the rate of the clk after
> enabling the critical clk itself, but that wouldn't fix another
> problem where a clk with CLK_OPS_PARENT_ENABLE is registered
> before the parent is registered. In this case the hardware access
> in the clk_ops::recalc_rate() function would fail if the parent
> is disabled.
>=20
> There are even more problems exposed by this patch because it
> introduces logic that disables clks earlier in system boot than
> has existed previously. Historically we've not disabled clks
> until late init (clk_disable_unused) under the assumption that
> clks have been registered enough to have a consistent view of the
> clk tree. The clk_disable_unused logic doesn't work very well
> though, leading to quite a few devices booting with
> clk_ignore_unused on the kernel command line.
>=20
> Long story short, disabling clks during clk registration is full
> of pitfalls. Revert this commit until a proper solution can be
> found.
>=20
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Closes: https://lore.kernel.org/r/6239343.lOV4Wx5bFT@steina-w
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/r/036da7ce-6487-4a6e-9b15-97c6d3bcdcec@si=
rena.org.uk
> Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Cc: Brian Masney <bmasney@redhat.com>
> Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Cc: Chen-Yu Tsai <wenst@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>

> ---
>  drivers/clk/clk.c | 13 -------------
>  1 file changed, 13 deletions(-)
>=20
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 1b0f9d567f48..85d2f2481acf 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1921,14 +1921,7 @@ static unsigned long clk_recalc(struct clk_core *c=
ore,
>  	unsigned long rate =3D parent_rate;
> =20
>  	if (core->ops->recalc_rate && !clk_pm_runtime_get(core)) {
> -		if (core->flags & CLK_OPS_PARENT_ENABLE)
> -			clk_core_prepare_enable(core->parent);
> -
>  		rate =3D core->ops->recalc_rate(core->hw, parent_rate);
> -
> -		if (core->flags & CLK_OPS_PARENT_ENABLE)
> -			clk_core_disable_unprepare(core->parent);
> -
>  		clk_pm_runtime_put(core);
>  	}
>  	return rate;
> @@ -4038,9 +4031,6 @@ static int __clk_core_init(struct clk_core *core)
>  	 */
>  	clk_core_update_duty_cycle_nolock(core);
> =20
> -	if (core->flags & CLK_OPS_PARENT_ENABLE)
> -		clk_core_prepare_enable(core->parent);
> -
>  	/*
>  	 * Set clk's rate.  The preferred method is to use .recalc_rate.  For
>  	 * simple clocks and lazy developers the default fallback is to use the
> @@ -4056,9 +4046,6 @@ static int __clk_core_init(struct clk_core *core)
>  		rate =3D 0;
>  	core->rate =3D core->req_rate =3D rate;
> =20
> -	if (core->flags & CLK_OPS_PARENT_ENABLE)
> -		clk_core_disable_unprepare(core->parent);
> -
>  	/*
>  	 * Enable CLK_IS_CRITICAL clocks so newly added critical clocks
>  	 * don't get accidentally disabled when walking the orphan tree and
>=20
> base-commit: aa2ad19210a6a444111bce55e8b69579f29318fb
>=20


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/


