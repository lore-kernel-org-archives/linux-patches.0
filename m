Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2C032D0F5;
	Fri, 13 Mar 2026 21:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773436572; cv=none; b=eagdKvCbMGrY0F/wPzslKYloswg4W30klwhTQI0PzLS0GoVeKMlmffB/c/ZyQqXHLW3av6SW/M2KR8kowM9ViaVBqS0+RLHZPGAelbMtynSAU0U3/gvXCkZHwzHpLUudLb/o6gOifqJtSNmRSFGd9pnndCPo140KGTjcsVXva6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773436572; c=relaxed/simple;
	bh=o6SuaUixfOBVxoSaRUT1MxJPWpr+FofBCMQw3ex+IoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2e78FAiLLqj84Moubg52EmGTy3SDURabfA8NyqHWVX5mH2Gzlpzw7oY379W7daC7Fts9ZcL5Jw39cG6v9xZrjliN7pj2/YOCCTrEba792DkRxA5E7fFarIYW9YXXj0uHelWPmhr2c1u87WcCKF+ssZawk+jELCuNs7kkDlC/W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmyJC/On; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmyJC/On"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C83C19421;
	Fri, 13 Mar 2026 21:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773436571;
	bh=o6SuaUixfOBVxoSaRUT1MxJPWpr+FofBCMQw3ex+IoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmyJC/On0zJv9YuXiHw8Nil+KOd6WrjGspN9H8YIo+oHZuvwv5qz9w7OC7eBeer4C
	 LZg2n7ZwPragREE/gwFgk0MO+m33fQUyahYpzolZn3glO9v2I9WF84fsvua2GMh3QG
	 TN/uhng5ZjIm+q3oHnzu20CyGIsoH36reK/8h0tKo8cT2nzdxYSd5SHrKwmShkt43T
	 jxxf9ShB2Ue25Gj2nHmA8xuzkaDzbjA8wULs0J4n8C3WohMY0FZ/gHlPCGXuJW3Lco
	 n0NveuLhGEGYHAtlt9kpYLmf3szLgdkLu4lQ4lQGTfFvJzUiPMoweLMmPOrnAJmsqE
	 GSC/5Gi09wZdA==
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
Subject: Re: [PATCH 6.18 00/13] 6.18.18-rc1 review
Date: Fri, 13 Mar 2026 22:15:59 +0100
Message-ID: <20260313211559.184021-1-ojeda@kernel.org>
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
References: <20260312200326.246396673@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 12 Mar 2026 21:03:41 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.18 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Mar 2026 20:03:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
