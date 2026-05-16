Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91497F507;
	Sat, 16 May 2026 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778895008; cv=none; b=QU3NnnV3JU8BCU0by3xpMJwjGejTVarf5ypgFgNiObXh4L1TEUERGwPGWIvcXOcRoRHg34SCZp0bC+V5IJGv2j6AgYqdTlt+zfutdSUN3tSQuT9V9DzPfzo7oV2ts02/gVGI7VyosyC7AWirkD0HcXJ6TANvxzkzmMKVUJXk1iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778895008; c=relaxed/simple;
	bh=bzEtM7pZzBYtfI1RRpjDA88ZflBOD/e2VzRrh9EXJJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkWnBjBH37TdFX3j5roR/kck2RueLXa4JagoHj15QZipRNfWFHPw4H+B8pO5O3fG/MV0tRytHBvIq2+jPODI2wqvk4rtMNc7fjlVkPU1b9CFUqSD4GQjqgcNCPgHOm8G7N1PLUowXwvBX1zXRKnuaLCNQHjK/LcwmxWriwZwUCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tBK48ThJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tBK48ThJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F829C2BCB0;
	Sat, 16 May 2026 01:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778895008;
	bh=bzEtM7pZzBYtfI1RRpjDA88ZflBOD/e2VzRrh9EXJJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBK48ThJ7FG6rqDkhPqh0jvG4ZKBuWtq2C7mP8XKgEJFrEXVSpNltdGm9Ma5qJir5
	 JROrogxa2GLCCSoAet+G6CfBN0zH9ybDPghexKn13FM04mnMKq0v/u36bdPwUUOkBV
	 9zn2JLZvhKsp3ArpoC54J2ME3CpIXA+jzUqZ7yNenz74MQILHncxcIDjNAzo8mkyse
	 PCzZeTCFntRwfJypKiOYyp2YuPyaJsHM3IlHVDP1NoN5yC1skB/xIiftBuOJx1S1lQ
	 xfDWzsycDxP7+gNdumZ+z06WhTeZ8ijY6da0IPnk9O0OopKLyS6jY19W5g2xT4wquj
	 NUSQZfBdDLq1w==
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
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
Date: Sat, 16 May 2026 03:29:55 +0200
Message-ID: <20260516012955.107017-1-ojeda@kernel.org>
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 15 May 2026 17:41:49 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.140 release.
> There are 474 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
