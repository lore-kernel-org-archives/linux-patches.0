Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9E113C8EA;
	Sat, 17 Jan 2026 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768660685; cv=none; b=VY8tstQ7u1+clJE4sM3qOhMSAPDTOPXaVJAACsjFb1mEQYfOnAiLVOy8rqp3rIinptOjJykf66eCWdgNCCqHHIEMrbDYNl+IZIi/ylaFOsENqaPWCOenpcvZj/pXRnVYOTY2OTFdrUpyl0XVQOIe/2yFIJGn5x9LBFsG6J7tjuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768660685; c=relaxed/simple;
	bh=pwGqr+UVjROufaS9k6IfT1Bg3husHfLL7Ytru1IzVlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUo0sZ9CskwBjQHsIXw7Q1OFt5t8Pu7h7HGcGt1rwChGh4/lKs/NnYpzdjBngM+q9SZ6P7NBvvjtMaDq9m4f2sKLlt5W+MtGIv1SSiUctLVoNhOmsZD72Mo2VHy/QLMbTuZvUXbr/XroYFHVtO2b7YVzry6ymThFsct2Nrkd+pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o113/jWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o113/jWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A6C4CEF7;
	Sat, 17 Jan 2026 14:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768660685;
	bh=pwGqr+UVjROufaS9k6IfT1Bg3husHfLL7Ytru1IzVlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o113/jWNUv4pjyHrB43N7j8Dg9XOj0Fjw3oMG4D0HvhaZ0Z2o89jePFY6fFTck+vU
	 AYimcu4JzEC9BFT15QKw03lX41UkuzTVA9r0fNgWXSwYb6RxcP1T7jbFpdeB0QCg60
	 IWdUxfCeNo7dojyBe9V6iqdDY4OTEZI/jQNvEBmkwMuFMEKbPqJegpZmj8VDTwdMZO
	 dMyLz8ZTkVd4xtVGrKpQBVgs5CIRqfilK1fLbunZZcq3dk0NgwyYuB0tDDEPu5gobp
	 0/KvB2Rrl8i0mmcbY5BgbBPjJLdjsik/AHhcSIge+lwqVyVQf2upUyR+mKF8OUdQxo
	 h2lLq6GPOk7GQ==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
Date: Sat, 17 Jan 2026 15:37:54 +0100
Message-ID: <20260117143754.171024-1-ojeda@kernel.org>
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 15 Jan 2026 17:47:43 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
