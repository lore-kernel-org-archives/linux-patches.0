Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4210288DA;
	Wed, 30 Apr 2025 15:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028724; cv=none; b=TbtPazn2JsHOXCj7vr7MM5hrXZdv4mBkniCoIpuU7G4l53aXSKTs7F2MRomUYcoSgn+Hji6ZdjtUYawTxC1zB8CRUslWE1nc11slYCZnSvzF/eqGL1qqtRLzSHjjArhnrSzfKB4KqB5bqvn+d40qPYQoaHGkyOIJ+zAeYVGrc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028724; c=relaxed/simple;
	bh=5cp1j27f3RlMZrTBzNZ0r/BlIAcGp7eCkrme0qdYtCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgCkJB940cg273GWyVPZJHft4S6Erjc3e7fe5V/Fe8DVtwvqqdgFxXYfhx2Jalt35B6FjVRKkIxUgRsobcyObcdqGQGG+beJH2w5LLpwcljo85RUsL2ff1MeIaKoAcWec0IaiutDet04L6GLDmBNSLhwG3BssBA+Vt7/+mrdDH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAlOzncq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAlOzncq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5599AC4CEE7;
	Wed, 30 Apr 2025 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746028723;
	bh=5cp1j27f3RlMZrTBzNZ0r/BlIAcGp7eCkrme0qdYtCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAlOzncqzqUIVr2c1FKFqPfRLztOkE0rRFavjO65i3Q8GGL/3WUVU7iVttlzw+C/L
	 H7ofuhyV623B1Vz5mc3GW1dvGnX1TegL2M4by7JkgcOgF5hCIVkdsrylcgJO5SVBtF
	 mEKXi7KJCOLzkXaJtTz57E6RtO2pWiJM51aS/2hwwxqyfw6Z2ZvjtV/L4A5B5VaGiT
	 McSZue7xA1QFnpi/iEFdBUVhmXY9K/eRYdYbtrr3SrwNfIUgnR58WS7OTMWbFiaURJ
	 R1SPmDOSbf1c+b6PXSElDx8NHnHyHcIQxZj/DJr7CspumuJMDT57al1J/nltWU3VzG
	 yq66lpBjCGmYQ==
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
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
Date: Wed, 30 Apr 2025 17:58:31 +0200
Message-ID: <20250430155831.797444-1-ojeda@kernel.org>
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 29 Apr 2025 18:37:17 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
