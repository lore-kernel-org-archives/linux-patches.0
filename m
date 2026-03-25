Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E8A2066DE;
	Wed, 25 Mar 2026 01:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774402511; cv=none; b=TlQvhEzBsSk3/OSPkHHyCsSN4etVc9Hus0MXJz9612oiwtFQjOTD94YOq2kEdoN6PI66g/7x9JdC1IV6Jb6juWOXlq7ikewk11dZVdAKS4tRj4cB6SLQVbNnshYbKRpvmR9uk1hMHEsrlSN02FtYkO9XpdyPzuGJt2IpieJHdFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774402511; c=relaxed/simple;
	bh=u+or+4ewo6DzW5OS99JNcJt3P+PYstR0dsJPR1tuZdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dB5+t6Zwkpr+H4YrlkeGsmt7Hvgpk9bl40AZdqQWOhbGo/Z447P9YFawER5BnBjIa8IY+eusXT7JuVGwHPhweD18Jr/qy8F36sCrDUpfo+cooehziAOHUv5Vjl+DOuyNx0icB5tw/I7dD2W/I4qYcETytrlUNUy0FDMSay7pla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfSNLXJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfSNLXJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C30C2BCB2;
	Wed, 25 Mar 2026 01:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774402511;
	bh=u+or+4ewo6DzW5OS99JNcJt3P+PYstR0dsJPR1tuZdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NfSNLXJjobHuFIyJwgQnaBha24RbrbvUDO7tgCICQaBxVu+Iy056ZzbsnHDKs74gR
	 jHgY2J++3sLB7d/nrI6XlokOLgnfwrwTTEucOZXkL3yxyOO2n/P/5jCvCecb2uhV9n
	 s3jyETmhuBCp81hJAXhmBirEWPDKgktu5zhy+ppProV3LaI47st429hj2g2LNmJ2uC
	 P1/T1NiXjNT1+bRoXFm1E1Gz2nuEerITSMeOKwPC7gbXHj9xcJAIOx4OMYLAp1pVcI
	 LPGdWVOXy4zce7aEeOjhHdO1OdZkDCPfhEpOMivLedLQxd2rEnp23AcJMu00FeTupE
	 p5htC9RVHmbXg==
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
	Miguel Ojeda <ojeda@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Tim Kovalenko <tim.kovalenko@proton.me>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	nouveau@lists.freedesktop.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
Date: Wed, 25 Mar 2026 02:34:47 +0100
Message-ID: <20260325013447.66771-1-ojeda@kernel.org>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 14:42:57 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

For loongarch64, I am seeing:

    drivers/gpu/nova-core/nova_core.o: warning: objtool: _RNvMs1_NtNtCskfHXyXj90Gn_9nova_core3gsp4cmdqNtB5_4Cmdq3new+0x2c8: return with modified stack frame

Which got fixed in mainline by:

  c7940c8bf215 ("gpu: nova-core: fix stack overflow in GSP memory allocation")

But 1) this is just for loongarch64, 2) Nova is still being developed
and 3) it is just for 6.19.y, so that is probably there was no Cc:
stable@. Anyway, Cc'ing here.

Cc: Gary Guo <gary@garyguo.net>
Cc: Tim Kovalenko <tim.kovalenko@proton.me>

Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>
Cc: nouveau@lists.freedesktop.org

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev

Thanks!

Cheers,
Miguel
