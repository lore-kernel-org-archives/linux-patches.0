Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FA324677F;
	Fri, 20 Mar 2026 00:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773968059; cv=none; b=HhBYiugLv61I/vBdwUPnqm9mHRQyZ9euvWjOK7eenFFMUzUBbPhdrGDRX/KH1FQOjrYHSwQmBD/AEUWzX4VqxCOOpyaIIMbqvZtp9yg6h9lGWqxh/+/2YtQdsycdW32upvMuKsHhoKln8uKtsI7H5Ls9B6TDCdItRc08UdjwJdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773968059; c=relaxed/simple;
	bh=MDXqeZs+Vnlfe5bTSGvfaZRthZjwZuz9ms08xEXd3dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8nYv5qsw1xa4QD8+tzsBRORPXiYdv8w39GDHUakKPNpdZ0y8QL6jRCHrQbn5hn2pkOHKueKJM4ynvSLTjl3iBIbEmqF4q/3WUZ82tymLnuv1ZFWzlrwNX7Qnx0ZFCUucVbtLDA6lN1BC2opppMaoClztYfOlyrhXGY7ZTdscAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/VsgxjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/VsgxjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D339C19424;
	Fri, 20 Mar 2026 00:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773968059;
	bh=MDXqeZs+Vnlfe5bTSGvfaZRthZjwZuz9ms08xEXd3dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/VsgxjUilrlC/L40b99B8BFlyZcIg+AYOHP24RnprFXNqmGU8QIhV8FYlC5FAcL+
	 +x0qteUKrqXFOI+cRIVuTNy2cJe0fTFazHZ7nJKQGgG5NBQ95Ra5oJYIpz8r4pfBg+
	 G1/53fxFhmu8OnUJK53CpcDo8lP/vJDZFUHdWbIi0yPQhpFLXuDlF3HVpGyAd9ffOf
	 5mPI0MMXEXlcYK+MAA8t+h1k11i1M8E+LGJg7A+t9GYDsmqMoxexyOI8xOGSt6vXoo
	 k9rJ05gxG7cVIn3/mz1+jI1YA7JiTYla2topfDSfEc67pVZ26amQ4Ch3thJeM0Yf1L
	 JOLiH/YlT+lpg==
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
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
Date: Fri, 20 Mar 2026 01:53:58 +0100
Message-ID: <20260320005358.10038-1-ojeda@kernel.org>
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
References: <20260318122621.714862892@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 18 Mar 2026 13:27:58 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Mar 2026 12:25:23 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
