Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870A4A34
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 12:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CB0C4339B;
	Fri, 17 Mar 2023 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679057745;
	bh=qg+EwQsv/p5UD+n3/gGaCynZ+XcaO3bFfgawomGNlQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+qMuMXC7iao+a1aAKpUS2OVaIkAjXbk9uWgOqd/hGE9TvU8rQkUN6gh1NgFLJRPW
	 DJaYCUr46TbKw9fzMmbBOt4BCzgp5R9S2ivZK1bhGmPFW5Q/7thQebwY/qtUk6Gazs
	 vMMevCEVS45DFDoGgjRwHJsQpK3TqCqTi0eia8vo=
Date: Fri, 17 Mar 2023 13:55:42 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
Message-ID: <ZBRjTid0Hc4V7bwB@kroah.com>
References: <20230316094129.846802350@linuxfoundation.org>
 <ZBQ/rhv9nP+i8Pyc@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBQ/rhv9nP+i8Pyc@debian>

On Fri, Mar 17, 2023 at 10:23:42AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Mar 16, 2023 at 10:42:14AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.278 release.
> > There are 27 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 11.3.1 20230311):
> mips: 63 configs -> no  failure
> arm: 115 configs -> no failure
> arm64: 2 configs -> no failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Boot test:
> x86_64: Booted on qemu. No regression. [1]
> 
> Boot Regression on test laptop:
> Only black screen but ssh worked, so from the dmesg it seems i915 failed.

Can you bisect this?

