Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544F5288CC;
	Sat, 19 Apr 2025 14:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745074055; cv=none; b=s5qrqfNzpy7akVdwDOo0/Su4l1sjeLPunmR/iP92Yv4elgy6QM5h03VnmMqzkTrdkbAWXRbT3sgXIYhdLmW7Ti83BwhieCufOC1xJrPK4gB+WIOafZyyEmTRtRhGz/+Kw4eIrrksh3V2lJaalOBFgF7Zq090wZN2Hkn1CmlCOnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745074055; c=relaxed/simple;
	bh=KDQiY2Lr9g9MGDXlermqBtZguIXqJVmPhhPUefgAsjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oipkv6RxYWME0yUxyJXxL3WA4dAJlmrdtBb8a89sohGueZ/AE+CxCFIqaw13rmS2IUQzJJLcLy+7sInoW8ODzmIjwGEOxD9M+DgpxOeXczyP/CmK+gMq8FOWkKOSuRRQ9EVELvHKG+FsvxyM4hOCtym4EPouE3vk0FHdQUT6BMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3GVzuLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3GVzuLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1ABC4CEE7;
	Sat, 19 Apr 2025 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745074053;
	bh=KDQiY2Lr9g9MGDXlermqBtZguIXqJVmPhhPUefgAsjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3GVzuLDaAZH/1sB9bt/H3ykA9EXSI5Z3teqP1B3Dahk3NOIkVL+BIReOWJfiqK5P
	 rh5M/dYs/NjzIlZflNpLg9zlhYi7kNjCO6P8DDuWl/f+r/BNbnBsFFPDzuQzzLBgdR
	 mYresWwBCLouF9kFt7XyePOBUTJ+OEpgiZccWKQK2fCMbxcVHxkdmzg3NMHUYKwpQ+
	 iVpsvaZ3GRq8yDmAQgo123BlNlrZYKst7pB8gSgyXgO37oHuaRtbJVI0RvB4QQbLtc
	 Wxud+YESV7PZLmUz8dIfYVDtEYt3LxVSy5B8o8HkohAx/S/djhbEdLfdmCuFznAzxy
	 exTmxGDpS/W1Q==
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
Subject: Re: [PATCH 6.14 000/447] 6.14.3-rc2 review
Date: Sat, 19 Apr 2025 16:47:14 +0200
Message-ID: <20250419144714.3014409-1-ojeda@kernel.org>
In-Reply-To: <20250418110423.925580973@linuxfoundation.org>
References: <20250418110423.925580973@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 18 Apr 2025 13:05:27 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 447 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 20 Apr 2025 11:02:55 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
