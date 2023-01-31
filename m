Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1AD659
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 07:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF602C433D2;
	Tue, 31 Jan 2023 07:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675149888;
	bh=liX3rhOdlyU1Q7LQxoCxYWUaVUDWXNTsiZ/H8qL2RyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eG96U4yx2HRPbvQRh0ihw2j+gr3Lq17aQOWg8CbqakAYzFEg9ncWD4mYlOAJd2CS5
	 tZaSp7x6UoLs0BJW+CrbQEj6cp8muFDTVgHc8tJizYjE9ZsTTAINsaGtS47cid3wNX
	 mQdBbIAna6DPUIBCHG6cyj2ty6Xc2TDZGWh3/P4s=
Date: Tue, 31 Jan 2023 08:24:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wang Yugui <wangyugui@e16-tech.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <Y9jCPZou887QFn/C@kroah.com>
References: <20230130181611.883327545@linuxfoundation.org>
 <20230131104206.0E8A.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131104206.0E8A.409509F4@e16-tech.com>

On Tue, Jan 31, 2023 at 10:42:07AM +0800, Wang Yugui wrote:
> Hi,
> 
> 
> > This is the start of the stable review cycle for the 6.1.9 release.
> > There are 313 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> 
> fstests btrfs/056 triggered a panic for 6.1.9-rc2, but the panic does not happen
> on 6.1.8 and 6.2.0-rc4.
> 
> reproduce frequency: 100%

Ick, yeah, the block patches got backported again.  I'll drop them and
push out a -rc3, thanks for the report!

greg k-h
