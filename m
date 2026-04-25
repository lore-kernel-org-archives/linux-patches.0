Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EF84315A;
	Sat, 25 Apr 2026 11:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777117800; cv=none; b=svGy6KURlphHU8J0Z1Aeg1mOp2DWkJUYdjWU+IXHWbC/Vn885HmcGuV8vs0qiqO9NpS3qMD/yOQ5xpFVF6bTqhV/A/faiCgKqbdBnmk3nuQe4EwfheQX7lujrCvbF3/zmLe+Jqx30d04quF6rdq5iBTBvDltQzeJW9vOZlONDJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777117800; c=relaxed/simple;
	bh=0K3ptHFYAFSwibV8lLi1fSBRaF2KKkiYN6qfRVj9Qo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBNNafmTMno3HSFpOOjAOFGPyLvRYjJ33HRw6ss6t+kgqEh53/iEcDb03Rx9eYdr7AYGXHBc/ExR1kwRkUEQVYjVRCrosrMw5u4a/Iefswqa+cZuN9spNqjcxWBEB2qR3PO5SLxg0/IeIk4bax5CLYgvRgVOdFlYbRZQRPvGqBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpF+JdgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpF+JdgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1EF0C2BCB0;
	Sat, 25 Apr 2026 11:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777117799;
	bh=0K3ptHFYAFSwibV8lLi1fSBRaF2KKkiYN6qfRVj9Qo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QpF+JdgI5pgKc44bzE/1MeeGhDF10RiZ7tHxZ4Y8cMfJLBY7tETNucqZ8UdXChmOh
	 u0mac6M3+lplFJHln82bZT4zv73vFDapx0XXiyX9kjGYaD5FUXQOdViv5lMQQpynnK
	 K+F5FTezDS2gyKrluwrXU8MDja8QRncJhBiAqH6w7lrwYYJGndSlk+o8+b5F53bhlG
	 WGD68LmsP4dWT34KQeOLCtqfJtt8qXFarhGLCOAJvtSDq0/x2vNcDTezRw/2nSWcna
	 9LdD0JV0OolnBzKOffwE9T0ab7bBo3zDSL8u8Wzm2l990ZIz/85nu1oJ/nH5V7B8M0
	 FE+e5k7vyqd5w==
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
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
Date: Sat, 25 Apr 2026 13:49:47 +0200
Message-ID: <20260425114947.158088-1-ojeda@kernel.org>
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 24 Apr 2026 15:30:25 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
