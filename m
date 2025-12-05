Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE08732571D;
	Fri,  5 Dec 2025 09:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764927324; cv=none; b=VHqZqxazfKG1njPciF4HMaVUTIGBQE/zhf6ghu8NU2shRF1f1zpcqynrnjLW1pt//o8EXURQq+Cn5qR/+n4zy1VmaeKQjmLha+LvVbEnhtRDjQrfHEOymrMBRPvFx2+zN4vXNA96Qn1eqdI7Ttdr33JHbIK92qBp4nFKgX1Fnr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764927324; c=relaxed/simple;
	bh=nYllTT6JX+7+s9fdw1F2HUyQ1OOd8gvhyYdM8uccGE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVjRSIHEFsnc7CTiCSivoiewxNo+iFD9eDDYijCO+FHfC4zTIoP2dmr5/foSdZph3ZmyEA7lnGjS9v+0W9vCOGa6/rx7ZvoDhQbT5bMZWGUdVVXoBMxSoSbxGnXJ7hHSIrsNQOmllxoATkD2pU9CvBy3yVx0yrh7SLecZWEGoUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbc3MHxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbc3MHxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40F8C4CEF1;
	Fri,  5 Dec 2025 09:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764927323;
	bh=nYllTT6JX+7+s9fdw1F2HUyQ1OOd8gvhyYdM8uccGE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbc3MHxVqMbc4G/aa+exA/Vl0kYAYxl+PiZb4vkDRBWuVlhK2tRRWDDgUOrMO+sPg
	 KyQbEYQcp7nmVv5Bj4D/wcGRACqM5593hJ/PdZnwaI3D3Jr2cTdGL+9ZYrEeJm1cr0
	 8VKRtv8qAuwIQjBM9y++hHRpY6ue0uur8AzZvz/WUr33Z4KfHKQ/s7HHPK1JxxuNXW
	 OeyF/trLgqbcc/lxPRHgezPpk/hcboFMmcOqGw3dqbRCKSxiepWQZp1PXiJsv4B0Av
	 DgQYGQzR+W2AT0xpeK7myo7L3xKz5GbiYNKrdrou9wfpLh5hjspDGDXTeFolOs727m
	 rGiF0nfHcleRA==
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
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
Date: Fri,  5 Dec 2025 10:35:13 +0100
Message-ID: <20251205093513.2163670-1-ojeda@kernel.org>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 03 Dec 2025 16:26:18 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
