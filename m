Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D733BB117;
	Sat,  5 Sep 2026 11:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788608049; cv=none; b=qT3CZXCCUcUbOUJf9rJUdFkX4Ob2j8gWVeuZC3uLZVdCHdnqCHoN9HGPcMMFeeuVAHfzEPcChN72fu7OKCpxNIj8Jv6OAiKKhRXkrq+T1OMtV30ApE5BgOiLHtbUxBxqXcpdaBDhNFT5IGe8GtVDolrDLxwj6hEl2aOSydiuC7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788608049; c=relaxed/simple;
	bh=prw0x8r+NxOm40OX/qeOkl3a628TWhv2flWJi56MF/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjLjkWErLODC2N7vWaP6JJR7++1/kgK1KHfznu86HsLcswrOYr/RHA+tBfVS3xoJrJrRnNHpLmf1BCpZirmwj6OG1jnk/oQwGRt9aVnzaW9lvyLpQlIvVCUdxEXbDakHeVyzw0Wl3p5ehcEShKrZTjtTRFskJ4J1Kk+yk6k5LqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsoCjr6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsoCjr6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC561F00A3D;
	Sat,  5 Sep 2026 11:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788608047;
	bh=anPiovGEewb6HZRo2WfkmcO6vn5iUB4MkUv5t0RDLfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsoCjr6bbH+j9au8p+60XOavSo6wOQyRimwAqBvNiFhzzSvuPkkYIdi/hTSoBvZEw
	 mBh16e/0f5ViOVuPAn+Xi7ETRag5/LTbpAayOEh01Ks6RZ8HkaRn8jsJjDCkh06ha5
	 Zj0aDzkA/If3MeroksER+CDG3zrCUk1qbRTZj1KgrlyVo7U+VI0Dn2wMy1lctbbNKO
	 +752DOZ3QWOSaaWep/az0B/t7g3dcknR7tO8A0MF0uToIqTPQIabw0yr6w0WJYFf2K
	 nchPwicHMOfEr6clEsAYERdVPL4XhObO1szxh3CU6f7yXoEK/07tvrp+7CwI7kLe9H
	 xRRafII8GKgSA==
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
Subject: Re: [PATCH 6.12 000/403] 6.12.109-rc1 review
Date: Sat,  5 Sep 2026 13:31:59 +0200
Message-ID: <20260905113159.123849-1-ojeda@kernel.org>
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 04 Sep 2026 06:56:43 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.109 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
