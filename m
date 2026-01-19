Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EC617A2F0;
	Mon, 19 Jan 2026 10:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768817869; cv=none; b=sXX/aamy72bwBdLAPvZRGJ2vbuk9zlJJ6DT59ULfIuvYQGuNUTWzpTrkgVD1dnZ8xqepgp7oqlWMneLvRPCTq8NaW9iAkveyWnSbDycX2Zcb6VMOFuyoOU7s0LSbvTPJC1SN+2ZL+wANGW+pQGLsyxlz5LqFPoAW0C5JPP8AatM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768817869; c=relaxed/simple;
	bh=P83hsBaTbVOqalbOss2rxH082xitXWVSPNIUF4duq1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mla/KFsF4xmoZBlEAtAdmYOhysz0zas9rjLGQbhKgTLEjSNZgJR47//uZARK3wJyodA3M5Tv0Ga1+awFfNSWjTnHtubpQ/v6eCF7c50GvSc2Qr7QdMPFVVl7Mf2XD5HG8rumXou3rg6O5XEUA2MHjtZ32wrkuSKF5CG6Ndu0cnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSLNUTYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSLNUTYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AFDC116C6;
	Mon, 19 Jan 2026 10:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768817868;
	bh=P83hsBaTbVOqalbOss2rxH082xitXWVSPNIUF4duq1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YSLNUTYCsaq4Eh7AOMu9ZK8CQae9MIEX13eEO3dBilq2cPjYamnVsMc4CKrXgwm/K
	 9Nu0rCgUSjPMZeijDQ03LbpRtG6wLTagx4VDovisMsMHGFO4bA5/gMsTXobhrxcz9o
	 S/HLweTh0c4rxPS8gIkTzNrvZnDfP796cuhil6Cw=
Date: Mon, 19 Jan 2026 11:17:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 374/451] ARM: dts: microchip: sama5d2: fix spi
 flexcom fifo size to 32
Message-ID: <2026011932-boogeyman-scheming-bfc2@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164244.445442721@linuxfoundation.org>
 <020da12b0832523db0723a3e36892a17b1ba7665.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <020da12b0832523db0723a3e36892a17b1ba7665.camel@decadent.org.uk>

On Sun, Jan 18, 2026 at 06:23:43PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:49 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Nicolas Ferre <nicolas.ferre@microchip.com>
> > 
> > [ Upstream commit 7d5864dc5d5ea6a35983dd05295fb17f2f2f44ce ]
> > 
> > Unlike standalone spi peripherals, on sama5d2, the flexcom spi have fifo
> > size of 32 data. Fix flexcom/spi nodes where this property is wrong.
> > 
> > Fixes: 6b9a3584c7ed ("ARM: dts: at91: sama5d2: Add missing flexcom definitions")
> > Cc: stable@vger.kernel.org # 5.8+
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> > Link: https://lore.kernel.org/r/20251114140225.30372-1-nicolas.ferre@microchip.com
> > Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  arch/arm/boot/dts/sama5d2.dtsi |   10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > --- a/arch/arm/boot/dts/sama5d2.dtsi
> > +++ b/arch/arm/boot/dts/sama5d2.dtsi
> [...]
> > @@ -925,7 +925,7 @@
> >  						 AT91_XDMAC_DT_PER_IF(1) |
> >  						 AT91_XDMAC_DT_PERID(18))>;
> >  					dma-names = "tx", "rx";
> > -					atmel,fifo-size = <16>;
> > +					atmel,fifo-size = <32>;
> >  					status = "disabled";
> >  				};
> >  
> [...]
> 
> This hunk (only) of the backport ends up changing the wrong node - it
> should be applied to spi5, not i2c5.  The starting line should be 905,
> not 925.

Yeah, something went wrong with the backport, I'll drop this from all
queues.

greg k-h
