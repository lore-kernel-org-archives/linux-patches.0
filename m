Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2E917BA5;
	Fri, 25 Apr 2025 00:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540280; cv=none; b=rUWHSlS1YCCzQfW7YXhsNxGWTUZ2jLHohdfeFjZ76tTiQYyYUJMTwq2EDUgqjGgtvZu172vtQ9+FLyuzuzN8haEvSRT7JJjk5q0LeRQ+sdS8P/ZC5HGg6fdFdkv/ls2xqcVcvRLNw4mgKFzx3csbcZA5Q6Ngpbunp4TnKQ61OPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540280; c=relaxed/simple;
	bh=w04ui9n+b5eQWZUkMB3F52O0GSLxqgBLN8BKbm/YuzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwcNWysqXvhGSjWlb6QF1AdBaXKPx1iMmL7EUc4VQnnf49Hq23Xw7OFcezo/RqdQoJF64+L4S4+TfOHJJNsOS26gw9VhFuARDkkBF7bisnIOQX7+LixD6JG8WNuw2h8lRB/fjVZihilOz0uugWmX6LxCWFU8qVBflpqkAGQeTWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Stn/nQPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Stn/nQPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F15C4CEE3;
	Fri, 25 Apr 2025 00:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745540280;
	bh=w04ui9n+b5eQWZUkMB3F52O0GSLxqgBLN8BKbm/YuzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Stn/nQPrPQNLomuUHnmOmKHpxf2rD4m8Vc7Sb11zDFPg4RxiKXcLG5yrC5RafUcf3
	 8SJw642ZxhCuLB2/9NRwmJyH9MWzn+AEipdJmRfnOJPkPqyoDk7BaR7BkK1XbdstSS
	 zSjJmgldYjvahltpKwV84s2RU1SBc/RjkAnk1+yijh0JzrcCG2V+LQaNIdD7i+qsfb
	 o0NNJ2CJA8eQNTIiJ272oYSI7+qnXRQc67ugGBrblamzxr/sPwDkUcW8WhnYOsWbri
	 dHQWdPDdBfYmH10Xf4tThRYkbK5u10piIVNSjLoY4CkKyNIuWS0MohI1cO48ipcp4k
	 el5aWi87l6kqg==
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
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
Date: Fri, 25 Apr 2025 02:17:47 +0200
Message-ID: <20250425001747.62746-1-ojeda@kernel.org>
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 23 Apr 2025 16:39:49 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.135 release.
> There are 291 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
