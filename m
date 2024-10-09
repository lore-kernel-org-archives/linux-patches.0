Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3391516BE3A;
	Wed,  9 Oct 2024 21:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728511079; cv=none; b=XrmwpsfAOL0zxcAYHZVbpF+wVklBeVtq3f2fxujCNyQAoU/95AZOvVSi4ejAkX4lfODJ+jLbYO158rkSSTHlSkLAgpI4V5g11BiSiz6L/Vwqx93n22kGfv8DDWoMpqZJ+ouQ4RLngzfjKpbeDTNwxPd94hywcByDtjUPQKuAZsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728511079; c=relaxed/simple;
	bh=um9DeAb1bTGl61eVh23cuf6FArPLwmhUKsBKaUmRVho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bV8cthvP42uXVJfWtDEi96ob4nOPjXHTuexJuqFuwfmiOtERyy4/m/c7uUBftuorsv/uD53mp5PRztpS+eNR5O9wz6arvRys/daY0BrXvU3sf2eQTbrdpkqzitezAw4jhD5E0tYjs7lDa0PMMiCsrHY8lOaCgmOKElGdhFxWYN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJJti4uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJJti4uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5418CC4CEC3;
	Wed,  9 Oct 2024 21:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728511078;
	bh=um9DeAb1bTGl61eVh23cuf6FArPLwmhUKsBKaUmRVho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JJJti4ujec4C7P1qoGLtwLQ0nDpJVu5CJNjblkME2HmYOtKe0FL0NZFTcj0sjfYYL
	 6OzWoXhGc+zt15PpQKci3st+bd8An3KdeXsOANbqV3fDBctO2qg8f/Yt81HNbwclqk
	 mLuIUhe7k64/OYH/kRlRroNccotxAvhziP+q1Cj/bVYe58fdHpXASa46E+Q3gXhmfh
	 lgk3DTWOr8UN12YZHFlveRmMvoaVTJaM9ZEIiqQVeOIC/l+RJheAUnv7csjMxh3Vjs
	 L3+z7QkPA9CFBf0UuqP70mPh7su9AanYjKe1ia9+Q9+G01G5eJOvtFn5B8dQGtFuI7
	 2fymgfzOjXUeQ==
Date: Wed, 9 Oct 2024 17:57:56 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
Message-ID: <Zwb8ZJlhwz8YxAur@sashalap>
References: <20241008115702.214071228@linuxfoundation.org>
 <526e573e-c352-484b-9b24-1f83abc93f8b@rnnvmail202.nvidia.com>
 <b222ca24-0d69-4893-b669-02a071e529bf@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b222ca24-0d69-4893-b669-02a071e529bf@nvidia.com>

On Wed, Oct 09, 2024 at 04:11:19PM +0100, Jon Hunter wrote:
>Hi Greg,
>
>On 09/10/2024 15:59, Jon Hunter wrote:
>>On Tue, 08 Oct 2024 14:00:30 +0200, Greg Kroah-Hartman wrote:
>>>This is the start of the stable review cycle for the 6.11.3 release.
>>>There are 558 patches in this series, all will be posted as a response
>>>to this one.  If anyone has any issues with these being applied, please
>>>let me know.
>>>
>>>Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
>>>Anything received after that time might be too late.
>>>
>>>The whole patch series can be found in one patch at:
>>>	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.3-rc1.gz
>>>or in the git tree and branch at:
>>>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
>>>and the diffstat can be found below.
>>>
>>>thanks,
>>>
>>>greg k-h
>>
>>Failures detected for Tegra ...
>>
>>Test results for stable-v6.11:
>>     10 builds:	10 pass, 0 fail
>>     26 boots:	26 pass, 0 fail
>>     116 tests:	115 pass, 1 fail
>>
>>Linux version:	6.11.3-rc1-gdd3578144a91
>>Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>>                 tegra20-ventana, tegra210-p2371-2180,
>>                 tegra210-p3450-0000, tegra30-cardhu-a04
>>
>>Test failures:	tegra194-p2972-0000: boot.py
>
>
>The above is a new kernel warning introduced by ...
>
>Michal Koutný <mkoutny@suse.com>
>    cgroup: Disallow mounting v1 hierarchies without controller implementation
>
>
>Interestingly the commit message for the above actually states ...
>
>"Wrap implementation into a helper function, leverage legacy_files to
> detect compiled out controllers. The effect is that mounts on v1 would
> fail and produce a message like:
>   [ 1543.999081] cgroup: Unknown subsys name 'memory'"
>
>The above is the exact warning we see ...
>
>boot: logs: [       8.673272] ERR KERN cgroup: Unknown subsys name 'memory'
>
>
>So although this appears deliberate, I don't see this on mainline/next.

I'll drop it, looks like there are some dependencies needed.

-- 
Thanks,
Sasha
