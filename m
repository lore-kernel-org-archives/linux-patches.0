Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350AA288C81;
	Sat, 19 Sep 2026 12:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789819819; cv=none; b=S3IUUNZcGTcgNGSIa9C8xvp0E1SZ08WKF9KlHQITEAuxFEtK4tL9BOnG0WESP+uePjpwUITOasIenwW7ttpR4a82ZVRQIWXEFea3lXQjgxxO/UzEToDLPHn7nZ3j6o6XOGSL8ZBGI8eATtOq+e0WH5EhmG6K5n7h00Ogcp9GprM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789819819; c=relaxed/simple;
	bh=NR2a+XeOb6+lQg/fem62mSfgGuJCVNNvl88EHF/WV6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8CBI0ykAidg0i/Hg5X0oA1fDQG0Q/ysHSOENYdEe669yrvum8GUwI44uNbZpLgOvx4jiJazpYDZrtDs+nUlPdLWEv5FEHdLIjTb8w3fbta6b5Mnbk8Q9Tw9Ye5zSDRe0xVJL6Ue8LpWVrrfziKKD3nlzF8rcmVO3weMLOWKt2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfQqevKc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfQqevKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1E81F000FF;
	Sat, 19 Sep 2026 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789819817;
	bh=kH5ntVlN7TFmTaFvUzxDesxALVDub1szy4pQ0HKJv5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfQqevKcx0DuOEkufgRfhb4jTPWn6Jy5cc9OhBDOw7f2HS/YHL2obZGrouqyDfVmi
	 pgaNfNuKIgbZ2z+nOGEvISuVsoR7Kp4DgtgzlxZ2gFeIz4uYFOoC6myzCjxyHKeqOE
	 i4MhcwJn5wTrf4lsJVs5rtgz6QJfLGp0CLBwcLF2ybyQnr2Op6We6CTDGwQXQ88+lh
	 NLIk+EnNh8ozNAATIBbiZJ4Ih/ckPnsdBLb+IOwSdt/FFQJHmU2Bb6Vw9MbpGzvlDk
	 FpBz7ojxsa/vi6W5jZhcumrysZo7gUJ4GQKNfhoozO6yIwtagkq1Sjv1tqEV08hL9G
	 mOsPAksy1vrrg==
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
Subject: Re: [PATCH 6.18 0000/1250] 6.18.53-rc1 review
Date: Sat, 19 Sep 2026 13:09:53 +0100
Message-ID: <20260919120953.13213-1-ojeda@kernel.org>
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 17 Sep 2026 15:56:35 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.53 release.
> There are 1250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Sep 2026 15:13:46 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
