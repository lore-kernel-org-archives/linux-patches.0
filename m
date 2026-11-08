Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794156297;
	b=i1Phh5cbrX+s8NTm4xuOgQwyIpnTxKVyxzRHCqL2/Mj10tYlkYyc+OYs0yn0LDnr0xKn
	 OuPsB1Vxoq+aWgVKBXPXKrglbfuVrIHix7XUvySAC2LRCWZBseGTUMT8+PSm241ErTiQ+
	 ErQUfdoxIIxJgoPr8ApRnshIcuP9WqY6FPxzrPGWwxk8kXlHjqgt477xo/HbWlIhnxnmC
	 BOPFMM3lMGa28Z/CWkDQ1ysk/Qo8lKdMK7GTXSPcRcRZhNq3OB5c1kcwP59CDiAqiitpe
	 khPgfmB/96dxXiWwXJpCw5LonvZ8Qc/PWOT8L3YFidsMNxR2UbpRPyIZIfa4pt9WiJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794156297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ocheey9ym6CpKRNuuU4ykX29RIoPZM6O0SiG9if3EI8=;
	b=KYZVZrxm18aA+QpYi+YoorjuvT2XzlBawIWzN0qpuSVFqozIjRvJLFnr0WBZN7bGDFb4
	 qQm90t7dxOMgm785V1dyrZvCxB3AGqExhNO8YKBsKZ77q5mUT65ov0I8sEnhv0JxN5/z4
	 UY+l00bGz4TCD7oKoyKlqL6+P12x9TOy4IaTBb3a90cPJFffNxWq8kzx4Q+JAX0qmVP9m
	 z/bdYUIgDxMt509rSbCmLFuPgwWwPjksCTuuK2HGrIPjgfgC5xD3eeoAb55qi09LTtx0F
	 FPbrn2yeBTWuKi7VekSTeMonNSKxuSWQzeAOsH6syWbVDSjFN3HJEoFdZ8dxTO4pa0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amAPYSTF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8BA606A322;
	Sun,  8 Nov 2026 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=amAPYSTF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C821F0089F;
	Sun,  8 Nov 2026 16:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794156296;
	bh=ocheey9ym6CpKRNuuU4ykX29RIoPZM6O0SiG9if3EI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amAPYSTFmSq+BATzwg+56go6sXKn7AoGQbCEcovJWUSB3BllnC0ucHrcJ4xwf5J7E
	 NFlBxFI1wtVsixWwyOjjasEOL2zLvDpth4gFdRJP/VToblhfAgLKIEITDzezbPxfNr
	 vR4JoY5FG21ca0Nxj3yCpCeCxJ9b6+DPos/qGuk5eWQbpsdDglZIok8CchhI7EV2bA
	 Lzt0ckky1S80HhdQZK4lEOfvuwJ5Y932lxiocyIaxSHq4Knkc9Jw0L4uVHKPhz5qXR
	 g8Eo0BGrbxgEaSTBLQFgVt9DoFpwo1cfpbwgpupp7tv48VjXqvrXR9k5v0urDf84nH
	 dp5onlMWR8IaA==
From: Sasha Levin <sashal@kernel.org>
To: Ronald Warsow <rwarsow@gmx.de>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	Pascal Ernster <git@hardfalcon.net>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Peter Schneider <pschneider1968@googlemail.com>,
	Joungmin Lee <leejm516@gmail.com>,
	Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Date: Sun,  8 Nov 2026 11:44:47 -0500
Message-ID: <20261108-rc-reply-01-sched-ext-7.3.4-rc1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <68c2efb8-e54f-40bc-9c36-76c719a590d5@gmx.de>
References: <20261107134939.434104957@linuxfoundation.org> <68c2efb8-e54f-40bc-9c36-76c719a590d5@gmx.de>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I need to revert (here)
>
> 1564da6afd7ce5297ba24f2d1e61d6a79a9ff6db

Thanks for the reports (to Ronald, and to Pascal, Thorsten, Peter, Joungmin
and Takeshi who hit the same thing).

"sched_ext: Fix the stall watchdog testing and blaming the wrong sched under
bypass" is dropped from the 7.3 queue. It needs 30fb2b1e4d41 ("sched_ext: Fix
the running task keeping its protection into bypass") and 5809f749fbdb
("sched_ext: Fix a bypassed task stalling on a cpu its scheduler has no caps
on"), which provide scx_exec_sched().

-- 
Thanks,
Sasha
