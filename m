Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FD023A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 10:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781BCC433D6;
	Fri, 28 Oct 2022 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666953744;
	bh=Gam20qC1+7dITgaY1kkmww2hgnCHG9A1vU6xUX6LcIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fx233X2td42L0ZoO57xGR6UMywW2sI1KvnhnEtIXv1XJuyroeYRAvxeODzENteKrr
	 Drk0Ks6kBoBVYnHAM1KLKNYAYmL8kfV29Rxa4RJpXg04TQLtnc5VBW/3XepaEbpI/d
	 CRJ+9XWDAKMzZLYgUXgV6JVRduRH7H7QnGKbaR7A=
Date: Fri, 28 Oct 2022 12:42:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
Message-ID: <Y1uyDV3i2heNmyne@kroah.com>
References: <20221027165054.917467648@linuxfoundation.org>
 <3624500e-8e07-ac95-8b15-2843a3c9d7c4@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3624500e-8e07-ac95-8b15-2843a3c9d7c4@roeck-us.net>

On Thu, Oct 27, 2022 at 11:18:42AM -0700, Guenter Roeck wrote:
> On 10/27/22 09:54, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.76 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> > Anything received after that time might be too late.
> > 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> In file included from drivers/cpufreq/tegra194-cpufreq.c:10:
> drivers/cpufreq/tegra194-cpufreq.c:282:25: error: 'tegra194_cpufreq_of_match' undeclared here (not in a function); did you mean 'tegra194_cpufreq_data'?
>   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/module.h:244:15: note: in definition of macro 'MODULE_DEVICE_TABLE'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |               ^~~~
> include/linux/module.h:244:21: error: conflicting types for '__mod_of__tegra194_cpufreq_of_match_device_table'; have 'const struct of_device_id[2]'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |                     ^~~~~~
> drivers/cpufreq/tegra194-cpufreq.c:417:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>   417 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       | ^~~~~~~~~~~~~~~~~~~
> include/linux/module.h:244:21: note: previous declaration of '__mod_of__tegra194_cpufreq_of_match_device_table' with type 'int'
>   244 | extern typeof(name) __mod_##type##__##name##_device_table               \
>       |                     ^~~~~~
> drivers/cpufreq/tegra194-cpufreq.c:282:1: note: in expansion of macro 'MODULE_DEVICE_TABLE'
>   282 | MODULE_DEVICE_TABLE(of, tegra194_cpufreq_of_match);
>       | ^~~~~~~~~~~~~~~~~~~
> make[3]: [scripts/Makefile.build:289: drivers/cpufreq/tegra194-cpufreq.o] Error 1 (ignored)
> ERROR: modpost: missing MODULE_LICENSE() in drivers/cpufreq/tegra194-cpufreq.o
> make[2]: [scripts/Makefile.modpost:133: modules-only.symvers] Error 1 (ignored)
> 
> I don't know what exactly happened, but commit b281adc68db8 ("cpufreq:
> tegra194: Fix module loading") introduces a second MODULE_DEVICE_TABLE
> at the wrong location, causing the build failure.

Ah, the "Fixes:" tag was wrong in the original commit in Linus's tree.
It should have said:
	Fixes: 0839ed1fd7ac ("cpufreq: tegra194: add soc data to support multiple soc")
which removed the existing MODULE_DEVICE_TABLE() entry.

So only kernels newer than 5.19 need this.  I'll go drop it from the
5.10.y and 5.15.y queues, thanks!

greg k-h
