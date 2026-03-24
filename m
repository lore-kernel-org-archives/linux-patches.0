Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA573CA4B1;
	Tue, 24 Mar 2026 23:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774396422; cv=none; b=IjfKZp8r3UAVMvKlzyoGoakRzp3Hp1w/u68q6onvrAS3bf7Jkym9AX2Q+4/hJsQk9xWzBo9oVKqixGQee4nckFsQDg7r8Ha65eUp1E/soYUHlkkI/dynT6YW3uQrY+PJxcLHwy+U6/3VOW7E+nI6dQ74MFSczYmTv0ntISWr4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774396422; c=relaxed/simple;
	bh=ZX4qWCMx6j1ChkTEq9cF/t39IJRMmS5VEjqG/Fx/FVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R446EWGytT2tUZFaittB2hYBDM1JQkC4dr8rYJj/kBzLiO2ad0m06xlTEEDkBRm4MmsPpXyzqnJWKjIWR5N2yDEy1iQfpGe0kE/HUuIKB7dIuglqfO/6F9NL9kjXzpcaFOn/mi+mtVoQGtmhBm86gX1TKwAaNq/OfSz8gcRQ7e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACbFLrP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACbFLrP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D64BC2BCB1;
	Tue, 24 Mar 2026 23:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774396421;
	bh=ZX4qWCMx6j1ChkTEq9cF/t39IJRMmS5VEjqG/Fx/FVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACbFLrP6MyX0kuKAEf4hgDgcv42iUGl6Pbrhu9Kyx82bYlCf4sk04hjOu1ZWTwpVz
	 MfRHn6t5ZwNBIQfyyOHvtHLmnSQbsN2yuN2tCv9FS4V+IafYQu0Hbgmvm/zpGdYehI
	 9uN93LuhTYGJeVPybv1bHZsZkiWqDs4SeM0t6eIrZeo0baXdqtOvCeC52PcYEaVlOb
	 pfgRT/EoOIXQ8ptvAMcb4LqOfRtfEo7waVPcjduzBSFQCyIKMISeZIWwXOWROwB4aL
	 FSBHQFkUayDsL+sD6zOAbpEITrZRBDF5oaZ3+jTUhhfp5wj/er9/XSF/nc1l/SLTyX
	 0bYx4vBhmaJjA==
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
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Date: Wed, 25 Mar 2026 00:53:33 +0100
Message-ID: <20260324235333.55028-1-ojeda@kernel.org>
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 14:39:42 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
