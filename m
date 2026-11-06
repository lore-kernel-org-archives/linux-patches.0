Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793982958;
	b=x7/fQUGYTAyLQ+2yFtftLjdjBtVwFqPD2UquleV+B92FXgV1MppttwWdxft73jmp8pju
	 MEa5YuM03npd5RpUor+/TpwoftZo8atlRrFAsQRpjIaB21YUZP+F8KTZ/1PHp6yurLHqI
	 /mdcU6FvvWWd18VoqWb+P8Ew0CWXuyCUWJ36PJ++yJUtuXZzS8EXxjNfgDpFRQQrhbMcr
	 il8rclmm+AJ1wVwtjJIaUCEGDNMTrvlO6NMkA+p4sefd0r9Xi/UlJUCsasLwQsSiReUAX
	 0/Bw4SGZBy8ntxXkL4XgfiUO3pa84HokFD3/8dQJU+D6axzzJhzihvc3CyHi0ea5mfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8oLI0jMRmvv1l9rLn/SvFZygTNaH4wbDO6RVrpAiPz0=;
	b=LUcLr+nIUuTZRydjEYrd4NXWuFPEWNSaOkiAjFID2odlE41cSBu0LUx/Wtk/Xm5YWqOs
	 ANFbTeesIum0iB/53rZgmVl7/Bz6TYI1AwBolHtnZG4yLiFrPFmHMdSFyYeaveZEbPudI
	 CMYPUJxTxspZIkLWks6Y9InMREVBQMyqq220ojCYs+tYL8MZWqGLt4EyfpOoa/VXv64yX
	 UN4oSDBSoAKL9M5ZIfAqfownUCowP0TGGoCNbVmxLfmuejxQct0wjr65v/cmgKvLsa/EV
	 sWlNHih2jMN94KKRLlL6e+OzsGEWCL4BsE/shVImTzKJP/KJtaf3paPikvM4LC4Y3Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ut8Kx1TF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2433A606A32D;
	Fri,  6 Nov 2026 16:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ut8Kx1TF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC32C1F0089F;
	Fri,  6 Nov 2026 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793982958;
	bh=8oLI0jMRmvv1l9rLn/SvFZygTNaH4wbDO6RVrpAiPz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ut8Kx1TFDaYqjPfdPTO+th/yM3bDmGfVPf5EFpL47K3Pq+82z273gToamf4jPtWFX
	 Bld+IFD4WVWgYOuxaKKs/U8g5UfF6gQg7HDOsrrV8E0ilRfah+Oe/zYR1ccDkLqPQJ
	 IIS+Tel91O7u0YwOVjYu3bTnFD7DHhB1g12EdiPM6t2tZ/GURT6Dy1Whbd5CTa1kOc
	 ZodpgwdMKRSNDUQaUsCVXx8jtDBAT3m/LE5BTYp3f5b8eajy42iWbqLh9hK8YApVrT
	 DIPZ19xsmLU1CaTQWEElcc/sP8xUDlds0h8PdwS2JopuVNmJRQqfvOtkMb52UWFIj9
	 VfmnfiL2zd+hg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
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
	Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Date: Fri,  6 Nov 2026 11:35:36 -0500
Message-ID: <2026-11-06-1-daily-reply-0001-7.3.2-rc1-wx@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
References: <3dfb9b8d-3bf7-4fa2-89ec-6561c1b7b70e@gmx.de>
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

> I need to revert:
>
> "x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()"

Queued "x86/mm/pat: Use pr_warn() for early W^X warnings" for 7.3, 6.18, 6.12,
6.6 and 6.1, which is the fix Jiri pointed to for this false positive.

-- 
Thanks,
Sasha
