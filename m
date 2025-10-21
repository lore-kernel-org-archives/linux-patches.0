Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACDC23815B;
	Tue, 21 Oct 2025 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761082410; cv=none; b=fYuZxDa/GOTNFiC5JgCftUB6CG+eYqCEKqEgM0TM6Aq/ZvR/FMcuoxrNRjMFOEtL+fsxlTPcNNzNgizJPW6hsM/dGasI8Oze3xd6CRhGDw6QZ0KuacXV+jPsflM7C29wssA7x8UpDW4JLMP4mgu1PklIzv5xYLgXDJjYmpMsqiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761082410; c=relaxed/simple;
	bh=JxJu9aSbuyJBtrZBnq83MTJiGQEotCp3nnab7l5cnRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bQpbXk+PtFnrAIFJ3uVc6D1+4pGswjBo9Kx/dGy/advXE/RUBxi6uX80tFWBO8ThZ499LMm0dBXwF/PmubjIXPMvvEmjMA7fj1pRZ60Da7ULWutfUBqCK1RSg/6A6OxIyoUu7UpqmnCb1oQhFNs4vs8vuzu8Rkk3/D9oCxvrPvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPYJGJ2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPYJGJ2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AFEC4CEF1;
	Tue, 21 Oct 2025 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761082410;
	bh=JxJu9aSbuyJBtrZBnq83MTJiGQEotCp3nnab7l5cnRg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lPYJGJ2xYz/4D6sOZrDDy+Fu7o4a8I1OwYNJDn8QtwBOWhSRNzzcszINwrDhmsZs/
	 Z+YBAPP4e5OCj8jHHcXyQepHcsWNZUIXp0mrPr5IYWqmhnCJGkboVekRtppWDoQoUJ
	 LEplqn4iG+tAuffh8Ano1CNo8pDnvFIusHQi7+5yXJDaBCc1948RBdc6erDDGvAsyD
	 1EI911RsXkROPNUubiy+DPwQN3xjVN33+yKIV4PVo3udSJcvL2K0Xi4p5J6hVEd6NI
	 qtRJPF+w+/K8TX/xl2SxAP8RjCKspzhVRbXn4XjtHsCXzos74/YiLc4gQhQLOKq1Aa
	 o/IJD9alpPAew==
Message-ID: <b7c17e91-cae7-46ef-bfc8-a9014d11346a@kernel.org>
Date: Tue, 21 Oct 2025 16:33:26 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/159] 6.17.5-rc1 review
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251021195043.182511864@linuxfoundation.org>
 <fc400181-7c76-6344-c6ea-a4e48d722f55@applied-asynchrony.com>
Content-Language: en-US
From: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>
In-Reply-To: <fc400181-7c76-6344-c6ea-a4e48d722f55@applied-asynchrony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/21/2025 4:30 PM, Holger Hoffstätte wrote:
> On 2025-10-21 21:49, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.17.5 release.
> 
> Hmm:
> 
> *  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
> *  MODPOST Module.symvers
> *ERROR: modpost: "pm_hibernation_mode_is_suspend" [drivers/gpu/drm/amd/ 
> amdgpu/amdgpu.ko] undefined!
> 
> Caused by drm-amd-fix-hybrid-sleep.patch
> 
> I have CONFIG_SUSPEND enabled, exactly same config as 6.17.4.
> 
> Looking at mainline it seems we also need parts of:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ 
> commit/?id=495c8d35035edb66e3284113bef01f3b1b843832
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ 
> commit/?id=bbfe987c5a2854705393ad79813074e5eadcbde6
> 
> cheers
> Holger

Can you please share your kconfig?

Specifically interesting are CONFIG_SUSPEND, CONFIG_HIBERNATION, 
CONFIG_HIBERNATE_CALLBACKS.

