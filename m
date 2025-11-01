Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13CD38FB9;
	Sat,  1 Nov 2025 21:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762031403; cv=none; b=I2PfCGRH/kchESvLh1FsDukraQfHl2ffcUR01g3AhHP2QRtsftZxPZ9HDsdyF7eiRzZokJJzaZWtq3qpR1hoB018V+g+syryGa+YM5piiV1H6FRXnhyVspjqH6LC7Ilq8km4fdLsQU8ML+3vxjyvLpG8wZTen5cSPJMFilYGRD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762031403; c=relaxed/simple;
	bh=R9EmxMP9hrrxF/Ra7pb3ULTY3Ov6Y48AbZDHrud4UAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQiYD7GV1aGx97fycxO0ZXxc/CtRsNFej81yyD54IEVHT40x88kffTlQUFq5sP0Qd5W4HQiIbP3VQlX0HuYtLqN58AleBV60lLyuJSepVrbUtJRG4rrLWtA7EhDn53EiZ59MWVxhGzEw44wvAy+2gl334IgCDcP8cAKyR6ZyhKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZnV8o9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZnV8o9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781F9C4CEF1;
	Sat,  1 Nov 2025 21:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762031403;
	bh=R9EmxMP9hrrxF/Ra7pb3ULTY3Ov6Y48AbZDHrud4UAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZnV8o9UQxfUp8HtVuzT9hevt+Q4X9lgZ3ImQRvLXxomYqIMVxrwtajEdR6fYqB4w
	 T7ESPWiwHQYfEEtC6Q4G2jErSlubYsjv3pnTkq4NpWVwz6Ar2zom8elFN2iRKQGse9
	 S2kGp+hPPnIZNRqDwW3Q0hI3mMapzBjf4Z/wwnGqr6JuZGwy8axG607mddlYuWGiar
	 xjru55PWG9xJJdIjc91p3md079wM+rTSKER2qwves58k8cAWNg3VamAAn/+2WaNeP8
	 +wN0xE8qP9TjW9iTsqEwEu/ysaFFU3MCEeMyXF72vfrVaHRDhPc5G3CMeRUq4PpLi4
	 WhDYiOjAJV/Jw==
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
Subject: Re: [PATCH 6.12 00/40] 6.12.57-rc1 review
Date: Sat,  1 Nov 2025 22:09:52 +0100
Message-ID: <20251101210952.1121227-1-ojeda@kernel.org>
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 31 Oct 2025 15:00:53 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.57 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
