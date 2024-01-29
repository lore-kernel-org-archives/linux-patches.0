Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580A027458;
	Tue, 30 Jan 2024 16:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706632516; cv=none; b=oQxSgov7XTC0He2zUQa2jzaIhgJrA8NHTdcEcEtyZnUb7S5RTsu3IX3srzvkvUMZpVvrzGhdNJrADec5rZI06Uv1puk0wIZhNDIop9s11MmvKsOwpXMjSAa9d10PC+ASB8hnJaqACddFMmVgO2Ib+/RO2XQ+afr+lgwm4TBg7Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706632516; c=relaxed/simple;
	bh=gM8zh3yV3xJaYgX/uPnPGLvV6UZA8zBh6l/y6vRrrm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ow3WTRxwaAgSIpqQIuKGFoygnMiFZ+xagnG1TR7PgKlzBxHPIH5PpHvB7UegJZBbcroaVXhzmvHyso068+HTqhBp2VUTFDWZfPgHgs8nLhN9eMbApFWebwe3IVzndqv9oevPvTZBRaElQM9mTu5S5RVPkWLp3my6Q17pcVJo0M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuZFz4gb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuZFz4gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B249AC433C7;
	Tue, 30 Jan 2024 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706632515;
	bh=gM8zh3yV3xJaYgX/uPnPGLvV6UZA8zBh6l/y6vRrrm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LuZFz4gbu+N5f3D2ntxH1iDfraxtaGZv7LZODlIj47JwYJKMlln953DBtdT+KDkxC
	 gMwpc6J1/0hQH/JlS9gfBiv922E7Cytrrn5SiuHxH6ZpLUeDTCHS6HvGNNTeUaTSJG
	 RJ46KmfPCtGMVIFqvj9v+xOyfCIDUDE66wFJ5Ehw=
Date: Mon, 29 Jan 2024 12:43:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 098/185] net/mlx5e: Allow software parsing when IPsec
 crypto is enabled
Message-ID: <2024012926-dagger-bazooka-b7da@gregkh>
References: <20240129165958.589924174@linuxfoundation.org>
 <20240129170001.745906693@linuxfoundation.org>
 <ZbgFoW5DV4dQxliM@eldamar.lan>
 <ZbgGrgeP_Wwrrb7C@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbgGrgeP_Wwrrb7C@eldamar.lan>

On Mon, Jan 29, 2024 at 09:12:30PM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Mon, Jan 29, 2024 at 09:08:02PM +0100, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > On Mon, Jan 29, 2024 at 09:04:58AM -0800, Greg Kroah-Hartman wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > [ Upstream commit 20f5468a7988dedd94a57ba8acd65ebda6a59723 ]
> > > 
> > > All ConnectX devices have software parsing capability enabled, but it is
> > > more correct to set allow_swp only if capability exists, which for IPsec
> > > means that crypto offload is supported.
> > > 
> > > Fixes: 2451da081a34 ("net/mlx5: Unify device IPsec capabilities check")
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > > index 29dd3a04c154..d3de1b7a80bf 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > > @@ -990,8 +990,8 @@ void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
> > >  	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
> > >  	bool allow_swp;
> > >  
> > > -	allow_swp =
> > > -		mlx5_geneve_tx_allowed(mdev) || !!mlx5_ipsec_device_caps(mdev);
> > > +	allow_swp = mlx5_geneve_tx_allowed(mdev) ||
> > > +		    (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
> > >  	mlx5e_build_sq_param_common(mdev, param);
> > >  	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
> > >  	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
> > 
> > When compiling 6.1.76-rc1 this commit causes the following build
> > failure:
> > 
> > drivers/net/ethernet/mellanox/mlx5/core/en/params.c: In function ‘mlx5e_build_sq_param’:
> > drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: error: ‘MLX5_IPSEC_CAP_CRYPTO’ undeclared (first use in this function)
> >   994 |                     (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
> >       |                                                     ^~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > Attached the used config.
> 
> Mailserver from leonro@nvidia.com, saeedm@nvidia.com rejected the
> message due to the attached test.config.xz . Resending this here again
> without attachment so that might reach Leon and Saeed as well.

This works for me, I don't know why it's failing elsewhere.  I'd like to
drop it but I really don't want to unless we can figure it out.

greg k-h
