Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4106947B
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 09:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABE1C433C7;
	Wed, 23 Aug 2023 09:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692782786;
	bh=ITHYbCSa8xC05AhgVVAUPq+ran6o4m6ijJRCtqyDnaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=19arubAMz5JMa7tD64e+VmEucN4mlbKn4q1cPGDyJhN/7esJfQK1t6Ke8snvHrPfO
	 RWssWDdFjrz8xrCedGg3agVoWv6o0vCV7P8gBSwZuTWJCu+h5dRj18lAwTPdwiR0tt
	 O9kYIF86By6hESVzoIC8dtSJNhqe7ShOhGoOhlOA=
Date: Wed, 23 Aug 2023 11:26:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <2023082303-musky-plastic-335f@gregkh>
References: <20230821194122.695845670@linuxfoundation.org>
 <ZOXJVamgYV1Mb+7S@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOXJVamgYV1Mb+7S@debian>

On Wed, Aug 23, 2023 at 09:54:45AM +0100, Sudip Mukherjee (Codethink) wrote:
> Hi Greg,
> 
> On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.47 release.
> > There are 194 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 12.3.1 20230625):
> mips: 52 configs -> no failure
> arm: 100 configs -> no failure
> arm64: 3 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> csky allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Boot test:
> x86_64: Booted on my test laptop. Warning on boot, already reported by others.
> x86_64: Booted on qemu. Warning on boot, already reported by others. [1]
> arm64: Booted on rpi4b (4GB model). No regression. [2]
> mips: Booted on ci20 board. No regression. [3]
> 
> [1]. https://openqa.qa.codethink.co.uk/tests/4765
> [2]. https://openqa.qa.codethink.co.uk/tests/4773
> [3]. https://openqa.qa.codethink.co.uk/tests/4772
> 
> Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> 
> -- 
> Regards
> Sudip

One question about the warning on boot, all still works afterward,
right?  Or does the system not work?

thanks,

greg k-h
