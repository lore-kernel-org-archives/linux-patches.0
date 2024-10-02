Received: from mail.thorsis.com (mail.thorsis.com [217.92.40.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DB61CF5FB
	for <patches@lists.linux.dev>; Wed,  2 Oct 2024 14:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.92.40.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880702; cv=none; b=XXsihke8JrUWCaN7JZ4mZVY7DIa5yI3S7dObdRIMd8PVCbFN1yXh/ZbSX2kZA11kV8YRCYXUP7UyoFiSgtCOV77d6Av1TjdgDn++5dxSFe6q9K+QUFuUztnIHKy263BS6c2dXQU1hi4XQVEMURYshqceJPGau933O8eHHbdiJnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880702; c=relaxed/simple;
	bh=U9Xyjppt0llW/DDtVEPhnZulfQw0+sQCti1nks95RE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3NU+M6fC8HjZMxKWWezaOZ4rtDqjKudU348GLJDHdLVeW6H17aaS17SOwZ+/niaBqIvbID1VrR5if25zFJWFhAaIym9SVS5FFfl0AXoEtjcHLgUpR86/RxwQ06sA01cMqjj22SIvgtzBL5EGwQZbOwV6w4TSJEoteUhS27NAN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorsis.com; spf=pass smtp.mailfrom=thorsis.com; dkim=pass (2048-bit key) header.d=thorsis.com header.i=@thorsis.com header.b=ZHaICyGE; arc=none smtp.client-ip=217.92.40.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=thorsis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thorsis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thorsis.com header.i=@thorsis.com header.b="ZHaICyGE"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 438771483606;
	Wed,  2 Oct 2024 16:51:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thorsis.com; s=dkim;
	t=1727880697; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=QcQConNE5B6onu/YoIV/R4UJfmR7ak4OQZL/VFhslo8=;
	b=ZHaICyGEIpVkVhYcb7RYhor2/HtFlWutk/HA0e9R+f6T0lympSaqYkShjfPpxo1/VnFmmh
	xWb9JufMVsK8mP35YrEO8/+S7me2DSGW+nMdJ8yhktYqxfrfk+THcvjuE2nyI6EpomjIFv
	pqdPYGifdw8UJWTF9haRUylzi+VmuWZ1/S0zWFoyxqhYkuQ5ZP5TPe2r7Zz0UNkwfOhFEE
	joQOafRrs93UMd/Sp0pHsdEtMNJdSNaY2+TduPnNc3jkrbFje32YYUUC4Zz+TE60JEZa+d
	IEJQOHCAk6aAvtzZKq+tTQ75/kLwpYA+ptkNyyTmDc33hVWyP+JhR82m4FsImg==
Date: Wed, 2 Oct 2024 16:51:35 +0200
From: Alexander Dahl <ada@thorsis.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>, Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.10 413/634] spi: atmel-quadspi: Avoid overwriting delay
 register settings
Message-ID: <20241002-elk-overeager-326e25534532@thorsis.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20241002125811.070689334@linuxfoundation.org>
 <20241002125827.407333729@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002125827.407333729@linuxfoundation.org>
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Last-TLS-Session-Version: TLSv1.3

Hello Greg,

Am Wed, Oct 02, 2024 at 02:58:33PM +0200 schrieb Greg Kroah-Hartman:
> 6.10-stable review patch.  If anyone has any objections, please let me know.

Same as for 6.11, if you take this, please also take
<20240926090356.105789-1-ada@thorsis.com>.

Thanks
Alex

Link: https://lore.kernel.org/linux-spi/20240926090356.105789-1-ada@thorsis.com/T/#u

> 
> ------------------
> 
> From: Alexander Dahl <ada@thorsis.com>
> 
> [ Upstream commit 329ca3eed4a9a161515a8714be6ba182321385c7 ]
> 
> Previously the MR and SCR registers were just set with the supposedly
> required values, from cached register values (cached reg content
> initialized to zero).
> 
> All parts fixed here did not consider the current register (cache)
> content, which would make future support of cs_setup, cs_hold, and
> cs_inactive impossible.
> 
> Setting SCBR in atmel_qspi_setup() erases a possible DLYBS setting from
> atmel_qspi_set_cs_timing().  The DLYBS setting is applied by ORing over
> the current setting, without resetting the bits first.  All writes to MR
> did not consider possible settings of DLYCS and DLYBCT.
> 
> Signed-off-by: Alexander Dahl <ada@thorsis.com>
> Fixes: f732646d0ccd ("spi: atmel-quadspi: Add support for configuring CS timing")
> Link: https://patch.msgid.link/20240918082744.379610-2-ada@thorsis.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/spi/atmel-quadspi.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
> index 466c01b31123b..b557ce94da209 100644
> --- a/drivers/spi/atmel-quadspi.c
> +++ b/drivers/spi/atmel-quadspi.c
> @@ -375,9 +375,9 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
>  	 * If the QSPI controller is set in regular SPI mode, set it in
>  	 * Serial Memory Mode (SMM).
>  	 */
> -	if (aq->mr != QSPI_MR_SMM) {
> -		atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
> -		aq->mr = QSPI_MR_SMM;
> +	if (!(aq->mr & QSPI_MR_SMM)) {
> +		aq->mr |= QSPI_MR_SMM;
> +		atmel_qspi_write(aq->scr, aq, QSPI_MR);
>  	}
>  
>  	/* Clear pending interrupts */
> @@ -501,7 +501,8 @@ static int atmel_qspi_setup(struct spi_device *spi)
>  	if (ret < 0)
>  		return ret;
>  
> -	aq->scr = QSPI_SCR_SCBR(scbr);
> +	aq->scr &= ~QSPI_SCR_SCBR_MASK;
> +	aq->scr |= QSPI_SCR_SCBR(scbr);
>  	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
>  
>  	pm_runtime_mark_last_busy(ctrl->dev.parent);
> @@ -534,6 +535,7 @@ static int atmel_qspi_set_cs_timing(struct spi_device *spi)
>  	if (ret < 0)
>  		return ret;
>  
> +	aq->scr &= ~QSPI_SCR_DLYBS_MASK;
>  	aq->scr |= QSPI_SCR_DLYBS(cs_setup);
>  	atmel_qspi_write(aq->scr, aq, QSPI_SCR);
>  
> @@ -549,8 +551,8 @@ static void atmel_qspi_init(struct atmel_qspi *aq)
>  	atmel_qspi_write(QSPI_CR_SWRST, aq, QSPI_CR);
>  
>  	/* Set the QSPI controller by default in Serial Memory Mode */
> -	atmel_qspi_write(QSPI_MR_SMM, aq, QSPI_MR);
> -	aq->mr = QSPI_MR_SMM;
> +	aq->mr |= QSPI_MR_SMM;
> +	atmel_qspi_write(aq->mr, aq, QSPI_MR);
>  
>  	/* Enable the QSPI controller */
>  	atmel_qspi_write(QSPI_CR_QSPIEN, aq, QSPI_CR);
> -- 
> 2.43.0
> 
> 
> 
