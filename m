Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0329448
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 15:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AF7C433C9;
	Wed, 23 Aug 2023 15:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692804262;
	bh=JFuHCyKtub3kOcwFFDhwPmV2t4hWRz5sfV+5kWTmhdM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WTNKDVJ2SyBfNSIx0sBJH/Hf9cc68a+n8z1wms/6tQ84bpOLqLglR1TCQ/jyun4kI
	 gJLABRZDzhAuTbq+ELRVrPTCG6OpMenUxchSlNilDo1wUe8t0Z4edPDNI736GRRcgM
	 yAC5aZrWiJAS9mHcmrdVM4bOZHKEERZwn97CACHQ=
Date: Wed, 23 Aug 2023 17:24:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <2023082308-obliged-protector-f04c@gregkh>
References: <20230821194122.695845670@linuxfoundation.org>
 <20230823-washer-reemerge-a412d55f8214@wendy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823-washer-reemerge-a412d55f8214@wendy>

On Wed, Aug 23, 2023 at 10:35:54AM +0100, Conor Dooley wrote:
> On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.47 release.
> > There are 194 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Fails to build for me with gcc-11/binutils 2.37 on RISC-V. The problematic
> patch is "riscv: Handle zicsr/zifencei issue between gcc and binutils".
> Can you drop that please, probably from all of your branches. It
> certainly affects 6.4 too & I don't personally test anything older than
> 6.1.

I've dropped that patch now from all trees, thanks.

greg k-h
