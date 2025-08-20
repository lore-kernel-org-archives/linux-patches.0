Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB7425CC69;
	Wed, 20 Aug 2025 08:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755677271; cv=none; b=dGwEMoGKXZYrF5MGIg4KEZXEuWU0q3PFc8n/dqtlmlE92WicCwb+AkK9vfb8CldGAvYotPEtx8oh1ojbX+poWx0mlIrh85uT9Rcr0mhBQxmzK94A3dFkCUwCjlvp0MtVoPLtmHJDmZLdjrWN3TOwTfrlXqmVxcEM2cPWQriTrhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755677271; c=relaxed/simple;
	bh=1LchkEdSUPOGHvF8BqxbIW+DxgHBEG7fHZ0C9P7w9bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/3zrdAr5fniSMNwJVRuxOUYfneUbyYVgb3kyfDMkJxd8L7tiBZvjje0vvZhFbpDd72Xi9s3fuZMJ4t3z+bCfOJEXhzonGuluIfjw6xYt+HFU79XW7NyGm7A0xpC/KPhPyMvHyMDkA8lkE+D/rhHu4AKD7sb+3STQCs00WbcTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=dOcyVhuo; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="dOcyVhuo"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id EEED01A0D4F;
	Wed, 20 Aug 2025 08:07:46 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id C032D606AF;
	Wed, 20 Aug 2025 08:07:46 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 41BCB1C22D86F;
	Wed, 20 Aug 2025 10:07:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1755677265; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=BqOeKH44mmo+fNgntbIgoiF5KwaoWXtJymnj9DvA82U=;
	b=dOcyVhuo4R38XYIpSGRStvC6gWxn/IXf/BnB8QnIGcJbHDO0V+a8hg90NTf93oxn7Z3qLv
	uiJKLhMw67PzGmtKQiVl046uQdqgbdxtpUBm7DGOCf4/QIZZjst1gtN+5INLfos3ORjaTt
	bU7aQVQabj5eoNEs38/PWsKzetcU+gZZcz4wWJV959VNZQh5HUVdEDYmwaYCUtkAPpF6Cy
	rsYduX0WN+Lxydxuk3FNXaU/NF2tcXIH0BAed0aLhUXdjWMH7uNlDZereJ2IYp/qPOSHrM
	1bD/kZLKySsfTZk3pJsZZUK43MHlf5GNV4U0PET/W2Gwio2OGPN4oqyIQRDN3w==
From: =?UTF-8?B?QmVub8OudA==?= Monin <benoit.monin@bootlin.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
 Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev
Subject:
 Re: [PATCH] mmc: sdhci-cadence: Fix -Wuninitialized in
 sdhci_cdns_tune_blkgap()
Date: Wed, 20 Aug 2025 10:07:35 +0200
Message-ID: <2560300.XAFRqVoOGU@benoit.monin>
In-Reply-To:
 <20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-v1-1-94aa2d0c438a@kernel.org>
References:
 <20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-v1-1-94aa2d0c438a@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Last-TLS-Session-Version: TLSv1.3

Hi Nathan,

On Tuesday, 19 August 2025 at 19:28:49 CEST, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=3Dy):
>=20
>   drivers/mmc/host/sdhci-cadence.c:297:9: error: variable 'hrs37_mode' is=
 uninitialized when used here [-Werror,-Wuninitialized]
>     297 |         writel(hrs37_mode, hrs37_reg);
>         |                ^~~~~~~~~~
>   drivers/mmc/host/sdhci-cadence.c:291:16: note: initialize the variable =
'hrs37_mode' to silence this warning
>     291 |         u32 hrs37_mode;
>         |                       ^
>         |                        =3D 0
>=20
> A previous revision assigned SDHCI_CDNS_HRS37_MODE_MMC_HS200 to
> hrs37_mode in a switch statement but the final revision moved to a
> simple if statement. Pass that as the value to writel() and
> remove hrs37_mode, clearing up the warning.
>=20
> Fixes: 60613a8b9b81 ("mmc: sdhci-cadence: implement multi-block read gap =
tuning")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/mmc/host/sdhci-cadence.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/mmc/host/sdhci-cadence.c b/drivers/mmc/host/sdhci-ca=
dence.c
> index a2a4a5b0ab96..eaa88897a256 100644
> --- a/drivers/mmc/host/sdhci-cadence.c
> +++ b/drivers/mmc/host/sdhci-cadence.c
> @@ -288,13 +288,12 @@ static int sdhci_cdns_tune_blkgap(struct mmc_host *=
mmc)
>  	void __iomem *hrs38_reg =3D priv->hrs_addr + SDHCI_CDNS_HRS38;
>  	int ret;
>  	u32 gap;
> -	u32 hrs37_mode;
> =20
>  	/* Currently only needed in HS200 mode */
>  	if (host->timing !=3D MMC_TIMING_MMC_HS200)
>  		return 0;
> =20
> -	writel(hrs37_mode, hrs37_reg);
> +	writel(SDHCI_CDNS_HRS37_MODE_MMC_HS200, hrs37_reg);
> =20
>  	for (gap =3D 0; gap <=3D SDHCI_CDNS_HRS38_BLKGAP_MAX; gap++) {
>  		writel(gap, hrs38_reg);
>=20
Thanks for the catch!

I don't get how gcc does not raise a warning here, only clang does. I
did build with gcc-11 and gcc-15 and they don't complain about this
uninitialized variable.

Tested-by: Beno=C3=AEt Monin <benoit.monin@bootlin.com>

> ---
> base-commit: 7138017038c42feb682445407974ed736e1ff308
> change-id: 20250819-mmc-sdhci-cadence-fix-uninit-hrs37_mode-cc1246cb39d8
>=20
> Best regards,
> -- =20
> Nathan Chancellor <nathan@kernel.org>
>=20
>=20

Best regards,
=2D-=20
Beno=C3=AEt Monin, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com



