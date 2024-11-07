Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B77C1D3644;
	Thu,  7 Nov 2024 09:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730970423; cv=none; b=aMOtWA/vwUDI4xZ4JGVT2s8nrw1dbUZZ6pU/58v78suY2zD9n8XNakRMg+8QCLFMX7bJSV9w56qygxsGMGWXGBPwavgazFqYS+Umihx2stvzfjXVdpCsQeRZkeZ84djPfQ3ozbCYtDzkHFkx/yRuwAFf7tbShG+eCycfegwkvGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730970423; c=relaxed/simple;
	bh=7/gT3e2vF+8UozxHJgGUXtyS5R6CJXcTb7xN5x7/23w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c9uErVL1QN3lmmfB5nFGegdlD1TVqynhThpOdeV+WkQ9WxMQUwpRwjqQTCHnyN4UA6EZ1ePRRE3HP1eRPDcOwk7h1owPqrrZJqes+xTGuOGLQII8EwlLLRuCie2DaLv0SUg/RkPvtiNI/+waEAyb05hyTtkXcBhzFqRmEfBGrvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBf2jHxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBf2jHxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38E7C4CECC;
	Thu,  7 Nov 2024 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730970421;
	bh=7/gT3e2vF+8UozxHJgGUXtyS5R6CJXcTb7xN5x7/23w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BBf2jHxifnL7H1g+Vm7TeOEdKsqy1LobDuvow7xQ7UngAz4pnuCG7WCGlZfIoXtvi
	 wFBrHMWP3bjhuYfwFKE3k7/rqFSyfdfa8C1lfoBhHC43esCAAJC47PsI4E6dyD168J
	 IXi42o19MKbEIGCASO1iCOS6daVhzyY0KLjw7I/M=
Date: Thu, 7 Nov 2024 10:06:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
Message-ID: <2024110723-bonus-glacier-710e@gregkh>
References: <20241107063342.964868073@linuxfoundation.org>
 <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdUi=gLLJp2zLgq4bQ-PMXdB1hOZus-5zRSKYS-71cQJsA@mail.gmail.com>

On Thu, Nov 07, 2024 at 09:37:51AM +0100, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Thu, Nov 7, 2024 at 7:47 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 4.19.323 release.
> > There are 349 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
> > Anything received after that time might be too late.
> 
> > Biju Das <biju.das@bp.renesas.com>
> >     dt-bindings: power: Add r8a774b1 SYSC power domain definitions
> 
> Same question as yesterday: why is this being backported (to multiple
> stable trees)? It is (only a small subset of) new hardware support.
> 
> > Stable-dep-of: 8a7d12d674ac ("net: usb: usbnet: fix name regression")
> 
> This is completely unrelated?

Yes, sorry, was getting to build breaks first, then dropping stuff like
this, it's now gone.

greg k-h
