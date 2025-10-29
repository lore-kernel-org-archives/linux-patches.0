Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0177335098;
	Wed, 29 Oct 2025 11:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761736877; cv=none; b=HLYnMCptTUdrD04mOFspPwh/v2Mxg0UEDB2eGCHa93Er4HN2BWDqRniVDESgcp3ZhLwnZYCAplqAxwk3IF891651AXWE8CVIlI17ZQcvP2UtR03WZe8RDFTmpOtspyxTFCTczZ6VRCwAzpH9dmge6r9tuokZ6WzMQFld+IkbfMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761736877; c=relaxed/simple;
	bh=8BmBcwaL7A9ygphEJ12kD6LT8Wb8PJbvdOUlXZ5aB80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRUUpKdc5tbD8JyjIZGG5uNOr5SXf+4u/IF0KW1AR84jguBaeU4Nyk+t4x/dzk2d/5lMxtGrnKeat/gQ17Qb98GyW1cauxi+JBMAIiJmvohCDR7z8mlsPXop0M/vYsHScte3qqwvqxu/+ewY76LtWWjsq+SZ1++95EK4cCtjZ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYQKErra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYQKErra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E56C4AF0D;
	Wed, 29 Oct 2025 11:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761736876;
	bh=8BmBcwaL7A9ygphEJ12kD6LT8Wb8PJbvdOUlXZ5aB80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYQKErraG9QOOrMRARXrJ4pKUtl1vLtcmKVq3UcnrUG3bA6dDjLvIa68/hpLmIeyi
	 N+/aYIX9zDG8tVNYljDOpPQb8hj9BBM/ST0z6RSg8LaIHlVBVhCVF6GS5qZ02ttyu7
	 IW742IMwoSqrNKghOsQq1M8E66YbAdUd9UThII80WDN60Vs0S5K4eujsp1acCyxK22
	 hMVS6QxCzInCY4w9pVzYdTm8939Gl3KabCqqYbeSvCIrfT8A6SbAykmcGfbenIGJc2
	 +wmf709Ks0ZFn1kTdP5OtUO3JSxrvIr4bS/h/Phs4f8MjE0E9l9cTn4y6kCiK1viih
	 iQW3KmJzikIHA==
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
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
Date: Wed, 29 Oct 2025 12:21:02 +0100
Message-ID: <20251029112102.696779-1-ojeda@kernel.org>
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 27 Oct 2025 19:35:49 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
