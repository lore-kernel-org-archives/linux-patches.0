Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2EF1F92E;
	Sun, 15 Feb 2026 00:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771114494; cv=none; b=JvTzUh32eO3BSe3fK+8LYNaieFNv5Htzf4uOdzVEFHMH7xG7YA26vzTvC3e9o2KHfQKAiZgS93CaB6DYBBYevFIlyNzAbRA1D4mnai7tjHesZKsF1+CQCF2P/23pF+bdQnvPfmsYPO5HEDOTnwZpRWm9OTtrM5w0PUPNrg2RvKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771114494; c=relaxed/simple;
	bh=WcbGfIuwBDOhvCpFmyWKk3VTxIHi9dQF/YfGLkxnJlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMCcpt9ySijShcJDqI5pHWsMsT25oH89J7bmPgFGIMkIv7ekd1BbmkeAGsobIjuBsH5Sa7OkMiLqOv+fSXz7sRw20I5NSxovTlNuH0cBotKEh+4NQtST3srlMWG6j/wY+uh+HC8EX74Y+f/jRozrjrDT9jjF5VjqwihXes53yL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sT6ybvOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sT6ybvOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B6DC16AAE;
	Sun, 15 Feb 2026 00:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771114493;
	bh=WcbGfIuwBDOhvCpFmyWKk3VTxIHi9dQF/YfGLkxnJlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sT6ybvOboTOjj1gn/7HlImTj19cr1pUKoIUbZCJfHniLgmqQQVgNO6unMA1BFwhBd
	 Cm01RmAaqUXiVSoKIEyiUqgIA08x0sUJnpqCC2swaes69hfLbryjDgQdG5ipHY/R9T
	 HZZm134zVER5xoUo5iVakWQBJHim+KHlTCKCUP3k+MTdeniRySYQ5f5NHjnqdM2rUS
	 LkT1QOO/TCOa4DggIkan3ihnz9vHB7Q5NjCL7e3zgsi/qrVq0jvJt5tNcB2PhcLRNF
	 +eClLAWTi+locE5UTEsAZj91TM7R7bM+c4Us/C8YXYQTCD5xcZDPo8fPQfV42Gk1b1
	 D+GwNzdxTImsg==
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
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
Date: Sun, 15 Feb 2026 01:14:42 +0100
Message-ID: <20260215001442.43424-1-ojeda@kernel.org>
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Feb 2026 14:47:44 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
