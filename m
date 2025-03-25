Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B783D2628C;
	Tue, 25 Mar 2025 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742927214; cv=none; b=klqUofUhKoke+xzRvlBi4qpkzTK4d9iOjHbrwp7apyygCk57m0zh3mucN2Fcf0x8lsJXoCrSZBoNoteD0oNEIKCpaDUUQlOU3t6weXJDSQc2q6DLxAX/fq+arTOVcLZRHlyZH+laZ+A5CKyEjDhM1Y5oEdHjz557IH0QOWrDPDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742927214; c=relaxed/simple;
	bh=88qoTG3H46IgMwoA1IM/GJKrDTtHn6XY3LMhRv68fTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+sx39jOn7t+iorujFv/kZn6xyIsYIajM666h/lDxEXSNKZobc/cMhkeGb+V48gWaZuMVvsnzIyWPpAeb4L8LjuXLIF1VmlXmcfDqUttf5/sSYzoFirgcDQ70U7mO3PDFr7UKm+BQIjhSgaZCzLzELpLE5JJH0ITpZYiGFm7rWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZREYlyoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZREYlyoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0580C4CEE4;
	Tue, 25 Mar 2025 18:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742927214;
	bh=88qoTG3H46IgMwoA1IM/GJKrDTtHn6XY3LMhRv68fTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZREYlyoP1JSGTRYpZXFsCmfd07dG0TbX2NKIFv/R56lBnS/DsJsKnaiyN16IY4XXJ
	 LTYMQ5synksA1YKP7iEyGU1yDpeW1y+PHvRzWtrnfHHC2So7vMaxAadl30GwmeICLn
	 qABNSVh7NIh2PTNqpQ3cQYTOQiM6EDKjWbtzw0XA0CETrW79Sv5lMTYCSWzI4/wNTa
	 sfSSSlyscvHD/YHvt58aimtBMu0zBT6aOTu4RTakPt4aCNYYmov1WpUXPx0g/HmFSQ
	 AM61W5u4hUey7Oje/rXTpL7HyDaO8wasfly/masGjb8ZvnqwNYzrTeX/u+ZrcnV5gd
	 0hAu6oe6S9tUg==
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
Subject: Re: [PATCH 6.12 000/116] 6.12.21-rc1 review
Date: Tue, 25 Mar 2025 19:26:41 +0100
Message-ID: <20250325182641.55860-1-ojeda@kernel.org>
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 25 Mar 2025 08:21:27 -0400 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.

Using my usual Rust configs, for all of them, I got the same issue in
arm64 that Naresh reported:

    arch/arm64/boot/dts/rockchip/rk3399-base.dtsi:291.23-336.4: ERROR (phandle_references): /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"

      also defined at arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:659.8-669.3
    ERROR: Input tree has errors, aborting (use -f to force output)
    make[3]: *** [scripts/Makefile.dtbs:131: arch/arm64/boot/dts/rockchip/rk3399-rockpro64-v2.dtb] Error 2

Boot-tested under QEMU for Rust x86_64 and riscv64; built-tested for
loongarch64, build failure for arm64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
