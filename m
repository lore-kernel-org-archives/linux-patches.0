Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF89310763;
	Mon,  2 Mar 2026 17:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772473793; cv=none; b=soTyoODn8TCcRGTyk32WX+UYnCLsKsNHPX/F3Mot4ln12E18m4Qvrk2Ehz6ZIZZOd2Ss/RzoQOttl5FdYblY8yLj7sh0hOhEj3o4HfmlYWXFwFw5WNDTp1KdyrRCwu7FszY0JtsCJVRTtK3vVLdKeX3/Jfz4rN8412pBFj/sHmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772473793; c=relaxed/simple;
	bh=E9E1uO0V40Y56xDIRSxMj9LvmLCJHkAiSoneO3rf3dE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKn+PIEW7Fr98pUkpvVA9jYRHikwQh6V5bTcd0l40v1lwjf3t24oE+tvEwkaOiQrSyhKEP1oao8bCwvuQYybcR2pBdbd5ztrCOQhThIEcUKBIujRLVHSUuAAwA7/+TjrYnimRBnSM5wSMzednID9I5ODqc5i1JXumidD9VQDyW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uoHzyHnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uoHzyHnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D16C19423;
	Mon,  2 Mar 2026 17:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772473792;
	bh=E9E1uO0V40Y56xDIRSxMj9LvmLCJHkAiSoneO3rf3dE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uoHzyHnNc5g/wXBYJzj2TkmcOncOPEnfs8R/WApstmu7X12DnAk+B8aXa76uZNkjn
	 k+eZWYP4A8tdBfe71zUj2MhcZuP/r/63yNBDY5AeOeFZRmmxuplUsT6wKp7kaAoFE9
	 MXnJtGg6mWJwmS+pnV/z0OBw+Kzvw8GKUSxTIJTtR+emmeqcJnx6OJY0pdnu25lP5J
	 hZju354dwoifjKV8mPY9vZGvZcTFFhkyxgiPelWZJssCDy3flESKQdI8G/FF2r8KxW
	 NQ3jOJel2bBrSvWzlxSgMyjgUKM2UXC45zJ7vhbTP2JZTQ2hHSa9qC2ZKdjX7p7IOf
	 6LBDvt0wsJVeQ==
Date: Mon, 2 Mar 2026 12:49:50 -0500
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Peter Schneider <pschneider1968@googlemail.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Message-ID: <aaXNvoIGNjR86bKY@laps>
References: <20260302160943.2522184-1-sashal@kernel.org>
 <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com>
 <7cfc1cde-a8e1-4802-831c-3e082b22fa73@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7cfc1cde-a8e1-4802-831c-3e082b22fa73@oracle.com>

On Mon, Mar 02, 2026 at 11:06:17PM +0530, Harshit Mogalapalli wrote:
>Hi Sasha,
>
>On 02/03/26 22:56, Peter Schneider wrote:
>>Am 02.03.2026 um 17:09 schrieb Sasha Levin:
>>>
>>>This is the start of the stable review cycle for the 6.1.165 release.
>>>There are 533 patches in this series, all will be posted as a response
>>>to this one.  If anyone has any issues with these being applied, please
>>>let me know.
>>
>>
>>I get a build error in arch/x86/kernel/setup.c:
>>
>>   CC      arch/x86/kernel/setup.o
>>arch/x86/kernel/setup.c: In function ‘ima_get_kexec_buffer’:
>>arch/x86/kernel/setup.c:385:15: error: implicit declaration of 
>>function ‘ima_validate_range’ [-Wimplicit-function-declaration]
>>   385 |         ret = ima_validate_range(ima_kexec_buffer_phys, 
>>ima_kexec_buffer_size);
>>       |               ^~~~~~~~~~~~~~~~~~
>>make[3]: *** [scripts/Makefile.build:250: arch/x86/kernel/setup.o] Fehler 1
>>make[2]: *** [scripts/Makefile.build:503: arch/x86/kernel] Fehler 2
>>make[1]: *** [scripts/Makefile.build:503: arch/x86] Fehler 2
>>make: *** [Makefile:2025: .] Fehler 2
>>root@linus:/usr/src/linux-stable-rc#
>>
>>
>>I always do my test builds with CONFIG_WEROR=Y, full .config attached.
>>
>>The line causing the error seems to come from
>>
>>73b97ee06bd63 x86/kexec: add a sanity check on previous kernel's ima 
>>kexec buffer [ Upstream commit 
>>c5489d04337b47e93c0623e8145fcba3f5739efd ]
>>
>
>Interesting: I didn't get an email that this got queued to 6.1.165, 
>note: this is not in 6.1.165-rc1, but in 6.1.165-rc2.
>
>I only got: FAILED: Patch "x86/kexec: add a sanity check on previous 
>kernel's ima kexec buffer" failed to apply to 6.1-stable tree
>
>In any case: we need a prerequisite for this, so I will work on 
>backports in a few days, I think for now, we should drop this commit 
>from 6.1.y.
>
>Also I see something unusual -->
>
>6.1.165-rc1 --> 232 patches.
>
>6.1.165-rc2 --> 533 patches.
>
>Can you please check ?

That's the reason for -rc2 :) See:

https://lore.kernel.org/all/aaWWE5uQqz_eG69i@laps/

-- 
Thanks,
Sasha
