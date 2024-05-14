Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7191802AA;
	Tue, 14 May 2024 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715709597; cv=none; b=Hwhg7sIwF6TSy9F79Ntr/GD9GVVyaNcpfTC2gpmxm2wibrfPZfer4IjgXzKHfZOj9Jo+sjU16uG3bASMz6ICyO7xOW/CBdRwj64MwuhQJM/8oQXKNd/QL09DDeSgQ4yjYEoQPDXcktNXJvV3AE8UpjIvK0SwAVpUqs+nU1KhjwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715709597; c=relaxed/simple;
	bh=mthMsZwME9+4YXzmaJGu9P4k9nP4BlU5JrK6Xkaanns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnK4s0Id+Bjg5dd8lugXC498qIL3qDxEzBsrfZpd5K6fvM6XVmNhpuHri/LcAKlt5V3uwFH0TyDIKqPKoEUPDdz4MlkFPXmSG8IwLEQ+lHVJjQ/4Yycj2LyVoHXpqeVmI3FRaPXwayPpo0z56dAy4DX0pzKyFHXrmNqp0DS7X8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uirhTq2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uirhTq2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AFBC2BD10;
	Tue, 14 May 2024 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715709596;
	bh=mthMsZwME9+4YXzmaJGu9P4k9nP4BlU5JrK6Xkaanns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uirhTq2rzFU6x1vn1qvfUlp+AI56GU8B2lmchTV/ZnY947YWoDEpZDX3vs7cpva7G
	 Kw8E9hjKixWF68OIl0EBQduqnJZFmV0P27pnr2NgxCbmN3hXnOYH5j5YJU8ihDea2p
	 K2p+hCWm7ooBf4mBJtd+TOKGGdcQticWnt8hOSpTAriU4yEEsqy77lmpTizA08YJsr
	 n0q5MDKyzQ7LSUSH825o7HWRzHGnw1VjZ7MBTIEqzzUp7CH3qnmb4JneL/uvDCj6m9
	 j5u7PVH8TggxEWwfiXDx37ING1e2LCIjiEbPUgaPaaWtK1MNMeRIMoFyWOonTEj7b9
	 +UHrtOa2JuZbA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.6 000/301] 6.6.31-rc1 review
Date: Tue, 14 May 2024 19:58:23 +0200
Message-ID: <20240514175823.24891-1-ojeda@kernel.org>
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 14 May 2024 12:14:31 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 301 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

Boot-tested under QEMU (x86_64) for Rust:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
