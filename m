Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3C12C6AA;
	Mon, 29 Jan 2024 20:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706559162; cv=none; b=CS1ae5XiURMd5PXNEeo3OIXT1/ZJpGA+rvQvRVV3seJI9ipG3BMFbAoJDFRReOFEVLM2Xxz7TGCZxTQYvF49oR7z9YBpoIQG7RT/Vbx6O/KChpJp8KMw/8idbGsIfJk+LoBi0Tb6KoWU6CTD8tzCDuSXFWZmX8RDIx1En7RCfXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706559162; c=relaxed/simple;
	bh=BRZFVN9heZy8fGbrY5sXRtI34DNTMxc43oxpyLtRlgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hlm8wfab9VIG3+gCIgGVWlSifz5pILN749hu1QlZVEDhjdVksCufT/JNYiDRndMAL3ZHr40CUOP89yEkSdaX3RihB72/JgV/xsa8RqnUQCLXzmVjvSa68V2dEqlaSADvBvBM1IGlqbbTdmF+QXW9OKlUcoWY8mvTzHIp9Z3pOjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=nuGGwsNF; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="nuGGwsNF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=4fgYY+L2DeqJdEV3fZi53TvqaRBA477yJ+Ai1b1IXHs=; b=nuGGwsNFWDEEMjJXjUQVFUPnZf
	LKI0v+V4yDBMFBV81EtSt8jJpFdpn/PmSxK6ETFw9zuc+d0yem+zuys3ridYHecP3aOy+dBi1Kwzm
	LwonnYi8QsuuxHYfzIXTc86JFA11Z7wW0S2we4QN9GGUgNN6mqHOQeq6mSSBGV2OtqGLdBpqh44Cc
	v9+ZLQD4AiqGpzEPSQSdwoEno+f3M7e4kK2nsVhD88kb2AP270EDWNwPiKv5om0LuflOuS5R8FzPr
	acgj6CFN/pAtnkToxKjJXg57EsdpQZMptu9ONJqjwbQm+mimwMiilF3I/A8W1XM10XtzLoV6ADTXO
	nQvMIO5A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1rUXzc-005WG9-0U; Mon, 29 Jan 2024 20:12:32 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id F3A73BE2DE0; Mon, 29 Jan 2024 21:12:30 +0100 (CET)
Date: Mon, 29 Jan 2024 21:12:30 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 098/185] net/mlx5e: Allow software parsing when IPsec
 crypto is enabled
Message-ID: <ZbgGrgeP_Wwrrb7C@eldamar.lan>
References: <20240129165958.589924174@linuxfoundation.org>
 <20240129170001.745906693@linuxfoundation.org>
 <ZbgFoW5DV4dQxliM@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbgFoW5DV4dQxliM@eldamar.lan>
X-Debian-User: carnil

Hi,

On Mon, Jan 29, 2024 at 09:08:02PM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Mon, Jan 29, 2024 at 09:04:58AM -0800, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > [ Upstream commit 20f5468a7988dedd94a57ba8acd65ebda6a59723 ]
> > 
> > All ConnectX devices have software parsing capability enabled, but it is
> > more correct to set allow_swp only if capability exists, which for IPsec
> > means that crypto offload is supported.
> > 
> > Fixes: 2451da081a34 ("net/mlx5: Unify device IPsec capabilities check")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > index 29dd3a04c154..d3de1b7a80bf 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> > @@ -990,8 +990,8 @@ void mlx5e_build_sq_param(struct mlx5_core_dev *mdev,
> >  	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
> >  	bool allow_swp;
> >  
> > -	allow_swp =
> > -		mlx5_geneve_tx_allowed(mdev) || !!mlx5_ipsec_device_caps(mdev);
> > +	allow_swp = mlx5_geneve_tx_allowed(mdev) ||
> > +		    (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
> >  	mlx5e_build_sq_param_common(mdev, param);
> >  	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
> >  	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
> 
> When compiling 6.1.76-rc1 this commit causes the following build
> failure:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/params.c: In function ‘mlx5e_build_sq_param’:
> drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: error: ‘MLX5_IPSEC_CAP_CRYPTO’ undeclared (first use in this function)
>   994 |                     (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_CRYPTO);
>       |                                                     ^~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en/params.c:994:53: note: each undeclared identifier is reported only once for each function it appears in
> 
> Attached the used config.

Mailserver from leonro@nvidia.com, saeedm@nvidia.com rejected the
message due to the attached test.config.xz . Resending this here again
without attachment so that might reach Leon and Saeed as well.

Regards,
Salvatore
