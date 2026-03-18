Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6B1EED8;
	Wed, 18 Mar 2026 00:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773794849; cv=none; b=Y/M/ujCQ8QBP7FTlCw2lKCfRmvfEiNpQiAN5APcZ+I9WUHG3zwXwlrj+PzNE0A7QOTzTci/+Sa+XCfAROLe62Hxg4Z8cJDOcXu2vwI6HBzgNJtjmOdKIf04asroJ47Ax9xJhL6LzRy6EHfkupioYy5r6koZ0H35g3VknZT4ixgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773794849; c=relaxed/simple;
	bh=zc4NRPxr061mWIvp2AcNd6PRqLH+dYNeYcYnjDmv+jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ3ee1pKwtlRxzgnPX0EuHwt6uKRXlsz6rbz0krKjU+gx16rE94/vQLltmod5326JlXVwjJvpHa93MwGzXXt0m6VAzvyMp3baxEfD6IOPopluuCj51wuLOFUYMjYDZk8lMhgLN62PIsKznG1N1XkMBqKBWT9kwA0reNUYIscoXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J295m2nX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J295m2nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86CFC2BCAF;
	Wed, 18 Mar 2026 00:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773794848;
	bh=zc4NRPxr061mWIvp2AcNd6PRqLH+dYNeYcYnjDmv+jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J295m2nXbrVAtbJZk42LteOOE4KJTbXbLuNzer1r5eK1MfXsNtVo4TW0Raj6ZejFe
	 q2d9Yr0oKlKNLKDAlweXtq6HcXkAvWRbdOYVOiqZgNdx/uKjxwdSSoRu/xAwPRwH+N
	 HrcFCrubVRvr+N7GquMXgDxj/EVEw6q3o9P4ReQowd2eQrkKk0xVCWu0+YAF3XRl3M
	 RwvMl3+EHB1hGc1Um1ut0yA9QaxEE2Qz8em2jlNsWmFwczXnZS/h8XzvvCPTxoOqDX
	 sH4/l1x1mxIyi8lYbyQluZn2lP1NdHfKrxHb7ElWkZNyxe3KweOLOWyODmUQTOysjm
	 2C/pEbJF8afgQ==
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
Subject: Re: [PATCH 6.18 000/333] 6.18.19-rc1 review
Date: Wed, 18 Mar 2026 01:45:34 +0100
Message-ID: <20260318004534.193064-1-ojeda@kernel.org>
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Mar 2026 17:30:29 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 333 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Mar 2026 16:28:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
