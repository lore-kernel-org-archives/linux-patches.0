Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCADF3EBF24;
	Fri, 13 Feb 2026 15:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997008; cv=none; b=JAdzuR82qRoqIoPFIh3grfBeAgUlPLphmS5ABn1PzLZ5DHEtrDSK0LkYdmhz330d6mNdUCU78FuhT9O3S9dAgvzYrzHErdlx19jrCrbEt2s69FfjVmxCTzhUGqwQKT1Sl1DAhHfRMjSvkY1hAEyCFMOH1ct+AOOa3732ypdUhqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997008; c=relaxed/simple;
	bh=+yn9KvBAQ1XacRXnFfpRxvPN+0rJ0QDCqIHM4Yrv9OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyC4OthqL5WYhVSRyh+7PaIZfUGTZ3SRsGuVRTI6/9rLQLQO/F7sDfJkU9KVPO53j+TLRfxF2TkMEeANUsO37dJwCyN5O7hpu92UUC8878NDU828WYPCGLMjHwLkQmbLQtJ5e8/TiQEILdki4zLJGztX5iZ0imn2bjCMzf9GzKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R385Ugkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R385Ugkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8900C16AAE;
	Fri, 13 Feb 2026 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770997007;
	bh=+yn9KvBAQ1XacRXnFfpRxvPN+0rJ0QDCqIHM4Yrv9OA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R385Ugkp4pANZaU5Fbd1IgDqO7yqxoXFmx8bUFcyYbxoX1WCMy6JJ29PGhu8ZiueC
	 HNqZRU+X+eZrBuFtrMCxoqs2ohCql2Q2wSh/4PMyA5GjQnCNNhj0U7D2pzTCQTVhDE
	 Ap9wzLGbw/wtZJ52DqWLxVTECr9+YcYBsLDEkDVI=
Date: Fri, 13 Feb 2026 16:36:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Achill Gilgenast <achill@achill.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Message-ID: <2026021325-repacking-crumpet-5861@gregkh>
References: <20260213134708.713126210@linuxfoundation.org>
 <DGDX0HGRJJ3N.1F1EWJEDMYZND@achill.org>
 <2026021312-magma-dormitory-53af@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026021312-magma-dormitory-53af@gregkh>

On Fri, Feb 13, 2026 at 04:35:27PM +0100, Greg Kroah-Hartman wrote:
> On Fri, Feb 13, 2026 at 03:48:19PM +0100, Achill Gilgenast wrote:
> > On Fri Feb 13, 2026 at 2:47 PM CET, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.19.1 release.
> > > There are 49 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
> > 
> > Hey, the link to this patch (and all other stable-review patches from
> > today) seem to be not uploaded yet. Is this expected?
> 
> Nope, not at all. let me see if something went wrong on my side...

Ok, pushed again from my side, let's see if it propagates properly
now...
