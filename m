Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792851036;
	b=SaSjL052UxX2wUDfDADfaJgpuEJ18QxROfVcSkZlR1fDYh/3+6Yv8xNaVMpHjQWtj6w2
	 +6MumPupP6n0QMonfZOsTw5c6KBTfAVfti0DVqHPOC1ARWQzDRkTCA4TWIzO6aj0KMST6
	 U4DSds2r1XpyN1UFo1D17Gmj78rBkJ+uHvO7sAcvAfrJobMBYMBZwA46Y5tSC1Vx1Q8Zv
	 vsT7IuYNjJPH03anamCe6LQSE/SNF9rARbE4mG24VVqQBTYQvSJiWr81NFLi2zlOEkpsz
	 h053ns/KlYtpBBbqpOoG2wmvwm5uH/K3BEEi2FfmRaSjbrUxRAIKGvK4N0dGWjaZYcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792851036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1cyOmveFG88rblFA1+YPp569uX+2Rs8Ra++X7bjgTx4=;
	b=zPYJAWroWqvemvV5Qr0dMRsKgxE341bzeugo1a74tscllTC4P4RButjVDazaL2K5DGIr
	 BTRIXqRRs1QyVAch3+TQIZAtfNvolsIE2D3ANheAZdh/GDaX0225eiiFYqkzVqNXga2Iv
	 dWqCbrm8UhyAPVjbCmdiOrLVCLcYiiHscRlv1RjziVcp70Fm+MuBF7Yr1qW8p5932tR8S
	 WX3qDItecPcNtljy+kJ9l54AdskeSC8lVVUHQT3+4s1uJaQB7reEfRnv37bB3r691xkN0
	 URutR4NUT0ga3PHAZ5O49J6f3juenviHLV6Svu9a6awczEzpKj2/rUku42U7DOg5W5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfMqMdBE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2391606A31B;
	Sat, 24 Oct 2026 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfMqMdBE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31091F01825;
	Sat, 24 Oct 2026 14:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792851035;
	bh=1cyOmveFG88rblFA1+YPp569uX+2Rs8Ra++X7bjgTx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfMqMdBExn4Nwx9C+EG10zQKRFkA2fZEkLTHwckqGgfXMc8rQnE3zADGm0PGam9m0
	 oh3l+lXti5J6FhA3ZDxXtrZFbpar5zYW9Oejza32Xb1sC8oZKisdg7ouUgahG9LOMh
	 ZZqji/S7HVMAIViDY+3swCMjeW0Y04dOiA2RSwwgbtMrAEqezwkxCkotrGEXrxggqI
	 s4CmZBENVtr2OjS+7d+u1vIg+UOlOvxu9GRdHU4W39ujPqt7kwWYrbKnzdhNpBeREf
	 UspXn/FGtvcmGmW9OvceJv1gfG2/NMlHzk17icjkBL5kk+yVXytrCay46mZpSxn2dW
	 g2/0/SO99Iwcw==
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
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Date: Sat, 24 Oct 2026 16:10:25 +0200
Message-ID: <20261024141025.154295-1-ojeda@kernel.org>
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
References: <20261024064731.125251200@linuxfoundation.org>
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

On Sat, 24 Oct 2026 08:59:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
