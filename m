Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBE525C707;
	Tue, 20 May 2025 19:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747769111; cv=none; b=p1Pnrfulcb0lgmk/1b5ukoHRSgwIHUOLNeyCVbMDI9aXKqWcjLbqPhbyS2/sI2yKFDHGKiCj5VJeRq0dc0vsWibax1Lg15CkEplsd09FIbxn/VuzrfpHwM8TGhqn+3+vGkw3ONApXgw84zjIAp8Xoz/U2Bg8xNr1EqCUWQk4CtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747769111; c=relaxed/simple;
	bh=bQgOF1utoXWEyH8ZdstymbRT4aWMNrmVlxjsAeALsgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKbyrkb2dt0RwjDawAN/V9uiFR/4O8lZKGzRX0MEj5XnmTYrrnoxI3eSMs6KqJ7jBo/ZRzFwXo5JGhApUX9y0J2uDpM1MhpJsh7wyZsRV8ovmWtHmbVVBej9M55HsT0tacfkzJ6hz38UX3ugc5aZLhgnZtF2xsRVVAJ/lcydvp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtQB2L+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtQB2L+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A45C4CEE9;
	Tue, 20 May 2025 19:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747769111;
	bh=bQgOF1utoXWEyH8ZdstymbRT4aWMNrmVlxjsAeALsgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtQB2L+2jgtnVqFwNwvm/EX4vmi35bV8Ml8mCORWhIR3Z9Mgywm8D9cdH3hIAru+t
	 KQmfHpMOAb1Xgp43eEPSxdS6ff2WwwPErumT2sZTrBZflGLqp5ZsWFZkxttuG72jdE
	 Geb7Jqm1JDMYb6d/+CFev+jd2zBYvlXS5cDzpxyO/Kn62GS1+HSvJs9nkup4k/sZ/Z
	 FLZXLxjU1qEK8Rw2waK8UmLmNGiMA6D94QCCYCyHKknJ9AzU/p1JzWYtAFdoErdMXm
	 IuN5R5IQhg4H9w8xhc6DaAnN+rRke4G/9kZRT7NPGyz+Q5l79XSD/I9+B7jRlDIeMj
	 ECBhIFTo6v09w==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
Date: Tue, 20 May 2025 21:25:00 +0200
Message-ID: <20250520192500.890306-1-ojeda@kernel.org>
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 20 May 2025 15:49:15 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
