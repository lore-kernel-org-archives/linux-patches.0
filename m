Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D17CA6A
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 09:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="YkpmTlyy";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="H7w52jMq"
Received: by nautica.notk.org (Postfix, from userid 108)
	id F414EC01A; Tue,  7 Nov 2023 10:08:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1699348112; bh=p1hhTlkHRNBwSalgO0gLVkqAEwk8nZAf/XeSXUwldc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YkpmTlyydJsYin0D/3qcpmebBI8LuSeqZoqDOqEwCN2Yr7gfjjWsu/OU9ADQqpx4Y
	 q5ZzBmnZALYGfKQcOEMa5s2+IQt/FjgLA1iOEU4HyTF3rS7tqEdwL8TgmQze0OOGLn
	 hGdUZx5KsL64DZoqQUOCqdQiA0oU7b0XE+w9o3refghJkiqKM2XMjKfPsXJB2e1mTP
	 ddTeofP0fOc1qHAcuMlKMOfVE2jiU2/GpfQVR4MTX24Ro06N0AMMTOiDhJT3HYNyUc
	 /seudTX1Rc2q4lcAtrgC28pS6pu8QN3yPwB0SHEh9RtCCeNXg1ezlxET08qnDDMAI4
	 r+sjyLMXqE2aQ==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id A42C7C009;
	Tue,  7 Nov 2023 10:08:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1699348110; bh=p1hhTlkHRNBwSalgO0gLVkqAEwk8nZAf/XeSXUwldc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H7w52jMqsQ1Gb6vTLqkBSTcJA9YesVDgf6iZYUj8JCd843h1mAd8YAw01jF4Ez5bR
	 0U5oPwYahyMn/82rK7oTSIXYdqASB05N1L3W0sZD+s6ESCPwvWunuuKB1jiziYKjGy
	 bjdE2yR/cybHUasnrdxrWJGEb1NjCqQE4oZQWqxODMriWHcYQv6CjBy1KRjXfMiz8f
	 +aglC5EAZzJl/d8uXfVLJWb7u1zwZhX8CRhimFa/3W+Yw85BMbj3VP2LmlUQGxhJav
	 gt6aBGKnuT+UZ3E9Nk2dz7XY0b7mK2DcNIMFEIoe0xLs/BrjzkHWAIzhokJaCEci/o
	 DNUPPrUdMIukA==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id 25f2b5b1;
	Tue, 7 Nov 2023 09:08:22 +0000 (UTC)
Date: Tue, 7 Nov 2023 18:08:07 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
Message-ID: <ZUn-d-s7J8cmS-em@codewreck.org>
References: <20231106130304.678610325@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Nov 06, 2023 at 02:03:28PM +0100:
> This is the start of the stable review cycle for the 5.10.200 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>


By the way, I wanted to start semi-automatize this (for 5.10
specifically since that's the kernel we're based on) and started
watching the linux-stable-rc.git's linux-5.10.y branch, specifically the
rev in this command:

  git ls-remote git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git refs/heads/linux-5.10.y

And there were two different "Linux 5.10.200-rc1" commits on the 1st,
3rd before the final rev on the 6th (this mail) as I assume you were
preparing this branch (and it's perfectly fine!)
Is there anything appropriate to watch instead, or should I setup mail
filters to see the announce mail instead of trying to second-guess the
git repo?


While I'm asking questions, I'm also comparing the dmesg output from one
version to the next by hand (as ordering etc changes a bit from one run
to the next it's a bit hard to automate reliably), if you're aware of a
fuzzy-diff for dmesg outputs or should I just kludge that in a corner?
(Should have noticed the MMC quirk regression[1] in 5.10.199 if I had been
doing that properly last time... It's too easy to miss when a line just
disappears and there's no error
[1] https://lore.kernel.org/all/20231103004220.1666641-1-asmadeus@codewreck.org/
(not yet in master))


-- 
Dominique Martinet | Asmadeus
