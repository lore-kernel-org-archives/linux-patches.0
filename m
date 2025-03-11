Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C029626281B;
	Tue, 11 Mar 2025 18:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741716301; cv=none; b=swe1MElK+U6k6FT3bT6C5B4UlhHYMsBkGTz2FbsGg9pPrKHaA6p697OYqH57SqaQIdvWMXMj6kjf14hQ145QYNJOCuwGE7aqPpkn7kptSvlTwjJVTG9tiq6ylkOFah8Eh8OhO37Unc2jqXwOqszo34wWl1FYjnSmst6aOHzOc5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741716301; c=relaxed/simple;
	bh=lY/xHmzZ3aDDAcR6EgObdm7ih5Fe0kwziACf5Ikja1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK/StS2LwdPtN8EcsXa5IYjEfjrAM9feLQMRom0P191HK7YzjNZN63H6dkbBrxMILu/50NcH+fZ2GKSzk1cdke3SPolld1hDIDBWskMWcfvqIbW8OjhCeJA73QVBXwddgSglCe8OudrjjAFPhzj8hVH3Ep3bkxBP2sxsF1xHO6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITmr/bGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITmr/bGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D395DC4CEE9;
	Tue, 11 Mar 2025 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741716301;
	bh=lY/xHmzZ3aDDAcR6EgObdm7ih5Fe0kwziACf5Ikja1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ITmr/bGQqtI3usEsvKBk9vBZ0h100pkag/NUFKQ9Go56bBH84reP/8CS0HZ+cmRAo
	 RPUPI0pb9fgNwhTJW5JROQtVpXJWHxcf+Eai/smFihlqw2CZ4G/2Jce5WNN6qU6qsB
	 RO02nJPGlJqIjUoJwuqZ3oCPkZtD22NXaPyWZGiDb9e6i0eXgwe4c4xa+kmtP5JXes
	 6sCR0RJTsV/pAacWyuBPVbgfgzHliyMeZ8ecz7ehGw9v7oDshB8EsjqnmPulQ5KDnA
	 YusJC/ZwFncT7OE3C7HzG+Yqfc6GIxPRH0POgKZGKrPsnEdu8o4GRmDfOcjuyKkL6I
	 eT7cGL6ejO4tA==
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
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
Date: Tue, 11 Mar 2025 19:04:48 +0100
Message-ID: <20250311180448.1804659-1-ojeda@kernel.org>
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 10 Mar 2025 18:02:33 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
