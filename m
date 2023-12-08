Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03B1171A;
	Fri,  8 Dec 2023 06:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+/b/5P0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A3DC433C7;
	Fri,  8 Dec 2023 06:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702017215;
	bh=Rv/ruy3db5Oz95ujeCfBD1LwNpGZWxkjI8JTNYAGUC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u+/b/5P0ZJHidKNaF6EmO+CJ36TT197KsvH7ahaswiveFl1rn1LJgMSLZv/JpwJ+d
	 chenp7LAjW4vG3IrEd6Uc2CTq3s1LPFatquDMJA531E5TiHm909F2cbfcv/TxB4gWy
	 ZMFzyCRBmA6Kl4fvPpAe94q123sCvhuN9QYRpKKQ=
Date: Fri, 8 Dec 2023 07:33:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH 5.10 000/131] 5.10.203-rc3 review
Message-ID: <2023120812-shrank-draw-9b9b@gregkh>
References: <20231205183249.651714114@linuxfoundation.org>
 <efdb0591-2259-f86c-0da4-781dfdae22e1@ispras.ru>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efdb0591-2259-f86c-0da4-781dfdae22e1@ispras.ru>

On Thu, Dec 07, 2023 at 02:00:06AM +0300, Alexey Khoroshilov wrote:
> On 05.12.2023 22:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.203 release.
> > There are 131 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.203-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> It seems something is seriously broken in this release.
> 
> There are patches already applied in 5.10.202 that are in 5.10.203-rc3
> transformed in some strange way, e.g.
> 
> Neil Armstrong <narmstrong@baylibre.com>
>     tty: serial: meson: retrieve port FIFO size from DT
> 
> 
> commit 980c3135f1ae6fe686a70c8ba78eb1bb4bde3060 in 5.10.202

Odd, yeah, something is off here, let me look into it after my coffee
has kicked in...

greg k-h
