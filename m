Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD2E63B9
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 08:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2971C433C7;
	Sat, 23 Sep 2023 08:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695457572;
	bh=QfSZi3CcaKcDGUu3aI1sCsbgvUsfgPydkTm/hs5D/r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ddt1VQNlnRJdg8YQ+u3H8AkGQb/Ge7s36yp6VVg4ovf1KPSUm2QxzplMpZEg1W34E
	 ZgG9t6eCpLmYzO8E7fO/YVTZra3cFrUWeNTx6GA3MLf/YSXTBhoIJ8XUzmNat2RB20
	 4UptXhhTuAFgl3hpaoH+/shMbQ+eQcXn3IcIYOZA=
Date: Sat, 23 Sep 2023 10:26:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.4 000/367] 5.4.257-rc1 review
Message-ID: <2023092300-sturdily-monastery-b1f0@gregkh>
References: <20230920112858.471730572@linuxfoundation.org>
 <166b5b43-adab-7d00-e3f6-c9a1dfd29f52@gmail.com>
 <1885150a-6caa-8d92-f893-02bdb5ee508d@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1885150a-6caa-8d92-f893-02bdb5ee508d@roeck-us.net>

On Thu, Sep 21, 2023 at 05:20:17AM -0700, Guenter Roeck wrote:
> On 9/20/23 10:21, Florian Fainelli wrote:
> > On 9/20/23 04:26, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.257 release.
> > > There are 367 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.257-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > perf does not build with:
> > 
> > libbpf.c: In function 'bpf_object__close':
> > libbpf.c:4205:15: error: 'struct bpf_object' has no member named 'btf_vmlinux'
> >    btf__free(obj->btf_vmlinux);
> >                 ^~
> > 
> > due to 34d66b750e83d49c7d3d33d59e6a1b49e0d5db15 ("libbpf: Free btf_vmlinux when closing bpf_object")
> > 
> > the btf_vmlinux member was introduced with a6ed02cac690b635dbb938690e795812ce1e14ca ("libbpf: Load btf_vmlinux only once per object.") which is only in >= 5.6.
> > 
> > Suggset we drop that commit.
> 
> 
> This problem affects 5.4, 5.10, and 5.15.

Now dropped from all of those queues, thanks.

greg k-h
