Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C82364AB;
	Fri, 17 May 2024 09:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715937988; cv=none; b=WD5TVkiXan95qk0zvRBs5uOpJxXoq/phuYgGRWAKeC1UdU9sFv5oC098uN2cb9q5JF6ddmImgq5tvdajT823Mxo3c9CFnc+gjjUvehlXByP0azfsUWXkaXf/kc/EXqkHIMaewIfjhxGTBoqRE8zADbCXKAdN4a07bhd0KOXuekI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715937988; c=relaxed/simple;
	bh=vT1emG8TeuLBvMfmFv/tdaK71DbcUi2KDUHMNbrlPBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZElGaVvlz1rlWhWn3QXhPaCPlXsR5mlmMGUSz5UX+j1Dp00Jwd4vwmveQe0PPANyT5snPALT1IanBtMTzuA/Wv5l4TYGu/TkdYLHbg07/8fTkoSNngmF85MDizkXLyd3hY0EZ6oDVTU1YXwau+PAL0eHnu7Oiysg2NvWrZUfS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svsHuiA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svsHuiA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD570C2BD10;
	Fri, 17 May 2024 09:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715937988;
	bh=vT1emG8TeuLBvMfmFv/tdaK71DbcUi2KDUHMNbrlPBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=svsHuiA1NMjF6amTIbNg/vqXEH5ivCPAj2ngpJUPM1aqR2pBQIPEhGJ8Lh8kS09gw
	 wJ/dDrVMn7bSX4nwn0RaB+6Az/vOoSUl0tcQyqlLxEWRgL4ZQa3hN0cxFinllYFhnV
	 sf4la5G21/pZt2GJksjbSrPaw4k3gnhzpq4QXg3Q=
Date: Fri, 17 May 2024 11:26:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/111] 5.10.217-rc1 review
Message-ID: <2024051744-refinery-galore-0089@gregkh>
References: <20240514100957.114746054@linuxfoundation.org>
 <ZkX+WBV4vJNpwX1i@duo.ucw.cz>
 <2024051700-jubilant-rotunda-eaac@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024051700-jubilant-rotunda-eaac@gregkh>

On Fri, May 17, 2024 at 11:22:37AM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 16, 2024 at 02:38:48PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > This is the start of the stable review cycle for the 5.10.217 release.
> > > There are 111 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > 
> > > Stephen Boyd <sboyd@kernel.org>
> > >     clk: Don't hold prepare_lock when calling kref_put()
> > 
> > Stephen said in a message that this depends on other patches,
> > including 9d1e795f754d clk: Get runtime PM before walking tree for
> > clk_summary. But we don't seem to have that one. Can you double-check?
> > 
> > (
> > Date: Tue, 23 Apr 2024 12:24:51 -0700
> > Subject: Re: [PATCH AUTOSEL 5.4 6/8] clk: Don't hold prepare_lock when calling kref_put()
> > )
> 
> Ugh, please use lore links when referring to other threads so that we
> don't have to figure it out on our own...
> 
> Anyway, that one commit seems missing, I'll look into it.

And I know you mean well, but if you had looked at it, you would have
seen that that commit isn't relevant at all to this kernel branch, which
is why it is not there.

Please be more careful with your reviews.

greg k-h
