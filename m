Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67731EB1AA;
	Sun,  6 Sep 2026 00:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788654228; cv=none; b=uo/j8Tj7feDEjyIUs4XNAjJm6L1NrPRtNfJs0oZuVaw4EsRzDBQ//9ZzixCJawqA0ieKsuAbYu2URU6UMyUgbIXgCPkSY2yqDMGzm8yoseWlKR74cqlJpvtU+InitCMdGF8K41of/u1AjCt98Ems8ZV7sBbEc8Sc91rWzGABgJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788654228; c=relaxed/simple;
	bh=DC3KQswZz2Gj7e1jKTkvuHoRpOByOtz6L2TZwbOfAdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoRP/6TLGUxBa60mS4o2IlEfsFI77iQuRe7JF40DGfgwMoRGs2CilltMuN24YDLH+P2JViHo3hew/lwAIEKaxwwot7yiDsDCp7aRBTmMOzlrsTttvD0ZwOC1TUnK29203GnYMJFmMa/GOBb4/gV+cWksbTXWp8lEIfE8P+9XPSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2nXJwpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2nXJwpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DD31F00ACA;
	Sun,  6 Sep 2026 00:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788654227;
	bh=tB2afu93ZFAZndvLToJM1aMofzU5OfeOdnXsh+u6glA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2nXJwpWHY9obIVCEbX8CgaK1VYCxFsswWW9ATNyx7Wm4uCuG0HTmX2tFDfX+iXP0
	 GumoWpFpGsc8XMmiczjc8uPqatGuNWFYTBKCNjPjHPH5Mpv8ELFOl/Ggm/Msz7qKlS
	 96MLoIrqUm4ujP+FqygmYm4htn1e85UmX0EqvG7ZWYcGJp6AA6PKUkOkSQ26D56mpC
	 twx2k+OYJstg4Uy7Xrj00mZgmSmZvNFDBsnIl40RmgAYxXP35yp5AvRwd7/ocmg7lW
	 kqceX+NIte91v2myiZSyiWT9IAmPd59o/XwxPCLV2YiGh1j8/9bRWK5sfREzH1yMZa
	 2xfAMKg7MOj6Q==
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
Subject: Re: [PATCH 6.12 000/400] 6.12.109-rc2 review
Date: Sun,  6 Sep 2026 02:22:56 +0200
Message-ID: <20260906002256.170030-1-ojeda@kernel.org>
In-Reply-To: <20260905115627.670276262@linuxfoundation.org>
References: <20260905115627.670276262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 05 Sep 2026 13:58:50 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.109 release.
> There are 400 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 07 Sep 2026 11:55:05 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
