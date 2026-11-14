Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794660163;
	b=5TqsUvl+DZ6PZN3gk8u6XUZMIyyXE7G9R8c7i5o/4u0TETfnF/C6SICbxP6S4mqw5IMe
	 njaH+hHrTSIiAH9qFS7s7uj4fz0NUazDn4IXw8hyaJ5I2N3AJQshDrwOOLobjZYkzz0mX
	 P5dytrwBEIEqwaYNXPrs52kC+Pcu38ajCPf0a2x7N9r86ayqpGEJAlgg+X+wEgqLT6+ix
	 C7X595eKKgoDuFJQXVYrrLyB7zUTOTKfHWiaGk5sWbExw1QlIPVoKLSRvkK3lGynZ8E0C
	 tHGCqCoe8/ke/ybJCTaLkMSMFfiIRQpiIyK27hdVSWIqYjE70GwLW2MppRywzjhaDbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794660163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=F6/bO5cetFPqhbMOtc9PwyTK7K9vR8m2Fecpdpp0T+k=;
	b=srvB95Eshu2VDhtVug4T5oyRFonuvQYEdsQS4tGT0ghAedd5WnDlEE6KZ8boLUpI+O1T
	 ulWH2efBDgVzj5tOAYNPl9MT9MVfS8CDssZQy5XHkWFrjyZXj0n9JJU2v/Rq0boyAOu4n
	 vANQXX/sOiozzE0ybZ+1Rhrkryktr0rGOZrvAXn94V2B83tW9SzNkPXEYLemZ8o9gLvWY
	 T7nCeGXM7ipMsI9dJs2cxONPP0cyUAs8NXdVrJpP9YFpdpvzIUFSEM6iC+7ysGJ11HZsM
	 qkHb0byB2vfC4ADCbwZQNr45W7TQY2ixN/Hxinsa+F++jdWgYo2JTFUUvUY/bEoVOBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OmPuvUyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0515606A327;
	Sat, 14 Nov 2026 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OmPuvUyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCD21F000C4;
	Sat, 14 Nov 2026 12:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794660162;
	bh=F6/bO5cetFPqhbMOtc9PwyTK7K9vR8m2Fecpdpp0T+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmPuvUyuDkXaCtdfFpDiLL3kKlMoP6dY6y16s2cWfAhkxxU+pK2vgrDvb9kNSTi9U
	 3q5NWph90FOV/fj6SunSyIVOMteEUvbnWJOm1DkzpzYM/L2p19ycEvdx4uyhEN3gM7
	 Odzm6ySi5nvEa2fhP2KD13n6Vj/GubMPIR1kU9FbOh6zYqS6MNkYl3ccolcDOj+uXb
	 QZHLxSYTnF953pqTVzLwQN9A/o4beC7mP9SSm0qQyMgH+5Ly+agaH4XLttVjoU3BJZ
	 kuD3gx/3ABQEgbeVOH4o8gSj0ph1mQzBj5MOVv3sFzjkCU6GvMbfHoav0VqFUZ7IvC
	 xCSP2NTHhIXhA==
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
Subject: Re: [PATCH 7.3 000/507] 7.3.5-rc1 review
Date: Sat, 14 Nov 2026 13:42:31 +0100
Message-ID: <20261114124231.113692-1-ojeda@kernel.org>
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

On Fri, 13 Nov 2026 10:45:04 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.5 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
