Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795187545;
	b=HdXkJ8BIqgEUSWxmE3+t0khjEMRPYCzA61p/qjwRFp+BJpGsbl177s/0OoQXhKhSqTtY
	 iRwJJ/2Cv/R+t0C5UtbkLdlgCMn8vsh1UrkeJJ77nYXUl7aHfFY+6sNMQdoorjHGOuUHk
	 y0bPDgy6cvLgCpWpWU8gdZ+zaxz4mhrc3FyQcmGg7C72uxEzyz26FCBzA2iexon5ax6vT
	 T+Y6jH36YjjP1KYyWRfyrsNcIs+H9a0/8tUH9E6lfHDPigPyG/2lO9MgmHk68Xzcp0/yl
	 mBJtt5OyvdJci2vhSdwdO1fSBRna7KU9ZGRziRTAqfE4zZ5N9lC+cplgznoAnvIi4Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795187545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XeHR8KcI4u5N4CABwzKgjeTMfIUHpiO+90sGtoBXfzE=;
	b=G/1kbzMqvWNEyifrghAT5Imi3EAYQJZqapfdJsXZ+KMZF6KAcWpzvC2aJ7QYKq6ouYMx
	 8tRN39PEOjCIqMl4XEJPzfmNmWyuImsIks5yALPTzbMEZiql2He/6UkPuosEbGUIOapxg
	 1+o3gDvSSANMxERZ4ckfrfYsHhTfGVZNkih60zGBzAYgkQXz6SmkdcNRjygWV85dVs3Ze
	 g+g6xMGBHtrKNAvsnsLkFRPbDWWG2bOf2EoT8k7CLB11qSfLCnKfXaaIt/Jy2R+FVm8CZ
	 SM8/IYWbc2e2hWWKcO5mMYDULZLXbkiJ/S+cvPXY016POh45ODPGhc7yLrJmuzXM9bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lc1vRAnl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F54606A32C;
	Fri, 20 Nov 2026 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lc1vRAnl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D178C1F000C6;
	Fri, 20 Nov 2026 15:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795187544;
	bh=XeHR8KcI4u5N4CABwzKgjeTMfIUHpiO+90sGtoBXfzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lc1vRAnluELw19Za83aYiKwzRxIiGlTtm+kG+Y3fQ+Hczy8Uva68/XpPvOrWJZp9t
	 GJTtM2hPg2zH+1w79fXPbxGsOWbLWPqOcFIAnOD8VUwvSgH1bUlVZu6XoI/UywQRwy
	 ICpo8FGnutqVi4qR3qYCivR//VU6tWA16ckXu+csHLpkEFyhYHrh7nS7MHm9arMPL5
	 oUGU3RRRhyRopdN6+AoyruTwDf5gcK0s4cN2L8Vk622RjomUxfHp9/0H6nHpnP2nr7
	 aC8KJa/tyNysSgvAQsbZ5CnSl5oEEZJFPN8G5VC/teV8VEr7LgXGbdHB3j58X6J3lS
	 DqTPEMuy3nZug==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
Date: Fri, 20 Nov 2026 16:12:14 +0100
Message-ID: <20261120151214.22886-1-ojeda@kernel.org>
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>
References: <20261120054951.366579794@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:57:42 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1736 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't see anymore the `BLK_MQ_F_SHOULD_MERGE` error I reported in -rc1.

Thanks!

Cheers,
Miguel
