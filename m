Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FCC1D618C;
	Sat, 18 Oct 2025 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760804399; cv=none; b=r0rnvWXpm6EKGYJnbBYZs9WQJ5XdwdCeA5NiAzhGnnXLrj7stF5JFSq3NETRs8pqBrscenQYU/TDNw0i46OY8OQ4MFoqrClK37DaMkV19dHmaKZZL+UYKRro0k5TSzlGFzFBvuGoV9LIEmAeINHo5kRLD6FA9JlYpMzmpZ9FJTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760804399; c=relaxed/simple;
	bh=B4tUZzenAVhpWOrM9CiBifYMDLBoipTmBKxJl3VKw/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9H3zm16dyNjLx0ZjaP3TUS/rQL4gflOWiiiSm/T5O9v4Lk9hW1oL4C5oKbgHvvxFc6yRauljDv5/oGf8AaZTGC6vlavIM2Vonwg90cnf8QJTQzWQLN+hGB3lw+t90L+njFc7aAC5Wd2ITd3qVFL926xVcQGAlL9/UWosV9oCVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPJJZXgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPJJZXgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1FEC4CEF8;
	Sat, 18 Oct 2025 16:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760804399;
	bh=B4tUZzenAVhpWOrM9CiBifYMDLBoipTmBKxJl3VKw/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPJJZXgGQgHGVfFAkBOILiMH3TA74OMfDt7PQvcCh2NcwplMHfeyR/kp6Aioc+ARk
	 wUF3MD9lhybl+iI3pFuP7pHj0R926AuUAptmTQMIBrve8pn9fwDannAF509retPqzC
	 jKdzuALDiQfc9jPH4goN7OAc3dd0/flfo1EYyh35dH6Z2CPWTZImhEwMPGmcJQtyfC
	 1maJuXncFOcy1B+LQQAH/NIEUcgkeJ+gWgwg+9cw8BIFL1dHD8F/oY26RdCXJqmrUi
	 edG42kMXatx4Rja2DvYoDsn/JtDo8nhkT44EAxEnvL9YUPxBWoHYTEOFTJLYHyJMnq
	 MoanQz9zgUIAg==
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
Date: Sat, 18 Oct 2025 18:19:50 +0200
Message-ID: <20251018161950.1551067-1-ojeda@kernel.org>
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 17 Oct 2025 16:49:35 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.4 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
