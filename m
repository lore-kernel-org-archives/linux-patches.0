Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFC323A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 10:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31A4C433D7;
	Fri, 28 Oct 2022 10:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666954709;
	bh=ygxPrRc/Zk4MIshtydB8kmhLSNfzXMaND3/WL0BWJck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VhbSRawayfrSK0AlXAR1kcJuI8SWObkqHhBJXcL7caVRSl2Y9f0tKzNtld3nkI3cw
	 ReJyMgD3Z+Z0KvIxtHgxOnC2pqCpS28kn82f6a2zyjHFXgGAhYrUEYowW6K8iLyFU5
	 /FIU7jt1+gTtiowVHF1mTFHeJsja+uJBf27jGyO0=
Date: Fri, 28 Oct 2022 12:58:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Message-ID: <Y1u10qtld2FjOncq@kroah.com>
References: <20221027165054.270676357@linuxfoundation.org>
 <Y1uzP3FJibb1UIlt@debian>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1uzP3FJibb1UIlt@debian>

On Fri, Oct 28, 2022 at 11:47:27AM +0100, Sudip Mukherjee (Codethink) wrote:
> Hi Greg,
> 
> On Thu, Oct 27, 2022 at 06:55:10PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.151 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> > Anything received after that time might be too late.
> 
> Build test (gcc version 11.3.1 20221016):
> mips: 63 configs -> no failure
> arm: 104 configs -> no failure
> arm64: 3 configs -> 1 failure
> x86_64: 4 configs -> no failure
> alpha allmodconfig -> no failure
> powerpc allmodconfig -> no failure
> riscv allmodconfig -> no failure
> s390 allmodconfig -> no failure
> xtensa allmodconfig -> no failure
> 
> Note:
> 1) arm64 allmodconfig fails to build with the error:
> In file included from drivers/cpufreq/tegra194-cpufreq.c:10:
> drivers/cpufreq/tegra194-cpufreq.c:245:25: error: 'tegra194_cpufreq_of_match' undeclared here (not in a function); did you mean 'tegra194_cpufreq_data'?
>   245 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/module.h:241:15: note: in definition of macro 'MODULE_DEVICE_TABLE'
>   241 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |               ^~~~
> ./include/linux/module.h:241:21: error: conflicting types for '__mod_of__tegra194_cpufreq_of_match_device_table'; have 'const struct of_device_id[2]'
>   241 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |                     ^~~~~~
> drivers/cpufreq/tegra194-cpufreq.c:380:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>   380 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       | ^~~~~~~~~~~~~~~~~~~
> ./include/linux/module.h:241:21: note: previous declaration of '__mod_of__tegra194_cpufreq_of_match_device_table' with type 'int'
>   241 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |                     ^~~~~~
> drivers/cpufreq/tegra194-cpufreq.c:245:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>   245 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       | ^~~~~~~~~~~~~~~~~~~
> 
> git bisect pointed to a327a52c9930 ("cpufreq: tegra194: Fix module loading")

Now dropped.

> 2) Already reported by others:
> scripts/pahole-flags.sh: Permission denied

Will be fixed up by hand.

I'll be doing a new 5.10.y release in a few minutes and start a new
round of -rc review for it to resolve this...

thanks,

greg k-h
