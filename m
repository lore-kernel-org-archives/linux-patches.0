Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D88430AACD;
	Fri,  6 Feb 2026 09:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770370475; cv=none; b=M2mjU+Oqqd6fuoh8VLyeZLyF6njU5DwidK/OyOSQi0wnx0VvK6MTbWgeAyPWO3CNi98ymXVriP+DTEQBL0w+CC741Eu757BAPzdb1RwSiyWc0zfykMQLj1UPB739rT4EubzMIs8LgB8uXCpkKND2Za1yAFzcAfUgdgDxYKDKXSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770370475; c=relaxed/simple;
	bh=9L/Y1wheQCMtpQYdiJoH12+WG+rfcMU93MAuNWER3A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOf5eHENrPD0zM9YCixhNEoyzYC+iY2l/SZIkuSVzEF63pLN0GKIBstKbK/aHCcZRGKoZmPxnX54RctpyDZvzg4sC4xGur8EiK/36M9sxWxIKvUf296c1yrD2W3dCvYHjRb+hLwmICgqu4ruAg/s6SDwf91QQzdpnCi3nUi/eJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h0wb7nf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h0wb7nf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F7DC116C6;
	Fri,  6 Feb 2026 09:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770370475;
	bh=9L/Y1wheQCMtpQYdiJoH12+WG+rfcMU93MAuNWER3A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0wb7nf2dC1RBMBUq4AkFSvXqplauHwPlN6pA0X5HNbeyh6QE7FkDpP74hJPd2W/L
	 wG80eYBZmihVvlheCPcolCscLb7c04OL6UyYsami5aPiBfLLaR9VjwtzIetZBcbuwZ
	 nn06S+Lg5Q4uApLQGE1/55qC7bH8RXxs7GwihFmOTpkHXVchf5a5FC4wodq80WSIPj
	 ln/IJEZGTd/ihr9CnODs57roUGRsF/vyx9ekKZJ2rV61Ihql43x9U1hipzSp483XVZ
	 i7J/0og1f9ntQuRS2lFqIC1Wxkn2+Sd0OnRpVlJlyEPtIWTlz6wz8arAeGoqUkngjF
	 /2QXSRllpgMaA==
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
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
Date: Fri,  6 Feb 2026 10:34:22 +0100
Message-ID: <20260206093422.89136-1-ojeda@kernel.org>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 04 Feb 2026 15:39:42 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
