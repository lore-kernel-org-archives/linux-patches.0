Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F5D22127A;
	Thu,  9 Oct 2025 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760027890; cv=none; b=iUGBwdq/kYJeXJZ6MkIiqSyHXTuqNfHuNqAAXEfnpxmJ618JG+fQ0UO+0M39uElfxaPIBNWVpeki/5aFwDBDTSp35ny/meNskEm3d1jfdvrd4aCNIE28MWJ5t5mTnHusjg7rZbghBZj5bISDk1eNvlIfk/bJ9jtn4Jpgj7T8cSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760027890; c=relaxed/simple;
	bh=Z6CkqxnnUfmkgbMvPoujJuaf91jki7GVcRE735THLT4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZrtSC/AmDEd/JxY3W1NWyxCjUWP6O5YC7QRM9m9RoIiaJv6a1LN9V4TZVXdL/Kx/UrRnSc/9NAZ4fzpgFPp9fNw2uIXVtgMlEk2vykQCnHqkN5R/Bx/cvZ6y4aSpFAtFkNk/oUTWAqt5UXuY9CeE7IBxcP2JqCH2XQXh08zRu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 531701762;
	Thu,  9 Oct 2025 09:37:57 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2BE7B3F66E;
	Thu,  9 Oct 2025 09:38:04 -0700 (PDT)
Date: Thu, 9 Oct 2025 17:38:01 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, Chen-Yu Tsai
 <wens@csie.org>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 samuel@sholland.org, linux-arm-kernel@lists.infradead.org,
 linux-sunxi@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 6.17-6.12] soc: sunxi: sram: add entry for a523
Message-ID: <20251009173801.13c133a4@donnerap.manchester.arm.com>
In-Reply-To: <20251009155752.773732-11-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
	<20251009155752.773732-11-sashal@kernel.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu,  9 Oct 2025 11:54:37 -0400
Sasha Levin <sashal@kernel.org> wrote:

Hi,

> From: Chen-Yu Tsai <wens@csie.org>
>=20
> [ Upstream commit 30849ab484f7397c9902082c7567ca4cd4eb03d3 ]
>=20
> The A523 has two Ethernet controllers. So in the system controller
> address space, there are two registers for Ethernet clock delays,
> one for each controller.
>=20
> Add a new entry for the A523 system controller that allows access to
> the second register.
>=20
> Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
> Link: https://patch.msgid.link/20250908181059.1785605-4-wens@kernel.org
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>=20
> LLM Generated explanations, may be completely bogus:
>=20
> YES =E2=80=93 this should go to stable; without it the second GMAC on A523
> cannot program its clock-delay register.

It's pointless, any kernel before v6.15 will not boot on any A523 device,
so support for any kind of A523 MAC is irrelevant.
For newer kernels, this would be tied to the GMAC1 enablement, which is
also a new feature, so not a candidate for stable.

Cheers,
Andre

> - The A523 DT already instantiates the system-control syscon with an
>   A523-specific compatible and wires GMAC0 (with GMAC1 expected next) to
>   that syscon (`arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi:423` and
>   `arch/arm64/boot/dts/allwinner/sun55i-a523.dtsi:543`). Because the
>   current driver falls back to the A64 variant,
>   `sunxi_sram_regmap_accessible_reg()` only exposes a single EMAC clock
>   register (`drivers/soc/sunxi/sunxi_sram.c:325`), so any attempt to use
>   the second EMAC clock register at 0x34 is blocked, which makes the
>   second Ethernet controller unusable on this SoC.
> - The patch adds a dedicated A523 variant with `.num_emac_clocks =3D 2`
>   and wires it into the OF match table
>   (`drivers/soc/sunxi/sunxi_sram.c:313` and
>   `drivers/soc/sunxi/sunxi_sram.c:438` after the change). This is the
>   minimal change required to expose the second register; no other SoCs
>   are affected and no behaviour changes for existing users.
> - Risk is very low: the change only enlarges the allowed register window
>   for the A523 system controller and mirrors the existing H616 handling.
>   Without it, backporting forthcoming GMAC1 enablement (or any
>   downstream board DT that already uses it) will continue to fail, so
>   carrying this fix in stable keeps A523 Ethernet support from
>   regressing.
>=20
> Next step if you pick it up: merge alongside the GMAC1 enablement so the
> second port works end-to-end.
>=20
>  drivers/soc/sunxi/sunxi_sram.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sra=
m.c
> index 2781a091a6a64..16144a0a0d371 100644
> --- a/drivers/soc/sunxi/sunxi_sram.c
> +++ b/drivers/soc/sunxi/sunxi_sram.c
> @@ -310,6 +310,10 @@ static const struct sunxi_sramc_variant sun50i_h616_=
sramc_variant =3D {
>  	.has_ths_offset =3D true,
>  };
> =20
> +static const struct sunxi_sramc_variant sun55i_a523_sramc_variant =3D {
> +	.num_emac_clocks =3D 2,
> +};
> +
>  #define SUNXI_SRAM_THS_OFFSET_REG	0x0
>  #define SUNXI_SRAM_EMAC_CLOCK_REG	0x30
>  #define SUNXI_SYS_LDO_CTRL_REG		0x150
> @@ -430,6 +434,10 @@ static const struct of_device_id sunxi_sram_dt_match=
[] =3D {
>  		.compatible =3D "allwinner,sun50i-h616-system-control",
>  		.data =3D &sun50i_h616_sramc_variant,
>  	},
> +	{
> +		.compatible =3D "allwinner,sun55i-a523-system-control",
> +		.data =3D &sun55i_a523_sramc_variant,
> +	},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, sunxi_sram_dt_match);

