Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62E405C53;
	Sat, 16 May 2026 01:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778895243; cv=none; b=YRtSF/7srhayfEdCz0s8BHdcqIbp9Ddi7snQ3EbJMYPHUww5oTjRiq5kZW4/RmBgDbySQ2a9ydWfivUNas562o+ixjFb7F/HkKnROm/d24mO7sQcTw5OkFFvbDoldOFJWIVcF5lK6+m3eu98qZ0/msZ4nROD0bBPU6Ms21PwgU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778895243; c=relaxed/simple;
	bh=GrRmDuwWDat0PKscgeKQPKZxuMmGDV9u/waYbUoJfzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoywmHHXcAd0312ozzo4AsdgQtI2A5N4EAXOwQE2LNA01a2wzQscHIHUjewNs+BZyepbTrrwgGXrqxTd69RHSJ6XRvZ3p+VyGlZ0fsafFNVkHrYmZtwDHFbnmyiZe84z7qir4nzi3t6FdDM1dUMls54S0pMaqUclMin32OFI3fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XrRVyZ4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XrRVyZ4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F51C2BCB0;
	Sat, 16 May 2026 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778895242;
	bh=GrRmDuwWDat0PKscgeKQPKZxuMmGDV9u/waYbUoJfzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrRVyZ4wPgk6kpRmdHDakAtNHU4LPXzQ5kzwnwMJn0nRbHd6c0F149cksFFIjJ8nV
	 tOs2fPMkzfW1XCSAZ3CjjkKUD0Lm7MPz8qnJL1qSYere6M42bien1WVo6drGplo6ER
	 GMoDnEVxvtTc8Y6HEst5/R28truYSGSVtBbBgHnRwMnQyEqWy+uMNtSZIDlLuA8SO4
	 KuScsZnegikj7rX3DK0Y1ZUVP1/J34v1XLINMfN5ZWhs93TaKt3GpN3AwwiNyiFHp3
	 9W/OUZzBLWWH5psgyg1XOHSb5mh2ZcbsxuqwUAQXtT2XVKwfW5xssDYZNwdVgtqfWs
	 zEvwKPgbAamgA==
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
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
Date: Sat, 16 May 2026 03:33:48 +0200
Message-ID: <20260516013348.107539-1-ojeda@kernel.org>
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 15 May 2026 17:47:06 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
