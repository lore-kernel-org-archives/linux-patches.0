Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7836E3559DF;
	Sat, 25 Apr 2026 12:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777118498; cv=none; b=VJBNnvvqXtAUgRZ9hmDZISpa0bp7bJm2CyVWMnPCfPCIpKkk0DGcy27FaDH9AtkEDfLpy1SmAhCvTwmmXcgAnTVk+rclLVIaeQG2kVh90UOeDLz0A9EWp04lHvsbg8CilvXefiOkrDsNghWRpjj+1QPE1s/XuGf9OF/v4ETRTYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777118498; c=relaxed/simple;
	bh=7S4EQLjdXdRSyql31dC/E/hGFZKE8xB2rDtspDLWcQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJ4egfJ12NhTFOcYMPDxkuLaInbVGt2Zr4OQcnbKYcLYc6jbgr4azxQjfLOB1DoQA+tHy0uc/xDnxPmU9je7tMw//69TErw+n8MyhZJb1wJzIqxYFC0cBU/1dYtNV5f87sRf4TvOUkOif/nRr+tz2uib+PcFHUKXSY6GDJ/Rvts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExIJlfOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExIJlfOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FCAC2BCB0;
	Sat, 25 Apr 2026 12:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777118498;
	bh=7S4EQLjdXdRSyql31dC/E/hGFZKE8xB2rDtspDLWcQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExIJlfOGkOk/1tRXrjTXBWTA0POwvr++W5QBPPx6YlGskg8wxncEIaMQYP6p1bANH
	 6wDuur2RKZJt+jCb2wAFxp7Qd5PVyKDp2BjR+Hdjz+lJjHCPmGilDejziaxtFIoxBm
	 etq39sSAfZll0XkkkCXztsxBHWCgAIhN2yamiclD+KA1Mm33av8hjuHva5fLwsGVK7
	 iGIqNQ9PajI9DJXDK3619/QI4AiZTlOuy9EutncK/Wy9C7fMiYh24D4d+aWUq6+oxA
	 lfyUpd0wpnDjXrV8Ooz7uJlEX+khF9uu4UUC5Hzrn6APTnJv+Rz8oAcOtLwA6jEpua
	 BAhHB3pJD1G9g==
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
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
Date: Sat, 25 Apr 2026 14:01:27 +0200
Message-ID: <20260425120128.159618-1-ojeda@kernel.org>
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 24 Apr 2026 15:30:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

The UML issue is now gone.

Thanks!

Cheers,
Miguel
