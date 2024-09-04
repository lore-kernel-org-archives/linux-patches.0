Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515361CCB41;
	Wed,  4 Sep 2024 09:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442209; cv=none; b=K03wJ3lM5ulxhoSmu0aw90poro0SpjIJGaxyCD8vMAYnAHWc5yXGlksrAJY/KE8SxshrjlFktG5rDbsDS60nMx0MLf0DJdgnevG1ihkGl7a6L3czlrknndsHCGSRby+f7OdCRYHAimPj6w2KtxTH7DERjlSJ7E+N9kmyeukKV8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442209; c=relaxed/simple;
	bh=RevlNoJv4JYRDAemKLgtFTzuLfhjsrtVm/vM57JgUtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rEa2+Y98IndRqPypo/REKxfGj3nLdPMKDBLzeUww+D71eCD56ROh4W2ductvSsmVtASo6um/+pdUMCQRiHRIQH34CLKPDL6+fbam0JAYjdDrMNgqW3NuvVjYjQ57q/PgUDomVYj6pHio8cLikim8rM+2MPneML7dBYg+HhQ2HAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iajBY3cX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iajBY3cX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24826C4CEC2;
	Wed,  4 Sep 2024 09:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725442208;
	bh=RevlNoJv4JYRDAemKLgtFTzuLfhjsrtVm/vM57JgUtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iajBY3cXKCi4cCrVKzb4mzcWkb5Ys3aHKgPeTUSivoyQvAom05SgL/E0BdDi/stz1
	 PwF0XKEnha4PcpA8RLnonJ4ncFGO8xZJrnLh47I6ezikneb9vIo8UQLZidPFhfHCH4
	 OA+KY4881urPgJocve/ClqEEO+Avh3aiBQwBpK94=
Date: Wed, 4 Sep 2024 11:30:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	abdulrasaqolawani@gmail.com, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
Message-ID: <2024090459-moaning-proclaim-6bf5@gregkh>
References: <20240901160803.673617007@linuxfoundation.org>
 <CA+G9fYvS_NL7bcKkOJEX2irsBHcrYHz_yOOU84T9V9XB7n92RQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvS_NL7bcKkOJEX2irsBHcrYHz_yOOU84T9V9XB7n92RQ@mail.gmail.com>

On Mon, Sep 02, 2024 at 02:16:48PM +0530, Naresh Kamboju wrote:
> On Sun, 1 Sept 2024 at 21:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.321 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.321-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The Powerpc defconfig builds failed on Linux stable-rc due to following
> build warnings / errors with clang-18 and gcc-12.
> 
> This is a same problem on current stable-rc review on
>    - 4.19.321-rc1 review
>    - 5.4.283-rc1 review
>    - 5.10.225-rc1 review
>    - 5.15.166-rc1 review
> 
> In the case of stable-rc linux-4.19.y
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Anders bisected this to first bad commit id as,
>   fbdev: offb: replace of_node_put with __free(device_node)
>   [ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]

Now dropped, thanks.

greg k-h
