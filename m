Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8AC3876C5;
	Thu, 12 Mar 2026 09:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773306336; cv=none; b=RRhFSAhNoMqMJJGTsDvijBQduQvxc0YXXUkwacqnJc/oG9AdraARQZkOwrANEwmFM7WeyS6E1plI6KLMLmmFRGnHDL7gfbKLkUsIDsURx90j/kYhVNJU/M6DN8XpTioxSo/0PUQARMKosSoCuZE9Hu0yBhGxpp/fqRtvpJ2YJjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773306336; c=relaxed/simple;
	bh=xgLXqgkYV+RSF6h2MuiylYskHHoupd2DfCcfAbo+zw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJ7ACMSHHnkwwzdm/1XtBjke3T2+vsEZRe7Vzv+gW3FKB/OTgdo55T4UzbfL2x4JQLKuNZuNKFZJ/KkyWP3jNZRrdUgEtj515b+WxGRfowlVsF6CaCNW8TpOhqDlfi+wlimqvOaesd1xcQ2Cym/3HjPAzUMoTq7KyW8vUHfuscA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwCOehY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwCOehY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E535C4CEF7;
	Thu, 12 Mar 2026 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773306335;
	bh=xgLXqgkYV+RSF6h2MuiylYskHHoupd2DfCcfAbo+zw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FwCOehY9YCp9YUcSS16Zvj8355iGHcyoCD6JZgnaZUJpzDWLPM79y/7lj0k8GcqhT
	 FuFh+vMLYlL1snTQJBFyQXLaTp6WVD2zCgtlZJHlWcJxUkd/AHGEmMUq3gXFj5hRv2
	 IqGHOsXmCqrVJN6Q0pIz0KXXO2xGzgafdedhq/IHBL+UYycqfEdAO55Uom5yrhCkq5
	 3PWVwUcD8DFRN6RzAKwYuUDJQ/zPc/rO7ijZDEYtHPbf+cslWt9EdzvkZ4qTnXSb/x
	 +2VqsjE4+YJ5LMU5rqOHkbpi/WBiERM+fYieQ60yiibXm5K0EGshJDOgG5zLslvr+3
	 SvfC7FUWYh0RQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: sashal@kernel.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	gregkh@linuxfoundation.org,
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
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
Date: Thu, 12 Mar 2026 10:05:25 +0100
Message-ID: <20260312090525.57500-1-ojeda@kernel.org>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 10 Mar 2026 07:05:54 -0400 Sasha Levin <sashal@kernel.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
