Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA566220F54;
	Tue, 22 Jul 2025 21:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220536; cv=none; b=WRjnYJeKoLSstoQh3fc/o/FIAamXvnBJ7fsd8SeAJtPiooBKZRcWGwfWxU3qT6XDtuOlQJbtg461KlAsD2tGEcwuxrW9Vv3GSYjkpSAkS0pDR5GjYpJ7oQ+pyq/ZHkN7A2FI9hPzb092ceq281Qzg3/hqgj5reTUO47gd1qavhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220536; c=relaxed/simple;
	bh=DdLdYFvZMf+X6YLoaBOv7f0pd/iKex6hjobfLWBcuOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHZwI1pQKv51gej9PK1KfjfW2jyahPAim0jlff5uwXa0ToFYy22LpkzaahhPKSLfzxbfYLHVYTG8SpgPlArOhzTyWYkTkoHwFC1TicjJ7gyIytn1JJ0kGrp6Pedig4yf07qGeUuu+PaMJ7ZOeoprKS96S1kfeuMSYR8XVfRBksA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8bG1YW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8bG1YW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343E7C4CEEB;
	Tue, 22 Jul 2025 21:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753220535;
	bh=DdLdYFvZMf+X6YLoaBOv7f0pd/iKex6hjobfLWBcuOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8bG1YW0xV7KmyaPNUn/MGwYujnkS+R5ElEAGetkfuYFCd9lLTZiuJMSdyiMOGCaP
	 BpaUbSDKQebqOI50s+barSnfh8N7VEoTYfwgC+AGsa8sg4qROvlFFXQVvoRMRPxlS3
	 B4VxXRuv0dtNGaozuwDttwNC65/wv71aOItNcPZ2lErlB849ZiA45LECPgGcIlojcm
	 OBBzOixbPVbrRy0h2fWcNQ6LaalkH+fQdgEBMzqRbx5+psmamwmiJYbSGIlFfwSABS
	 66smy+QyinsiYNVBwAQZLDJ99i+l3eT84kOHkrHigOrFjSuME6tJgl7NIABEUiLsgH
	 UHIsSlirkjbiA==
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
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Date: Tue, 22 Jul 2025 23:42:05 +0200
Message-ID: <20250722214205.1676741-1-ojeda@kernel.org>
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 22 Jul 2025 15:42:50 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
