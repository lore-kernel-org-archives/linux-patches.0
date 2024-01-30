Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C575B129A87
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706634620; cv=none; b=OERT7dOfHYxHJBc6vaNh6YH9mkp+idYaGQwF789koL+/rSV+XcQIIZb3Hxn81vpkzyP0iibgPTPbsireTJxDcmNK4g3fP8Dub1WlM3SOsW00y/7aOGYM/AhFPrjIohwW2ZzTTsqEhVkpp8UcjNfkmOAvXBbV89QfW8SrHZXNsO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706634620; c=relaxed/simple;
	bh=qs3bHzLttFydFy/a7bg3wwRcc02Xlp3EA5qTNS+OYVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gYBZYLeVVxQ0vXtJfO/3GBhRVE8yTT9Q7mRqgDlzxjFxYfLub/rTZRviF/8jhLqlZ8DZ2l5d/rK07LldxXNZo/oSSjii40YIbTU+9RbVx9wbwfUSWLJCRiS7m5RWQKxoizvbR0KJnigv9GNDdjkRkc5p01CvD1pAZisLKo1BMV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpdcBd6g; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpdcBd6g"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d05b06b5f9so11641311fa.3
        for <patches@lists.linux.dev>; Tue, 30 Jan 2024 09:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706634612; x=1707239412; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KAf6tgblhFk5SS7xF/05maRRLfXRqqg0AmAUe2SVN0M=;
        b=TpdcBd6gvfke4YMg0noAHi3K8d0O0A3AqtSC+qo05PUFiJG+tRjjNQQ6whLQM+SEEE
         PWHoliJsnQk8/JOPkyt5y0Uaeds0t/lL/gPzcxAovnoYvLgxZKtn6yOiGQ+YBrto+pw1
         JG8Ih9jBLcocNZMaRyK9kWMdUOgk7oksfqGD3cZu8506eGb2qNAIlSvNiuPWkV9PWBbH
         t4IjyQHCd8thB5UeVwUFYkWATm9YNJ1mCrjyclmBiSQAFCwJ/vHZL7gvJmgbNWzThKVQ
         B/3F7MBtc+IrNM9nvwZ4rZqr0ERWEA8Ge38OQ+7yhEFzNs5d8zeOPiZYR+ZBgAZYnhGw
         CFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706634612; x=1707239412;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KAf6tgblhFk5SS7xF/05maRRLfXRqqg0AmAUe2SVN0M=;
        b=nVotvp/dEYiNptkM9sLHA42bemRj9Ew6Jm2GDNqi67GZUBF6muXMmF4Fa7LuR+7Wo7
         zAhuYyUEcHtbvR/3cSxFXpQC2JpjfwNeR+rfDf9NXAwgLf0vyoZyJZYuRZ50OE0hWBr4
         Aet1qtUzH8DnEfidkz7tg/NAjGALJSHh67/er7Jzd07aQh5R/3niduF8QR0N89RpDE8u
         pqIPJdeHTg4h1E+ivZAPF/JKrKQoIX1kFbbLizlTiTC1BVhWK7LV/k58epXlRiXz3nlw
         evuBu9jSIdbI/ZZNCno4KMagmdnWg5vi6aQ5KZhCCurm4U7wvoKdaBMWvd1ULl6B5C8H
         46Nw==
X-Gm-Message-State: AOJu0Yz6x6q8tuHyWi7PcoLRpUM9RuKZ1UCtkN2t/rowIaW13+C55dh/
	wQSbpDFw0PYeUxI75zcWELWUvBQdGKpZz+Nk+f2JqjKUTnvb3wj+
X-Google-Smtp-Source: AGHT+IFSUK1TGC/xVKTkhUtyOB2SQ2m2OaxRok6eqOPvn4/MIrrR1kxT9lIoa2q+QUSu0YbJSWLoGQ==
X-Received: by 2002:a2e:8e73:0:b0:2cd:9503:f91 with SMTP id t19-20020a2e8e73000000b002cd95030f91mr5533320ljk.15.1706634612059;
        Tue, 30 Jan 2024 09:10:12 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id ds8-20020a0564021cc800b0055c9280dc51sm5046118edb.14.2024.01.30.09.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 09:10:11 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 6359CBE2DE0; Tue, 30 Jan 2024 18:10:10 +0100 (CET)
Date: Tue, 30 Jan 2024 18:10:10 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Sasha Levin <sashal@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 098/185] net/mlx5e: Allow software parsing when IPsec
 crypto is enabled
Message-ID: <ZbktcnbWiq14DiSX@eldamar.lan>
References: <20240129165958.589924174@linuxfoundation.org>
 <20240129170001.745906693@linuxfoundation.org>
 <ZbgFoW5DV4dQxliM@eldamar.lan>
 <ZbgGrgeP_Wwrrb7C@eldamar.lan>
 <2024012926-dagger-bazooka-b7da@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2024012926-dagger-bazooka-b7da@gregkh>

Hi Greg,

On Mon, Jan 29, 2024 at 12:43:05PM -0800, Greg Kroah-Hartman wrote:
> On Mon, Jan 29, 2024 at 09:12:30PM +0100, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Mon, Jan 29, 2024 at 09:08:02PM +0100, Salvatore Bonaccorso wrote:
> > > Hi Greg,
> > > 
> > > On Mon, Jan 29, 2024 at 09:04:58AM -0800, Greg Kroah-Hartman wrote:
> > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > [ Upstream commit 20f5468a7988dedd94a57ba8acd65ebda6a59723 ]
> > > > 
> > > > All ConnectX devices have software parsing capability enabled, but it is
> > > > more correct to set allow_swp only if capability exists, which for IPsec
> > > > means that crypto offload is supported.
> > > > 
> > > > Fixes: 2451da081a34 ("net/mlx5: Unify device IPsec capabilities check")
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > > > index 29dd3a04c154..d3de1b7a80bf 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > > > @@ -990,8 +990,8 @@ void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
> > > >  	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
> > > >  	bool allow_swp;
> > > >  
> > > > -	allow_swp =
> > > > -		mlx5_geneve_tx_allowed(mdev) || !!mlx5_ipsec_device_caps(mdev);
> > > > +	allow_swp = mlx5_geneve_tx_allowed(mdev) ||
> > > > +		    (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
> > > >  	mlx5e_build_sq_param_common(mdev, param);
> > > >  	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
> > > >  	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
> > > 
> > > When compiling 6.1.76-rc1 this commit causes the following build
> > > failure:
> > > 
> > > drivers/net/ethernet/mellanox/mlx5/core/en/params.c: In function ‘mlx5e_build_sq_param’:
> > > drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: error: ‘MLX5_IPSEC_CAP_CRYPTO’ undeclared (first use in this function)
> > >   994 |                     (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
> > >       |                                                     ^~~~~~~~~~~~~~~~~~~~~
> > > drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: note: each undeclared identifier is reported only once for each function it appears in
> > > 
> > > Attached the used config.
> > 
> > Mailserver from leonro@nvidia.com, saeedm@nvidia.com rejected the
> > message due to the attached test.config.xz . Resending this here again
> > without attachment so that might reach Leon and Saeed as well.
> 
> This works for me, I don't know why it's failing elsewhere.  I'd like to
> drop it but I really don't want to unless we can figure it out.

There is an explanation and a proposed fix by Florian Fainelli
<f.fainelli@gmail.com> in https://lore.kernel.org/stable/8c178bd1-e0c9-4e29-9b63-dd298298bc7b@gmail.com/

Hope this helps!

Regards,
Salvatore
