Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB803CF200;
	Tue, 23 Jun 2026 08:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205201; cv=none; b=KSE1JrwrxPrDPBphjrDM8nU3EFJ4UpyioqnBpxFb4vTbz9G0NALMc68xx+6kaAeII6MFwYmL9zjQbpx1RezVK8NB+Lq0PMo7lmr41j+YSJu4g0Qer+UQWgHvhzGE3ewe7ieFxePt10xE3HVH3A/Y9qw+r9P7pF1qsx2XcIff/9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205201; c=relaxed/simple;
	bh=0GU9LIMJY50aIaiYHYc+NTnY9K6OdMdQEpFxEubWTJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrDfTKIBIGg+nsMi7qLMuX3/rezY4XJh3Fyh+eoMhoGTZGO5o3e2P4ZtPBIFbhqT5QriruPK4x9IxC7AiAadCntjhEhoV0uCItBB/6vE9tTxMTMLiCoOODApAhIdbNernvUAO+gRsjFlJWRrpIR9OCmKNAlvhiH2dJcuuWZYHo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCddekKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCddekKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B271F000E9;
	Tue, 23 Jun 2026 08:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782205195;
	bh=CZJDMKie+kghBH4XpQ8XcibyOPE/XQSoQlDLMtsEl4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZCddekKJeKhGUvYTJgXy9VoBpK1WCBwH238B5Ov4bM/rLsaZmhsVB3PYh7W4Q1EKE
	 6ILnKu1bv0n1xn54jX3aHNp+JzxMQUm5CKebOTP5r2qifBmSUj4O+LuNsy8GBwA7M8
	 MiQazGMT1kWNjDHx35ledoiyrRVsAjmbdWO51zyyD7hGf44VB3jwpoj6J7cmTW7rRs
	 SPOy360WTGEWlK8dGCqvKRFXp+sMLTsD6bDf+8x9c8U0wBhRWN0XC20ET9UCg98BPY
	 Ua43fgAGAS6tgec2DXPOnz3b/NZYnd4OvIfHYLCkJToAZfIEy+gYKw4l9uuMPHCTRU
	 y8HTEz5/Syhww==
Received: from johan by xi.lan with local (Exim 4.99.3)
	(envelope-from <johan@kernel.org>)
	id 1wbwz3-00000000Zgb-0NSv;
	Tue, 23 Jun 2026 10:59:53 +0200
Date: Tue, 23 Jun 2026 10:59:53 +0200
From: Johan Hovold <johan@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
	Ramanan Govindarajan <ramanan.govindarajan@oracle.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 323/411] spi: topcliff-pch: fix controller
 deregistration
Message-ID: <ajpLCYZ3eQm5p64L@hovoldconsulting.com>
References: <20260616145100.376842714@linuxfoundation.org>
 <20260616145118.324999322@linuxfoundation.org>
 <d23a21f0-95dd-4e0c-845e-2a54c50f44eb@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d23a21f0-95dd-4e0c-845e-2a54c50f44eb@oracle.com>

On Fri, Jun 19, 2026 at 06:08:40PM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 16/06/26 20:29, Greg Kroah-Hartman wrote:
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johan Hovold <johan@kernel.org>
> > 
> > [ Upstream commit 5d6f477d6fc0767c57c5e1e6f55a1662820eef87 ]
> > 
> > Make sure to deregister the controller before disabling and releasing
> > underlying resources like interrupts and DMA during driver unbind.
> > 
> 
> ^^ let us remember this -- deregister before releasing irqs.
> 
> > Fixes: e8b17b5b3f30 ("spi/topcliff: Add topcliff platform controller hub (PCH) spi bus driver")
> > Cc: stable@vger.kernel.org	# 2.6.37
> > Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Link: https://patch.msgid.link/20260414134319.978196-8-johan@kernel.org
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > [ renamed spi_controller_*(data->host) calls to spi_master_*(data->master) ]
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/spi/spi-topcliff-pch.c |    7 ++++++-
> >   1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > --- a/drivers/spi/spi-topcliff-pch.c
> > +++ b/drivers/spi/spi-topcliff-pch.c
> > @@ -1450,11 +1450,16 @@ static void pch_spi_pd_remove(struct pla
> >   		free_irq(board_dat->pdev->irq, data);
> >   	}
> ^^^ let us remember this.
> 
> >   
> > +	spi_master_get(data->master);
> > +
> > +	spi_unregister_master(data->master);
> > +
> >   	if (use_dma)
> >   		pch_free_dma_buf(board_dat, data);
> >   
> >   	pci_iounmap(board_dat->pdev, data->io_remap_addr);
> > -	spi_unregister_master(data->master);
> > +
> > +	spi_master_put(data->master);
> >   }
> 
> 
> I ran an AI assisted backport review over the 5.15.210 queue and then
> checked this one manually. I think the 5.15.y backport keeps the API 
> mapping, but not the upstream teardown ordering.
> 
> Upstream 5d6f477d6fc0 unregisters the controller before the local teardown:
> 
>          spi_controller_get(data->host);
> 
>          spi_unregister_controller(data->host);
> 
>          if (use_dma)
>                  pch_free_dma_buf(board_dat, data);
>          ...
>          pch_spi_free_resources(board_dat, data);
>          /* disable interrupts & free IRQ */
>          if (data->irq_reg_sts) {
>                  /* disable interrupts */
>                  pch_spi_setclr_reg(data->host, PCH_SPCR, 0, PCH_ALL);
>                  data->irq_reg_sts = false;
>                  free_irq(board_dat->pdev->irq, data);
>          }
> 
> 
> In final 5.15.y, the equivalent spi_master_get()/spi_unregister_master()
> still happens after queue/status teardown, pch_spi_free_resources(), IRQ
> disable, and free_irq():
> 
>          pch_spi_free_resources(board_dat, data);
>          if (data->irq_reg_sts) {
>                  pch_spi_setclr_reg(data->master, PCH_SPCR, 0, PCH_ALL);
>                  data->irq_reg_sts = false;
>                  free_irq(board_dat->pdev->irq, data);
>          }
> 
>          spi_master_get(data->master);
> 
>          spi_unregister_master(data->master);
> 
> The spi_master_* names are equivalent wrappers for the controller APIs 
> in 5.15.y, but the call placement is still the old ordering. That leaves 
> child SPI devices registered while the driver has already started 
> tearing down controller resources.
> 
> I think for 5.15.y we should fix the backport by moving spi_master_get() 
> and spi_unregister_master() before the local queue/resource/IRQ teardown 
> in pch_spi_pd_remove(), thoughts?

I agree, this backport looks wrong.

This is probably an effect of

	9d72732fe70c ("spi: topcliff-pch: fix use-after-free on unbind")

being backported before

	9d72732fe70c ("spi: topcliff-pch: fix use-after-free on unbind")

due to the latter first failing to apply because of the SPI API rename.

Johan
